// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'word_dao.dart';

// ignore_for_file: type=lint
mixin _$WordDaoMixin on DatabaseAccessor<AppDatabase> {
  $WordsTable get words => attachedDatabase.words;
  $DecksTable get decks => attachedDatabase.decks;
  $DeckWordsTable get deckWords => attachedDatabase.deckWords;
  $WordProgressTable get wordProgress => attachedDatabase.wordProgress;
  WordDaoManager get managers => WordDaoManager(this);
}

class WordDaoManager {
  final _$WordDaoMixin _db;
  WordDaoManager(this._db);
  $$WordsTableTableManager get words =>
      $$WordsTableTableManager(_db.attachedDatabase, _db.words);
  $$DecksTableTableManager get decks =>
      $$DecksTableTableManager(_db.attachedDatabase, _db.decks);
  $$DeckWordsTableTableManager get deckWords =>
      $$DeckWordsTableTableManager(_db.attachedDatabase, _db.deckWords);
  $$WordProgressTableTableManager get wordProgress =>
      $$WordProgressTableTableManager(_db.attachedDatabase, _db.wordProgress);
}
