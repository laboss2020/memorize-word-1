/// 系统 TTS 封装：语言映射、失败降级（无语音包时静默失败并回调）。
library;

import 'package:flutter_tts/flutter_tts.dart';

/// 学习语言 → TTS 语言代码。
const ttsLanguageCodes = {'en': 'en-US', 'ja': 'ja-JP'};

class TtsService {
  TtsService({FlutterTts? engine}) : _engine = engine ?? FlutterTts();

  final FlutterTts _engine;
  bool _initialized = false;

  Future<void> _ensureInit() async {
    if (_initialized) return;
    await _engine.setSharedInstance(true);
    _initialized = true;
  }

  /// 播报单词/例句。语言不支持时返回 false（UI 可提示安装语音包）。
  Future<bool> speak(String text, {required String language}) async {
    await _ensureInit();
    final code = ttsLanguageCodes[language] ?? language;
    try {
      final available = await _engine.isLanguageAvailable(code);
      if (available != true) return false;
      await _engine.setLanguage(code);
      await _engine.setSpeechRate(0.45); // 稍慢，便于跟读
      await _engine.speak(text);
      return true;
    } catch (_) {
      return false;
    }
  }

  Future<void> stop() async {
    try {
      await _engine.stop();
    } catch (_) {}
  }
}
