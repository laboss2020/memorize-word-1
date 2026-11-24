import 'package:drift/drift.dart';

import '../app_database.dart';
import '../tables/user.dart' show WordProgress;
import '../tables/words.dart';

part 'word_dao.g.dart';

/// 词库查询（词库表只读）。
@DriftAccessor(tables: [Words, Decks, DeckWords, WordProgress])
class WordDao extends DatabaseAccessor<AppDatabase> with _$WordDaoMixin {
  WordDao(super.db);

  /// 当前学习语言下的词书列表。
  Stream<List<Deck>> watchDecks(String language) {
    return (select(decks)
          ..where((d) => d.language.equals(language))
          ..orderBy([(d) => OrderingTerm.asc(d.sortOrder)]))
        .watch();
  }

  Future<Word?> getWord(String id) {
    return (select(words)..where((w) => w.id.equals(id))).getSingleOrNull();
  }

  /// 批量取词（调度器构建队列时需要例句信息）。
  Future<List<Word>> wordsByIds(List<String> ids) {
    if (ids.isEmpty) return Future.value(const []);
    return (select(words)..where((w) => w.id.isIn(ids))).get();
  }

  Stream<Word?> watchWord(String id) {
    return (select(words)..where((w) => w.id.equals(id))).watchSingleOrNull();
  }

  /// 词书内单词（带排序），附带该词是否已有学习进度。
  Stream<List<(Word, bool)>> watchDeckWords(String deckId) {
    final query = select(words).join([
      innerJoin(deckWords, deckWords.wordId.equalsExp(words.id)),
      leftOuterJoin(wordProgress, wordProgress.wordId.equalsExp(words.id) & wordProgress.deletedAt.isNull()),
    ]);
    query.where(deckWords.deckId.equals(deckId));
    query.orderBy([OrderingTerm.asc(deckWords.sortOrder)]);
    return query.watch().map((rows) => rows
        .map((r) => (r.readTable(words), r.readTableOrNull(wordProgress) != null))
        .toList());
  }

  /// 搜索：headword / reading / 释义 匹配。
  Future<List<Word>> search(String language, String query, {int limit = 50}) {
    final q = '%${query.trim()}%';
    return (select(words)
          ..where((w) =>
              w.language.equals(language) &
              (w.headword.like(q) | w.reading.like(q) | w.meanings.like(q)))
          ..orderBy([(w) => OrderingTerm.asc(w.freqRank)])
          ..limit(limit))
        .get();
  }

  /// 点词查字典：按词形精确查询（忽略大小写），频率序取第一个。
  Future<Word?> lookupByHeadword(String language, String key) {
    return customSelect(
      'SELECT * FROM words WHERE language = ? AND lower(headword) = lower(?) '
      'ORDER BY freq_rank IS NULL, freq_rank ASC LIMIT 1',
      variables: [Variable(language), Variable(key)],
      readsFrom: {words},
    ).get().then((rows) => rows.isEmpty ? null : _wordFromRow(rows.first));
  }

  /// 词库词形集合（点词查字典的分词用）：
  /// en 为小写 headword；ja 为 headword + reading。
  Future<Set<String>> headwordForms(String language) async {
    final rows = await customSelect(
      'SELECT headword, reading FROM words WHERE language = ?',
      variables: [Variable(language)],
      readsFrom: {words},
    ).get();
    return {
      for (final r in rows) ...[
        if (language == 'en') r.read<String>('headword').toLowerCase(),
        if (language != 'en') ...[
          r.read<String>('headword'),
          if (r.readNullable<String>('reading') != null)
            r.read<String>('reading')!,
        ],
      ],
    };
  }

  /// 抽取新词：无进度、难度靠近目标、按频率升序。
  Future<List<Word>> nextNewWords({
    required String language,
    required double difficultyCenter,
    required int limit,
  }) {
    return customSelect(
      'SELECT w.* FROM words w '
      'LEFT JOIN word_progress p ON p.word_id = w.id AND p.deleted_at IS NULL '
      'WHERE w.language = ? AND p.id IS NULL '
      'ORDER BY abs(w.difficulty - ?), w.freq_rank IS NULL, w.freq_rank ASC '
      'LIMIT ?',
      variables: [Variable(language), Variable(difficultyCenter), Variable(limit)],
      readsFrom: {words, wordProgress},
    ).get().then((rows) => rows.map(_wordFromRow).toList());
  }

  /// 选择题干扰项：同语言、难度相近、排除自身。
  Future<List<Word>> distractorsFor(Word word, {int count = 3}) {
    return customSelect(
      'SELECT * FROM words WHERE language = ? AND id != ? '
      'AND abs(difficulty - ?) <= 1.0 ORDER BY RANDOM() LIMIT ?',
      variables: [
        Variable(word.language),
        Variable(word.id),
        Variable(word.difficulty),
        Variable(count),
      ],
      readsFrom: {words},
    ).get().then((rows) => rows.map(_wordFromRow).toList());
  }

  /// 定级测试题池：某语言某档位的高频代表词。
  Future<List<Word>> placementPool(String language, String level, {int count = 30}) {
    return (select(words)
          ..where((w) => w.language.equals(language) & w.level.equals(level))
          ..orderBy([(w) => OrderingTerm.asc(w.freqRank)])
          ..limit(count))
        .get();
  }

  /// 某语言的词总数。
  Future<int> wordCount(String language) async {
    final countExp = countAll();
    final query = selectOnly(words)
      ..addColumns([countExp])
      ..where(words.language.equals(language));
    return query.map((row) => row.read(countExp) ?? 0).getSingle();
  }

  /// 已学词数（有进度且未删除）。
  Future<int> learnedCount(String language) {
    return customSelect(
      'SELECT COUNT(*) c FROM word_progress WHERE language = ? AND deleted_at IS NULL',
      variables: [Variable(language)],
      readsFrom: {wordProgress},
    ).map((row) => row.read<int>('c')).getSingle();
  }

  static Word _wordFromRow(QueryRow r) => Word(
        id: r.read<String>('id'),
        language: r.read<String>('language'),
        headword: r.read<String>('headword'),
        reading: r.readNullable<String>('reading'),
        pos: r.readNullable<String>('pos'),
        phonetic: r.readNullable<String>('phonetic'),
        meanings: r.read<String>('meanings'),
        examples: r.read<String>('examples'),
        difficulty: r.read<double>('difficulty'),
        level: r.read<String>('level'),
        freqRank: r.readNullable<int>('freq_rank'),
        tags: r.readNullable<String>('tags'),
      );
}
