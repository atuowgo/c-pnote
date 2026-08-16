import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:pnote/core/format.dart';

void main() {
  test('中文日期格式化', () {
    final d = DateTime(2026, 8, 16); // 周日
    expect(Fmt.monthDay(d), '8月16日');
    expect(Fmt.weekday(d), '周日');
    expect(Fmt.ymdSlash(d), '2026 / 08 / 16');
  });

  testWidgets('空占位组件可渲染', (tester) async {
    await tester.pumpWidget(const MaterialApp(home: Scaffold(body: Text('ok'))));
    expect(find.text('ok'), findsOneWidget);
  });
}
