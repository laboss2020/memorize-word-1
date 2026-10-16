/// 今日学习队列构建（纯函数，可单测）。
///
/// 输入：到期复习（due 升序、已按 daily_review_limit 截取）与新词
/// （difficulty≈定级、freq_rank 升序、已按 daily_new_limit 截取）。
/// 规则：复习优先于新词；新词:复习 ≈ 1:3 交错；复习模式按 reps 轮换
/// （choice→dictation→cloze）；无例句的词填空降级为选择题。
library;

import 'rating_mapper.dart' show StudyMode;

/// 队列项：一个待学习单元。
class QueueItem {
  const QueueItem({
    required this.wordId,
    required this.mode,
    required this.isNew,
  });

  final String wordId;
  final StudyMode mode;
  final bool isNew; // 新词首呈
}

/// 调度器输入的最小单词信息。
class QueueWord {
  const QueueWord({
    required this.wordId,
    this.reps = 0,
    this.hasExamples = false,
  });

  final String wordId;

  /// 已复习次数（来自 word_progress；新词为 0）。用于模式轮换。
  final int reps;
  final bool hasExamples;
}

/// 构建今日队列：3 个复习后插 1 个新词；不足时复习在前、新词殿后。
List<QueueItem> buildTodayQueue({
  required List<QueueWord> dueReviews,
  required List<QueueWord> newWords,
}) {
  final items = <QueueItem>[];
  var ri = 0;
  var ni = 0;

  while (ri < dueReviews.length && ni < newWords.length) {
    for (var k = 0; k < 3 && ri < dueReviews.length; k++) {
      items.add(_reviewItem(dueReviews[ri++]));
    }
    items.add(_newItem(newWords[ni++]));
  }
  // 剩余：复习优先，再排新词。
  while (ri < dueReviews.length) {
    items.add(_reviewItem(dueReviews[ri++]));
  }
  while (ni < newWords.length) {
    items.add(_newItem(newWords[ni++]));
  }
  return items;
}

QueueItem _reviewItem(QueueWord w) {
  const cycle = [StudyMode.choice, StudyMode.dictation, StudyMode.cloze];
  var mode = cycle[w.reps % cycle.length];
  if (mode == StudyMode.cloze && !w.hasExamples) {
    mode = StudyMode.choice; // 无例句降级
  }
  return QueueItem(wordId: w.wordId, mode: mode, isNew: false);
}

QueueItem _newItem(QueueWord w) =>
    QueueItem(wordId: w.wordId, mode: StudyMode.newCard, isNew: true);
