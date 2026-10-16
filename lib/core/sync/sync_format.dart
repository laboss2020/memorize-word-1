/// 导出/导入的备份格式（version 1）。
///
/// 手写 JSON 模型：格式稳定且需要严格的导入校验，不引入代码生成。
/// wordId 引用词库的确定性 ID（uuid5），词库本身不随备份导出。
///
/// ```json
/// {
///   "format": "memorize-word-backup",
///   "formatVersion": 1,
///   "exportedAt": "2026-10-15T08:00:00.000Z",
///   "data": {
///     "settings": {...},
///     "wordProgress": [...],
///     "studyLogs": [...],
///     "dailyStats": [...]
///   }
/// }
/// ```
library;

const backupFormatName = 'memorize-word-backup';
const backupFormatVersion = 1;

/// 备份文件格式不合法（format/version 不符或结构损坏）。
class BackupFormatException implements Exception {
  const BackupFormatException(this.message);

  final String message;

  @override
  String toString() => 'BackupFormatException: $message';
}

/// 解析并校验备份 JSON；不合法抛 [BackupFormatException]。
Map<String, dynamic> parseBackupJson(Map<String, dynamic> json) {
  if (json['format'] != backupFormatName) {
    throw const BackupFormatException('不是本应用的备份文件');
  }
  final version = json['formatVersion'];
  if (version is! int || version > backupFormatVersion) {
    throw BackupFormatException('备份版本不支持：$version（当前支持 ≤$backupFormatVersion）');
  }
  final data = json['data'];
  if (data is! Map<String, dynamic>) {
    throw const BackupFormatException('备份缺少 data 段');
  }
  return data;
}

/// 行 ↔ JSON 的通用取值工具（缺字段抛格式异常，避免静默丢数据）。

int reqInt(Map<String, dynamic> row, String key) {
  final v = row[key];
  if (v is int) return v;
  if (v is num) return v.toInt();
  throw BackupFormatException('字段 $key 缺失或类型错误');
}

String reqString(Map<String, dynamic> row, String key) {
  final v = row[key];
  if (v is String) return v;
  throw BackupFormatException('字段 $key 缺失或类型错误');
}

bool reqBool(Map<String, dynamic> row, String key) {
  final v = row[key];
  if (v is bool) return v;
  throw BackupFormatException('字段 $key 缺失或类型错误');
}

int? optInt(Map<String, dynamic> row, String key) =>
    row[key] is int ? row[key] as int : (row[key] is num ? (row[key] as num).toInt() : null);

double? optDouble(Map<String, dynamic> row, String key) =>
    row[key] is num ? (row[key] as num).toDouble() : null;

bool? optBool(Map<String, dynamic> row, String key) =>
    row[key] is bool ? row[key] as bool : null;

String? optString(Map<String, dynamic> row, String key) =>
    row[key] is String ? row[key] as String : null;
