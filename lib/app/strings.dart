/// 应用界面文案（中/英/日，手写无 codegen）。
///
/// 用法：`AppStrings.of(context).xxx`；中文为默认回退（未支持语言/测试环境）。
/// 诊断性错误信息（BackupFormatException 等）不在本类中，保留中文。
library;

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class AppStrings {
  AppStrings(this.localeName);

  /// BCP-47 语言代码（zh/en/ja）。
  final String localeName;

  static AppStrings of(BuildContext context) =>
      Localizations.of<AppStrings>(context, AppStrings) ?? AppStrings('zh');

  static const delegate = _AppStringsDelegate();

  bool get _isEn => localeName == 'en';
  bool get _isJa => localeName == 'ja';

  // ---- 通用 ----

  String get appName => switch (localeName) {
        'en' => 'Memorize Words',
        'ja' => '単語学習',
        _ => '背单词',
      };

  String get startupError => switch (localeName) {
        'en' => 'Startup failed, please restart the app',
        'ja' => '起動に失敗しました。アプリを再起動してください',
        _ => '启动失败，请重启应用',
      };

  String get cancel => switch (localeName) {
        'en' => 'Cancel',
        'ja' => 'キャンセル',
        _ => '取消',
      };

  String get retry => switch (localeName) {
        'en' => 'Retry',
        'ja' => '再試行',
        _ => '重试',
      };

  String get skip => switch (localeName) {
        'en' => 'Skip',
        'ja' => 'スキップ',
        _ => '跳过',
      };

  String get hint => switch (localeName) {
        'en' => 'Hint',
        'ja' => 'ヒント',
        _ => '提示',
      };

  String get submit => switch (localeName) {
        'en' => 'Submit',
        'ja' => '提出',
        _ => '提交',
      };

  String get comingSoon => switch (localeName) {
        'en' => 'Coming soon',
        'ja' => '近日公開',
        _ => '即将上线',
      };

  String get loadFailed => switch (localeName) {
        'en' => 'Failed to load',
        'ja' => '読み込みに失敗しました',
        _ => '加载失败',
      };

  /// 学习语言 → 本地化名称。
  String langName(String learningLang) => switch (localeName) {
        'en' => learningLang == 'ja' ? 'Japanese' : 'English',
        'ja' => learningLang == 'ja' ? '日本語' : '英語',
        _ => learningLang == 'ja' ? '日语' : '英语',
      };

  /// 释义语言选项中的辅助语言名（学日语→英文，学英语→日文）。
  String altGlossName(String learningLang) => switch (localeName) {
        'en' => learningLang == 'ja' ? 'English' : 'Japanese',
        'ja' => learningLang == 'ja' ? '英語' : '日本語',
        _ => learningLang == 'ja' ? '英文' : '日文',
      };

  /// 界面语言下「中文」的名称。
  String get chineseName => switch (localeName) {
        'en' => 'Chinese',
        'ja' => '中国語',
        _ => '中文',
      };

  // ---- 主壳 / 主页 ----

  String get navHome => switch (localeName) {
        'en' => 'Home',
        'ja' => 'ホーム',
        _ => '主页',
      };

  String get navLibrary => switch (localeName) {
        'en' => 'Library',
        'ja' => '単語帳',
        _ => '词库',
      };

  String get navStats => switch (localeName) {
        'en' => 'Stats',
        'ja' => '統計',
        _ => '统计',
      };

  String get navSettings => switch (localeName) {
        'en' => 'Settings',
        'ja' => '設定',
        _ => '设置',
      };

  String get fallbackDeckName => switch (localeName) {
        'en' => 'Deck',
        'ja' => '単語帳',
        _ => '词书',
      };

  String todayMotivation(String learningLang) => switch (localeName) {
        'en' => learningLang == 'ja'
            ? "Let's learn some Japanese today"
            : "Let's learn some English today",
        'ja' =>
            learningLang == 'ja' ? '今日も日本語を学びましょう' : '今日も英語を学びましょう',
        _ => learningLang == 'ja' ? '今天也来学点日语吧' : '今天也来学点英语吧',
      };

  String streakDays(int n) => switch (localeName) {
        'en' => '$n days',
        'ja' => '$n日',
        _ => '$n 天',
      };

  String get todayTask => switch (localeName) {
        'en' => "Today's Task",
        'ja' => '今日のタスク',
        _ => '今日任务',
      };

  String get toReview => switch (localeName) {
        'en' => 'To review',
        'ja' => '復習待ち',
        _ => '待复习',
      };

  String get newWords => switch (localeName) {
        'en' => 'New',
        'ja' => '新規',
        _ => '新词',
      };

  String continueStudy(int done) => switch (localeName) {
        'en' => 'Continue ($done done)',
        'ja' => '学習を続ける（$done 完了）',
        _ => '继续学习 ($done 已完成)',
      };

  String get startStudy => switch (localeName) {
        'en' => 'Start Studying',
        'ja' => '学習を始める',
        _ => '开始学习',
      };

  String get allDoneToday => switch (localeName) {
        'en' => 'All done for today',
        'ja' => '今日のタスクは完了',
        _ => '今日任务已完成',
      };

  String get aiPractice => switch (localeName) {
        'en' => 'AI Chat Practice',
        'ja' => 'AI会話練習',
        _ => 'AI 对话练习',
      };

  String get aiPracticeSub => switch (localeName) {
        'en' => 'Chat with AI using your new words',
        'ja' => '新しい単語でAIと会話しよう',
        _ => '用新学的单词和 AI 聊天',
      };

  // ---- 建议卡（SuggestionEngine） ----

  String get suggestionWelcomeBack => switch (localeName) {
        'en' => 'Welcome Back',
        'ja' => 'おかえりなさい',
        _ => '欢迎回来',
      };

  String suggestionComebackBody(int absent, int half) => switch (localeName) {
        'en' =>
          "You've been away $absent days. Try lowering your review limit to "
              '$half to ease back in.',
        'ja' => '$absent日ぶりです。復習上限を$halfに下げて、無理なく再開しましょう。',
        _ => '休息了 $absent 天，建议把复习上限降到 $half，轻松找回节奏。',
      };

  String get suggestionHalveReviews => switch (localeName) {
        'en' => 'Halve Reviews',
        'ja' => '復習を半分に',
        _ => '复习减半',
      };

  String get suggestionBacklog => switch (localeName) {
        'en' => 'Reviews Piling Up',
        'ja' => '復習がたまっています',
        _ => '复习积压了',
      };

  String suggestionBacklogBody(int due) => switch (localeName) {
        'en' =>
          '$due words are due for review. Clear reviews before learning new '
              'words for better efficiency.',
        'ja' => '$due個の単語が復習待ちです。先に復習を片付けると効率的です。',
        _ => '有 $due 个单词等着复习，先清复习再学新词效率更高。',
      };

  String get suggestionGoodShape => switch (localeName) {
        'en' => 'On a Roll',
        'ja' => '調子がいい',
        _ => '状态不错',
      };

  String suggestionScaleUpBody(int streak, int accuracy) =>
      switch (localeName) {
        'en' =>
          '$streak-day streak with $accuracy% accuracy. '
              'Time to increase your load.',
        'ja' => '$streak日連続で学習し、正答率$accuracy%。少し負荷を上げてもよいでしょう。',
        _ => '连续 $streak 天打卡，正确率 $accuracy%，可以适当加量。',
      };

  String get suggestionNewPlus5 => switch (localeName) {
        'en' => 'New +5',
        'ja' => '新規 +5',
        _ => '新词 +5',
      };

  // ---- 学习页 ----

  String get sessionComplete => switch (localeName) {
        'en' => 'Session Complete',
        'ja' => '今回の完了',
        _ => '本次完成',
      };

  String get studyTitle => switch (localeName) {
        'en' => 'Study',
        'ja' => '学習',
        _ => '学习',
      };

  String get newWordLabel => switch (localeName) {
        'en' => 'New Word',
        'ja' => '新規単語',
        _ => '新词',
      };

  String get previousBtn => switch (localeName) {
        'en' => 'Previous',
        'ja' => '前へ',
        _ => '上一个',
      };

  String get gotItContinue => switch (localeName) {
        'en' => 'Got it, continue',
        'ja' => '覚えた、次へ',
        _ => '记住了，继续',
      };

  String get replayContinue => switch (localeName) {
        'en' => 'Continue',
        'ja' => '続ける',
        _ => '继 续',
      };

  String get pickMeaning => switch (localeName) {
        'en' => 'Choose the meaning',
        'ja' => '正しい意味を選ぼう',
        _ => '选出正确释义',
      };

  String get dictationPrompt => switch (localeName) {
        'en' => 'Dictation: listen and spell',
        'ja' => 'ディクテーション：音を聞いて綴ろう',
        _ => '听写：听发音拼写单词',
      };

  String get tapToReplay => switch (localeName) {
        'en' => 'Tap to replay',
        'ja' => 'もう一度聞く',
        _ => '点击重听',
      };

  String get inputJaReading => switch (localeName) {
        'en' => 'Input reading (kana/romaji)',
        'ja' => '読みを入力（かな/ローマ字）',
        _ => '输入读音（假名/罗马字）',
      };

  String get inputSpelling => switch (localeName) {
        'en' => 'Type the spelling',
        'ja' => '綴りを入力',
        _ => '输入拼写',
      };

  String get inputMissingWord => switch (localeName) {
        'en' => 'Type the missing word',
        'ja' => '欠けた単語を入力',
        _ => '输入缺失的词',
      };

  String hintText(String target) => switch (localeName) {
        'en' => 'Hint: $target',
        'ja' => 'ヒント：$target',
        _ => '提示：$target',
      };

  String get clozePrompt => switch (localeName) {
        'en' => 'Cloze: fill in the missing word',
        'ja' => '空欄補充：欠けた単語を入れよう',
        _ => '填空：补全句中缺失的词',
      };

  String get repracticedCorrect => switch (localeName) {
        'en' => 'Retry passed ✓',
        'ja' => '再練習クリア ✓',
        _ => '重练通过 ✓',
      };

  String get answerCorrect => switch (localeName) {
        'en' => 'Correct ✓',
        'ja' => '正解 ✓',
        _ => '回答正确 ✓',
      };

  String correctAnswer(String answer) => switch (localeName) {
        'en' => 'Correct answer: $answer',
        'ja' => '正解：$answer',
        _ => '正确答案：$answer',
      };

  String get nextQuestion => switch (localeName) {
        'en' => 'Next',
        'ja' => '次の問題',
        _ => '下一题',
      };

  String firstTryAccuracy(int accuracy) => switch (localeName) {
        'en' => 'First-try accuracy $accuracy%',
        'ja' => '初回正答率 $accuracy%',
        _ => '首答正确率 $accuracy%',
      };

  String completedN(int n) => switch (localeName) {
        'en' => 'Completed $n items',
        'ja' => '$n項目を完了',
        _ => '完成 $n 项',
      };

  String get backHome => switch (localeName) {
        'en' => 'Back to Home',
        'ja' => 'ホームへ戻る',
        _ => '返回主页',
      };

  // ---- 设置页 ----

  String get sectionStudy => switch (localeName) {
        'en' => 'Learning',
        'ja' => '学習',
        _ => '学习',
      };

  String get uiLang => switch (localeName) {
        'en' => 'App Language',
        'ja' => '表示言語',
        _ => '界面语言',
      };

  String get uiLangSystem => switch (localeName) {
        'en' => 'Follow system',
        'ja' => 'システムに従う',
        _ => '跟随系统',
      };

  String get learningLang => switch (localeName) {
        'en' => 'Learning Language',
        'ja' => '学習言語',
        _ => '学习语言',
      };

  String get learningLangSub => switch (localeName) {
        'en' => 'Takes effect from the next session',
        'ja' => '次回の学習から反映されます',
        _ => '切换后从下次学习生效',
      };

  String get glossLang => switch (localeName) {
        'en' => 'Gloss Language',
        'ja' => '訳語の言語',
        _ => '释义语言',
      };

  String glossSubtitle(String learningLang) {
    final alt = altGlossName(learningLang);
    return switch (localeName) {
      'en' => 'Glosses & example translations: Chinese / $alt / Both',
      'ja' => '訳語と例文訳の表示：中国語 / $alt / 両方',
      _ => '单词释义与例句翻译显示：中文 / $alt / 双语',
    };
  }

  /// 双语选项标签（前缀为界面语言下的「中文」）。
  String glossBothLabel(String learningLang) => switch (localeName) {
        'en' => 'Chinese + ${altGlossName(learningLang)}',
        'ja' => '中国語＋${altGlossName(learningLang)}',
        _ => '中${altGlossName(learningLang)}双语',
      };

  String get dailyNewLimit => switch (localeName) {
        'en' => 'Daily New Words',
        'ja' => '1日の新規単語',
        _ => '每日新词上限',
      };

  String get dailyReviewLimit => switch (localeName) {
        'en' => 'Daily Review Limit',
        'ja' => '1日の復習上限',
        _ => '每日复习上限',
      };

  String get unitWords => switch (localeName) {
        'en' => 'words',
        'ja' => '語',
        _ => '词',
      };

  String get sectionReminders => switch (localeName) {
        'en' => 'Reminders',
        'ja' => 'リマインダー',
        _ => '提醒',
      };

  String get dailyReminder => switch (localeName) {
        'en' => 'Daily Review Reminder',
        'ja' => '毎日の復習リマインダー',
        _ => '每日复习提醒',
      };

  String get dailyReminderSub => switch (localeName) {
        'en' => 'Sends a local notification at the set time',
        'ja' => '設定時刻にローカル通知を送ります',
        _ => '到点发送本地通知',
      };

  String get notifPermissionDenied => switch (localeName) {
        'en' => 'Notification permission denied. Enable it in system settings',
        'ja' => '通知が許可されていません。端末の設定で有効にできます',
        _ => '未获得通知权限，可在系统设置中开启',
      };

  String get reminderTime => switch (localeName) {
        'en' => 'Reminder Time',
        'ja' => 'リマインダー時刻',
        _ => '提醒时间',
      };

  String get sectionMore => switch (localeName) {
        'en' => 'More',
        'ja' => 'その他',
        _ => '更多',
      };

  String get retestPlacement => switch (localeName) {
        'en' => 'Retake Placement Test',
        'ja' => 'レベル再診断',
        _ => '重新定级测试',
      };

  String get retestPlacementSub => switch (localeName) {
        'en' => 'Re-estimate your level in 1 minute',
        'ja' => '1分で語彙レベルを再判定します',
        _ => '用 1 分钟重新估计你的词汇水平',
      };

  String get exportData => switch (localeName) {
        'en' => 'Export Data',
        'ja' => 'データのエクスポート',
        _ => '导出数据',
      };

  String get exportDataSub => switch (localeName) {
        'en' => 'Export progress & settings as JSON backup',
        'ja' => '学習状況と設定をJSONでバックアップ',
        _ => '学习进度与设置导出为 JSON 备份',
      };

  String get importData => switch (localeName) {
        'en' => 'Import Data',
        'ja' => 'データのインポート',
        _ => '导入数据',
      };

  String get importDataSub => switch (localeName) {
        'en' => 'Restore from backup (auto-backs up current data first)',
        'ja' => 'バックアップから復元（先に現状を自動バックアップ）',
        _ => '从备份文件恢复（自动先备份当前数据）',
      };

  String get aboutCredits => switch (localeName) {
        'en' => 'About & Credits',
        'ja' => 'このアプリについて',
        _ => '关于与致谢',
      };

  String get cancelled => switch (localeName) {
        'en' => 'Cancelled',
        'ja' => 'キャンセルしました',
        _ => '已取消',
      };

  String savedTo(String path) => switch (localeName) {
        'en' => 'Saved to $path',
        'ja' => '$path に保存しました',
        _ => '已保存到 $path',
      };

  String exportFailed(Object error) => switch (localeName) {
        'en' => 'Export failed: $error',
        'ja' => 'エクスポートに失敗しました：$error',
        _ => '导出失败：$error',
      };

  String get importBackupTitle => switch (localeName) {
        'en' => 'Import Backup',
        'ja' => 'バックアップのインポート',
        _ => '导入备份',
      };

  String get importBackupBody => switch (localeName) {
        'en' => 'Restores progress and settings from the backup:\n'
            '· For the same records, the newer side wins\n'
            '· Records missing locally will be added\n\n'
            'Your current data is backed up automatically before importing.',
        'ja' => 'バックアップから学習状況と設定を復元します：\n'
            '· 同一データは新しい方を優先\n'
            '· 端末にない学習記録は取り込みます\n\n'
            'インポート前に現在のデータを自動バックアップします。',
        _ => '将恢复备份中的学习进度与设置：\n'
            '· 相同数据以较新的一方为准\n'
            '· 本地没有的学习记录会被补入\n\n'
            '导入前会自动备份当前数据。',
      };

  String get importBtn => switch (localeName) {
        'en' => 'Import',
        'ja' => 'インポート',
        _ => '导入',
      };

  String importDone(int applied, int unknown, int stale) {
    final extra = [
      if (unknown > 0)
        switch (localeName) {
          'en' => 'skipped $unknown unknown-word records',
          'ja' => '未知の単語の記録$unknown件をスキップ',
          _ => '跳过未知词记录 $unknown 条',
        },
      if (stale > 0)
        switch (localeName) {
          'en' => 'kept $stale newer local records',
          'ja' => 'ローカルの新しいデータ$stale件を維持',
          _ => '保留本地较新数据 $stale 条',
        },
    ];
    final head = switch (localeName) {
      'en' => 'Imported $applied records',
      'ja' => '$applied件をインポートしました',
      _ => '已导入 $applied 条',
    };
    final sep = switch (localeName) {
      'en' => ', ',
      'ja' => '、',
      _ => '，',
    };
    return extra.isEmpty ? head : '$head$sep${extra.join(sep)}';
  }

  String importFailed(Object error) => switch (localeName) {
        'en' => 'Import failed: $error',
        'ja' => 'インポートに失敗しました：$error',
        _ => '导入失败：$error',
      };

  // ---- 引导页 ----

  String get intro1Title => switch (localeName) {
        'en' => 'Science-based Learning',
        'ja' => '科学的な単語学習',
        _ => '科学记单词',
      };

  String get intro1Desc => switch (localeName) {
        'en' =>
          'Spaced repetition (FSRS) schedules every review right before '
              'you forget.',
        'ja' => '間隔反復（FSRS）が忘れかけのタイミングで復習を配置します。',
        _ => '间隔重复（FSRS）自动安排每次复习，在快忘记的时候提醒你。',
      };

  String get intro2Title => switch (localeName) {
        'en' => 'Three Practice Modes',
        'ja' => '3つの練習モード',
        _ => '三种练习模式',
      };

  String get intro2Desc => switch (localeName) {
        'en' =>
          'Multiple choice, dictation and cloze to reinforce memory from '
              'every angle.',
        'ja' => '選択肢・ディクテーション・空欄補充で多角的に記憶を固めます。',
        _ => '选择题认词、听写拼词、例句填空，多角度巩固记忆。',
      };

  String get intro3Title => switch (localeName) {
        'en' => 'Fully Offline',
        'ja' => '完全オフライン',
        _ => '完全离线',
      };

  String get intro3Desc => switch (localeName) {
        'en' => 'All data stays on your device. No account needed.',
        'ja' => '単語データも学習記録も端末内に保存。登録不要です。',
        _ => '词库与学习数据全部保存在本地，无需注册，随时可用。',
      };

  String get nextStep => switch (localeName) {
        'en' => 'Next',
        'ja' => '次へ',
        _ => '下一步',
      };

  String get getStarted => switch (localeName) {
        'en' => 'Get Started',
        'ja' => 'はじめる',
        _ => '开始使用',
      };

  String get chooseLearningLang => switch (localeName) {
        'en' => 'Choose a Language',
        'ja' => '学習言語を選択',
        _ => '选择学习语言',
      };

  String get startPlacement => switch (localeName) {
        'en' => 'Take the placement test (~1 min)',
        'ja' => 'レベル診断テスト開始（約1分）',
        _ => '开始定级测试（约 1 分钟）',
      };

  String get skipTestFromBeginner => switch (localeName) {
        'en' => 'Skip the test, start from beginner',
        'ja' => 'テストをスキップして入門から',
        _ => '跳过测试，从入门级开始',
      };

  String placementTitle(String level) => switch (localeName) {
        'en' => 'Placement · $level',
        'ja' => 'レベル診断 · $level',
        _ => '定级测试 · $level',
      };

  String pickMeaningN(int n) => switch (localeName) {
        'en' => 'Choose the meaning (Q$n)',
        'ja' => '正しい意味を選ぼう（第$n問）',
        _ => '选出正确释义（第 $n 题）',
      };

  String get placementResult => switch (localeName) {
        'en' => 'Placement Result',
        'ja' => '診断結果',
        _ => '定级结果',
      };

  String suggestedStart(String level) => switch (localeName) {
        'en' => 'Suggested starting point: $level',
        'ja' => '「$level」から始めるのがおすすめ',
        _ => '建议从「$level」开始',
      };

  String get resultFootnote => switch (localeName) {
        'en' => 'You can retake the test or adjust daily goals in Settings.',
        'ja' => '設定から再診断や目標の変更ができます。',
        _ => '之后可在设置中重新测试，或调整每日目标。',
      };

  String get startWithThis => switch (localeName) {
        'en' => 'Start Here',
        'ja' => 'これではじめる',
        _ => '就这样开始',
      };

  String get retest => switch (localeName) {
        'en' => 'Retake',
        'ja' => 'もう一度',
        _ => '重新测试',
      };

  String get dailyGoal => switch (localeName) {
        'en' => 'Daily Goals',
        'ja' => '1日の目標',
        _ => '每日目标',
      };

  String get dailyNew => switch (localeName) {
        'en' => 'New words per day',
        'ja' => '1日の新規単語',
        _ => '每天学新词',
      };

  String get dailyReview => switch (localeName) {
        'en' => 'Review limit per day',
        'ja' => '1日の復習上限',
        _ => '每天复习上限',
      };

  String get finishStart => switch (localeName) {
        'en' => 'Done, start learning',
        'ja' => '完了、学習を始める',
        _ => '完成，开始学习',
      };

  /// 档位展示名（zh 带前缀修饰，en/ja 直接用档位代码）。
  String levelName(String level) {
    if (!_isEn && !_isJa) {
      const cefrNames = {
        'A1': '入门 A1', 'A2': '基础 A2', 'B1': '进阶 B1',
        'B2': '中高 B2', 'C1': '高级 C1', 'C2': '精通 C2',
      };
      const jlptNames = {
        'N5': '入门 N5', 'N4': '基础 N4', 'N3': '进阶 N3',
        'N2': '中高 N2', 'N1': '精通 N1',
      };
      return cefrNames[level] ?? jlptNames[level] ?? level;
    }
    return level;
  }

  // ---- 统计页 ----

  String get streakDaysLabel => switch (localeName) {
        'en' => 'Day Streak',
        'ja' => '連続学習（日）',
        _ => '连续打卡（天）',
      };

  String get todayDone => switch (localeName) {
        'en' => 'Done Today',
        'ja' => '今日の完了',
        _ => '今日完成',
      };

  String get todayAccuracy => switch (localeName) {
        'en' => 'Accuracy Today',
        'ja' => '今日の正答率',
        _ => '今日正确率',
      };

  String get totalHours => switch (localeName) {
        'en' => 'Total Hours',
        'ja' => '累計学習（時間）',
        _ => '累计学习（小时）',
      };

  String get last30Volume => switch (localeName) {
        'en' => 'Last 30 Days',
        'ja' => '直近30日の学習量',
        _ => '近 30 天学习量',
      };

  String get last30Accuracy => switch (localeName) {
        'en' => '30-day Accuracy (%)',
        'ja' => '直近30日の正答率（%）',
        _ => '近 30 天正确率（%）',
      };

  String get noRecordsYet => switch (localeName) {
        'en' => 'No study records yet',
        'ja' => '学習記録はまだありません',
        _ => '还没有学习记录',
      };

  String get masteryDist => switch (localeName) {
        'en' => 'Mastery Distribution',
        'ja' => '習熟度の分布',
        _ => '掌握度分布',
      };

  String get noData => switch (localeName) {
        'en' => 'No data',
        'ja' => 'データなし',
        _ => '暂无数据',
      };

  List<String> get masteryLabels => switch (localeName) {
        'en' => const ['New', 'Learning', 'Consolidating', 'Mastered'],
        'ja' => const ['未学習', '学習中', '定着中', '習得済'],
        _ => const ['未学', '学习中', '巩固中', '已掌握'],
      };

  String get last365Heatmap => switch (localeName) {
        'en' => 'Yearly Heatmap',
        'ja' => '直近1年のヒートマップ',
        _ => '近一年热力图',
      };

  String heatmapTooltip(int month, int day, int count) => switch (localeName) {
        'en' => '$month/$day: $count items',
        'ja' => '$month/$day：$count件',
        _ => '$month/$day：$count 项',
      };

  // ---- 关于页 ----

  String get aboutIntro => switch (localeName) {
        'en' => 'A fully offline spaced-repetition vocabulary app. '
            'All study data stays on your device — no servers, '
            'no data collection.',
        'ja' => '完全オフラインの間隔反復型単語学習アプリ。'
            '学習データはすべて端末内に保存され、サーバーもデータ収集もありません。',
        _ => '一个完全离线的间隔重复记单词应用。'
            '所有学习数据仅保存在你的设备上，我们没有任何服务器，不收集任何数据。',
      };

  String get creditsTitle => switch (localeName) {
        'en' => 'Open-source Credits',
        'ja' => 'オープンソース謝辞',
        _ => '开源致谢',
      };

  String get fsrsDesc => switch (localeName) {
        'en' => 'FSRS-5 spaced repetition algorithm powering review scheduling.',
        'ja' => 'FSRS-5間隔反復アルゴリズム（復習スケジューリング）。',
        _ => 'FSRS-5 间隔重复算法，驱动复习调度。',
      };

  String get ecdictDesc => switch (localeName) {
        'en' => 'English–Chinese dictionary data '
            '(headwords, IPA, definitions, POS, frequency).',
        'ja' => '英中辞典データ（見出し・発音・語義・品詞・頻度）。',
        _ => '英汉字典数据（词头、音标、释义、词性、词频）。',
      };

  String get jmdictDesc => switch (localeName) {
        'en' => 'Japanese dictionary data. This app is a derivative work and '
            'attributes it under the EDRDG licence: '
            'dictionary data provided by JMdict/EDRDG.',
        'ja' => '日本語辞書データ。本アプリはその派生物であり、EDRDGライセンスに基づき'
            '次の通り表記します：dictionary data provided by JMdict/EDRDG。',
        _ => '日语词典数据。本应用是其衍生作品，依据 EDRDG 许可协议声明署名：'
            'dictionary data provided by JMdict/EDRDG。',
      };

  String get tatoebaDesc => switch (localeName) {
        'en' => 'Example sentence data (tatoeba.org).',
        'ja' => '例文データ（tatoeba.org）。',
        _ => '例句数据（tatoeba.org）。',
      };

  String get openjlptName => switch (localeName) {
        'en' => 'OpenJLPT / JLPT word lists',
        'ja' => 'OpenJLPT / JLPT 語彙リスト',
        _ => 'OpenJLPT / JLPT 词表',
      };

  String get openjlptDesc => switch (localeName) {
        'en' => 'JLPT level classification for Japanese vocabulary.',
        'ja' => '日本語語彙のJLPTレベル分類。',
        _ => '日语词汇 JLPT 等级划分。',
      };

  String get openjlptLicense => switch (localeName) {
        'en' => 'See license notes in the project repository',
        'ja' => 'リポジトリ内のライセンス記載を参照',
        _ => '见项目仓库许可说明',
      };

  String get flutterCreditName => switch (localeName) {
        'en' => 'Flutter and all open-source packages',
        'ja' => 'Flutterとオープンソース依存パッケージ',
        _ => 'Flutter 及全部开源依赖包',
      };

  String get flutterLicense => switch (localeName) {
        'en' => 'Each under its own license',
        'ja' => '各々のライセンスに従う',
        _ => '各依其许可',
      };

  String get flutterDesc =>
      'drift、flutter_riverpod、go_router、fl_chart、'
      'flutter_tts、flutter_local_notifications 等。';

  String get aboutFooter => switch (localeName) {
        'en' => 'The above data is only used to build the offline dictionary; '
            'all processing happens locally.',
        'ja' => '上記データはオフライン辞書の構築のみに使用し、処理はすべて端末内で行われます。',
        _ => '以上数据仅用于构建离线词库，所有处理均在本机完成。',
      };

  // ---- 词详情 ----

  String get examples => switch (localeName) {
        'en' => 'Examples',
        'ja' => '例文',
        _ => '例句',
      };

  String get studyRecords => switch (localeName) {
        'en' => 'Study History',
        'ja' => '学習履歴',
        _ => '学习记录',
      };

  String get noStudyRecords => switch (localeName) {
        'en' => 'No study history yet',
        'ja' => '学習履歴はまだありません',
        _ => '还没有学习记录',
      };

  /// 模式 → 显示名。
  String modeName(String mode) => switch (mode) {
        'new_card' => switch (localeName) {
            'en' => 'New Word',
            'ja' => '新規学習',
            _ => '新词学习',
          },
        'choice' => switch (localeName) {
            'en' => 'Multiple Choice',
            'ja' => '選択問題',
            _ => '选择题',
          },
        'dictation' => switch (localeName) {
            'en' => 'Dictation',
            'ja' => 'ディクテーション',
            _ => '听写',
          },
        'cloze' => switch (localeName) {
            'en' => 'Cloze',
            'ja' => '空欄補充',
            _ => '填空',
          },
        'placement' => switch (localeName) {
            'en' => 'Placement Test',
            'ja' => 'レベル診断',
            _ => '定级测试',
          },
        _ => mode,
      };

  String stateName(int state) => switch (localeName) {
        'en' => switch (state) {
            1 => 'Learning',
            2 => 'Reviewing',
            _ => 'Relearning',
          },
        'ja' => switch (state) { 1 => '学習中', 2 => '復習中', _ => '再学習中' },
        _ => switch (state) { 1 => '学习中', 2 => '复习中', _ => '重学中' },
      };

  String get statusLabel => switch (localeName) {
        'en' => 'State',
        'ja' => '状態',
        _ => '状态',
      };

  String get repsLabel => switch (localeName) {
        'en' => 'Reviews',
        'ja' => '復習回数',
        _ => '复习次数',
      };

  String get lapsesLabel => switch (localeName) {
        'en' => 'Lapses',
        'ja' => '忘却回数',
        _ => '遗忘次数',
      };

  String get nextLabel => switch (localeName) {
        'en' => 'Next',
        'ja' => '次回',
        _ => '下次',
      };

  String get dueNow => switch (localeName) {
        'en' => 'Due now',
        'ja' => '期限切れ',
        _ => '已到期',
      };

  String dueInDays(int days) => switch (localeName) {
        'en' => 'Review in $days days',
        'ja' => '$days日後に復習',
        _ => '$days 天后复习',
      };

  // ---- AI 对话 / 词库 ----

  String get aiChatTitle => switch (localeName) {
        'en' => 'AI Chat',
        'ja' => 'AI会話',
        _ => 'AI 对话',
      };

  String get aiChatSoonDesc => switch (localeName) {
        'en' => 'Practice chatting with AI using new words (planned)',
        'ja' => '新しい単語でAIと会話練習（計画中）',
        _ => '用新学的单词和 AI 对话练习（规划中）',
      };

  String libraryTitle(String learningLang) => switch (localeName) {
        'en' => 'Library · ${learningLang == 'ja' ? 'Japanese' : 'English'}',
        'ja' => '単語帳 · ${learningLang == 'ja' ? '日本語' : '英語'}',
        _ => '词库 · ${learningLang == 'ja' ? '日语' : '英语'}',
      };

  String loadFailedWith(Object error) => switch (localeName) {
        'en' => 'Failed to load: $error',
        'ja' => '読み込みに失敗しました: $error',
        _ => '加载失败: $error',
      };

  // ---- 通知（无 BuildContext：按平台语言取） ----

  String get reminderBody => switch (localeName) {
        'en' => 'Your reviews are ready — take a few minutes to practice.',
        'ja' => '今日の復習の準備ができています。少しの時間で復習しましょう。',
        _ => '今天的复习安排好了，花几分钟巩固一下吧。',
      };

  String get reminderChannelName => switch (localeName) {
        'en' => 'Daily Review Reminder',
        'ja' => '毎日の復習リマインダー',
        _ => '每日复习提醒',
      };

  String get reminderChannelDesc => switch (localeName) {
        'en' => 'Daily reminder to review words',
        'ja' => '毎日定時に単語の復習を促します',
        _ => '每天固定时间提醒复习单词',
      };
}

class _AppStringsDelegate extends LocalizationsDelegate<AppStrings> {
  const _AppStringsDelegate();

  @override
  bool isSupported(Locale locale) =>
      const ['zh', 'en', 'ja'].contains(locale.languageCode);

  @override
  Future<AppStrings> load(Locale locale) =>
      SynchronousFuture<AppStrings>(AppStrings(locale.languageCode));

  @override
  bool shouldReload(_AppStringsDelegate old) => false;
}
