/// 定级测试的爬梯逻辑（纯 Dart，可单测）。
///
/// 规则（实现计划）：
/// - 档位列表如 en: [A1..C2]，ja: [N5..N1]，从中间档开始出题。
/// - 同档连续答对 2 题 → 该档"确认"，升档；升到最高档即完成。
/// - 同档连续答错 2 题 → 结束，保守取低一档（低于失败档）。
/// - 最多 [maxQuestions] 题（默认 20）防止不收敛；中途结束时取当前档
///   （答对中）或低一档（答错中）。
library;

class PlacementEngine {
  PlacementEngine({
    required this.levels,
    this.startIndex = -1,
    this.maxQuestions = 20,
  })  : _index = startIndex < 0
            ? (levels.length - 1) ~/ 2 // 默认中间档
            : startIndex.clamp(0, levels.length - 1);

  /// 档位标识列表（'A1'.. / 'N5'..）。
  final List<String> levels;

  /// 起始档下标；-1 = 中间档。
  final int startIndex;

  final int maxQuestions;

  int _index;
  int _streak = 0;
  bool? _lastCorrect;
  int _asked = 0;
  bool _done = false;
  int _resultIndex = 0;

  /// 当前出题档下标。
  int get currentIndex => _index;

  String get currentLevel => levels[_index];

  /// 已答题数。
  int get askedCount => _asked;

  /// 是否已结束。
  bool get isDone => _done;

  /// 结束后的建议档下标（isDone 为 true 时有效）。
  int get resultIndex => _resultIndex;

  String get resultLevel => levels[_resultIndex];

  /// 记录一次作答并推进爬梯。
  void recordAnswer(bool correct) {
    if (_done) return;
    _asked++;

    final sameAsLast = _lastCorrect != null && _lastCorrect == correct;
    _streak = sameAsLast ? _streak + 1 : 1;
    _lastCorrect = correct;

    if (correct && _streak >= 2) {
      // 确认本档；最高档则直接完成。
      if (_index >= levels.length - 1) {
        _finish(_index);
      } else {
        _index++;
        _resetStreak();
      }
      return;
    }

    if (!correct && _streak >= 2) {
      // 失败本档：保守取低一档。
      _finish(_index > 0 ? _index - 1 : 0);
      return;
    }

    if (_asked >= maxQuestions) {
      // 题量上限：当前档答对中取本档，答错中取低一档。
      _finish(correct ? _index : (_index > 0 ? _index - 1 : 0));
    }
  }

  void _finish(int result) {
    _done = true;
    _resultIndex = result;
  }

  void _resetStreak() {
    _streak = 0;
    _lastCorrect = null;
  }
}
