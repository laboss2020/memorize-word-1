import 'package:flutter/material.dart';

/// 关于与致谢：隐私声明 + 词库/算法开源致谢（许可合规必需）。
class AboutPage extends StatelessWidget {
  const AboutPage({super.key});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Scaffold(
      appBar: AppBar(title: const Text('关于与致谢')),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          Text('背单词 v1.0.0', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          Text(
            '一个完全离线的间隔重复记单词应用。'
            '所有学习数据仅保存在你的设备上，我们没有任何服务器，'
            '不收集任何数据。',
            style: textTheme.bodyMedium,
          ),
          const Divider(height: 32),
          Text('开源致谢', style: textTheme.titleMedium),
          const SizedBox(height: 8),
          const _Credit(
            name: 'FSRS（open-spaced-repetition/fsrs-dart）',
            license: 'MIT License',
            desc: 'FSRS-5 间隔重复算法，驱动复习调度。',
          ),
          const _Credit(
            name: 'ECDICT',
            license: 'MIT License',
            desc: '英汉字典数据（词头、音标、释义、词性、词频）。',
          ),
          const _Credit(
            name: 'JMdict / JMnedict（EDRDG）',
            license: 'Electronic Dictionary Research and Development Group',
            desc: '日语词典数据。本应用是其衍生作品，'
                '依据 EDRDG 许可协议声明署名：dictionary data provided by JMdict/EDRDG。',
          ),
          const _Credit(
            name: 'Tatoeba',
            license: 'CC BY 2.0 FR',
            desc: '例句数据（tatoeba.org）。',
          ),
          const _Credit(
            name: 'OpenJLPT / JLPT 词表',
            license: '见项目仓库许可说明',
            desc: '日语词汇 JLPT 等级划分。',
          ),
          const _Credit(
            name: 'Flutter 及全部开源依赖包',
            license: '各依其许可',
            desc: 'drift、flutter_riverpod、go_router、fl_chart、'
                'flutter_tts、flutter_local_notifications 等。',
          ),
          const SizedBox(height: 24),
          Text(
            '以上数据仅用于构建离线词库，所有处理均在本机完成。',
            style: textTheme.bodySmall,
          ),
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
