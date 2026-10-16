// CLI 检查脚本：打印种子库样例，允许直接 print。
// ignore_for_file: avoid_print
import 'package:sqlite3/sqlite3.dart';

void main() {
  final db = sqlite3.open('assets/db/seed_v1.sqlite');
  for (final r in db.select(
      "SELECT headword, reading, level, substr(meanings,1,60) m FROM words "
      "WHERE language='ja' AND level='N5' ORDER BY freq_rank LIMIT 5")) {
    print(r);
  }
  for (final r in db.select(
      "SELECT headword, level, substr(meanings,1,50) m, substr(examples,1,80) e "
      "FROM words WHERE language='en' AND headword IN ('apple','walk','serendipity')")) {
    print(r);
  }
  print('deck_words: ${db.select("SELECT COUNT(*) c FROM deck_words").first['c']}');
  print('decks: ${db.select("SELECT id, name FROM decks").map((r) => r['id']).join(', ')}');
  db.close();
}
