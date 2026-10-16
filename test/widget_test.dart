import 'package:flutter_test/flutter_test.dart';
import 'package:memorize_word/app/theme.dart';

void main() {
  test('主题提供 light/dark 两套 Material 3 配色', () {
    expect(AppTheme.light().useMaterial3, isTrue);
    expect(AppTheme.dark().useMaterial3, isTrue);
  });
}
