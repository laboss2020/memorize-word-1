import 'dart:io';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_test/flutter_test.dart';

/// 应用图标生成器：`flutter test tool/icon_gen_test.dart`
///
/// 用 CustomPainter 画矢量图形（不依赖字体，测试环境渲染稳定），
/// 生成 flutter_launcher_icons / flutter_native_splash 所需的 PNG。
const _indigo = Color(0xFF3F6EDC);
const _indigoDark = Color(0xFF2B4FA8);

void main() {
  Future<void> render(WidgetTester tester, Widget child, String path) async {
    tester.view.physicalSize = const Size(1024, 1024);
    tester.view.devicePixelRatio = 1.0;
    addTearDown(tester.view.reset);

    await tester.pumpWidget(
      Directionality(
        textDirection: TextDirection.ltr,
        child: RepaintBoundary(
          key: const Key('capture'),
          child: SizedBox(width: 1024, height: 1024, child: child),
        ),
      ),
    );
    await tester.pump();

    final boundary = tester.renderObject(
        find.byKey(const Key('capture'))) as RenderRepaintBoundary;
    await tester.runAsync(() async {
      final image = await boundary.toImage(pixelRatio: 1);
      final bytes =
          await image.toByteData(format: ui.ImageByteFormat.png);
      File(path)
        ..parent.createSync(recursive: true)
        ..writeAsBytesSync(bytes!.buffer.asUint8List());
      // ignore: avoid_print
      print('生成 $path');
    });
  }

  testWidgets('应用图标（完整出血，legacy/iOS）', (tester) async {
    await render(
      tester,
      DecoratedBox(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [_indigo, _indigoDark],
          ),
        ),
        child: const _CardsGlyph(scale: 1.0),
      ),
      'assets/icon/icon.png',
    );
  });

  testWidgets('自适应图标前景（透明底，内容居中缩小）', (tester) async {
    await render(
      tester,
      const ColoredBox(
        color: Color(0x00000000),
        child: _CardsGlyph(scale: 0.62),
      ),
      'assets/icon/icon_foreground.png',
    );
  });
}

/// 图案：两张叠起的单词卡片 + 对勾。
class _CardsGlyph extends StatelessWidget {
  const _CardsGlyph({required this.scale});

  final double scale;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: SizedBox(
        width: 1024 * scale,
        height: 1024 * scale,
        child: CustomPaint(painter: _CardsPainter()),
      ),
    );
  }
}

class _CardsPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final s = size.width / 1024; // 以 1024 为设计基准缩放

    // 背卡（微旋转，营造卡片堆叠感）。
    final backRot = Matrix4.identity()
      ..translateByDouble(512 * s, 512 * s, 0, 1)
      ..rotateZ(-0.14)
      ..translateByDouble(-512 * s, -512 * s, 0, 1);
    canvas.save();
    canvas.transform(backRot.storage);
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromCenter(
            center: Offset(512 * s, 520 * s),
            width: 560 * s,
            height: 560 * s),
        Radius.circular(72 * s),
      ),
      Paint()..color = Colors.white.withValues(alpha: 0.35),
    );
    canvas.restore();

    // 前卡。
    final frontRect = RRect.fromRectAndRadius(
      Rect.fromCenter(
          center: Offset(512 * s, 500 * s), width: 560 * s, height: 560 * s),
      Radius.circular(72 * s),
    );
    canvas.drawRRect(frontRect, Paint()..color = Colors.white);

    // 对勾（主题靛蓝，粗圆头）。
    final check = Path()
      ..moveTo(360 * s, 512 * s)
      ..lineTo(470 * s, 620 * s)
      ..lineTo(672 * s, 392 * s);
    canvas.drawPath(
      check,
      Paint()
        ..color = _indigo
        ..style = PaintingStyle.stroke
        ..strokeWidth = 64 * s
        ..strokeCap = StrokeCap.round
        ..strokeJoin = StrokeJoin.round,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
