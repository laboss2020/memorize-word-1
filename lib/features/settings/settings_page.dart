import 'dart:convert';
import 'dart:io';

import 'package:drift/drift.dart' show Value;
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:share_plus/share_plus.dart';

import '../../app/providers.dart';
import '../../app/widgets/stepper_tile.dart';
import '../../core/db/app_database.dart' show SettingsCompanion;
import '../../core/sync/export_service.dart';
import '../../core/sync/import_service.dart';
import '../../core/sync/sync_format.dart';

/// 设置页：学习语言 / 每日目标 / 复习提醒。
/// 定级重测（M4）、导出导入与关于（M5）先占位。
class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final settings = ref.watch(settingsProvider).value;

    return Scaffold(
      appBar: AppBar(title: const Text('设置')),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _section(context, '学习'),
                ListTile(
                  title: const Text('学习语言'),
                  subtitle: const Text('切换后从下次学习生效'),
                  trailing: SegmentedButton<String>(
                    segments: const [
                      ButtonSegment(value: 'en', label: Text('英语')),
                      ButtonSegment(value: 'ja', label: Text('日语')),
                    ],
                    selected: {settings.learningLang},
                    onSelectionChanged: (selection) {
                      _update(ref,
                          SettingsCompanion(learningLang: Value(selection.first)));
                    },
                  ),
                ),
                StepperTile(
                  title: '每日新词上限',
                  value: settings.dailyNewLimit,
                  min: 3,
                  max: 50,
                  step: 1,
                  unit: '词',
                  onChanged: (v) =>
                      _update(ref, SettingsCompanion(dailyNewLimit: Value(v))),
                ),
                StepperTile(
                  title: '每日复习上限',
                  value: settings.dailyReviewLimit,
                  min: 10,
                  max: 200,
                  step: 10,
                  unit: '词',
                  onChanged: (v) => _update(
                      ref, SettingsCompanion(dailyReviewLimit: Value(v))),
                ),
                const Divider(height: 32),
                _section(context, '提醒'),
                SwitchListTile(
                  title: const Text('每日复习提醒'),
                  subtitle: const Text('到点发送本地通知'),
                  value: settings.reminderEnabled,
                  onChanged: (v) async {
                    _update(
                        ref, SettingsCompanion(reminderEnabled: Value(v)));
                    if (v) {
                      // Android 13+ / iOS 运行时权限；拒绝则提示去系统设置。
                      final granted = await ref
                          .read(reminderServiceProvider)
                          .requestPermission();
                      if (!granted && context.mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                              content: Text('未获得通知权限，可在系统设置中开启')),
                        );
                      }
                    }
                  },
                ),
                ListTile(
                  title: const Text('提醒时间'),
                  enabled: settings.reminderEnabled,
                  trailing: Text(_fmtTime(settings.reminderTime),
                      style: Theme.of(context).textTheme.titleMedium),
                  onTap: () async {
                    final picked = await showTimePicker(
                      context: context,
                      initialTime: _parseTime(settings.reminderTime),
                    );
                    if (picked != null) {
                      _update(
                        ref,
                        SettingsCompanion(
                            reminderTime:
                                Value('${picked.hour.toString().padLeft(2, '0')}:'
                                    '${picked.minute.toString().padLeft(2, '0')}')),
                      );
                    }
                  },
                ),
                const Divider(height: 32),
                _section(context, '更多'),
                ListTile(
                  leading: const Icon(Icons.quiz_outlined),
                  title: const Text('重新定级测试'),
                  subtitle: const Text('用 1 分钟重新估计你的词汇水平'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/placement'),
                ),
                ListTile(
                  leading: const Icon(Icons.ios_share_outlined),
                  title: const Text('导出数据'),
                  subtitle: const Text('学习进度与设置导出为 JSON 备份'),
                  onTap: () => _exportData(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: const Text('导入数据'),
                  subtitle: const Text('从备份文件恢复（自动先备份当前数据）'),
                  onTap: () => _importData(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: const Text('关于与致谢'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/about'),
                ),
                const SizedBox(height: 24),
              ],
            ),
    );
  }

  void _update(WidgetRef ref, SettingsCompanion patch) {
    ref.read(dbProvider).settingsDao.updateSettings(patch,
        nowMs: DateTime.now().millisecondsSinceEpoch);
  }

  /// 导出：生成备份 → 移动端系统分享 / 桌面端另存为。
  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    // 跨 await 使用 messenger，避免 context 过 async gap。
    final messenger = ScaffoldMessenger.of(context);
    try {
      final db = ref.read(dbProvider);
      final exporter =
          ExportService(db, tempDir: await getTemporaryDirectory());
      final result = await exporter.writeBackupToTemp();
      if (Platform.isAndroid || Platform.isIOS) {
        await SharePlus.instance.share(ShareParams(
          files: [XFile(result.path)],
          fileNameOverrides: [p.basename(result.path)],
        ));
      } else {
        final saved = await FilePicker.saveFile(
          fileName: p.basename(result.path),
          bytes: await File(result.path).readAsBytes(),
          mimeType: 'application/json',
        );
        messenger.showSnackBar(SnackBar(
          content: Text(saved == null ? '已取消' : '已保存到 $saved'),
        ));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导出失败：$e')));
    }
  }

  /// 导入：选文件 → 确认 → 自动备份当前数据 → 恢复。
  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    try {
      final picked = await FilePicker.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['json'],
      );
      if (picked.isEmpty) return;
      final content = await File(picked.single.path!).readAsString();
      final json = jsonDecode(content) as Map<String, dynamic>;
      parseBackupJson(json); // 先校验格式再询问

      if (!context.mounted) return;
      final ok = await showDialog<bool>(
        context: context,
        builder: (dialogContext) => AlertDialog(
          title: const Text('导入备份'),
          content: const Text(
              '将恢复备份中的学习进度与设置：\n'
              '· 相同数据以较新的一方为准\n'
              '· 本地没有的学习记录会被补入\n\n'
              '导入前会自动备份当前数据。'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: const Text('取消'),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: const Text('导入'),
            ),
          ],
        ),
      );
      if (ok != true) return;

      final db = ref.read(dbProvider);
      // 自动备份（失败不阻断导入）。
      try {
        await ExportService(db, tempDir: await getTemporaryDirectory())
            .writeBackupToTemp();
      } catch (_) {}

      final report = await ImportService(db).importJson(json);
      messenger.showSnackBar(SnackBar(
        content: Text(
          '已导入 ${report.applied} 条'
          '${report.skippedUnknownWord > 0 ? '，跳过未知词记录 ${report.skippedUnknownWord} 条' : ''}'
          '${report.skippedStale > 0 ? '，保留本地较新数据 ${report.skippedStale} 条' : ''}',
        ),
      ));
    } on BackupFormatException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text('导入失败：$e')));
    }
  }

  Widget _section(BuildContext context, String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 16, 16, 4),
      child: Text(title,
          style: Theme.of(context)
              .textTheme
              .titleSmall
              ?.copyWith(color: Theme.of(context).colorScheme.primary)),
    );
  }

  TimeOfDay _parseTime(String hhmm) {
    final parts = hhmm.split(':');
    return TimeOfDay(
        hour: int.tryParse(parts[0]) ?? 20, minute: int.tryParse(parts[1]) ?? 0);
  }

  String _fmtTime(String hhmm) {
    final t = _parseTime(hhmm);
    return '${t.hour.toString().padLeft(2, '0')}:${t.minute.toString().padLeft(2, '0')}';
  }
}
