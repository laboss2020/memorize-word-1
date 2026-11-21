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
import '../../app/strings.dart';
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
    final s = AppStrings.of(context);

    return Scaffold(
      appBar: AppBar(title: Text(s.navSettings)),
      body: settings == null
          ? const Center(child: CircularProgressIndicator())
          : ListView(
              children: [
                _section(context, s.sectionStudy),
                ListTile(
                  title: Text(s.learningLang),
                  subtitle: Text(s.learningLangSub),
                  trailing: SegmentedButton<String>(
                    segments: [
                      ButtonSegment(
                          value: 'en', label: Text(s.langName('en'))),
                      ButtonSegment(
                          value: 'ja', label: Text(s.langName('ja'))),
                    ],
                    selected: {settings.learningLang},
                    onSelectionChanged: (selection) {
                      _update(ref,
                          SettingsCompanion(learningLang: Value(selection.first)));
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(s.glossLang,
                          style: Theme.of(context).textTheme.bodyLarge),
                      const SizedBox(height: 4),
                      Text(s.glossSubtitle(settings.learningLang),
                          style: Theme.of(context).textTheme.bodySmall),
                      const SizedBox(height: 8),
                      SegmentedButton<String>(
                        segments: _glossSegments(settings.learningLang, s),
                        selected: {settings.glossMode},
                        onSelectionChanged: (selection) {
                          _update(
                              ref,
                              SettingsCompanion(
                                  glossMode: Value(selection.first)));
                        },
                      ),
                    ],
                  ),
                ),
                StepperTile(
                  title: s.dailyNewLimit,
                  value: settings.dailyNewLimit,
                  min: 3,
                  max: 50,
                  step: 1,
                  unit: s.unitWords,
                  onChanged: (v) =>
                      _update(ref, SettingsCompanion(dailyNewLimit: Value(v))),
                ),
                StepperTile(
                  title: s.dailyReviewLimit,
                  value: settings.dailyReviewLimit,
                  min: 10,
                  max: 200,
                  step: 10,
                  unit: s.unitWords,
                  onChanged: (v) => _update(
                      ref, SettingsCompanion(dailyReviewLimit: Value(v))),
                ),
                const Divider(height: 32),
                _section(context, s.sectionReminders),
                SwitchListTile(
                  title: Text(s.dailyReminder),
                  subtitle: Text(s.dailyReminderSub),
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
                          SnackBar(content: Text(s.notifPermissionDenied)),
                        );
                      }
                    }
                  },
                ),
                ListTile(
                  title: Text(s.reminderTime),
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
                _section(context, s.sectionMore),
                ListTile(
                  leading: const Icon(Icons.quiz_outlined),
                  title: Text(s.retestPlacement),
                  subtitle: Text(s.retestPlacementSub),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () => context.push('/placement'),
                ),
                ListTile(
                  leading: const Icon(Icons.ios_share_outlined),
                  title: Text(s.exportData),
                  subtitle: Text(s.exportDataSub),
                  onTap: () => _exportData(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.download_outlined),
                  title: Text(s.importData),
                  subtitle: Text(s.importDataSub),
                  onTap: () => _importData(context, ref),
                ),
                ListTile(
                  leading: const Icon(Icons.info_outline),
                  title: Text(s.aboutCredits),
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

  /// 释义语言选项随学习语言变化：学日语→中文/英文/双语；学英语→中文/日文/双语。
  List<ButtonSegment<String>> _glossSegments(
      String learningLang, AppStrings s) {
    return [
      ButtonSegment(value: 'zh', label: Text(s.chineseName)),
      ButtonSegment(
          value: 'alt', label: Text(s.altGlossName(learningLang))),
      ButtonSegment(
          value: 'both', label: Text(s.glossBothLabel(learningLang))),
    ];
  }

  /// 导出：生成备份 → 移动端系统分享 / 桌面端另存为。
  Future<void> _exportData(BuildContext context, WidgetRef ref) async {
    // 跨 await 使用 messenger，避免 context 过 async gap。
    final messenger = ScaffoldMessenger.of(context);
    final s = AppStrings.of(context);
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
          content: Text(saved == null ? s.cancelled : s.savedTo(saved)),
        ));
      }
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(s.exportFailed(e))));
    }
  }

  /// 导入：选文件 → 确认 → 自动备份当前数据 → 恢复。
  Future<void> _importData(BuildContext context, WidgetRef ref) async {
    final messenger = ScaffoldMessenger.of(context);
    final s = AppStrings.of(context);
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
          title: Text(s.importBackupTitle),
          content: Text(s.importBackupBody),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext, false),
              child: Text(s.cancel),
            ),
            FilledButton(
              onPressed: () => Navigator.pop(dialogContext, true),
              child: Text(s.importBtn),
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
        content: Text(s.importDone(
          report.applied,
          report.skippedUnknownWord,
          report.skippedStale,
        )),
      ));
    } on BackupFormatException catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(e.message)));
    } catch (e) {
      messenger.showSnackBar(SnackBar(content: Text(s.importFailed(e))));
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
