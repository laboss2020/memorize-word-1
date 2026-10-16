// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'app_database.dart';

// ignore_for_file: type=lint
class $WordsTable extends Words with TableInfo<$WordsTable, Word> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _headwordMeta = const VerificationMeta(
    'headword',
  );
  @override
  late final GeneratedColumn<String> headword = GeneratedColumn<String>(
    'headword',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _readingMeta = const VerificationMeta(
    'reading',
  );
  @override
  late final GeneratedColumn<String> reading = GeneratedColumn<String>(
    'reading',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _posMeta = const VerificationMeta('pos');
  @override
  late final GeneratedColumn<String> pos = GeneratedColumn<String>(
    'pos',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _phoneticMeta = const VerificationMeta(
    'phonetic',
  );
  @override
  late final GeneratedColumn<String> phonetic = GeneratedColumn<String>(
    'phonetic',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _meaningsMeta = const VerificationMeta(
    'meanings',
  );
  @override
  late final GeneratedColumn<String> meanings = GeneratedColumn<String>(
    'meanings',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _examplesMeta = const VerificationMeta(
    'examples',
  );
  @override
  late final GeneratedColumn<String> examples = GeneratedColumn<String>(
    'examples',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    false,
    type: DriftSqlType.double,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _levelMeta = const VerificationMeta('level');
  @override
  late final GeneratedColumn<String> level = GeneratedColumn<String>(
    'level',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _freqRankMeta = const VerificationMeta(
    'freqRank',
  );
  @override
  late final GeneratedColumn<int> freqRank = GeneratedColumn<int>(
    'freq_rank',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _tagsMeta = const VerificationMeta('tags');
  @override
  late final GeneratedColumn<String> tags = GeneratedColumn<String>(
    'tags',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    headword,
    reading,
    pos,
    phonetic,
    meanings,
    examples,
    difficulty,
    level,
    freqRank,
    tags,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'words';
  @override
  VerificationContext validateIntegrity(
    Insertable<Word> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('headword')) {
      context.handle(
        _headwordMeta,
        headword.isAcceptableOrUnknown(data['headword']!, _headwordMeta),
      );
    } else if (isInserting) {
      context.missing(_headwordMeta);
    }
    if (data.containsKey('reading')) {
      context.handle(
        _readingMeta,
        reading.isAcceptableOrUnknown(data['reading']!, _readingMeta),
      );
    }
    if (data.containsKey('pos')) {
      context.handle(
        _posMeta,
        pos.isAcceptableOrUnknown(data['pos']!, _posMeta),
      );
    }
    if (data.containsKey('phonetic')) {
      context.handle(
        _phoneticMeta,
        phonetic.isAcceptableOrUnknown(data['phonetic']!, _phoneticMeta),
      );
    }
    if (data.containsKey('meanings')) {
      context.handle(
        _meaningsMeta,
        meanings.isAcceptableOrUnknown(data['meanings']!, _meaningsMeta),
      );
    } else if (isInserting) {
      context.missing(_meaningsMeta);
    }
    if (data.containsKey('examples')) {
      context.handle(
        _examplesMeta,
        examples.isAcceptableOrUnknown(data['examples']!, _examplesMeta),
      );
    } else if (isInserting) {
      context.missing(_examplesMeta);
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    } else if (isInserting) {
      context.missing(_difficultyMeta);
    }
    if (data.containsKey('level')) {
      context.handle(
        _levelMeta,
        level.isAcceptableOrUnknown(data['level']!, _levelMeta),
      );
    } else if (isInserting) {
      context.missing(_levelMeta);
    }
    if (data.containsKey('freq_rank')) {
      context.handle(
        _freqRankMeta,
        freqRank.isAcceptableOrUnknown(data['freq_rank']!, _freqRankMeta),
      );
    }
    if (data.containsKey('tags')) {
      context.handle(
        _tagsMeta,
        tags.isAcceptableOrUnknown(data['tags']!, _tagsMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Word map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Word(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      headword: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}headword'],
      )!,
      reading: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reading'],
      ),
      pos: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}pos'],
      ),
      phonetic: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}phonetic'],
      ),
      meanings: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}meanings'],
      )!,
      examples: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}examples'],
      )!,
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      )!,
      level: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}level'],
      )!,
      freqRank: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}freq_rank'],
      ),
      tags: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}tags'],
      ),
    );
  }

  @override
  $WordsTable createAlias(String alias) {
    return $WordsTable(attachedDatabase, alias);
  }
}

class Word extends DataClass implements Insertable<Word> {
  final String id;
  final String language;
  final String headword;
  final String? reading;
  final String? pos;
  final String? phonetic;
  final String meanings;
  final String examples;
  final double difficulty;
  final String level;
  final int? freqRank;
  final String? tags;
  const Word({
    required this.id,
    required this.language,
    required this.headword,
    this.reading,
    this.pos,
    this.phonetic,
    required this.meanings,
    required this.examples,
    required this.difficulty,
    required this.level,
    this.freqRank,
    this.tags,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language'] = Variable<String>(language);
    map['headword'] = Variable<String>(headword);
    if (!nullToAbsent || reading != null) {
      map['reading'] = Variable<String>(reading);
    }
    if (!nullToAbsent || pos != null) {
      map['pos'] = Variable<String>(pos);
    }
    if (!nullToAbsent || phonetic != null) {
      map['phonetic'] = Variable<String>(phonetic);
    }
    map['meanings'] = Variable<String>(meanings);
    map['examples'] = Variable<String>(examples);
    map['difficulty'] = Variable<double>(difficulty);
    map['level'] = Variable<String>(level);
    if (!nullToAbsent || freqRank != null) {
      map['freq_rank'] = Variable<int>(freqRank);
    }
    if (!nullToAbsent || tags != null) {
      map['tags'] = Variable<String>(tags);
    }
    return map;
  }

  WordsCompanion toCompanion(bool nullToAbsent) {
    return WordsCompanion(
      id: Value(id),
      language: Value(language),
      headword: Value(headword),
      reading: reading == null && nullToAbsent
          ? const Value.absent()
          : Value(reading),
      pos: pos == null && nullToAbsent ? const Value.absent() : Value(pos),
      phonetic: phonetic == null && nullToAbsent
          ? const Value.absent()
          : Value(phonetic),
      meanings: Value(meanings),
      examples: Value(examples),
      difficulty: Value(difficulty),
      level: Value(level),
      freqRank: freqRank == null && nullToAbsent
          ? const Value.absent()
          : Value(freqRank),
      tags: tags == null && nullToAbsent ? const Value.absent() : Value(tags),
    );
  }

  factory Word.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Word(
      id: serializer.fromJson<String>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      headword: serializer.fromJson<String>(json['headword']),
      reading: serializer.fromJson<String?>(json['reading']),
      pos: serializer.fromJson<String?>(json['pos']),
      phonetic: serializer.fromJson<String?>(json['phonetic']),
      meanings: serializer.fromJson<String>(json['meanings']),
      examples: serializer.fromJson<String>(json['examples']),
      difficulty: serializer.fromJson<double>(json['difficulty']),
      level: serializer.fromJson<String>(json['level']),
      freqRank: serializer.fromJson<int?>(json['freqRank']),
      tags: serializer.fromJson<String?>(json['tags']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'language': serializer.toJson<String>(language),
      'headword': serializer.toJson<String>(headword),
      'reading': serializer.toJson<String?>(reading),
      'pos': serializer.toJson<String?>(pos),
      'phonetic': serializer.toJson<String?>(phonetic),
      'meanings': serializer.toJson<String>(meanings),
      'examples': serializer.toJson<String>(examples),
      'difficulty': serializer.toJson<double>(difficulty),
      'level': serializer.toJson<String>(level),
      'freqRank': serializer.toJson<int?>(freqRank),
      'tags': serializer.toJson<String?>(tags),
    };
  }

  Word copyWith({
    String? id,
    String? language,
    String? headword,
    Value<String?> reading = const Value.absent(),
    Value<String?> pos = const Value.absent(),
    Value<String?> phonetic = const Value.absent(),
    String? meanings,
    String? examples,
    double? difficulty,
    String? level,
    Value<int?> freqRank = const Value.absent(),
    Value<String?> tags = const Value.absent(),
  }) => Word(
    id: id ?? this.id,
    language: language ?? this.language,
    headword: headword ?? this.headword,
    reading: reading.present ? reading.value : this.reading,
    pos: pos.present ? pos.value : this.pos,
    phonetic: phonetic.present ? phonetic.value : this.phonetic,
    meanings: meanings ?? this.meanings,
    examples: examples ?? this.examples,
    difficulty: difficulty ?? this.difficulty,
    level: level ?? this.level,
    freqRank: freqRank.present ? freqRank.value : this.freqRank,
    tags: tags.present ? tags.value : this.tags,
  );
  Word copyWithCompanion(WordsCompanion data) {
    return Word(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      headword: data.headword.present ? data.headword.value : this.headword,
      reading: data.reading.present ? data.reading.value : this.reading,
      pos: data.pos.present ? data.pos.value : this.pos,
      phonetic: data.phonetic.present ? data.phonetic.value : this.phonetic,
      meanings: data.meanings.present ? data.meanings.value : this.meanings,
      examples: data.examples.present ? data.examples.value : this.examples,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      level: data.level.present ? data.level.value : this.level,
      freqRank: data.freqRank.present ? data.freqRank.value : this.freqRank,
      tags: data.tags.present ? data.tags.value : this.tags,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Word(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('headword: $headword, ')
          ..write('reading: $reading, ')
          ..write('pos: $pos, ')
          ..write('phonetic: $phonetic, ')
          ..write('meanings: $meanings, ')
          ..write('examples: $examples, ')
          ..write('difficulty: $difficulty, ')
          ..write('level: $level, ')
          ..write('freqRank: $freqRank, ')
          ..write('tags: $tags')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    language,
    headword,
    reading,
    pos,
    phonetic,
    meanings,
    examples,
    difficulty,
    level,
    freqRank,
    tags,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Word &&
          other.id == this.id &&
          other.language == this.language &&
          other.headword == this.headword &&
          other.reading == this.reading &&
          other.pos == this.pos &&
          other.phonetic == this.phonetic &&
          other.meanings == this.meanings &&
          other.examples == this.examples &&
          other.difficulty == this.difficulty &&
          other.level == this.level &&
          other.freqRank == this.freqRank &&
          other.tags == this.tags);
}

class WordsCompanion extends UpdateCompanion<Word> {
  final Value<String> id;
  final Value<String> language;
  final Value<String> headword;
  final Value<String?> reading;
  final Value<String?> pos;
  final Value<String?> phonetic;
  final Value<String> meanings;
  final Value<String> examples;
  final Value<double> difficulty;
  final Value<String> level;
  final Value<int?> freqRank;
  final Value<String?> tags;
  final Value<int> rowid;
  const WordsCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.headword = const Value.absent(),
    this.reading = const Value.absent(),
    this.pos = const Value.absent(),
    this.phonetic = const Value.absent(),
    this.meanings = const Value.absent(),
    this.examples = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.level = const Value.absent(),
    this.freqRank = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordsCompanion.insert({
    required String id,
    required String language,
    required String headword,
    this.reading = const Value.absent(),
    this.pos = const Value.absent(),
    this.phonetic = const Value.absent(),
    required String meanings,
    required String examples,
    required double difficulty,
    required String level,
    this.freqRank = const Value.absent(),
    this.tags = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       language = Value(language),
       headword = Value(headword),
       meanings = Value(meanings),
       examples = Value(examples),
       difficulty = Value(difficulty),
       level = Value(level);
  static Insertable<Word> custom({
    Expression<String>? id,
    Expression<String>? language,
    Expression<String>? headword,
    Expression<String>? reading,
    Expression<String>? pos,
    Expression<String>? phonetic,
    Expression<String>? meanings,
    Expression<String>? examples,
    Expression<double>? difficulty,
    Expression<String>? level,
    Expression<int>? freqRank,
    Expression<String>? tags,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (headword != null) 'headword': headword,
      if (reading != null) 'reading': reading,
      if (pos != null) 'pos': pos,
      if (phonetic != null) 'phonetic': phonetic,
      if (meanings != null) 'meanings': meanings,
      if (examples != null) 'examples': examples,
      if (difficulty != null) 'difficulty': difficulty,
      if (level != null) 'level': level,
      if (freqRank != null) 'freq_rank': freqRank,
      if (tags != null) 'tags': tags,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordsCompanion copyWith({
    Value<String>? id,
    Value<String>? language,
    Value<String>? headword,
    Value<String?>? reading,
    Value<String?>? pos,
    Value<String?>? phonetic,
    Value<String>? meanings,
    Value<String>? examples,
    Value<double>? difficulty,
    Value<String>? level,
    Value<int?>? freqRank,
    Value<String?>? tags,
    Value<int>? rowid,
  }) {
    return WordsCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      headword: headword ?? this.headword,
      reading: reading ?? this.reading,
      pos: pos ?? this.pos,
      phonetic: phonetic ?? this.phonetic,
      meanings: meanings ?? this.meanings,
      examples: examples ?? this.examples,
      difficulty: difficulty ?? this.difficulty,
      level: level ?? this.level,
      freqRank: freqRank ?? this.freqRank,
      tags: tags ?? this.tags,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (headword.present) {
      map['headword'] = Variable<String>(headword.value);
    }
    if (reading.present) {
      map['reading'] = Variable<String>(reading.value);
    }
    if (pos.present) {
      map['pos'] = Variable<String>(pos.value);
    }
    if (phonetic.present) {
      map['phonetic'] = Variable<String>(phonetic.value);
    }
    if (meanings.present) {
      map['meanings'] = Variable<String>(meanings.value);
    }
    if (examples.present) {
      map['examples'] = Variable<String>(examples.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (level.present) {
      map['level'] = Variable<String>(level.value);
    }
    if (freqRank.present) {
      map['freq_rank'] = Variable<int>(freqRank.value);
    }
    if (tags.present) {
      map['tags'] = Variable<String>(tags.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordsCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('headword: $headword, ')
          ..write('reading: $reading, ')
          ..write('pos: $pos, ')
          ..write('phonetic: $phonetic, ')
          ..write('meanings: $meanings, ')
          ..write('examples: $examples, ')
          ..write('difficulty: $difficulty, ')
          ..write('level: $level, ')
          ..write('freqRank: $freqRank, ')
          ..write('tags: $tags, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DecksTable extends Decks with TableInfo<$DecksTable, Deck> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DecksTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _nameMeta = const VerificationMeta('name');
  @override
  late final GeneratedColumn<String> name = GeneratedColumn<String>(
    'name',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [id, language, name, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'decks';
  @override
  VerificationContext validateIntegrity(
    Insertable<Deck> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('name')) {
      context.handle(
        _nameMeta,
        name.isAcceptableOrUnknown(data['name']!, _nameMeta),
      );
    } else if (isInserting) {
      context.missing(_nameMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Deck map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Deck(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      name: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}name'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DecksTable createAlias(String alias) {
    return $DecksTable(attachedDatabase, alias);
  }
}

class Deck extends DataClass implements Insertable<Deck> {
  final String id;
  final String language;
  final String name;
  final int sortOrder;
  const Deck({
    required this.id,
    required this.language,
    required this.name,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language'] = Variable<String>(language);
    map['name'] = Variable<String>(name);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DecksCompanion toCompanion(bool nullToAbsent) {
    return DecksCompanion(
      id: Value(id),
      language: Value(language),
      name: Value(name),
      sortOrder: Value(sortOrder),
    );
  }

  factory Deck.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Deck(
      id: serializer.fromJson<String>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      name: serializer.fromJson<String>(json['name']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'language': serializer.toJson<String>(language),
      'name': serializer.toJson<String>(name),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  Deck copyWith({String? id, String? language, String? name, int? sortOrder}) =>
      Deck(
        id: id ?? this.id,
        language: language ?? this.language,
        name: name ?? this.name,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  Deck copyWithCompanion(DecksCompanion data) {
    return Deck(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      name: data.name.present ? data.name.value : this.name,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Deck(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(id, language, name, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Deck &&
          other.id == this.id &&
          other.language == this.language &&
          other.name == this.name &&
          other.sortOrder == this.sortOrder);
}

class DecksCompanion extends UpdateCompanion<Deck> {
  final Value<String> id;
  final Value<String> language;
  final Value<String> name;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DecksCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.name = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DecksCompanion.insert({
    required String id,
    required String language,
    required String name,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       language = Value(language),
       name = Value(name),
       sortOrder = Value(sortOrder);
  static Insertable<Deck> custom({
    Expression<String>? id,
    Expression<String>? language,
    Expression<String>? name,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (name != null) 'name': name,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DecksCompanion copyWith({
    Value<String>? id,
    Value<String>? language,
    Value<String>? name,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DecksCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      name: name ?? this.name,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (name.present) {
      map['name'] = Variable<String>(name.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DecksCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('name: $name, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DeckWordsTable extends DeckWords
    with TableInfo<$DeckWordsTable, DeckWord> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DeckWordsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _deckIdMeta = const VerificationMeta('deckId');
  @override
  late final GeneratedColumn<String> deckId = GeneratedColumn<String>(
    'deck_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _sortOrderMeta = const VerificationMeta(
    'sortOrder',
  );
  @override
  late final GeneratedColumn<int> sortOrder = GeneratedColumn<int>(
    'sort_order',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [deckId, wordId, sortOrder];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'deck_words';
  @override
  VerificationContext validateIntegrity(
    Insertable<DeckWord> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('deck_id')) {
      context.handle(
        _deckIdMeta,
        deckId.isAcceptableOrUnknown(data['deck_id']!, _deckIdMeta),
      );
    } else if (isInserting) {
      context.missing(_deckIdMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('sort_order')) {
      context.handle(
        _sortOrderMeta,
        sortOrder.isAcceptableOrUnknown(data['sort_order']!, _sortOrderMeta),
      );
    } else if (isInserting) {
      context.missing(_sortOrderMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {deckId, wordId};
  @override
  DeckWord map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DeckWord(
      deckId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}deck_id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      sortOrder: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sort_order'],
      )!,
    );
  }

  @override
  $DeckWordsTable createAlias(String alias) {
    return $DeckWordsTable(attachedDatabase, alias);
  }
}

class DeckWord extends DataClass implements Insertable<DeckWord> {
  final String deckId;
  final String wordId;
  final int sortOrder;
  const DeckWord({
    required this.deckId,
    required this.wordId,
    required this.sortOrder,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['deck_id'] = Variable<String>(deckId);
    map['word_id'] = Variable<String>(wordId);
    map['sort_order'] = Variable<int>(sortOrder);
    return map;
  }

  DeckWordsCompanion toCompanion(bool nullToAbsent) {
    return DeckWordsCompanion(
      deckId: Value(deckId),
      wordId: Value(wordId),
      sortOrder: Value(sortOrder),
    );
  }

  factory DeckWord.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DeckWord(
      deckId: serializer.fromJson<String>(json['deckId']),
      wordId: serializer.fromJson<String>(json['wordId']),
      sortOrder: serializer.fromJson<int>(json['sortOrder']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'deckId': serializer.toJson<String>(deckId),
      'wordId': serializer.toJson<String>(wordId),
      'sortOrder': serializer.toJson<int>(sortOrder),
    };
  }

  DeckWord copyWith({String? deckId, String? wordId, int? sortOrder}) =>
      DeckWord(
        deckId: deckId ?? this.deckId,
        wordId: wordId ?? this.wordId,
        sortOrder: sortOrder ?? this.sortOrder,
      );
  DeckWord copyWithCompanion(DeckWordsCompanion data) {
    return DeckWord(
      deckId: data.deckId.present ? data.deckId.value : this.deckId,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      sortOrder: data.sortOrder.present ? data.sortOrder.value : this.sortOrder,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DeckWord(')
          ..write('deckId: $deckId, ')
          ..write('wordId: $wordId, ')
          ..write('sortOrder: $sortOrder')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(deckId, wordId, sortOrder);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DeckWord &&
          other.deckId == this.deckId &&
          other.wordId == this.wordId &&
          other.sortOrder == this.sortOrder);
}

class DeckWordsCompanion extends UpdateCompanion<DeckWord> {
  final Value<String> deckId;
  final Value<String> wordId;
  final Value<int> sortOrder;
  final Value<int> rowid;
  const DeckWordsCompanion({
    this.deckId = const Value.absent(),
    this.wordId = const Value.absent(),
    this.sortOrder = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DeckWordsCompanion.insert({
    required String deckId,
    required String wordId,
    required int sortOrder,
    this.rowid = const Value.absent(),
  }) : deckId = Value(deckId),
       wordId = Value(wordId),
       sortOrder = Value(sortOrder);
  static Insertable<DeckWord> custom({
    Expression<String>? deckId,
    Expression<String>? wordId,
    Expression<int>? sortOrder,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (deckId != null) 'deck_id': deckId,
      if (wordId != null) 'word_id': wordId,
      if (sortOrder != null) 'sort_order': sortOrder,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DeckWordsCompanion copyWith({
    Value<String>? deckId,
    Value<String>? wordId,
    Value<int>? sortOrder,
    Value<int>? rowid,
  }) {
    return DeckWordsCompanion(
      deckId: deckId ?? this.deckId,
      wordId: wordId ?? this.wordId,
      sortOrder: sortOrder ?? this.sortOrder,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (deckId.present) {
      map['deck_id'] = Variable<String>(deckId.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (sortOrder.present) {
      map['sort_order'] = Variable<int>(sortOrder.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DeckWordsCompanion(')
          ..write('deckId: $deckId, ')
          ..write('wordId: $wordId, ')
          ..write('sortOrder: $sortOrder, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $WordProgressTable extends WordProgress
    with TableInfo<$WordProgressTable, WordProgressData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $WordProgressTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stateMeta = const VerificationMeta('state');
  @override
  late final GeneratedColumn<int> state = GeneratedColumn<int>(
    'state',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _dueMeta = const VerificationMeta('due');
  @override
  late final GeneratedColumn<int> due = GeneratedColumn<int>(
    'due',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _stabilityMeta = const VerificationMeta(
    'stability',
  );
  @override
  late final GeneratedColumn<double> stability = GeneratedColumn<double>(
    'stability',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _difficultyMeta = const VerificationMeta(
    'difficulty',
  );
  @override
  late final GeneratedColumn<double> difficulty = GeneratedColumn<double>(
    'difficulty',
    aliasedName,
    true,
    type: DriftSqlType.double,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _stepMeta = const VerificationMeta('step');
  @override
  late final GeneratedColumn<int> step = GeneratedColumn<int>(
    'step',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _elapsedDaysMeta = const VerificationMeta(
    'elapsedDays',
  );
  @override
  late final GeneratedColumn<int> elapsedDays = GeneratedColumn<int>(
    'elapsed_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _scheduledDaysMeta = const VerificationMeta(
    'scheduledDays',
  );
  @override
  late final GeneratedColumn<int> scheduledDays = GeneratedColumn<int>(
    'scheduled_days',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _repsMeta = const VerificationMeta('reps');
  @override
  late final GeneratedColumn<int> reps = GeneratedColumn<int>(
    'reps',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lapsesMeta = const VerificationMeta('lapses');
  @override
  late final GeneratedColumn<int> lapses = GeneratedColumn<int>(
    'lapses',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _lastReviewAtMeta = const VerificationMeta(
    'lastReviewAt',
  );
  @override
  late final GeneratedColumn<int> lastReviewAt = GeneratedColumn<int>(
    'last_review_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    language,
    state,
    due,
    stability,
    difficulty,
    step,
    elapsedDays,
    scheduledDays,
    reps,
    lapses,
    lastReviewAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'word_progress';
  @override
  VerificationContext validateIntegrity(
    Insertable<WordProgressData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('state')) {
      context.handle(
        _stateMeta,
        state.isAcceptableOrUnknown(data['state']!, _stateMeta),
      );
    } else if (isInserting) {
      context.missing(_stateMeta);
    }
    if (data.containsKey('due')) {
      context.handle(
        _dueMeta,
        due.isAcceptableOrUnknown(data['due']!, _dueMeta),
      );
    } else if (isInserting) {
      context.missing(_dueMeta);
    }
    if (data.containsKey('stability')) {
      context.handle(
        _stabilityMeta,
        stability.isAcceptableOrUnknown(data['stability']!, _stabilityMeta),
      );
    }
    if (data.containsKey('difficulty')) {
      context.handle(
        _difficultyMeta,
        difficulty.isAcceptableOrUnknown(data['difficulty']!, _difficultyMeta),
      );
    }
    if (data.containsKey('step')) {
      context.handle(
        _stepMeta,
        step.isAcceptableOrUnknown(data['step']!, _stepMeta),
      );
    }
    if (data.containsKey('elapsed_days')) {
      context.handle(
        _elapsedDaysMeta,
        elapsedDays.isAcceptableOrUnknown(
          data['elapsed_days']!,
          _elapsedDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_elapsedDaysMeta);
    }
    if (data.containsKey('scheduled_days')) {
      context.handle(
        _scheduledDaysMeta,
        scheduledDays.isAcceptableOrUnknown(
          data['scheduled_days']!,
          _scheduledDaysMeta,
        ),
      );
    } else if (isInserting) {
      context.missing(_scheduledDaysMeta);
    }
    if (data.containsKey('reps')) {
      context.handle(
        _repsMeta,
        reps.isAcceptableOrUnknown(data['reps']!, _repsMeta),
      );
    } else if (isInserting) {
      context.missing(_repsMeta);
    }
    if (data.containsKey('lapses')) {
      context.handle(
        _lapsesMeta,
        lapses.isAcceptableOrUnknown(data['lapses']!, _lapsesMeta),
      );
    } else if (isInserting) {
      context.missing(_lapsesMeta);
    }
    if (data.containsKey('last_review_at')) {
      context.handle(
        _lastReviewAtMeta,
        lastReviewAt.isAcceptableOrUnknown(
          data['last_review_at']!,
          _lastReviewAtMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  List<Set<GeneratedColumn>> get uniqueKeys => [
    {wordId},
  ];
  @override
  WordProgressData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return WordProgressData(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      state: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}state'],
      )!,
      due: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}due'],
      )!,
      stability: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}stability'],
      ),
      difficulty: attachedDatabase.typeMapping.read(
        DriftSqlType.double,
        data['${effectivePrefix}difficulty'],
      ),
      step: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}step'],
      ),
      elapsedDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}elapsed_days'],
      )!,
      scheduledDays: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}scheduled_days'],
      )!,
      reps: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}reps'],
      )!,
      lapses: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}lapses'],
      )!,
      lastReviewAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}last_review_at'],
      ),
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $WordProgressTable createAlias(String alias) {
    return $WordProgressTable(attachedDatabase, alias);
  }
}

class WordProgressData extends DataClass
    implements Insertable<WordProgressData> {
  final String id;
  final String wordId;
  final String language;
  final int state;
  final int due;
  final double? stability;
  final double? difficulty;
  final int? step;
  final int elapsedDays;
  final int scheduledDays;
  final int reps;
  final int lapses;
  final int? lastReviewAt;
  final int updatedAt;
  final int? deletedAt;
  final int syncStatus;
  const WordProgressData({
    required this.id,
    required this.wordId,
    required this.language,
    required this.state,
    required this.due,
    this.stability,
    this.difficulty,
    this.step,
    required this.elapsedDays,
    required this.scheduledDays,
    required this.reps,
    required this.lapses,
    this.lastReviewAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word_id'] = Variable<String>(wordId);
    map['language'] = Variable<String>(language);
    map['state'] = Variable<int>(state);
    map['due'] = Variable<int>(due);
    if (!nullToAbsent || stability != null) {
      map['stability'] = Variable<double>(stability);
    }
    if (!nullToAbsent || difficulty != null) {
      map['difficulty'] = Variable<double>(difficulty);
    }
    if (!nullToAbsent || step != null) {
      map['step'] = Variable<int>(step);
    }
    map['elapsed_days'] = Variable<int>(elapsedDays);
    map['scheduled_days'] = Variable<int>(scheduledDays);
    map['reps'] = Variable<int>(reps);
    map['lapses'] = Variable<int>(lapses);
    if (!nullToAbsent || lastReviewAt != null) {
      map['last_review_at'] = Variable<int>(lastReviewAt);
    }
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  WordProgressCompanion toCompanion(bool nullToAbsent) {
    return WordProgressCompanion(
      id: Value(id),
      wordId: Value(wordId),
      language: Value(language),
      state: Value(state),
      due: Value(due),
      stability: stability == null && nullToAbsent
          ? const Value.absent()
          : Value(stability),
      difficulty: difficulty == null && nullToAbsent
          ? const Value.absent()
          : Value(difficulty),
      step: step == null && nullToAbsent ? const Value.absent() : Value(step),
      elapsedDays: Value(elapsedDays),
      scheduledDays: Value(scheduledDays),
      reps: Value(reps),
      lapses: Value(lapses),
      lastReviewAt: lastReviewAt == null && nullToAbsent
          ? const Value.absent()
          : Value(lastReviewAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory WordProgressData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return WordProgressData(
      id: serializer.fromJson<String>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      language: serializer.fromJson<String>(json['language']),
      state: serializer.fromJson<int>(json['state']),
      due: serializer.fromJson<int>(json['due']),
      stability: serializer.fromJson<double?>(json['stability']),
      difficulty: serializer.fromJson<double?>(json['difficulty']),
      step: serializer.fromJson<int?>(json['step']),
      elapsedDays: serializer.fromJson<int>(json['elapsedDays']),
      scheduledDays: serializer.fromJson<int>(json['scheduledDays']),
      reps: serializer.fromJson<int>(json['reps']),
      lapses: serializer.fromJson<int>(json['lapses']),
      lastReviewAt: serializer.fromJson<int?>(json['lastReviewAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wordId': serializer.toJson<String>(wordId),
      'language': serializer.toJson<String>(language),
      'state': serializer.toJson<int>(state),
      'due': serializer.toJson<int>(due),
      'stability': serializer.toJson<double?>(stability),
      'difficulty': serializer.toJson<double?>(difficulty),
      'step': serializer.toJson<int?>(step),
      'elapsedDays': serializer.toJson<int>(elapsedDays),
      'scheduledDays': serializer.toJson<int>(scheduledDays),
      'reps': serializer.toJson<int>(reps),
      'lapses': serializer.toJson<int>(lapses),
      'lastReviewAt': serializer.toJson<int?>(lastReviewAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  WordProgressData copyWith({
    String? id,
    String? wordId,
    String? language,
    int? state,
    int? due,
    Value<double?> stability = const Value.absent(),
    Value<double?> difficulty = const Value.absent(),
    Value<int?> step = const Value.absent(),
    int? elapsedDays,
    int? scheduledDays,
    int? reps,
    int? lapses,
    Value<int?> lastReviewAt = const Value.absent(),
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    int? syncStatus,
  }) => WordProgressData(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    language: language ?? this.language,
    state: state ?? this.state,
    due: due ?? this.due,
    stability: stability.present ? stability.value : this.stability,
    difficulty: difficulty.present ? difficulty.value : this.difficulty,
    step: step.present ? step.value : this.step,
    elapsedDays: elapsedDays ?? this.elapsedDays,
    scheduledDays: scheduledDays ?? this.scheduledDays,
    reps: reps ?? this.reps,
    lapses: lapses ?? this.lapses,
    lastReviewAt: lastReviewAt.present ? lastReviewAt.value : this.lastReviewAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  WordProgressData copyWithCompanion(WordProgressCompanion data) {
    return WordProgressData(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      language: data.language.present ? data.language.value : this.language,
      state: data.state.present ? data.state.value : this.state,
      due: data.due.present ? data.due.value : this.due,
      stability: data.stability.present ? data.stability.value : this.stability,
      difficulty: data.difficulty.present
          ? data.difficulty.value
          : this.difficulty,
      step: data.step.present ? data.step.value : this.step,
      elapsedDays: data.elapsedDays.present
          ? data.elapsedDays.value
          : this.elapsedDays,
      scheduledDays: data.scheduledDays.present
          ? data.scheduledDays.value
          : this.scheduledDays,
      reps: data.reps.present ? data.reps.value : this.reps,
      lapses: data.lapses.present ? data.lapses.value : this.lapses,
      lastReviewAt: data.lastReviewAt.present
          ? data.lastReviewAt.value
          : this.lastReviewAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('WordProgressData(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('language: $language, ')
          ..write('state: $state, ')
          ..write('due: $due, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('step: $step, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewAt: $lastReviewAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wordId,
    language,
    state,
    due,
    stability,
    difficulty,
    step,
    elapsedDays,
    scheduledDays,
    reps,
    lapses,
    lastReviewAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is WordProgressData &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.language == this.language &&
          other.state == this.state &&
          other.due == this.due &&
          other.stability == this.stability &&
          other.difficulty == this.difficulty &&
          other.step == this.step &&
          other.elapsedDays == this.elapsedDays &&
          other.scheduledDays == this.scheduledDays &&
          other.reps == this.reps &&
          other.lapses == this.lapses &&
          other.lastReviewAt == this.lastReviewAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class WordProgressCompanion extends UpdateCompanion<WordProgressData> {
  final Value<String> id;
  final Value<String> wordId;
  final Value<String> language;
  final Value<int> state;
  final Value<int> due;
  final Value<double?> stability;
  final Value<double?> difficulty;
  final Value<int?> step;
  final Value<int> elapsedDays;
  final Value<int> scheduledDays;
  final Value<int> reps;
  final Value<int> lapses;
  final Value<int?> lastReviewAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const WordProgressCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.language = const Value.absent(),
    this.state = const Value.absent(),
    this.due = const Value.absent(),
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.step = const Value.absent(),
    this.elapsedDays = const Value.absent(),
    this.scheduledDays = const Value.absent(),
    this.reps = const Value.absent(),
    this.lapses = const Value.absent(),
    this.lastReviewAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  WordProgressCompanion.insert({
    required String id,
    required String wordId,
    required String language,
    required int state,
    required int due,
    this.stability = const Value.absent(),
    this.difficulty = const Value.absent(),
    this.step = const Value.absent(),
    required int elapsedDays,
    required int scheduledDays,
    required int reps,
    required int lapses,
    this.lastReviewAt = const Value.absent(),
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wordId = Value(wordId),
       language = Value(language),
       state = Value(state),
       due = Value(due),
       elapsedDays = Value(elapsedDays),
       scheduledDays = Value(scheduledDays),
       reps = Value(reps),
       lapses = Value(lapses),
       updatedAt = Value(updatedAt);
  static Insertable<WordProgressData> custom({
    Expression<String>? id,
    Expression<String>? wordId,
    Expression<String>? language,
    Expression<int>? state,
    Expression<int>? due,
    Expression<double>? stability,
    Expression<double>? difficulty,
    Expression<int>? step,
    Expression<int>? elapsedDays,
    Expression<int>? scheduledDays,
    Expression<int>? reps,
    Expression<int>? lapses,
    Expression<int>? lastReviewAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (language != null) 'language': language,
      if (state != null) 'state': state,
      if (due != null) 'due': due,
      if (stability != null) 'stability': stability,
      if (difficulty != null) 'difficulty': difficulty,
      if (step != null) 'step': step,
      if (elapsedDays != null) 'elapsed_days': elapsedDays,
      if (scheduledDays != null) 'scheduled_days': scheduledDays,
      if (reps != null) 'reps': reps,
      if (lapses != null) 'lapses': lapses,
      if (lastReviewAt != null) 'last_review_at': lastReviewAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  WordProgressCompanion copyWith({
    Value<String>? id,
    Value<String>? wordId,
    Value<String>? language,
    Value<int>? state,
    Value<int>? due,
    Value<double?>? stability,
    Value<double?>? difficulty,
    Value<int?>? step,
    Value<int>? elapsedDays,
    Value<int>? scheduledDays,
    Value<int>? reps,
    Value<int>? lapses,
    Value<int?>? lastReviewAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return WordProgressCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      language: language ?? this.language,
      state: state ?? this.state,
      due: due ?? this.due,
      stability: stability ?? this.stability,
      difficulty: difficulty ?? this.difficulty,
      step: step ?? this.step,
      elapsedDays: elapsedDays ?? this.elapsedDays,
      scheduledDays: scheduledDays ?? this.scheduledDays,
      reps: reps ?? this.reps,
      lapses: lapses ?? this.lapses,
      lastReviewAt: lastReviewAt ?? this.lastReviewAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (state.present) {
      map['state'] = Variable<int>(state.value);
    }
    if (due.present) {
      map['due'] = Variable<int>(due.value);
    }
    if (stability.present) {
      map['stability'] = Variable<double>(stability.value);
    }
    if (difficulty.present) {
      map['difficulty'] = Variable<double>(difficulty.value);
    }
    if (step.present) {
      map['step'] = Variable<int>(step.value);
    }
    if (elapsedDays.present) {
      map['elapsed_days'] = Variable<int>(elapsedDays.value);
    }
    if (scheduledDays.present) {
      map['scheduled_days'] = Variable<int>(scheduledDays.value);
    }
    if (reps.present) {
      map['reps'] = Variable<int>(reps.value);
    }
    if (lapses.present) {
      map['lapses'] = Variable<int>(lapses.value);
    }
    if (lastReviewAt.present) {
      map['last_review_at'] = Variable<int>(lastReviewAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('WordProgressCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('language: $language, ')
          ..write('state: $state, ')
          ..write('due: $due, ')
          ..write('stability: $stability, ')
          ..write('difficulty: $difficulty, ')
          ..write('step: $step, ')
          ..write('elapsedDays: $elapsedDays, ')
          ..write('scheduledDays: $scheduledDays, ')
          ..write('reps: $reps, ')
          ..write('lapses: $lapses, ')
          ..write('lastReviewAt: $lastReviewAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudyLogsTable extends StudyLogs
    with TableInfo<$StudyLogsTable, StudyLog> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudyLogsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _wordIdMeta = const VerificationMeta('wordId');
  @override
  late final GeneratedColumn<String> wordId = GeneratedColumn<String>(
    'word_id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _modeMeta = const VerificationMeta('mode');
  @override
  late final GeneratedColumn<String> mode = GeneratedColumn<String>(
    'mode',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _ratingMeta = const VerificationMeta('rating');
  @override
  late final GeneratedColumn<int> rating = GeneratedColumn<int>(
    'rating',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _correctMeta = const VerificationMeta(
    'correct',
  );
  @override
  late final GeneratedColumn<bool> correct = GeneratedColumn<bool>(
    'correct',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: true,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("correct" IN (0, 1))',
    ),
  );
  static const VerificationMeta _durationMsMeta = const VerificationMeta(
    'durationMs',
  );
  @override
  late final GeneratedColumn<int> durationMs = GeneratedColumn<int>(
    'duration_ms',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _reviewLogMeta = const VerificationMeta(
    'reviewLog',
  );
  @override
  late final GeneratedColumn<String> reviewLog = GeneratedColumn<String>(
    'review_log',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _studiedAtMeta = const VerificationMeta(
    'studiedAt',
  );
  @override
  late final GeneratedColumn<int> studiedAt = GeneratedColumn<int>(
    'studied_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    wordId,
    mode,
    rating,
    correct,
    durationMs,
    reviewLog,
    studiedAt,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_logs';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudyLog> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('word_id')) {
      context.handle(
        _wordIdMeta,
        wordId.isAcceptableOrUnknown(data['word_id']!, _wordIdMeta),
      );
    } else if (isInserting) {
      context.missing(_wordIdMeta);
    }
    if (data.containsKey('mode')) {
      context.handle(
        _modeMeta,
        mode.isAcceptableOrUnknown(data['mode']!, _modeMeta),
      );
    } else if (isInserting) {
      context.missing(_modeMeta);
    }
    if (data.containsKey('rating')) {
      context.handle(
        _ratingMeta,
        rating.isAcceptableOrUnknown(data['rating']!, _ratingMeta),
      );
    } else if (isInserting) {
      context.missing(_ratingMeta);
    }
    if (data.containsKey('correct')) {
      context.handle(
        _correctMeta,
        correct.isAcceptableOrUnknown(data['correct']!, _correctMeta),
      );
    } else if (isInserting) {
      context.missing(_correctMeta);
    }
    if (data.containsKey('duration_ms')) {
      context.handle(
        _durationMsMeta,
        durationMs.isAcceptableOrUnknown(data['duration_ms']!, _durationMsMeta),
      );
    } else if (isInserting) {
      context.missing(_durationMsMeta);
    }
    if (data.containsKey('review_log')) {
      context.handle(
        _reviewLogMeta,
        reviewLog.isAcceptableOrUnknown(data['review_log']!, _reviewLogMeta),
      );
    }
    if (data.containsKey('studied_at')) {
      context.handle(
        _studiedAtMeta,
        studiedAt.isAcceptableOrUnknown(data['studied_at']!, _studiedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_studiedAtMeta);
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudyLog map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudyLog(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      wordId: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}word_id'],
      )!,
      mode: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}mode'],
      )!,
      rating: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}rating'],
      )!,
      correct: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}correct'],
      )!,
      durationMs: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}duration_ms'],
      )!,
      reviewLog: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}review_log'],
      ),
      studiedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}studied_at'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $StudyLogsTable createAlias(String alias) {
    return $StudyLogsTable(attachedDatabase, alias);
  }
}

class StudyLog extends DataClass implements Insertable<StudyLog> {
  final String id;
  final String wordId;
  final String mode;
  final int rating;
  final bool correct;
  final int durationMs;
  final String? reviewLog;
  final int studiedAt;
  final int updatedAt;
  final int? deletedAt;
  final int syncStatus;
  const StudyLog({
    required this.id,
    required this.wordId,
    required this.mode,
    required this.rating,
    required this.correct,
    required this.durationMs,
    this.reviewLog,
    required this.studiedAt,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['word_id'] = Variable<String>(wordId);
    map['mode'] = Variable<String>(mode);
    map['rating'] = Variable<int>(rating);
    map['correct'] = Variable<bool>(correct);
    map['duration_ms'] = Variable<int>(durationMs);
    if (!nullToAbsent || reviewLog != null) {
      map['review_log'] = Variable<String>(reviewLog);
    }
    map['studied_at'] = Variable<int>(studiedAt);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  StudyLogsCompanion toCompanion(bool nullToAbsent) {
    return StudyLogsCompanion(
      id: Value(id),
      wordId: Value(wordId),
      mode: Value(mode),
      rating: Value(rating),
      correct: Value(correct),
      durationMs: Value(durationMs),
      reviewLog: reviewLog == null && nullToAbsent
          ? const Value.absent()
          : Value(reviewLog),
      studiedAt: Value(studiedAt),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory StudyLog.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudyLog(
      id: serializer.fromJson<String>(json['id']),
      wordId: serializer.fromJson<String>(json['wordId']),
      mode: serializer.fromJson<String>(json['mode']),
      rating: serializer.fromJson<int>(json['rating']),
      correct: serializer.fromJson<bool>(json['correct']),
      durationMs: serializer.fromJson<int>(json['durationMs']),
      reviewLog: serializer.fromJson<String?>(json['reviewLog']),
      studiedAt: serializer.fromJson<int>(json['studiedAt']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'wordId': serializer.toJson<String>(wordId),
      'mode': serializer.toJson<String>(mode),
      'rating': serializer.toJson<int>(rating),
      'correct': serializer.toJson<bool>(correct),
      'durationMs': serializer.toJson<int>(durationMs),
      'reviewLog': serializer.toJson<String?>(reviewLog),
      'studiedAt': serializer.toJson<int>(studiedAt),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  StudyLog copyWith({
    String? id,
    String? wordId,
    String? mode,
    int? rating,
    bool? correct,
    int? durationMs,
    Value<String?> reviewLog = const Value.absent(),
    int? studiedAt,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    int? syncStatus,
  }) => StudyLog(
    id: id ?? this.id,
    wordId: wordId ?? this.wordId,
    mode: mode ?? this.mode,
    rating: rating ?? this.rating,
    correct: correct ?? this.correct,
    durationMs: durationMs ?? this.durationMs,
    reviewLog: reviewLog.present ? reviewLog.value : this.reviewLog,
    studiedAt: studiedAt ?? this.studiedAt,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  StudyLog copyWithCompanion(StudyLogsCompanion data) {
    return StudyLog(
      id: data.id.present ? data.id.value : this.id,
      wordId: data.wordId.present ? data.wordId.value : this.wordId,
      mode: data.mode.present ? data.mode.value : this.mode,
      rating: data.rating.present ? data.rating.value : this.rating,
      correct: data.correct.present ? data.correct.value : this.correct,
      durationMs: data.durationMs.present
          ? data.durationMs.value
          : this.durationMs,
      reviewLog: data.reviewLog.present ? data.reviewLog.value : this.reviewLog,
      studiedAt: data.studiedAt.present ? data.studiedAt.value : this.studiedAt,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudyLog(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('mode: $mode, ')
          ..write('rating: $rating, ')
          ..write('correct: $correct, ')
          ..write('durationMs: $durationMs, ')
          ..write('reviewLog: $reviewLog, ')
          ..write('studiedAt: $studiedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    wordId,
    mode,
    rating,
    correct,
    durationMs,
    reviewLog,
    studiedAt,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudyLog &&
          other.id == this.id &&
          other.wordId == this.wordId &&
          other.mode == this.mode &&
          other.rating == this.rating &&
          other.correct == this.correct &&
          other.durationMs == this.durationMs &&
          other.reviewLog == this.reviewLog &&
          other.studiedAt == this.studiedAt &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class StudyLogsCompanion extends UpdateCompanion<StudyLog> {
  final Value<String> id;
  final Value<String> wordId;
  final Value<String> mode;
  final Value<int> rating;
  final Value<bool> correct;
  final Value<int> durationMs;
  final Value<String?> reviewLog;
  final Value<int> studiedAt;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const StudyLogsCompanion({
    this.id = const Value.absent(),
    this.wordId = const Value.absent(),
    this.mode = const Value.absent(),
    this.rating = const Value.absent(),
    this.correct = const Value.absent(),
    this.durationMs = const Value.absent(),
    this.reviewLog = const Value.absent(),
    this.studiedAt = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudyLogsCompanion.insert({
    required String id,
    required String wordId,
    required String mode,
    required int rating,
    required bool correct,
    required int durationMs,
    this.reviewLog = const Value.absent(),
    required int studiedAt,
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       wordId = Value(wordId),
       mode = Value(mode),
       rating = Value(rating),
       correct = Value(correct),
       durationMs = Value(durationMs),
       studiedAt = Value(studiedAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudyLog> custom({
    Expression<String>? id,
    Expression<String>? wordId,
    Expression<String>? mode,
    Expression<int>? rating,
    Expression<bool>? correct,
    Expression<int>? durationMs,
    Expression<String>? reviewLog,
    Expression<int>? studiedAt,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (wordId != null) 'word_id': wordId,
      if (mode != null) 'mode': mode,
      if (rating != null) 'rating': rating,
      if (correct != null) 'correct': correct,
      if (durationMs != null) 'duration_ms': durationMs,
      if (reviewLog != null) 'review_log': reviewLog,
      if (studiedAt != null) 'studied_at': studiedAt,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudyLogsCompanion copyWith({
    Value<String>? id,
    Value<String>? wordId,
    Value<String>? mode,
    Value<int>? rating,
    Value<bool>? correct,
    Value<int>? durationMs,
    Value<String?>? reviewLog,
    Value<int>? studiedAt,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return StudyLogsCompanion(
      id: id ?? this.id,
      wordId: wordId ?? this.wordId,
      mode: mode ?? this.mode,
      rating: rating ?? this.rating,
      correct: correct ?? this.correct,
      durationMs: durationMs ?? this.durationMs,
      reviewLog: reviewLog ?? this.reviewLog,
      studiedAt: studiedAt ?? this.studiedAt,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (wordId.present) {
      map['word_id'] = Variable<String>(wordId.value);
    }
    if (mode.present) {
      map['mode'] = Variable<String>(mode.value);
    }
    if (rating.present) {
      map['rating'] = Variable<int>(rating.value);
    }
    if (correct.present) {
      map['correct'] = Variable<bool>(correct.value);
    }
    if (durationMs.present) {
      map['duration_ms'] = Variable<int>(durationMs.value);
    }
    if (reviewLog.present) {
      map['review_log'] = Variable<String>(reviewLog.value);
    }
    if (studiedAt.present) {
      map['studied_at'] = Variable<int>(studiedAt.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudyLogsCompanion(')
          ..write('id: $id, ')
          ..write('wordId: $wordId, ')
          ..write('mode: $mode, ')
          ..write('rating: $rating, ')
          ..write('correct: $correct, ')
          ..write('durationMs: $durationMs, ')
          ..write('reviewLog: $reviewLog, ')
          ..write('studiedAt: $studiedAt, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $SettingsTable extends Settings with TableInfo<$SettingsTable, Setting> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $SettingsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    clientDefault: () => 'local',
  );
  static const VerificationMeta _nativeLangMeta = const VerificationMeta(
    'nativeLang',
  );
  @override
  late final GeneratedColumn<String> nativeLang = GeneratedColumn<String>(
    'native_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('zh'),
  );
  static const VerificationMeta _learningLangMeta = const VerificationMeta(
    'learningLang',
  );
  @override
  late final GeneratedColumn<String> learningLang = GeneratedColumn<String>(
    'learning_lang',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('en'),
  );
  static const VerificationMeta _dailyNewLimitMeta = const VerificationMeta(
    'dailyNewLimit',
  );
  @override
  late final GeneratedColumn<int> dailyNewLimit = GeneratedColumn<int>(
    'daily_new_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(10),
  );
  static const VerificationMeta _dailyReviewLimitMeta = const VerificationMeta(
    'dailyReviewLimit',
  );
  @override
  late final GeneratedColumn<int> dailyReviewLimit = GeneratedColumn<int>(
    'daily_review_limit',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(50),
  );
  static const VerificationMeta _reminderEnabledMeta = const VerificationMeta(
    'reminderEnabled',
  );
  @override
  late final GeneratedColumn<bool> reminderEnabled = GeneratedColumn<bool>(
    'reminder_enabled',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("reminder_enabled" IN (0, 1))',
    ),
    defaultValue: const Constant(true),
  );
  static const VerificationMeta _reminderTimeMeta = const VerificationMeta(
    'reminderTime',
  );
  @override
  late final GeneratedColumn<String> reminderTime = GeneratedColumn<String>(
    'reminder_time',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
    defaultValue: const Constant('20:00'),
  );
  static const VerificationMeta _placementDoneMeta = const VerificationMeta(
    'placementDone',
  );
  @override
  late final GeneratedColumn<bool> placementDone = GeneratedColumn<bool>(
    'placement_done',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("placement_done" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _placementLevelEnMeta = const VerificationMeta(
    'placementLevelEn',
  );
  @override
  late final GeneratedColumn<String> placementLevelEn = GeneratedColumn<String>(
    'placement_level_en',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _placementLevelJaMeta = const VerificationMeta(
    'placementLevelJa',
  );
  @override
  late final GeneratedColumn<String> placementLevelJa = GeneratedColumn<String>(
    'placement_level_ja',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _dailyGoalMinutesMeta = const VerificationMeta(
    'dailyGoalMinutes',
  );
  @override
  late final GeneratedColumn<int> dailyGoalMinutes = GeneratedColumn<int>(
    'daily_goal_minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(15),
  );
  static const VerificationMeta _onboardedMeta = const VerificationMeta(
    'onboarded',
  );
  @override
  late final GeneratedColumn<bool> onboarded = GeneratedColumn<bool>(
    'onboarded',
    aliasedName,
    false,
    type: DriftSqlType.bool,
    requiredDuringInsert: false,
    defaultConstraints: GeneratedColumn.constraintIsAlways(
      'CHECK ("onboarded" IN (0, 1))',
    ),
    defaultValue: const Constant(false),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _deletedAtMeta = const VerificationMeta(
    'deletedAt',
  );
  @override
  late final GeneratedColumn<int> deletedAt = GeneratedColumn<int>(
    'deleted_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _syncStatusMeta = const VerificationMeta(
    'syncStatus',
  );
  @override
  late final GeneratedColumn<int> syncStatus = GeneratedColumn<int>(
    'sync_status',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    nativeLang,
    learningLang,
    dailyNewLimit,
    dailyReviewLimit,
    reminderEnabled,
    reminderTime,
    placementDone,
    placementLevelEn,
    placementLevelJa,
    dailyGoalMinutes,
    onboarded,
    updatedAt,
    deletedAt,
    syncStatus,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'settings';
  @override
  VerificationContext validateIntegrity(
    Insertable<Setting> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    }
    if (data.containsKey('native_lang')) {
      context.handle(
        _nativeLangMeta,
        nativeLang.isAcceptableOrUnknown(data['native_lang']!, _nativeLangMeta),
      );
    }
    if (data.containsKey('learning_lang')) {
      context.handle(
        _learningLangMeta,
        learningLang.isAcceptableOrUnknown(
          data['learning_lang']!,
          _learningLangMeta,
        ),
      );
    }
    if (data.containsKey('daily_new_limit')) {
      context.handle(
        _dailyNewLimitMeta,
        dailyNewLimit.isAcceptableOrUnknown(
          data['daily_new_limit']!,
          _dailyNewLimitMeta,
        ),
      );
    }
    if (data.containsKey('daily_review_limit')) {
      context.handle(
        _dailyReviewLimitMeta,
        dailyReviewLimit.isAcceptableOrUnknown(
          data['daily_review_limit']!,
          _dailyReviewLimitMeta,
        ),
      );
    }
    if (data.containsKey('reminder_enabled')) {
      context.handle(
        _reminderEnabledMeta,
        reminderEnabled.isAcceptableOrUnknown(
          data['reminder_enabled']!,
          _reminderEnabledMeta,
        ),
      );
    }
    if (data.containsKey('reminder_time')) {
      context.handle(
        _reminderTimeMeta,
        reminderTime.isAcceptableOrUnknown(
          data['reminder_time']!,
          _reminderTimeMeta,
        ),
      );
    }
    if (data.containsKey('placement_done')) {
      context.handle(
        _placementDoneMeta,
        placementDone.isAcceptableOrUnknown(
          data['placement_done']!,
          _placementDoneMeta,
        ),
      );
    }
    if (data.containsKey('placement_level_en')) {
      context.handle(
        _placementLevelEnMeta,
        placementLevelEn.isAcceptableOrUnknown(
          data['placement_level_en']!,
          _placementLevelEnMeta,
        ),
      );
    }
    if (data.containsKey('placement_level_ja')) {
      context.handle(
        _placementLevelJaMeta,
        placementLevelJa.isAcceptableOrUnknown(
          data['placement_level_ja']!,
          _placementLevelJaMeta,
        ),
      );
    }
    if (data.containsKey('daily_goal_minutes')) {
      context.handle(
        _dailyGoalMinutesMeta,
        dailyGoalMinutes.isAcceptableOrUnknown(
          data['daily_goal_minutes']!,
          _dailyGoalMinutesMeta,
        ),
      );
    }
    if (data.containsKey('onboarded')) {
      context.handle(
        _onboardedMeta,
        onboarded.isAcceptableOrUnknown(data['onboarded']!, _onboardedMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    if (data.containsKey('deleted_at')) {
      context.handle(
        _deletedAtMeta,
        deletedAt.isAcceptableOrUnknown(data['deleted_at']!, _deletedAtMeta),
      );
    }
    if (data.containsKey('sync_status')) {
      context.handle(
        _syncStatusMeta,
        syncStatus.isAcceptableOrUnknown(data['sync_status']!, _syncStatusMeta),
      );
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  Setting map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return Setting(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      nativeLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}native_lang'],
      )!,
      learningLang: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}learning_lang'],
      )!,
      dailyNewLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_new_limit'],
      )!,
      dailyReviewLimit: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_review_limit'],
      )!,
      reminderEnabled: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}reminder_enabled'],
      )!,
      reminderTime: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}reminder_time'],
      )!,
      placementDone: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}placement_done'],
      )!,
      placementLevelEn: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placement_level_en'],
      ),
      placementLevelJa: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}placement_level_ja'],
      ),
      dailyGoalMinutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}daily_goal_minutes'],
      )!,
      onboarded: attachedDatabase.typeMapping.read(
        DriftSqlType.bool,
        data['${effectivePrefix}onboarded'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
      deletedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}deleted_at'],
      ),
      syncStatus: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}sync_status'],
      )!,
    );
  }

  @override
  $SettingsTable createAlias(String alias) {
    return $SettingsTable(attachedDatabase, alias);
  }
}

class Setting extends DataClass implements Insertable<Setting> {
  final String id;
  final String nativeLang;
  final String learningLang;
  final int dailyNewLimit;
  final int dailyReviewLimit;
  final bool reminderEnabled;
  final String reminderTime;
  final bool placementDone;
  final String? placementLevelEn;
  final String? placementLevelJa;
  final int dailyGoalMinutes;
  final bool onboarded;
  final int updatedAt;
  final int? deletedAt;
  final int syncStatus;
  const Setting({
    required this.id,
    required this.nativeLang,
    required this.learningLang,
    required this.dailyNewLimit,
    required this.dailyReviewLimit,
    required this.reminderEnabled,
    required this.reminderTime,
    required this.placementDone,
    this.placementLevelEn,
    this.placementLevelJa,
    required this.dailyGoalMinutes,
    required this.onboarded,
    required this.updatedAt,
    this.deletedAt,
    required this.syncStatus,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['native_lang'] = Variable<String>(nativeLang);
    map['learning_lang'] = Variable<String>(learningLang);
    map['daily_new_limit'] = Variable<int>(dailyNewLimit);
    map['daily_review_limit'] = Variable<int>(dailyReviewLimit);
    map['reminder_enabled'] = Variable<bool>(reminderEnabled);
    map['reminder_time'] = Variable<String>(reminderTime);
    map['placement_done'] = Variable<bool>(placementDone);
    if (!nullToAbsent || placementLevelEn != null) {
      map['placement_level_en'] = Variable<String>(placementLevelEn);
    }
    if (!nullToAbsent || placementLevelJa != null) {
      map['placement_level_ja'] = Variable<String>(placementLevelJa);
    }
    map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes);
    map['onboarded'] = Variable<bool>(onboarded);
    map['updated_at'] = Variable<int>(updatedAt);
    if (!nullToAbsent || deletedAt != null) {
      map['deleted_at'] = Variable<int>(deletedAt);
    }
    map['sync_status'] = Variable<int>(syncStatus);
    return map;
  }

  SettingsCompanion toCompanion(bool nullToAbsent) {
    return SettingsCompanion(
      id: Value(id),
      nativeLang: Value(nativeLang),
      learningLang: Value(learningLang),
      dailyNewLimit: Value(dailyNewLimit),
      dailyReviewLimit: Value(dailyReviewLimit),
      reminderEnabled: Value(reminderEnabled),
      reminderTime: Value(reminderTime),
      placementDone: Value(placementDone),
      placementLevelEn: placementLevelEn == null && nullToAbsent
          ? const Value.absent()
          : Value(placementLevelEn),
      placementLevelJa: placementLevelJa == null && nullToAbsent
          ? const Value.absent()
          : Value(placementLevelJa),
      dailyGoalMinutes: Value(dailyGoalMinutes),
      onboarded: Value(onboarded),
      updatedAt: Value(updatedAt),
      deletedAt: deletedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(deletedAt),
      syncStatus: Value(syncStatus),
    );
  }

  factory Setting.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return Setting(
      id: serializer.fromJson<String>(json['id']),
      nativeLang: serializer.fromJson<String>(json['nativeLang']),
      learningLang: serializer.fromJson<String>(json['learningLang']),
      dailyNewLimit: serializer.fromJson<int>(json['dailyNewLimit']),
      dailyReviewLimit: serializer.fromJson<int>(json['dailyReviewLimit']),
      reminderEnabled: serializer.fromJson<bool>(json['reminderEnabled']),
      reminderTime: serializer.fromJson<String>(json['reminderTime']),
      placementDone: serializer.fromJson<bool>(json['placementDone']),
      placementLevelEn: serializer.fromJson<String?>(json['placementLevelEn']),
      placementLevelJa: serializer.fromJson<String?>(json['placementLevelJa']),
      dailyGoalMinutes: serializer.fromJson<int>(json['dailyGoalMinutes']),
      onboarded: serializer.fromJson<bool>(json['onboarded']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
      deletedAt: serializer.fromJson<int?>(json['deletedAt']),
      syncStatus: serializer.fromJson<int>(json['syncStatus']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'nativeLang': serializer.toJson<String>(nativeLang),
      'learningLang': serializer.toJson<String>(learningLang),
      'dailyNewLimit': serializer.toJson<int>(dailyNewLimit),
      'dailyReviewLimit': serializer.toJson<int>(dailyReviewLimit),
      'reminderEnabled': serializer.toJson<bool>(reminderEnabled),
      'reminderTime': serializer.toJson<String>(reminderTime),
      'placementDone': serializer.toJson<bool>(placementDone),
      'placementLevelEn': serializer.toJson<String?>(placementLevelEn),
      'placementLevelJa': serializer.toJson<String?>(placementLevelJa),
      'dailyGoalMinutes': serializer.toJson<int>(dailyGoalMinutes),
      'onboarded': serializer.toJson<bool>(onboarded),
      'updatedAt': serializer.toJson<int>(updatedAt),
      'deletedAt': serializer.toJson<int?>(deletedAt),
      'syncStatus': serializer.toJson<int>(syncStatus),
    };
  }

  Setting copyWith({
    String? id,
    String? nativeLang,
    String? learningLang,
    int? dailyNewLimit,
    int? dailyReviewLimit,
    bool? reminderEnabled,
    String? reminderTime,
    bool? placementDone,
    Value<String?> placementLevelEn = const Value.absent(),
    Value<String?> placementLevelJa = const Value.absent(),
    int? dailyGoalMinutes,
    bool? onboarded,
    int? updatedAt,
    Value<int?> deletedAt = const Value.absent(),
    int? syncStatus,
  }) => Setting(
    id: id ?? this.id,
    nativeLang: nativeLang ?? this.nativeLang,
    learningLang: learningLang ?? this.learningLang,
    dailyNewLimit: dailyNewLimit ?? this.dailyNewLimit,
    dailyReviewLimit: dailyReviewLimit ?? this.dailyReviewLimit,
    reminderEnabled: reminderEnabled ?? this.reminderEnabled,
    reminderTime: reminderTime ?? this.reminderTime,
    placementDone: placementDone ?? this.placementDone,
    placementLevelEn: placementLevelEn.present
        ? placementLevelEn.value
        : this.placementLevelEn,
    placementLevelJa: placementLevelJa.present
        ? placementLevelJa.value
        : this.placementLevelJa,
    dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
    onboarded: onboarded ?? this.onboarded,
    updatedAt: updatedAt ?? this.updatedAt,
    deletedAt: deletedAt.present ? deletedAt.value : this.deletedAt,
    syncStatus: syncStatus ?? this.syncStatus,
  );
  Setting copyWithCompanion(SettingsCompanion data) {
    return Setting(
      id: data.id.present ? data.id.value : this.id,
      nativeLang: data.nativeLang.present
          ? data.nativeLang.value
          : this.nativeLang,
      learningLang: data.learningLang.present
          ? data.learningLang.value
          : this.learningLang,
      dailyNewLimit: data.dailyNewLimit.present
          ? data.dailyNewLimit.value
          : this.dailyNewLimit,
      dailyReviewLimit: data.dailyReviewLimit.present
          ? data.dailyReviewLimit.value
          : this.dailyReviewLimit,
      reminderEnabled: data.reminderEnabled.present
          ? data.reminderEnabled.value
          : this.reminderEnabled,
      reminderTime: data.reminderTime.present
          ? data.reminderTime.value
          : this.reminderTime,
      placementDone: data.placementDone.present
          ? data.placementDone.value
          : this.placementDone,
      placementLevelEn: data.placementLevelEn.present
          ? data.placementLevelEn.value
          : this.placementLevelEn,
      placementLevelJa: data.placementLevelJa.present
          ? data.placementLevelJa.value
          : this.placementLevelJa,
      dailyGoalMinutes: data.dailyGoalMinutes.present
          ? data.dailyGoalMinutes.value
          : this.dailyGoalMinutes,
      onboarded: data.onboarded.present ? data.onboarded.value : this.onboarded,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
      deletedAt: data.deletedAt.present ? data.deletedAt.value : this.deletedAt,
      syncStatus: data.syncStatus.present
          ? data.syncStatus.value
          : this.syncStatus,
    );
  }

  @override
  String toString() {
    return (StringBuffer('Setting(')
          ..write('id: $id, ')
          ..write('nativeLang: $nativeLang, ')
          ..write('learningLang: $learningLang, ')
          ..write('dailyNewLimit: $dailyNewLimit, ')
          ..write('dailyReviewLimit: $dailyReviewLimit, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('placementDone: $placementDone, ')
          ..write('placementLevelEn: $placementLevelEn, ')
          ..write('placementLevelJa: $placementLevelJa, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('onboarded: $onboarded, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    nativeLang,
    learningLang,
    dailyNewLimit,
    dailyReviewLimit,
    reminderEnabled,
    reminderTime,
    placementDone,
    placementLevelEn,
    placementLevelJa,
    dailyGoalMinutes,
    onboarded,
    updatedAt,
    deletedAt,
    syncStatus,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is Setting &&
          other.id == this.id &&
          other.nativeLang == this.nativeLang &&
          other.learningLang == this.learningLang &&
          other.dailyNewLimit == this.dailyNewLimit &&
          other.dailyReviewLimit == this.dailyReviewLimit &&
          other.reminderEnabled == this.reminderEnabled &&
          other.reminderTime == this.reminderTime &&
          other.placementDone == this.placementDone &&
          other.placementLevelEn == this.placementLevelEn &&
          other.placementLevelJa == this.placementLevelJa &&
          other.dailyGoalMinutes == this.dailyGoalMinutes &&
          other.onboarded == this.onboarded &&
          other.updatedAt == this.updatedAt &&
          other.deletedAt == this.deletedAt &&
          other.syncStatus == this.syncStatus);
}

class SettingsCompanion extends UpdateCompanion<Setting> {
  final Value<String> id;
  final Value<String> nativeLang;
  final Value<String> learningLang;
  final Value<int> dailyNewLimit;
  final Value<int> dailyReviewLimit;
  final Value<bool> reminderEnabled;
  final Value<String> reminderTime;
  final Value<bool> placementDone;
  final Value<String?> placementLevelEn;
  final Value<String?> placementLevelJa;
  final Value<int> dailyGoalMinutes;
  final Value<bool> onboarded;
  final Value<int> updatedAt;
  final Value<int?> deletedAt;
  final Value<int> syncStatus;
  final Value<int> rowid;
  const SettingsCompanion({
    this.id = const Value.absent(),
    this.nativeLang = const Value.absent(),
    this.learningLang = const Value.absent(),
    this.dailyNewLimit = const Value.absent(),
    this.dailyReviewLimit = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.placementDone = const Value.absent(),
    this.placementLevelEn = const Value.absent(),
    this.placementLevelJa = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.onboarded = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  SettingsCompanion.insert({
    this.id = const Value.absent(),
    this.nativeLang = const Value.absent(),
    this.learningLang = const Value.absent(),
    this.dailyNewLimit = const Value.absent(),
    this.dailyReviewLimit = const Value.absent(),
    this.reminderEnabled = const Value.absent(),
    this.reminderTime = const Value.absent(),
    this.placementDone = const Value.absent(),
    this.placementLevelEn = const Value.absent(),
    this.placementLevelJa = const Value.absent(),
    this.dailyGoalMinutes = const Value.absent(),
    this.onboarded = const Value.absent(),
    required int updatedAt,
    this.deletedAt = const Value.absent(),
    this.syncStatus = const Value.absent(),
    this.rowid = const Value.absent(),
  }) : updatedAt = Value(updatedAt);
  static Insertable<Setting> custom({
    Expression<String>? id,
    Expression<String>? nativeLang,
    Expression<String>? learningLang,
    Expression<int>? dailyNewLimit,
    Expression<int>? dailyReviewLimit,
    Expression<bool>? reminderEnabled,
    Expression<String>? reminderTime,
    Expression<bool>? placementDone,
    Expression<String>? placementLevelEn,
    Expression<String>? placementLevelJa,
    Expression<int>? dailyGoalMinutes,
    Expression<bool>? onboarded,
    Expression<int>? updatedAt,
    Expression<int>? deletedAt,
    Expression<int>? syncStatus,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (nativeLang != null) 'native_lang': nativeLang,
      if (learningLang != null) 'learning_lang': learningLang,
      if (dailyNewLimit != null) 'daily_new_limit': dailyNewLimit,
      if (dailyReviewLimit != null) 'daily_review_limit': dailyReviewLimit,
      if (reminderEnabled != null) 'reminder_enabled': reminderEnabled,
      if (reminderTime != null) 'reminder_time': reminderTime,
      if (placementDone != null) 'placement_done': placementDone,
      if (placementLevelEn != null) 'placement_level_en': placementLevelEn,
      if (placementLevelJa != null) 'placement_level_ja': placementLevelJa,
      if (dailyGoalMinutes != null) 'daily_goal_minutes': dailyGoalMinutes,
      if (onboarded != null) 'onboarded': onboarded,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (deletedAt != null) 'deleted_at': deletedAt,
      if (syncStatus != null) 'sync_status': syncStatus,
      if (rowid != null) 'rowid': rowid,
    });
  }

  SettingsCompanion copyWith({
    Value<String>? id,
    Value<String>? nativeLang,
    Value<String>? learningLang,
    Value<int>? dailyNewLimit,
    Value<int>? dailyReviewLimit,
    Value<bool>? reminderEnabled,
    Value<String>? reminderTime,
    Value<bool>? placementDone,
    Value<String?>? placementLevelEn,
    Value<String?>? placementLevelJa,
    Value<int>? dailyGoalMinutes,
    Value<bool>? onboarded,
    Value<int>? updatedAt,
    Value<int?>? deletedAt,
    Value<int>? syncStatus,
    Value<int>? rowid,
  }) {
    return SettingsCompanion(
      id: id ?? this.id,
      nativeLang: nativeLang ?? this.nativeLang,
      learningLang: learningLang ?? this.learningLang,
      dailyNewLimit: dailyNewLimit ?? this.dailyNewLimit,
      dailyReviewLimit: dailyReviewLimit ?? this.dailyReviewLimit,
      reminderEnabled: reminderEnabled ?? this.reminderEnabled,
      reminderTime: reminderTime ?? this.reminderTime,
      placementDone: placementDone ?? this.placementDone,
      placementLevelEn: placementLevelEn ?? this.placementLevelEn,
      placementLevelJa: placementLevelJa ?? this.placementLevelJa,
      dailyGoalMinutes: dailyGoalMinutes ?? this.dailyGoalMinutes,
      onboarded: onboarded ?? this.onboarded,
      updatedAt: updatedAt ?? this.updatedAt,
      deletedAt: deletedAt ?? this.deletedAt,
      syncStatus: syncStatus ?? this.syncStatus,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (nativeLang.present) {
      map['native_lang'] = Variable<String>(nativeLang.value);
    }
    if (learningLang.present) {
      map['learning_lang'] = Variable<String>(learningLang.value);
    }
    if (dailyNewLimit.present) {
      map['daily_new_limit'] = Variable<int>(dailyNewLimit.value);
    }
    if (dailyReviewLimit.present) {
      map['daily_review_limit'] = Variable<int>(dailyReviewLimit.value);
    }
    if (reminderEnabled.present) {
      map['reminder_enabled'] = Variable<bool>(reminderEnabled.value);
    }
    if (reminderTime.present) {
      map['reminder_time'] = Variable<String>(reminderTime.value);
    }
    if (placementDone.present) {
      map['placement_done'] = Variable<bool>(placementDone.value);
    }
    if (placementLevelEn.present) {
      map['placement_level_en'] = Variable<String>(placementLevelEn.value);
    }
    if (placementLevelJa.present) {
      map['placement_level_ja'] = Variable<String>(placementLevelJa.value);
    }
    if (dailyGoalMinutes.present) {
      map['daily_goal_minutes'] = Variable<int>(dailyGoalMinutes.value);
    }
    if (onboarded.present) {
      map['onboarded'] = Variable<bool>(onboarded.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (deletedAt.present) {
      map['deleted_at'] = Variable<int>(deletedAt.value);
    }
    if (syncStatus.present) {
      map['sync_status'] = Variable<int>(syncStatus.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('SettingsCompanion(')
          ..write('id: $id, ')
          ..write('nativeLang: $nativeLang, ')
          ..write('learningLang: $learningLang, ')
          ..write('dailyNewLimit: $dailyNewLimit, ')
          ..write('dailyReviewLimit: $dailyReviewLimit, ')
          ..write('reminderEnabled: $reminderEnabled, ')
          ..write('reminderTime: $reminderTime, ')
          ..write('placementDone: $placementDone, ')
          ..write('placementLevelEn: $placementLevelEn, ')
          ..write('placementLevelJa: $placementLevelJa, ')
          ..write('dailyGoalMinutes: $dailyGoalMinutes, ')
          ..write('onboarded: $onboarded, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('deletedAt: $deletedAt, ')
          ..write('syncStatus: $syncStatus, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $DailyStatsTable extends DailyStats
    with TableInfo<$DailyStatsTable, DailyStat> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $DailyStatsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _dateMeta = const VerificationMeta('date');
  @override
  late final GeneratedColumn<String> date = GeneratedColumn<String>(
    'date',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _newCountMeta = const VerificationMeta(
    'newCount',
  );
  @override
  late final GeneratedColumn<int> newCount = GeneratedColumn<int>(
    'new_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _reviewCountMeta = const VerificationMeta(
    'reviewCount',
  );
  @override
  late final GeneratedColumn<int> reviewCount = GeneratedColumn<int>(
    'review_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _correctCountMeta = const VerificationMeta(
    'correctCount',
  );
  @override
  late final GeneratedColumn<int> correctCount = GeneratedColumn<int>(
    'correct_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _totalCountMeta = const VerificationMeta(
    'totalCount',
  );
  @override
  late final GeneratedColumn<int> totalCount = GeneratedColumn<int>(
    'total_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _minutesMeta = const VerificationMeta(
    'minutes',
  );
  @override
  late final GeneratedColumn<int> minutes = GeneratedColumn<int>(
    'minutes',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    date,
    newCount,
    reviewCount,
    correctCount,
    totalCount,
    minutes,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'daily_stats';
  @override
  VerificationContext validateIntegrity(
    Insertable<DailyStat> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('date')) {
      context.handle(
        _dateMeta,
        date.isAcceptableOrUnknown(data['date']!, _dateMeta),
      );
    } else if (isInserting) {
      context.missing(_dateMeta);
    }
    if (data.containsKey('new_count')) {
      context.handle(
        _newCountMeta,
        newCount.isAcceptableOrUnknown(data['new_count']!, _newCountMeta),
      );
    }
    if (data.containsKey('review_count')) {
      context.handle(
        _reviewCountMeta,
        reviewCount.isAcceptableOrUnknown(
          data['review_count']!,
          _reviewCountMeta,
        ),
      );
    }
    if (data.containsKey('correct_count')) {
      context.handle(
        _correctCountMeta,
        correctCount.isAcceptableOrUnknown(
          data['correct_count']!,
          _correctCountMeta,
        ),
      );
    }
    if (data.containsKey('total_count')) {
      context.handle(
        _totalCountMeta,
        totalCount.isAcceptableOrUnknown(data['total_count']!, _totalCountMeta),
      );
    }
    if (data.containsKey('minutes')) {
      context.handle(
        _minutesMeta,
        minutes.isAcceptableOrUnknown(data['minutes']!, _minutesMeta),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {date};
  @override
  DailyStat map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return DailyStat(
      date: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}date'],
      )!,
      newCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}new_count'],
      )!,
      reviewCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}review_count'],
      )!,
      correctCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}correct_count'],
      )!,
      totalCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}total_count'],
      )!,
      minutes: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}minutes'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $DailyStatsTable createAlias(String alias) {
    return $DailyStatsTable(attachedDatabase, alias);
  }
}

class DailyStat extends DataClass implements Insertable<DailyStat> {
  final String date;
  final int newCount;
  final int reviewCount;
  final int correctCount;
  final int totalCount;
  final int minutes;
  final int updatedAt;
  const DailyStat({
    required this.date,
    required this.newCount,
    required this.reviewCount,
    required this.correctCount,
    required this.totalCount,
    required this.minutes,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['date'] = Variable<String>(date);
    map['new_count'] = Variable<int>(newCount);
    map['review_count'] = Variable<int>(reviewCount);
    map['correct_count'] = Variable<int>(correctCount);
    map['total_count'] = Variable<int>(totalCount);
    map['minutes'] = Variable<int>(minutes);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  DailyStatsCompanion toCompanion(bool nullToAbsent) {
    return DailyStatsCompanion(
      date: Value(date),
      newCount: Value(newCount),
      reviewCount: Value(reviewCount),
      correctCount: Value(correctCount),
      totalCount: Value(totalCount),
      minutes: Value(minutes),
      updatedAt: Value(updatedAt),
    );
  }

  factory DailyStat.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return DailyStat(
      date: serializer.fromJson<String>(json['date']),
      newCount: serializer.fromJson<int>(json['newCount']),
      reviewCount: serializer.fromJson<int>(json['reviewCount']),
      correctCount: serializer.fromJson<int>(json['correctCount']),
      totalCount: serializer.fromJson<int>(json['totalCount']),
      minutes: serializer.fromJson<int>(json['minutes']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'date': serializer.toJson<String>(date),
      'newCount': serializer.toJson<int>(newCount),
      'reviewCount': serializer.toJson<int>(reviewCount),
      'correctCount': serializer.toJson<int>(correctCount),
      'totalCount': serializer.toJson<int>(totalCount),
      'minutes': serializer.toJson<int>(minutes),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  DailyStat copyWith({
    String? date,
    int? newCount,
    int? reviewCount,
    int? correctCount,
    int? totalCount,
    int? minutes,
    int? updatedAt,
  }) => DailyStat(
    date: date ?? this.date,
    newCount: newCount ?? this.newCount,
    reviewCount: reviewCount ?? this.reviewCount,
    correctCount: correctCount ?? this.correctCount,
    totalCount: totalCount ?? this.totalCount,
    minutes: minutes ?? this.minutes,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  DailyStat copyWithCompanion(DailyStatsCompanion data) {
    return DailyStat(
      date: data.date.present ? data.date.value : this.date,
      newCount: data.newCount.present ? data.newCount.value : this.newCount,
      reviewCount: data.reviewCount.present
          ? data.reviewCount.value
          : this.reviewCount,
      correctCount: data.correctCount.present
          ? data.correctCount.value
          : this.correctCount,
      totalCount: data.totalCount.present
          ? data.totalCount.value
          : this.totalCount,
      minutes: data.minutes.present ? data.minutes.value : this.minutes,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('DailyStat(')
          ..write('date: $date, ')
          ..write('newCount: $newCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('totalCount: $totalCount, ')
          ..write('minutes: $minutes, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    date,
    newCount,
    reviewCount,
    correctCount,
    totalCount,
    minutes,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is DailyStat &&
          other.date == this.date &&
          other.newCount == this.newCount &&
          other.reviewCount == this.reviewCount &&
          other.correctCount == this.correctCount &&
          other.totalCount == this.totalCount &&
          other.minutes == this.minutes &&
          other.updatedAt == this.updatedAt);
}

class DailyStatsCompanion extends UpdateCompanion<DailyStat> {
  final Value<String> date;
  final Value<int> newCount;
  final Value<int> reviewCount;
  final Value<int> correctCount;
  final Value<int> totalCount;
  final Value<int> minutes;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const DailyStatsCompanion({
    this.date = const Value.absent(),
    this.newCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.minutes = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  DailyStatsCompanion.insert({
    required String date,
    this.newCount = const Value.absent(),
    this.reviewCount = const Value.absent(),
    this.correctCount = const Value.absent(),
    this.totalCount = const Value.absent(),
    this.minutes = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : date = Value(date),
       updatedAt = Value(updatedAt);
  static Insertable<DailyStat> custom({
    Expression<String>? date,
    Expression<int>? newCount,
    Expression<int>? reviewCount,
    Expression<int>? correctCount,
    Expression<int>? totalCount,
    Expression<int>? minutes,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (date != null) 'date': date,
      if (newCount != null) 'new_count': newCount,
      if (reviewCount != null) 'review_count': reviewCount,
      if (correctCount != null) 'correct_count': correctCount,
      if (totalCount != null) 'total_count': totalCount,
      if (minutes != null) 'minutes': minutes,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  DailyStatsCompanion copyWith({
    Value<String>? date,
    Value<int>? newCount,
    Value<int>? reviewCount,
    Value<int>? correctCount,
    Value<int>? totalCount,
    Value<int>? minutes,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return DailyStatsCompanion(
      date: date ?? this.date,
      newCount: newCount ?? this.newCount,
      reviewCount: reviewCount ?? this.reviewCount,
      correctCount: correctCount ?? this.correctCount,
      totalCount: totalCount ?? this.totalCount,
      minutes: minutes ?? this.minutes,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (date.present) {
      map['date'] = Variable<String>(date.value);
    }
    if (newCount.present) {
      map['new_count'] = Variable<int>(newCount.value);
    }
    if (reviewCount.present) {
      map['review_count'] = Variable<int>(reviewCount.value);
    }
    if (correctCount.present) {
      map['correct_count'] = Variable<int>(correctCount.value);
    }
    if (totalCount.present) {
      map['total_count'] = Variable<int>(totalCount.value);
    }
    if (minutes.present) {
      map['minutes'] = Variable<int>(minutes.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('DailyStatsCompanion(')
          ..write('date: $date, ')
          ..write('newCount: $newCount, ')
          ..write('reviewCount: $reviewCount, ')
          ..write('correctCount: $correctCount, ')
          ..write('totalCount: $totalCount, ')
          ..write('minutes: $minutes, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $StudySessionsTable extends StudySessions
    with TableInfo<$StudySessionsTable, StudySession> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $StudySessionsTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _idMeta = const VerificationMeta('id');
  @override
  late final GeneratedColumn<String> id = GeneratedColumn<String>(
    'id',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _languageMeta = const VerificationMeta(
    'language',
  );
  @override
  late final GeneratedColumn<String> language = GeneratedColumn<String>(
    'language',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _startedAtMeta = const VerificationMeta(
    'startedAt',
  );
  @override
  late final GeneratedColumn<int> startedAt = GeneratedColumn<int>(
    'started_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _endedAtMeta = const VerificationMeta(
    'endedAt',
  );
  @override
  late final GeneratedColumn<int> endedAt = GeneratedColumn<int>(
    'ended_at',
    aliasedName,
    true,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _queueMeta = const VerificationMeta('queue');
  @override
  late final GeneratedColumn<String> queue = GeneratedColumn<String>(
    'queue',
    aliasedName,
    true,
    type: DriftSqlType.string,
    requiredDuringInsert: false,
  );
  static const VerificationMeta _completedCountMeta = const VerificationMeta(
    'completedCount',
  );
  @override
  late final GeneratedColumn<int> completedCount = GeneratedColumn<int>(
    'completed_count',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: false,
    defaultValue: const Constant(0),
  );
  static const VerificationMeta _updatedAtMeta = const VerificationMeta(
    'updatedAt',
  );
  @override
  late final GeneratedColumn<int> updatedAt = GeneratedColumn<int>(
    'updated_at',
    aliasedName,
    false,
    type: DriftSqlType.int,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [
    id,
    language,
    startedAt,
    endedAt,
    queue,
    completedCount,
    updatedAt,
  ];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'study_sessions';
  @override
  VerificationContext validateIntegrity(
    Insertable<StudySession> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('id')) {
      context.handle(_idMeta, id.isAcceptableOrUnknown(data['id']!, _idMeta));
    } else if (isInserting) {
      context.missing(_idMeta);
    }
    if (data.containsKey('language')) {
      context.handle(
        _languageMeta,
        language.isAcceptableOrUnknown(data['language']!, _languageMeta),
      );
    } else if (isInserting) {
      context.missing(_languageMeta);
    }
    if (data.containsKey('started_at')) {
      context.handle(
        _startedAtMeta,
        startedAt.isAcceptableOrUnknown(data['started_at']!, _startedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_startedAtMeta);
    }
    if (data.containsKey('ended_at')) {
      context.handle(
        _endedAtMeta,
        endedAt.isAcceptableOrUnknown(data['ended_at']!, _endedAtMeta),
      );
    }
    if (data.containsKey('queue')) {
      context.handle(
        _queueMeta,
        queue.isAcceptableOrUnknown(data['queue']!, _queueMeta),
      );
    }
    if (data.containsKey('completed_count')) {
      context.handle(
        _completedCountMeta,
        completedCount.isAcceptableOrUnknown(
          data['completed_count']!,
          _completedCountMeta,
        ),
      );
    }
    if (data.containsKey('updated_at')) {
      context.handle(
        _updatedAtMeta,
        updatedAt.isAcceptableOrUnknown(data['updated_at']!, _updatedAtMeta),
      );
    } else if (isInserting) {
      context.missing(_updatedAtMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {id};
  @override
  StudySession map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return StudySession(
      id: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}id'],
      )!,
      language: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}language'],
      )!,
      startedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}started_at'],
      )!,
      endedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}ended_at'],
      ),
      queue: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}queue'],
      ),
      completedCount: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}completed_count'],
      )!,
      updatedAt: attachedDatabase.typeMapping.read(
        DriftSqlType.int,
        data['${effectivePrefix}updated_at'],
      )!,
    );
  }

  @override
  $StudySessionsTable createAlias(String alias) {
    return $StudySessionsTable(attachedDatabase, alias);
  }
}

class StudySession extends DataClass implements Insertable<StudySession> {
  final String id;
  final String language;
  final int startedAt;
  final int? endedAt;
  final String? queue;
  final int completedCount;
  final int updatedAt;
  const StudySession({
    required this.id,
    required this.language,
    required this.startedAt,
    this.endedAt,
    this.queue,
    required this.completedCount,
    required this.updatedAt,
  });
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['id'] = Variable<String>(id);
    map['language'] = Variable<String>(language);
    map['started_at'] = Variable<int>(startedAt);
    if (!nullToAbsent || endedAt != null) {
      map['ended_at'] = Variable<int>(endedAt);
    }
    if (!nullToAbsent || queue != null) {
      map['queue'] = Variable<String>(queue);
    }
    map['completed_count'] = Variable<int>(completedCount);
    map['updated_at'] = Variable<int>(updatedAt);
    return map;
  }

  StudySessionsCompanion toCompanion(bool nullToAbsent) {
    return StudySessionsCompanion(
      id: Value(id),
      language: Value(language),
      startedAt: Value(startedAt),
      endedAt: endedAt == null && nullToAbsent
          ? const Value.absent()
          : Value(endedAt),
      queue: queue == null && nullToAbsent
          ? const Value.absent()
          : Value(queue),
      completedCount: Value(completedCount),
      updatedAt: Value(updatedAt),
    );
  }

  factory StudySession.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return StudySession(
      id: serializer.fromJson<String>(json['id']),
      language: serializer.fromJson<String>(json['language']),
      startedAt: serializer.fromJson<int>(json['startedAt']),
      endedAt: serializer.fromJson<int?>(json['endedAt']),
      queue: serializer.fromJson<String?>(json['queue']),
      completedCount: serializer.fromJson<int>(json['completedCount']),
      updatedAt: serializer.fromJson<int>(json['updatedAt']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'id': serializer.toJson<String>(id),
      'language': serializer.toJson<String>(language),
      'startedAt': serializer.toJson<int>(startedAt),
      'endedAt': serializer.toJson<int?>(endedAt),
      'queue': serializer.toJson<String?>(queue),
      'completedCount': serializer.toJson<int>(completedCount),
      'updatedAt': serializer.toJson<int>(updatedAt),
    };
  }

  StudySession copyWith({
    String? id,
    String? language,
    int? startedAt,
    Value<int?> endedAt = const Value.absent(),
    Value<String?> queue = const Value.absent(),
    int? completedCount,
    int? updatedAt,
  }) => StudySession(
    id: id ?? this.id,
    language: language ?? this.language,
    startedAt: startedAt ?? this.startedAt,
    endedAt: endedAt.present ? endedAt.value : this.endedAt,
    queue: queue.present ? queue.value : this.queue,
    completedCount: completedCount ?? this.completedCount,
    updatedAt: updatedAt ?? this.updatedAt,
  );
  StudySession copyWithCompanion(StudySessionsCompanion data) {
    return StudySession(
      id: data.id.present ? data.id.value : this.id,
      language: data.language.present ? data.language.value : this.language,
      startedAt: data.startedAt.present ? data.startedAt.value : this.startedAt,
      endedAt: data.endedAt.present ? data.endedAt.value : this.endedAt,
      queue: data.queue.present ? data.queue.value : this.queue,
      completedCount: data.completedCount.present
          ? data.completedCount.value
          : this.completedCount,
      updatedAt: data.updatedAt.present ? data.updatedAt.value : this.updatedAt,
    );
  }

  @override
  String toString() {
    return (StringBuffer('StudySession(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('queue: $queue, ')
          ..write('completedCount: $completedCount, ')
          ..write('updatedAt: $updatedAt')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(
    id,
    language,
    startedAt,
    endedAt,
    queue,
    completedCount,
    updatedAt,
  );
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is StudySession &&
          other.id == this.id &&
          other.language == this.language &&
          other.startedAt == this.startedAt &&
          other.endedAt == this.endedAt &&
          other.queue == this.queue &&
          other.completedCount == this.completedCount &&
          other.updatedAt == this.updatedAt);
}

class StudySessionsCompanion extends UpdateCompanion<StudySession> {
  final Value<String> id;
  final Value<String> language;
  final Value<int> startedAt;
  final Value<int?> endedAt;
  final Value<String?> queue;
  final Value<int> completedCount;
  final Value<int> updatedAt;
  final Value<int> rowid;
  const StudySessionsCompanion({
    this.id = const Value.absent(),
    this.language = const Value.absent(),
    this.startedAt = const Value.absent(),
    this.endedAt = const Value.absent(),
    this.queue = const Value.absent(),
    this.completedCount = const Value.absent(),
    this.updatedAt = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  StudySessionsCompanion.insert({
    required String id,
    required String language,
    required int startedAt,
    this.endedAt = const Value.absent(),
    this.queue = const Value.absent(),
    this.completedCount = const Value.absent(),
    required int updatedAt,
    this.rowid = const Value.absent(),
  }) : id = Value(id),
       language = Value(language),
       startedAt = Value(startedAt),
       updatedAt = Value(updatedAt);
  static Insertable<StudySession> custom({
    Expression<String>? id,
    Expression<String>? language,
    Expression<int>? startedAt,
    Expression<int>? endedAt,
    Expression<String>? queue,
    Expression<int>? completedCount,
    Expression<int>? updatedAt,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (id != null) 'id': id,
      if (language != null) 'language': language,
      if (startedAt != null) 'started_at': startedAt,
      if (endedAt != null) 'ended_at': endedAt,
      if (queue != null) 'queue': queue,
      if (completedCount != null) 'completed_count': completedCount,
      if (updatedAt != null) 'updated_at': updatedAt,
      if (rowid != null) 'rowid': rowid,
    });
  }

  StudySessionsCompanion copyWith({
    Value<String>? id,
    Value<String>? language,
    Value<int>? startedAt,
    Value<int?>? endedAt,
    Value<String?>? queue,
    Value<int>? completedCount,
    Value<int>? updatedAt,
    Value<int>? rowid,
  }) {
    return StudySessionsCompanion(
      id: id ?? this.id,
      language: language ?? this.language,
      startedAt: startedAt ?? this.startedAt,
      endedAt: endedAt ?? this.endedAt,
      queue: queue ?? this.queue,
      completedCount: completedCount ?? this.completedCount,
      updatedAt: updatedAt ?? this.updatedAt,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (id.present) {
      map['id'] = Variable<String>(id.value);
    }
    if (language.present) {
      map['language'] = Variable<String>(language.value);
    }
    if (startedAt.present) {
      map['started_at'] = Variable<int>(startedAt.value);
    }
    if (endedAt.present) {
      map['ended_at'] = Variable<int>(endedAt.value);
    }
    if (queue.present) {
      map['queue'] = Variable<String>(queue.value);
    }
    if (completedCount.present) {
      map['completed_count'] = Variable<int>(completedCount.value);
    }
    if (updatedAt.present) {
      map['updated_at'] = Variable<int>(updatedAt.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('StudySessionsCompanion(')
          ..write('id: $id, ')
          ..write('language: $language, ')
          ..write('startedAt: $startedAt, ')
          ..write('endedAt: $endedAt, ')
          ..write('queue: $queue, ')
          ..write('completedCount: $completedCount, ')
          ..write('updatedAt: $updatedAt, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

class $MetaTable extends Meta with TableInfo<$MetaTable, MetaData> {
  @override
  final GeneratedDatabase attachedDatabase;
  final String? _alias;
  $MetaTable(this.attachedDatabase, [this._alias]);
  static const VerificationMeta _keyMeta = const VerificationMeta('key');
  @override
  late final GeneratedColumn<String> key = GeneratedColumn<String>(
    'key',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  static const VerificationMeta _valueMeta = const VerificationMeta('value');
  @override
  late final GeneratedColumn<String> value = GeneratedColumn<String>(
    'value',
    aliasedName,
    false,
    type: DriftSqlType.string,
    requiredDuringInsert: true,
  );
  @override
  List<GeneratedColumn> get $columns => [key, value];
  @override
  String get aliasedName => _alias ?? actualTableName;
  @override
  String get actualTableName => $name;
  static const String $name = 'meta';
  @override
  VerificationContext validateIntegrity(
    Insertable<MetaData> instance, {
    bool isInserting = false,
  }) {
    final context = VerificationContext();
    final data = instance.toColumns(true);
    if (data.containsKey('key')) {
      context.handle(
        _keyMeta,
        key.isAcceptableOrUnknown(data['key']!, _keyMeta),
      );
    } else if (isInserting) {
      context.missing(_keyMeta);
    }
    if (data.containsKey('value')) {
      context.handle(
        _valueMeta,
        value.isAcceptableOrUnknown(data['value']!, _valueMeta),
      );
    } else if (isInserting) {
      context.missing(_valueMeta);
    }
    return context;
  }

  @override
  Set<GeneratedColumn> get $primaryKey => {key};
  @override
  MetaData map(Map<String, dynamic> data, {String? tablePrefix}) {
    final effectivePrefix = tablePrefix != null ? '$tablePrefix.' : '';
    return MetaData(
      key: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}key'],
      )!,
      value: attachedDatabase.typeMapping.read(
        DriftSqlType.string,
        data['${effectivePrefix}value'],
      )!,
    );
  }

  @override
  $MetaTable createAlias(String alias) {
    return $MetaTable(attachedDatabase, alias);
  }
}

class MetaData extends DataClass implements Insertable<MetaData> {
  final String key;
  final String value;
  const MetaData({required this.key, required this.value});
  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    map['key'] = Variable<String>(key);
    map['value'] = Variable<String>(value);
    return map;
  }

  MetaCompanion toCompanion(bool nullToAbsent) {
    return MetaCompanion(key: Value(key), value: Value(value));
  }

  factory MetaData.fromJson(
    Map<String, dynamic> json, {
    ValueSerializer? serializer,
  }) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return MetaData(
      key: serializer.fromJson<String>(json['key']),
      value: serializer.fromJson<String>(json['value']),
    );
  }
  @override
  Map<String, dynamic> toJson({ValueSerializer? serializer}) {
    serializer ??= driftRuntimeOptions.defaultSerializer;
    return <String, dynamic>{
      'key': serializer.toJson<String>(key),
      'value': serializer.toJson<String>(value),
    };
  }

  MetaData copyWith({String? key, String? value}) =>
      MetaData(key: key ?? this.key, value: value ?? this.value);
  MetaData copyWithCompanion(MetaCompanion data) {
    return MetaData(
      key: data.key.present ? data.key.value : this.key,
      value: data.value.present ? data.value.value : this.value,
    );
  }

  @override
  String toString() {
    return (StringBuffer('MetaData(')
          ..write('key: $key, ')
          ..write('value: $value')
          ..write(')'))
        .toString();
  }

  @override
  int get hashCode => Object.hash(key, value);
  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      (other is MetaData && other.key == this.key && other.value == this.value);
}

class MetaCompanion extends UpdateCompanion<MetaData> {
  final Value<String> key;
  final Value<String> value;
  final Value<int> rowid;
  const MetaCompanion({
    this.key = const Value.absent(),
    this.value = const Value.absent(),
    this.rowid = const Value.absent(),
  });
  MetaCompanion.insert({
    required String key,
    required String value,
    this.rowid = const Value.absent(),
  }) : key = Value(key),
       value = Value(value);
  static Insertable<MetaData> custom({
    Expression<String>? key,
    Expression<String>? value,
    Expression<int>? rowid,
  }) {
    return RawValuesInsertable({
      if (key != null) 'key': key,
      if (value != null) 'value': value,
      if (rowid != null) 'rowid': rowid,
    });
  }

  MetaCompanion copyWith({
    Value<String>? key,
    Value<String>? value,
    Value<int>? rowid,
  }) {
    return MetaCompanion(
      key: key ?? this.key,
      value: value ?? this.value,
      rowid: rowid ?? this.rowid,
    );
  }

  @override
  Map<String, Expression> toColumns(bool nullToAbsent) {
    final map = <String, Expression>{};
    if (key.present) {
      map['key'] = Variable<String>(key.value);
    }
    if (value.present) {
      map['value'] = Variable<String>(value.value);
    }
    if (rowid.present) {
      map['rowid'] = Variable<int>(rowid.value);
    }
    return map;
  }

  @override
  String toString() {
    return (StringBuffer('MetaCompanion(')
          ..write('key: $key, ')
          ..write('value: $value, ')
          ..write('rowid: $rowid')
          ..write(')'))
        .toString();
  }
}

abstract class _$AppDatabase extends GeneratedDatabase {
  _$AppDatabase(QueryExecutor e) : super(e);
  $AppDatabaseManager get managers => $AppDatabaseManager(this);
  late final $WordsTable words = $WordsTable(this);
  late final $DecksTable decks = $DecksTable(this);
  late final $DeckWordsTable deckWords = $DeckWordsTable(this);
  late final $WordProgressTable wordProgress = $WordProgressTable(this);
  late final $StudyLogsTable studyLogs = $StudyLogsTable(this);
  late final $SettingsTable settings = $SettingsTable(this);
  late final $DailyStatsTable dailyStats = $DailyStatsTable(this);
  late final $StudySessionsTable studySessions = $StudySessionsTable(this);
  late final $MetaTable meta = $MetaTable(this);
  late final Index idxWordsLangDiff = Index(
    'idx_words_lang_diff',
    'CREATE INDEX idx_words_lang_diff ON words (language, difficulty)',
  );
  late final Index idxWordsLangHeadword = Index(
    'idx_words_lang_headword',
    'CREATE INDEX idx_words_lang_headword ON words (language, headword)',
  );
  late final Index idxProgressDue = Index(
    'idx_progress_due',
    'CREATE INDEX idx_progress_due ON word_progress (due)',
  );
  late final Index idxProgressLangState = Index(
    'idx_progress_lang_state',
    'CREATE INDEX idx_progress_lang_state ON word_progress (language, state)',
  );
  late final Index idxLogsWordTime = Index(
    'idx_logs_word_time',
    'CREATE INDEX idx_logs_word_time ON study_logs (word_id, studied_at)',
  );
  late final Index idxLogsStudiedAt = Index(
    'idx_logs_studied_at',
    'CREATE INDEX idx_logs_studied_at ON study_logs (studied_at)',
  );
  late final WordDao wordDao = WordDao(this as AppDatabase);
  late final ProgressDao progressDao = ProgressDao(this as AppDatabase);
  late final StudyDao studyDao = StudyDao(this as AppDatabase);
  late final SettingsDao settingsDao = SettingsDao(this as AppDatabase);
  @override
  Iterable<TableInfo<Table, Object?>> get allTables =>
      allSchemaEntities.whereType<TableInfo<Table, Object?>>();
  @override
  List<DatabaseSchemaEntity> get allSchemaEntities => [
    words,
    decks,
    deckWords,
    wordProgress,
    studyLogs,
    settings,
    dailyStats,
    studySessions,
    meta,
    idxWordsLangDiff,
    idxWordsLangHeadword,
    idxProgressDue,
    idxProgressLangState,
    idxLogsWordTime,
    idxLogsStudiedAt,
  ];
}

typedef $$WordsTableCreateCompanionBuilder = WordsCompanion Function({
  required String id,
  required String language,
  required String headword,
  Value<String?> reading,
  Value<String?> pos,
  Value<String?> phonetic,
  required String meanings,
  required String examples,
  required double difficulty,
  required String level,
  Value<int?> freqRank,
  Value<String?> tags,
  Value<int> rowid,
});
typedef $$WordsTableUpdateCompanionBuilder = WordsCompanion Function({
  Value<String> id,
  Value<String> language,
  Value<String> headword,
  Value<String?> reading,
  Value<String?> pos,
  Value<String?> phonetic,
  Value<String> meanings,
  Value<String> examples,
  Value<double> difficulty,
  Value<String> level,
  Value<int?> freqRank,
  Value<String?> tags,
  Value<int> rowid,
});

class $$WordsTableFilterComposer extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get headword => $composableBuilder(
    column: $table.headword,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get phonetic => $composableBuilder(
    column: $table.phonetic,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get meanings => $composableBuilder(
    column: $table.meanings,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get examples => $composableBuilder(
    column: $table.examples,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordsTableOrderingComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get headword => $composableBuilder(
    column: $table.headword,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reading => $composableBuilder(
    column: $table.reading,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get pos => $composableBuilder(
    column: $table.pos,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get phonetic => $composableBuilder(
    column: $table.phonetic,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get meanings => $composableBuilder(
    column: $table.meanings,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get examples => $composableBuilder(
    column: $table.examples,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get level => $composableBuilder(
    column: $table.level,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get freqRank => $composableBuilder(
    column: $table.freqRank,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get tags => $composableBuilder(
    column: $table.tags,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordsTable> {
  $$WordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get headword =>
      $composableBuilder(column: $table.headword, builder: (column) => column);

  GeneratedColumn<String> get reading =>
      $composableBuilder(column: $table.reading, builder: (column) => column);

  GeneratedColumn<String> get pos =>
      $composableBuilder(column: $table.pos, builder: (column) => column);

  GeneratedColumn<String> get phonetic =>
      $composableBuilder(column: $table.phonetic, builder: (column) => column);

  GeneratedColumn<String> get meanings =>
      $composableBuilder(column: $table.meanings, builder: (column) => column);

  GeneratedColumn<String> get examples =>
      $composableBuilder(column: $table.examples, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<String> get level =>
      $composableBuilder(column: $table.level, builder: (column) => column);

  GeneratedColumn<int> get freqRank =>
      $composableBuilder(column: $table.freqRank, builder: (column) => column);

  GeneratedColumn<String> get tags =>
      $composableBuilder(column: $table.tags, builder: (column) => column);
}

class $$WordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordsTable,
          Word,
          $$WordsTableFilterComposer,
          $$WordsTableOrderingComposer,
          $$WordsTableAnnotationComposer,
          $$WordsTableCreateCompanionBuilder,
          $$WordsTableUpdateCompanionBuilder,
          (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
          Word,
          PrefetchHooks Function()
        > {
  $$WordsTableTableManager(_$AppDatabase db, $WordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> headword = const Value.absent(),
                Value<String?> reading = const Value.absent(),
                Value<String?> pos = const Value.absent(),
                Value<String?> phonetic = const Value.absent(),
                Value<String> meanings = const Value.absent(),
                Value<String> examples = const Value.absent(),
                Value<double> difficulty = const Value.absent(),
                Value<String> level = const Value.absent(),
                Value<int?> freqRank = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion(
                id: id,
                language: language,
                headword: headword,
                reading: reading,
                pos: pos,
                phonetic: phonetic,
                meanings: meanings,
                examples: examples,
                difficulty: difficulty,
                level: level,
                freqRank: freqRank,
                tags: tags,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String language,
                required String headword,
                Value<String?> reading = const Value.absent(),
                Value<String?> pos = const Value.absent(),
                Value<String?> phonetic = const Value.absent(),
                required String meanings,
                required String examples,
                required double difficulty,
                required String level,
                Value<int?> freqRank = const Value.absent(),
                Value<String?> tags = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordsCompanion.insert(
                id: id,
                language: language,
                headword: headword,
                reading: reading,
                pos: pos,
                phonetic: phonetic,
                meanings: meanings,
                examples: examples,
                difficulty: difficulty,
                level: level,
                freqRank: freqRank,
                tags: tags,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordsTable, Word>(table),
                  BaseReferences<_$AppDatabase, $WordsTable, Word>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordsTable,
      Word,
      $$WordsTableFilterComposer,
      $$WordsTableOrderingComposer,
      $$WordsTableAnnotationComposer,
      $$WordsTableCreateCompanionBuilder,
      $$WordsTableUpdateCompanionBuilder,
      (Word, BaseReferences<_$AppDatabase, $WordsTable, Word>),
      Word,
      PrefetchHooks Function()
    >;
typedef $$DecksTableCreateCompanionBuilder = DecksCompanion Function({
  required String id,
  required String language,
  required String name,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$DecksTableUpdateCompanionBuilder = DecksCompanion Function({
  Value<String> id,
  Value<String> language,
  Value<String> name,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$DecksTableFilterComposer extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DecksTableOrderingComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get name => $composableBuilder(
    column: $table.name,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DecksTableAnnotationComposer
    extends Composer<_$AppDatabase, $DecksTable> {
  $$DecksTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<String> get name =>
      $composableBuilder(column: $table.name, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DecksTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DecksTable,
          Deck,
          $$DecksTableFilterComposer,
          $$DecksTableOrderingComposer,
          $$DecksTableAnnotationComposer,
          $$DecksTableCreateCompanionBuilder,
          $$DecksTableUpdateCompanionBuilder,
          (Deck, BaseReferences<_$AppDatabase, $DecksTable, Deck>),
          Deck,
          PrefetchHooks Function()
        > {
  $$DecksTableTableManager(_$AppDatabase db, $DecksTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DecksTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DecksTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DecksTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<String> name = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DecksCompanion(
                id: id,
                language: language,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String language,
                required String name,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => DecksCompanion.insert(
                id: id,
                language: language,
                name: name,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DecksTable, Deck>(table),
                  BaseReferences<_$AppDatabase, $DecksTable, Deck>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DecksTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DecksTable,
      Deck,
      $$DecksTableFilterComposer,
      $$DecksTableOrderingComposer,
      $$DecksTableAnnotationComposer,
      $$DecksTableCreateCompanionBuilder,
      $$DecksTableUpdateCompanionBuilder,
      (Deck, BaseReferences<_$AppDatabase, $DecksTable, Deck>),
      Deck,
      PrefetchHooks Function()
    >;
typedef $$DeckWordsTableCreateCompanionBuilder = DeckWordsCompanion Function({
  required String deckId,
  required String wordId,
  required int sortOrder,
  Value<int> rowid,
});
typedef $$DeckWordsTableUpdateCompanionBuilder = DeckWordsCompanion Function({
  Value<String> deckId,
  Value<String> wordId,
  Value<int> sortOrder,
  Value<int> rowid,
});

class $$DeckWordsTableFilterComposer
    extends Composer<_$AppDatabase, $DeckWordsTable> {
  $$DeckWordsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DeckWordsTableOrderingComposer
    extends Composer<_$AppDatabase, $DeckWordsTable> {
  $$DeckWordsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get deckId => $composableBuilder(
    column: $table.deckId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get sortOrder => $composableBuilder(
    column: $table.sortOrder,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DeckWordsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DeckWordsTable> {
  $$DeckWordsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get deckId =>
      $composableBuilder(column: $table.deckId, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<int> get sortOrder =>
      $composableBuilder(column: $table.sortOrder, builder: (column) => column);
}

class $$DeckWordsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DeckWordsTable,
          DeckWord,
          $$DeckWordsTableFilterComposer,
          $$DeckWordsTableOrderingComposer,
          $$DeckWordsTableAnnotationComposer,
          $$DeckWordsTableCreateCompanionBuilder,
          $$DeckWordsTableUpdateCompanionBuilder,
          (DeckWord, BaseReferences<_$AppDatabase, $DeckWordsTable, DeckWord>),
          DeckWord,
          PrefetchHooks Function()
        > {
  $$DeckWordsTableTableManager(_$AppDatabase db, $DeckWordsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DeckWordsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DeckWordsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DeckWordsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> deckId = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<int> sortOrder = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DeckWordsCompanion(
                deckId: deckId,
                wordId: wordId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String deckId,
                required String wordId,
                required int sortOrder,
                Value<int> rowid = const Value.absent(),
              }) => DeckWordsCompanion.insert(
                deckId: deckId,
                wordId: wordId,
                sortOrder: sortOrder,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DeckWordsTable, DeckWord>(table),
                  BaseReferences<_$AppDatabase, $DeckWordsTable, DeckWord>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DeckWordsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DeckWordsTable,
      DeckWord,
      $$DeckWordsTableFilterComposer,
      $$DeckWordsTableOrderingComposer,
      $$DeckWordsTableAnnotationComposer,
      $$DeckWordsTableCreateCompanionBuilder,
      $$DeckWordsTableUpdateCompanionBuilder,
      (DeckWord, BaseReferences<_$AppDatabase, $DeckWordsTable, DeckWord>),
      DeckWord,
      PrefetchHooks Function()
    >;
typedef $$WordProgressTableCreateCompanionBuilder =
    WordProgressCompanion Function({
      required String id,
      required String wordId,
      required String language,
      required int state,
      required int due,
      Value<double?> stability,
      Value<double?> difficulty,
      Value<int?> step,
      required int elapsedDays,
      required int scheduledDays,
      required int reps,
      required int lapses,
      Value<int?> lastReviewAt,
      required int updatedAt,
      Value<int?> deletedAt,
      Value<int> syncStatus,
      Value<int> rowid,
    });
typedef $$WordProgressTableUpdateCompanionBuilder =
    WordProgressCompanion Function({
      Value<String> id,
      Value<String> wordId,
      Value<String> language,
      Value<int> state,
      Value<int> due,
      Value<double?> stability,
      Value<double?> difficulty,
      Value<int?> step,
      Value<int> elapsedDays,
      Value<int> scheduledDays,
      Value<int> reps,
      Value<int> lapses,
      Value<int?> lastReviewAt,
      Value<int> updatedAt,
      Value<int?> deletedAt,
      Value<int> syncStatus,
      Value<int> rowid,
    });

class $$WordProgressTableFilterComposer
    extends Composer<_$AppDatabase, $WordProgressTable> {
  $$WordProgressTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$WordProgressTableOrderingComposer
    extends Composer<_$AppDatabase, $WordProgressTable> {
  $$WordProgressTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get state => $composableBuilder(
    column: $table.state,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get due => $composableBuilder(
    column: $table.due,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get stability => $composableBuilder(
    column: $table.stability,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get step => $composableBuilder(
    column: $table.step,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reps => $composableBuilder(
    column: $table.reps,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lapses => $composableBuilder(
    column: $table.lapses,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$WordProgressTableAnnotationComposer
    extends Composer<_$AppDatabase, $WordProgressTable> {
  $$WordProgressTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get state =>
      $composableBuilder(column: $table.state, builder: (column) => column);

  GeneratedColumn<int> get due =>
      $composableBuilder(column: $table.due, builder: (column) => column);

  GeneratedColumn<double> get stability =>
      $composableBuilder(column: $table.stability, builder: (column) => column);

  GeneratedColumn<double> get difficulty => $composableBuilder(
    column: $table.difficulty,
    builder: (column) => column,
  );

  GeneratedColumn<int> get step =>
      $composableBuilder(column: $table.step, builder: (column) => column);

  GeneratedColumn<int> get elapsedDays => $composableBuilder(
    column: $table.elapsedDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get scheduledDays => $composableBuilder(
    column: $table.scheduledDays,
    builder: (column) => column,
  );

  GeneratedColumn<int> get reps =>
      $composableBuilder(column: $table.reps, builder: (column) => column);

  GeneratedColumn<int> get lapses =>
      $composableBuilder(column: $table.lapses, builder: (column) => column);

  GeneratedColumn<int> get lastReviewAt => $composableBuilder(
    column: $table.lastReviewAt,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$WordProgressTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $WordProgressTable,
          WordProgressData,
          $$WordProgressTableFilterComposer,
          $$WordProgressTableOrderingComposer,
          $$WordProgressTableAnnotationComposer,
          $$WordProgressTableCreateCompanionBuilder,
          $$WordProgressTableUpdateCompanionBuilder,
          (
            WordProgressData,
            BaseReferences<_$AppDatabase, $WordProgressTable, WordProgressData>,
          ),
          WordProgressData,
          PrefetchHooks Function()
        > {
  $$WordProgressTableTableManager(_$AppDatabase db, $WordProgressTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$WordProgressTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$WordProgressTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$WordProgressTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> state = const Value.absent(),
                Value<int> due = const Value.absent(),
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<int?> step = const Value.absent(),
                Value<int> elapsedDays = const Value.absent(),
                Value<int> scheduledDays = const Value.absent(),
                Value<int> reps = const Value.absent(),
                Value<int> lapses = const Value.absent(),
                Value<int?> lastReviewAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordProgressCompanion(
                id: id,
                wordId: wordId,
                language: language,
                state: state,
                due: due,
                stability: stability,
                difficulty: difficulty,
                step: step,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
                lapses: lapses,
                lastReviewAt: lastReviewAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wordId,
                required String language,
                required int state,
                required int due,
                Value<double?> stability = const Value.absent(),
                Value<double?> difficulty = const Value.absent(),
                Value<int?> step = const Value.absent(),
                required int elapsedDays,
                required int scheduledDays,
                required int reps,
                required int lapses,
                Value<int?> lastReviewAt = const Value.absent(),
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => WordProgressCompanion.insert(
                id: id,
                wordId: wordId,
                language: language,
                state: state,
                due: due,
                stability: stability,
                difficulty: difficulty,
                step: step,
                elapsedDays: elapsedDays,
                scheduledDays: scheduledDays,
                reps: reps,
                lapses: lapses,
                lastReviewAt: lastReviewAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$WordProgressTable, WordProgressData>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $WordProgressTable,
                    WordProgressData
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$WordProgressTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $WordProgressTable,
      WordProgressData,
      $$WordProgressTableFilterComposer,
      $$WordProgressTableOrderingComposer,
      $$WordProgressTableAnnotationComposer,
      $$WordProgressTableCreateCompanionBuilder,
      $$WordProgressTableUpdateCompanionBuilder,
      (
        WordProgressData,
        BaseReferences<_$AppDatabase, $WordProgressTable, WordProgressData>,
      ),
      WordProgressData,
      PrefetchHooks Function()
    >;
typedef $$StudyLogsTableCreateCompanionBuilder = StudyLogsCompanion Function({
  required String id,
  required String wordId,
  required String mode,
  required int rating,
  required bool correct,
  required int durationMs,
  Value<String?> reviewLog,
  required int studiedAt,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> syncStatus,
  Value<int> rowid,
});
typedef $$StudyLogsTableUpdateCompanionBuilder = StudyLogsCompanion Function({
  Value<String> id,
  Value<String> wordId,
  Value<String> mode,
  Value<int> rating,
  Value<bool> correct,
  Value<int> durationMs,
  Value<String?> reviewLog,
  Value<int> studiedAt,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> syncStatus,
  Value<int> rowid,
});

class $$StudyLogsTableFilterComposer
    extends Composer<_$AppDatabase, $StudyLogsTable> {
  $$StudyLogsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reviewLog => $composableBuilder(
    column: $table.reviewLog,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get studiedAt => $composableBuilder(
    column: $table.studiedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudyLogsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudyLogsTable> {
  $$StudyLogsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get wordId => $composableBuilder(
    column: $table.wordId,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get mode => $composableBuilder(
    column: $table.mode,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get rating => $composableBuilder(
    column: $table.rating,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get correct => $composableBuilder(
    column: $table.correct,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reviewLog => $composableBuilder(
    column: $table.reviewLog,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get studiedAt => $composableBuilder(
    column: $table.studiedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudyLogsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudyLogsTable> {
  $$StudyLogsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get wordId =>
      $composableBuilder(column: $table.wordId, builder: (column) => column);

  GeneratedColumn<String> get mode =>
      $composableBuilder(column: $table.mode, builder: (column) => column);

  GeneratedColumn<int> get rating =>
      $composableBuilder(column: $table.rating, builder: (column) => column);

  GeneratedColumn<bool> get correct =>
      $composableBuilder(column: $table.correct, builder: (column) => column);

  GeneratedColumn<int> get durationMs => $composableBuilder(
    column: $table.durationMs,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reviewLog =>
      $composableBuilder(column: $table.reviewLog, builder: (column) => column);

  GeneratedColumn<int> get studiedAt =>
      $composableBuilder(column: $table.studiedAt, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$StudyLogsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudyLogsTable,
          StudyLog,
          $$StudyLogsTableFilterComposer,
          $$StudyLogsTableOrderingComposer,
          $$StudyLogsTableAnnotationComposer,
          $$StudyLogsTableCreateCompanionBuilder,
          $$StudyLogsTableUpdateCompanionBuilder,
          (StudyLog, BaseReferences<_$AppDatabase, $StudyLogsTable, StudyLog>),
          StudyLog,
          PrefetchHooks Function()
        > {
  $$StudyLogsTableTableManager(_$AppDatabase db, $StudyLogsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudyLogsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudyLogsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudyLogsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> wordId = const Value.absent(),
                Value<String> mode = const Value.absent(),
                Value<int> rating = const Value.absent(),
                Value<bool> correct = const Value.absent(),
                Value<int> durationMs = const Value.absent(),
                Value<String?> reviewLog = const Value.absent(),
                Value<int> studiedAt = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyLogsCompanion(
                id: id,
                wordId: wordId,
                mode: mode,
                rating: rating,
                correct: correct,
                durationMs: durationMs,
                reviewLog: reviewLog,
                studiedAt: studiedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String wordId,
                required String mode,
                required int rating,
                required bool correct,
                required int durationMs,
                Value<String?> reviewLog = const Value.absent(),
                required int studiedAt,
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudyLogsCompanion.insert(
                id: id,
                wordId: wordId,
                mode: mode,
                rating: rating,
                correct: correct,
                durationMs: durationMs,
                reviewLog: reviewLog,
                studiedAt: studiedAt,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudyLogsTable, StudyLog>(table),
                  BaseReferences<_$AppDatabase, $StudyLogsTable, StudyLog>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudyLogsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudyLogsTable,
      StudyLog,
      $$StudyLogsTableFilterComposer,
      $$StudyLogsTableOrderingComposer,
      $$StudyLogsTableAnnotationComposer,
      $$StudyLogsTableCreateCompanionBuilder,
      $$StudyLogsTableUpdateCompanionBuilder,
      (StudyLog, BaseReferences<_$AppDatabase, $StudyLogsTable, StudyLog>),
      StudyLog,
      PrefetchHooks Function()
    >;
typedef $$SettingsTableCreateCompanionBuilder = SettingsCompanion Function({
  Value<String> id,
  Value<String> nativeLang,
  Value<String> learningLang,
  Value<int> dailyNewLimit,
  Value<int> dailyReviewLimit,
  Value<bool> reminderEnabled,
  Value<String> reminderTime,
  Value<bool> placementDone,
  Value<String?> placementLevelEn,
  Value<String?> placementLevelJa,
  Value<int> dailyGoalMinutes,
  Value<bool> onboarded,
  required int updatedAt,
  Value<int?> deletedAt,
  Value<int> syncStatus,
  Value<int> rowid,
});
typedef $$SettingsTableUpdateCompanionBuilder = SettingsCompanion Function({
  Value<String> id,
  Value<String> nativeLang,
  Value<String> learningLang,
  Value<int> dailyNewLimit,
  Value<int> dailyReviewLimit,
  Value<bool> reminderEnabled,
  Value<String> reminderTime,
  Value<bool> placementDone,
  Value<String?> placementLevelEn,
  Value<String?> placementLevelJa,
  Value<int> dailyGoalMinutes,
  Value<bool> onboarded,
  Value<int> updatedAt,
  Value<int?> deletedAt,
  Value<int> syncStatus,
  Value<int> rowid,
});

class $$SettingsTableFilterComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get nativeLang => $composableBuilder(
    column: $table.nativeLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get learningLang => $composableBuilder(
    column: $table.learningLang,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyNewLimit => $composableBuilder(
    column: $table.dailyNewLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyReviewLimit => $composableBuilder(
    column: $table.dailyReviewLimit,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get placementDone => $composableBuilder(
    column: $table.placementDone,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placementLevelEn => $composableBuilder(
    column: $table.placementLevelEn,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get placementLevelJa => $composableBuilder(
    column: $table.placementLevelJa,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<bool> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnFilters(column),
  );
}

class $$SettingsTableOrderingComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get nativeLang => $composableBuilder(
    column: $table.nativeLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get learningLang => $composableBuilder(
    column: $table.learningLang,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyNewLimit => $composableBuilder(
    column: $table.dailyNewLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyReviewLimit => $composableBuilder(
    column: $table.dailyReviewLimit,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get placementDone => $composableBuilder(
    column: $table.placementDone,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placementLevelEn => $composableBuilder(
    column: $table.placementLevelEn,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get placementLevelJa => $composableBuilder(
    column: $table.placementLevelJa,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<bool> get onboarded => $composableBuilder(
    column: $table.onboarded,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get deletedAt => $composableBuilder(
    column: $table.deletedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$SettingsTableAnnotationComposer
    extends Composer<_$AppDatabase, $SettingsTable> {
  $$SettingsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get nativeLang => $composableBuilder(
    column: $table.nativeLang,
    builder: (column) => column,
  );

  GeneratedColumn<String> get learningLang => $composableBuilder(
    column: $table.learningLang,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyNewLimit => $composableBuilder(
    column: $table.dailyNewLimit,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyReviewLimit => $composableBuilder(
    column: $table.dailyReviewLimit,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get reminderEnabled => $composableBuilder(
    column: $table.reminderEnabled,
    builder: (column) => column,
  );

  GeneratedColumn<String> get reminderTime => $composableBuilder(
    column: $table.reminderTime,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get placementDone => $composableBuilder(
    column: $table.placementDone,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placementLevelEn => $composableBuilder(
    column: $table.placementLevelEn,
    builder: (column) => column,
  );

  GeneratedColumn<String> get placementLevelJa => $composableBuilder(
    column: $table.placementLevelJa,
    builder: (column) => column,
  );

  GeneratedColumn<int> get dailyGoalMinutes => $composableBuilder(
    column: $table.dailyGoalMinutes,
    builder: (column) => column,
  );

  GeneratedColumn<bool> get onboarded =>
      $composableBuilder(column: $table.onboarded, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);

  GeneratedColumn<int> get deletedAt =>
      $composableBuilder(column: $table.deletedAt, builder: (column) => column);

  GeneratedColumn<int> get syncStatus => $composableBuilder(
    column: $table.syncStatus,
    builder: (column) => column,
  );
}

class $$SettingsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $SettingsTable,
          Setting,
          $$SettingsTableFilterComposer,
          $$SettingsTableOrderingComposer,
          $$SettingsTableAnnotationComposer,
          $$SettingsTableCreateCompanionBuilder,
          $$SettingsTableUpdateCompanionBuilder,
          (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
          Setting,
          PrefetchHooks Function()
        > {
  $$SettingsTableTableManager(_$AppDatabase db, $SettingsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$SettingsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$SettingsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$SettingsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nativeLang = const Value.absent(),
                Value<String> learningLang = const Value.absent(),
                Value<int> dailyNewLimit = const Value.absent(),
                Value<int> dailyReviewLimit = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String> reminderTime = const Value.absent(),
                Value<bool> placementDone = const Value.absent(),
                Value<String?> placementLevelEn = const Value.absent(),
                Value<String?> placementLevelJa = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<bool> onboarded = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion(
                id: id,
                nativeLang: nativeLang,
                learningLang: learningLang,
                dailyNewLimit: dailyNewLimit,
                dailyReviewLimit: dailyReviewLimit,
                reminderEnabled: reminderEnabled,
                reminderTime: reminderTime,
                placementDone: placementDone,
                placementLevelEn: placementLevelEn,
                placementLevelJa: placementLevelJa,
                dailyGoalMinutes: dailyGoalMinutes,
                onboarded: onboarded,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> nativeLang = const Value.absent(),
                Value<String> learningLang = const Value.absent(),
                Value<int> dailyNewLimit = const Value.absent(),
                Value<int> dailyReviewLimit = const Value.absent(),
                Value<bool> reminderEnabled = const Value.absent(),
                Value<String> reminderTime = const Value.absent(),
                Value<bool> placementDone = const Value.absent(),
                Value<String?> placementLevelEn = const Value.absent(),
                Value<String?> placementLevelJa = const Value.absent(),
                Value<int> dailyGoalMinutes = const Value.absent(),
                Value<bool> onboarded = const Value.absent(),
                required int updatedAt,
                Value<int?> deletedAt = const Value.absent(),
                Value<int> syncStatus = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => SettingsCompanion.insert(
                id: id,
                nativeLang: nativeLang,
                learningLang: learningLang,
                dailyNewLimit: dailyNewLimit,
                dailyReviewLimit: dailyReviewLimit,
                reminderEnabled: reminderEnabled,
                reminderTime: reminderTime,
                placementDone: placementDone,
                placementLevelEn: placementLevelEn,
                placementLevelJa: placementLevelJa,
                dailyGoalMinutes: dailyGoalMinutes,
                onboarded: onboarded,
                updatedAt: updatedAt,
                deletedAt: deletedAt,
                syncStatus: syncStatus,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$SettingsTable, Setting>(table),
                  BaseReferences<_$AppDatabase, $SettingsTable, Setting>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$SettingsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $SettingsTable,
      Setting,
      $$SettingsTableFilterComposer,
      $$SettingsTableOrderingComposer,
      $$SettingsTableAnnotationComposer,
      $$SettingsTableCreateCompanionBuilder,
      $$SettingsTableUpdateCompanionBuilder,
      (Setting, BaseReferences<_$AppDatabase, $SettingsTable, Setting>),
      Setting,
      PrefetchHooks Function()
    >;
typedef $$DailyStatsTableCreateCompanionBuilder = DailyStatsCompanion Function({
  required String date,
  Value<int> newCount,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> totalCount,
  Value<int> minutes,
  required int updatedAt,
  Value<int> rowid,
});
typedef $$DailyStatsTableUpdateCompanionBuilder = DailyStatsCompanion Function({
  Value<String> date,
  Value<int> newCount,
  Value<int> reviewCount,
  Value<int> correctCount,
  Value<int> totalCount,
  Value<int> minutes,
  Value<int> updatedAt,
  Value<int> rowid,
});

class $$DailyStatsTableFilterComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get newCount => $composableBuilder(
    column: $table.newCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$DailyStatsTableOrderingComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get date => $composableBuilder(
    column: $table.date,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get newCount => $composableBuilder(
    column: $table.newCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get minutes => $composableBuilder(
    column: $table.minutes,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$DailyStatsTableAnnotationComposer
    extends Composer<_$AppDatabase, $DailyStatsTable> {
  $$DailyStatsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get date =>
      $composableBuilder(column: $table.date, builder: (column) => column);

  GeneratedColumn<int> get newCount =>
      $composableBuilder(column: $table.newCount, builder: (column) => column);

  GeneratedColumn<int> get reviewCount => $composableBuilder(
    column: $table.reviewCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get correctCount => $composableBuilder(
    column: $table.correctCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get totalCount => $composableBuilder(
    column: $table.totalCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get minutes =>
      $composableBuilder(column: $table.minutes, builder: (column) => column);

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$DailyStatsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $DailyStatsTable,
          DailyStat,
          $$DailyStatsTableFilterComposer,
          $$DailyStatsTableOrderingComposer,
          $$DailyStatsTableAnnotationComposer,
          $$DailyStatsTableCreateCompanionBuilder,
          $$DailyStatsTableUpdateCompanionBuilder,
          (
            DailyStat,
            BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>,
          ),
          DailyStat,
          PrefetchHooks Function()
        > {
  $$DailyStatsTableTableManager(_$AppDatabase db, $DailyStatsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$DailyStatsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$DailyStatsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$DailyStatsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> date = const Value.absent(),
                Value<int> newCount = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion(
                date: date,
                newCount: newCount,
                reviewCount: reviewCount,
                correctCount: correctCount,
                totalCount: totalCount,
                minutes: minutes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String date,
                Value<int> newCount = const Value.absent(),
                Value<int> reviewCount = const Value.absent(),
                Value<int> correctCount = const Value.absent(),
                Value<int> totalCount = const Value.absent(),
                Value<int> minutes = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => DailyStatsCompanion.insert(
                date: date,
                newCount: newCount,
                reviewCount: reviewCount,
                correctCount: correctCount,
                totalCount: totalCount,
                minutes: minutes,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$DailyStatsTable, DailyStat>(table),
                  BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$DailyStatsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $DailyStatsTable,
      DailyStat,
      $$DailyStatsTableFilterComposer,
      $$DailyStatsTableOrderingComposer,
      $$DailyStatsTableAnnotationComposer,
      $$DailyStatsTableCreateCompanionBuilder,
      $$DailyStatsTableUpdateCompanionBuilder,
      (DailyStat, BaseReferences<_$AppDatabase, $DailyStatsTable, DailyStat>),
      DailyStat,
      PrefetchHooks Function()
    >;
typedef $$StudySessionsTableCreateCompanionBuilder =
    StudySessionsCompanion Function({
      required String id,
      required String language,
      required int startedAt,
      Value<int?> endedAt,
      Value<String?> queue,
      Value<int> completedCount,
      required int updatedAt,
      Value<int> rowid,
    });
typedef $$StudySessionsTableUpdateCompanionBuilder =
    StudySessionsCompanion Function({
      Value<String> id,
      Value<String> language,
      Value<int> startedAt,
      Value<int?> endedAt,
      Value<String?> queue,
      Value<int> completedCount,
      Value<int> updatedAt,
      Value<int> rowid,
    });

class $$StudySessionsTableFilterComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get queue => $composableBuilder(
    column: $table.queue,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get completedCount => $composableBuilder(
    column: $table.completedCount,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnFilters(column),
  );
}

class $$StudySessionsTableOrderingComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get id => $composableBuilder(
    column: $table.id,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get language => $composableBuilder(
    column: $table.language,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get startedAt => $composableBuilder(
    column: $table.startedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get endedAt => $composableBuilder(
    column: $table.endedAt,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get queue => $composableBuilder(
    column: $table.queue,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get completedCount => $composableBuilder(
    column: $table.completedCount,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<int> get updatedAt => $composableBuilder(
    column: $table.updatedAt,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$StudySessionsTableAnnotationComposer
    extends Composer<_$AppDatabase, $StudySessionsTable> {
  $$StudySessionsTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get id =>
      $composableBuilder(column: $table.id, builder: (column) => column);

  GeneratedColumn<String> get language =>
      $composableBuilder(column: $table.language, builder: (column) => column);

  GeneratedColumn<int> get startedAt =>
      $composableBuilder(column: $table.startedAt, builder: (column) => column);

  GeneratedColumn<int> get endedAt =>
      $composableBuilder(column: $table.endedAt, builder: (column) => column);

  GeneratedColumn<String> get queue =>
      $composableBuilder(column: $table.queue, builder: (column) => column);

  GeneratedColumn<int> get completedCount => $composableBuilder(
    column: $table.completedCount,
    builder: (column) => column,
  );

  GeneratedColumn<int> get updatedAt =>
      $composableBuilder(column: $table.updatedAt, builder: (column) => column);
}

class $$StudySessionsTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $StudySessionsTable,
          StudySession,
          $$StudySessionsTableFilterComposer,
          $$StudySessionsTableOrderingComposer,
          $$StudySessionsTableAnnotationComposer,
          $$StudySessionsTableCreateCompanionBuilder,
          $$StudySessionsTableUpdateCompanionBuilder,
          (
            StudySession,
            BaseReferences<_$AppDatabase, $StudySessionsTable, StudySession>,
          ),
          StudySession,
          PrefetchHooks Function()
        > {
  $$StudySessionsTableTableManager(_$AppDatabase db, $StudySessionsTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$StudySessionsTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$StudySessionsTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$StudySessionsTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback:
              ({
                Value<String> id = const Value.absent(),
                Value<String> language = const Value.absent(),
                Value<int> startedAt = const Value.absent(),
                Value<int?> endedAt = const Value.absent(),
                Value<String?> queue = const Value.absent(),
                Value<int> completedCount = const Value.absent(),
                Value<int> updatedAt = const Value.absent(),
                Value<int> rowid = const Value.absent(),
              }) => StudySessionsCompanion(
                id: id,
                language: language,
                startedAt: startedAt,
                endedAt: endedAt,
                queue: queue,
                completedCount: completedCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          createCompanionCallback:
              ({
                required String id,
                required String language,
                required int startedAt,
                Value<int?> endedAt = const Value.absent(),
                Value<String?> queue = const Value.absent(),
                Value<int> completedCount = const Value.absent(),
                required int updatedAt,
                Value<int> rowid = const Value.absent(),
              }) => StudySessionsCompanion.insert(
                id: id,
                language: language,
                startedAt: startedAt,
                endedAt: endedAt,
                queue: queue,
                completedCount: completedCount,
                updatedAt: updatedAt,
                rowid: rowid,
              ),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$StudySessionsTable, StudySession>(table),
                  BaseReferences<
                    _$AppDatabase,
                    $StudySessionsTable,
                    StudySession
                  >(db, table, e),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$StudySessionsTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $StudySessionsTable,
      StudySession,
      $$StudySessionsTableFilterComposer,
      $$StudySessionsTableOrderingComposer,
      $$StudySessionsTableAnnotationComposer,
      $$StudySessionsTableCreateCompanionBuilder,
      $$StudySessionsTableUpdateCompanionBuilder,
      (
        StudySession,
        BaseReferences<_$AppDatabase, $StudySessionsTable, StudySession>,
      ),
      StudySession,
      PrefetchHooks Function()
    >;
typedef $$MetaTableCreateCompanionBuilder = MetaCompanion Function({
  required String key,
  required String value,
  Value<int> rowid,
});
typedef $$MetaTableUpdateCompanionBuilder = MetaCompanion Function({
  Value<String> key,
  Value<String> value,
  Value<int> rowid,
});

class $$MetaTableFilterComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableFilterComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnFilters<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnFilters(column),
  );

  ColumnFilters<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnFilters(column),
  );
}

class $$MetaTableOrderingComposer extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableOrderingComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  ColumnOrderings<String> get key => $composableBuilder(
    column: $table.key,
    builder: (column) => ColumnOrderings(column),
  );

  ColumnOrderings<String> get value => $composableBuilder(
    column: $table.value,
    builder: (column) => ColumnOrderings(column),
  );
}

class $$MetaTableAnnotationComposer
    extends Composer<_$AppDatabase, $MetaTable> {
  $$MetaTableAnnotationComposer({
    required super.$db,
    required super.$table,
    super.joinBuilder,
    super.$addJoinBuilderToRootComposer,
    super.$removeJoinBuilderFromRootComposer,
  });
  GeneratedColumn<String> get key =>
      $composableBuilder(column: $table.key, builder: (column) => column);

  GeneratedColumn<String> get value =>
      $composableBuilder(column: $table.value, builder: (column) => column);
}

class $$MetaTableTableManager
    extends
        RootTableManager<
          _$AppDatabase,
          $MetaTable,
          MetaData,
          $$MetaTableFilterComposer,
          $$MetaTableOrderingComposer,
          $$MetaTableAnnotationComposer,
          $$MetaTableCreateCompanionBuilder,
          $$MetaTableUpdateCompanionBuilder,
          (MetaData, BaseReferences<_$AppDatabase, $MetaTable, MetaData>),
          MetaData,
          PrefetchHooks Function()
        > {
  $$MetaTableTableManager(_$AppDatabase db, $MetaTable table)
    : super(
        TableManagerState(
          db: db,
          table: table,
          createFilteringComposer: () =>
              $$MetaTableFilterComposer($db: db, $table: table),
          createOrderingComposer: () =>
              $$MetaTableOrderingComposer($db: db, $table: table),
          createComputedFieldComposer: () =>
              $$MetaTableAnnotationComposer($db: db, $table: table),
          updateCompanionCallback: ({
            Value<String> key = const Value.absent(),
            Value<String> value = const Value.absent(),
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion(key: key, value: value, rowid: rowid),
          createCompanionCallback: ({
            required String key,
            required String value,
            Value<int> rowid = const Value.absent(),
          }) => MetaCompanion.insert(key: key, value: value, rowid: rowid),
          withReferenceMapper: (p0) => p0
              .map(
                (e) => (
                  e.readTable<$MetaTable, MetaData>(table),
                  BaseReferences<_$AppDatabase, $MetaTable, MetaData>(
                    db,
                    table,
                    e,
                  ),
                ),
              )
              .toList(),
          prefetchHooksCallback: null,
        ),
      );
}

typedef $$MetaTableProcessedTableManager =
    ProcessedTableManager<
      _$AppDatabase,
      $MetaTable,
      MetaData,
      $$MetaTableFilterComposer,
      $$MetaTableOrderingComposer,
      $$MetaTableAnnotationComposer,
      $$MetaTableCreateCompanionBuilder,
      $$MetaTableUpdateCompanionBuilder,
      (MetaData, BaseReferences<_$AppDatabase, $MetaTable, MetaData>),
      MetaData,
      PrefetchHooks Function()
    >;

class $AppDatabaseManager {
  final _$AppDatabase _db;
  $AppDatabaseManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db, _db.words);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db, _db.decks);
  $$DeckWordsTableTableManager get deckWords =>
      $$DeckWordsTableTableManager(_db, _db.deckWords);
  $$WordProgressTableTableManager get wordProgress =>
      $$WordProgressTableTableManager(_db, _db.wordProgress);
  $$StudyLogsTableTableManager get studyLogs =>
      $$StudyLogsTableTableManager(_db, _db.studyLogs);
  $$SettingsTableTableManager get settings =>
      $$SettingsTableTableManager(_db, _db.settings);
  $$DailyStatsTableTableManager get dailyStats =>
      $$DailyStatsTableTableManager(_db, _db.dailyStats);
  $$StudySessionsTableTableManager get studySessions =>
      $$StudySessionsTableTableManager(_db, _db.studySessions);
  $$MetaTableTableManager get meta => $$MetaTableTableManager(_db, _db.meta);
}
