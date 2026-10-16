/// 模式判定 → FSRS Rating 的映射（纯函数，可单测）。
///
/// 映射表（实现计划）：
/// - 选择题：首次对=Good；此前（最近一次记录）也对=Easy；错=Again；错后重练对=Hard
/// - 听写/填空：拼写全对=Good；用提示或编辑距离 1=Hard；≥2 错=Again
/// - 新卡首呈：固定 Good（进 Learning）
/// - 定级测试不进 FSRS（不产生 rating）
///
/// 客观判定优先：correct=false 强制 Again。
/// 每词每会话每模式只计 1 条 FSRS rating（队列项完结时）；study_logs 记录每次作答。
library;

import 'package:fsrs/fsrs.dart' show Rating;

/// 学习模式（对应 study_logs.mode 的字符串编码）。
enum StudyMode {
  newCard('new_card'),
  choice('choice'),
  dictation('dictation'),
  cloze('cloze'),
  placement('placement');

  const StudyMode(this.id);

  final String id;

  static StudyMode fromId(String id) => StudyMode.values.firstWhere(
        (m) => m.id == id,
        orElse: () => throw ArgumentError('未知学习模式: $id'),
      );
}

/// 选择题的一次作答结果。
class ChoiceAnswer {
  const ChoiceAnswer({
    required this.correct,
    this.consecutiveCorrect = 1,
    this.isRepractice = false,
  });

  /// 客观对错（选中正确选项）。
  final bool correct;

  /// 本词此前最近一次学习记录（任意模式）也答对时传 2，否则 1。
  /// （用于"连续第 2+ 次对 = Easy"）
  final int consecutiveCorrect;

  /// 之前答错过，本次是同题重练。
  final bool isRepractice;
}

/// 听写/填空的一次作答结果。
class RecallAnswer {
  const RecallAnswer({
    required this.correct,
    this.hintUsed = false,
    this.errorCount = 0,
  });

  final bool correct;

  /// 用了提示（首字母/假名提示等）。
  final bool hintUsed;

  /// 输入与答案的编辑距离（correct=false 时通常 ≥2）。
  final int errorCount;
}

/// 选择题判定。
Rating rateChoice(ChoiceAnswer answer) {
  if (!answer.correct) return Rating.again;
  if (answer.isRepractice) return Rating.hard;
  return answer.consecutiveCorrect >= 2 ? Rating.easy : Rating.good;
}

/// 听写/填空判定。
///
/// rating 只看 errorCount/hintUsed：≥2 错=Again；提示或编辑距离 1=Hard；全对=Good。
/// [RecallAnswer.correct] 仅表示客观对错（errorCount==0），用于日志与统计。
Rating rateRecall(RecallAnswer answer) {
  if (answer.errorCount >= 2) return Rating.again;
  if (answer.hintUsed || answer.errorCount == 1) return Rating.hard;
  return Rating.good;
}

/// 新卡首呈：固定 Good。
Rating rateNewCard() => Rating.good;
