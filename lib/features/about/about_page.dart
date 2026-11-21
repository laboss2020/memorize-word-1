import 'package:flutter/material.dart';

import '../../app/strings.dart';

/// 关于与致谢：隐私声明 + 词库/算法开源致谢（许可合规必需）。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final s = AppStrings.of(context);
    return Scaffold(
      appBar: AppBar(title: Text(s.aboutCredits)),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('${s.appName} v1.0.0', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(s.aboutIntro, style: textTheme.bodyMedium),
          const Divider(height: 32),
          Text(s.creditsTitle, style: textTheme.titleMedium),
          const SizedBox(height: 8),
          _Credit(
            name: 'FSRS（open-spaced-repetition/fsrs-dart）',
            license: 'MIT License',
            desc: s.fsrsDesc,
          ),
          _Credit(
            name: 'ECDICT',
            license: 'MIT License',
            desc: s.ecdictDesc,
          ),
          _Credit(
            name: 'JMdict / JMnedict（EDRDG）',
            license: 'Electronic Dictionary Research and Development Group',
            desc: s.jmdictDesc,
          ),
          _Credit(
            name: 'Tatoeba',
            license: 'CC BY 2.0 FR',
            desc: s.tatoebaDesc,
          ),
          _Credit(
            name: s.openjlptName,
            license: s.openjlptLicense,
            desc: s.openjlptDesc,
          ),
          _Credit(
            name: s.flutterCreditName,
            license: s.flutterLicense,
            desc: s.flutterDesc,
          ),
          const SizedBox(height: 24),
          Text(s.aboutFooter, style: textTheme.bodySmall),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}

class _Credit extends StatelessWidget {
  const _Credit({
    required this.name,
    required this.license,
    required this.desc,
  });

  final String name;
  final String license;
  final String desc;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(name, style: textTheme.bodyLarge),
          Text('$license · $desc', style: textTheme.bodySmall),
        ],
      ),
    );
  }
}
