/// 档位 ↔ 难度值换算（与流水线 tool/pipeline/model.dart 保持一致）。
library;

const cefrOrder = ['A1', 'A2', 'B1', 'B2', 'C1', 'C2'];
const jlptOrder = ['N5', 'N4', 'N3', 'N2', 'N1'];

/// CEFR 档位 → 难度 1.0-6.0。
double cefrDifficulty(String level) =>
    (cefrOrder.indexOf(level) + 1).clamp(1, 6).toDouble();

/// JLPT 档位 → 难度 1.0-5.0。
double jlptDifficulty(String level) =>
    (jlptOrder.indexOf(level) + 1).clamp(1, 5).toDouble();

/// 按学习语言取档位难度。
double levelDifficulty(String language, String level) =>
    language == 'ja' ? jlptDifficulty(level) : cefrDifficulty(level);

/// 定级结果的展示名（词书/建议卡用）。
String levelDisplayName(String language, String level) {
  const cefrNames = {
    'A1': '入门 A1',
    'A2': '基础 A2',
    'B1': '进阶 B1',
    'B2': '中高 B2',
    'C1': '高级 C1',
    'C2': '精通 C2',
  };
  const jlptNames = {
    'N5': '入门 N5',
    'N4': '基础 N4',
    'N3': '进阶 N3',
    'N2': '中高 N2',
    'N1': '精通 N1',
  };
  return (language == 'ja' ? jlptNames[level] : cefrNames[level]) ?? level;
}
