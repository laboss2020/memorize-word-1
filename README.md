# 背单词（memorize_word）

完全离线的英语/日语背单词 App（Android + iOS，Flutter 单代码库）。

需求来源见 [future.txt](future.txt)；二期扩展（AI 对话、云同步、成就系统等）见 [future1.txt](future1.txt)。

## 功能（v1）

- **打开即用**：无登录；引导与定级测试均可跳过
- **科学记忆**：FSRS-5 间隔重复调度，新词 Learning 期会话内步进
- **三种练习模式**：选择题 / 听写（含五十音假名键盘）/ 填空（词形豁免、按掌握度轮换）
- **双词库**：英语 CEFR A1–C2（ECDICT）+ 日语 JLPT N5–N1（JMdict + OpenJLPT），例句来自 Tatoeba；随包离线
- **发音**：系统 TTS（en-US / ja-JP），无网络依赖
- **个性化计划**：每日新词/复习配额可调，主页规则建议卡（回归减半、清复习、加量）
- **统计**：连续打卡、近 30 天柱状图、掌握度环形图、年度热力图、正确率
- **复习提醒**：每日本地通知（可关、可选时间）
- **断点续学**：会话随时退出，队列落库，回来继续
- **数据迁移**：导出/导入 JSON（updatedAt 新者胜；导入前自动备份）
- **AI 对话**：一期占位「即将上线」（`core/ai/ai_service.dart` 已留抽象接口）

## 开发

```bash
flutter pub get
flutter analyze          # 必须 0 issues
flutter test             # 单测 + widget 测试（Windows 建议加 -j 1）
flutter build apk --release
```

### 词库流水线

`tool/pipeline/`：从开源词源生成 `assets/db/seed_v1.sqlite`（幂等，可重跑）。
词库更新 = 重跑流水线 + bump `meta.seed_version`，用户进度不受影响（词 ID 为 uuid5 确定性生成）。

### 图标与启动屏

源图由 `flutter test tool/icon_gen_test.dart` 生成到 `assets/icon/`，然后：

```bash
dart run flutter_launcher_icons
dart run flutter_native_splash:create
```

## CI

`.github/workflows/ci.yml`：ubuntu 跑 analyze + test + APK 构建；macos 跑 `flutter build ios --no-codesign`（Windows 本地无法验证 iOS）。

## 目录结构

```
lib/
├── main.dart            # 初始化 DB → 种子导入 → TTS/通知 → runApp
├── app/                 # 路由（守卫）、主题、壳、全局 provider
├── core/                # db / fsrs / tts / notifications / sync / placement / ai / utils
└── features/            # onboarding home study word_detail library stats settings ai_chat about
tool/pipeline/           # 词库流水线 CLI
tool/icon_gen_test.dart  # 图标生成（widget test 形式）
```

## 许可与致谢

见应用内「设置 → 关于与致谢」。核心数据源：ECDICT（MIT）、JMdict/EDRDG（署名必需）、Tatoeba（CC BY 2.0 FR）、OpenJLPT、FSRS（MIT）。应用完全本地运行，零数据收集。
