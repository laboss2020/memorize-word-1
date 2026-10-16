import 'dart:io';

import 'english.dart';
import 'japanese.dart';
import 'seed_writer.dart';

/// 词库流水线入口。
///
/// 用法（在项目根目录）：
///   dart run tool/pipeline/build_seed.dart --datasets D:/tmp_flutter_dl/datasets
///
/// 数据集目录需包含：
///   ecdict.csv            ECDICT 词库（github.com/skywind3000/ECDICT，MIT）
///   cefr_words.csv        Words-CEFR-Dataset words.csv
///   cefr_word_pos.csv     Words-CEFR-Dataset word_pos.csv
///   tatoeba_sentences.csv Tatoeba sentences_CC0.csv
///   openjlpt/n5.json..n1.json  OpenJLPT vocab JSON（CC-BY-SA-4.0）
Future<void> main(List<String> args) async {
  String? datasets;
  for (var i = 0; i < args.length - 1; i++) {
    if (args[i] == '--datasets') datasets = args[i + 1];
  }
  datasets ??= 'D:/tmp_flutter_dl/datasets';
  final dir = Directory(datasets);
  if (!dir.existsSync()) {
    stderr.writeln('数据集目录不存在: $datasets');
    exit(2);
  }

  final projectRoot = File(Platform.script.toFilePath()).parent.parent.parent.path;

  final english = await EnglishPipeline(
    ecdictCsv: '$datasets/ecdict.csv',
    cefrWordsCsv: '$datasets/cefr_words.csv',
    cefrWordPosCsv: '$datasets/cefr_word_pos.csv',
    tatoebaCsv: '$datasets/tatoeba_sentences.csv',
  ).build();

  final japanese = await JapanesePipeline(openjlptDir: '$datasets/openjlpt').build();

  SeedWriter(outputPath: '$projectRoot/assets/db/seed_v1.sqlite')
      .write(english: english, japanese: japanese);
}
