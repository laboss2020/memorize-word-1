import 'package:drift/drift.dart';

/// 词库表（种子数据，只读）。
///
/// id 为内容寻址的确定性 UUID（uuid5(namespace, "lang|headword|pos")），
/// 保证同一单词在任何设备上的 id 一致，是导出/导入与云同步的基础。
@TableIndex(name: 'idx_words_lang_diff', columns: {#language, #difficulty})
@TableIndex(name: 'idx_words_lang_headword', columns: {#language, #headword})
class Words extends Table {
  TextColumn get id => text()();
  TextColumn get language => text()(); // 'en' | 'ja'
  TextColumn get headword => text()(); // 英: word；日: 表记（漢字/かな）
  TextColumn get reading => text().nullable()(); // 日语读音（かな），英语可空
  TextColumn get pos => text().nullable()(); // 词性，如 n./v./v5u
  TextColumn get phonetic => text().nullable()(); // 英语音标
  // JSON: [{"lang":"zh","def":"..."}]，释义语言可扩展
  TextColumn get meanings => text()();
  // JSON: [{"text":"...","translation":"..."}]，1-3 条例句，可为 '[]'
  TextColumn get examples => text()();
  RealColumn get difficulty => real()(); // 1.0-6.0，定级与抽题依据
  TextColumn get level => text()(); // 英: A1..C2；日: N5..N1
  IntColumn get freqRank => integer().nullable()(); // 频率排名（级内序）
  TextColumn get tags => text().nullable()(); // JSON 数组，主题标签

  @override
  Set<Column> get primaryKey => {id};

  @override
  List<String> get customConstraints => ['UNIQUE (language, headword, pos)'];
}

/// 词书/分级结构（流水线静态生成，如 en-cefr-a1、ja-jlpt-n3）。
class Decks extends Table {
  TextColumn get id => text()(); // 如 'en-cefr-a1'
  TextColumn get language => text()();
  TextColumn get name => text()(); // 展示名，如 "英语 A1"
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {id};
}

/// 词书-单词关联。
class DeckWords extends Table {
  TextColumn get deckId => text()();
  TextColumn get wordId => text()();
  IntColumn get sortOrder => integer()();

  @override
  Set<Column> get primaryKey => {deckId, wordId};
}
