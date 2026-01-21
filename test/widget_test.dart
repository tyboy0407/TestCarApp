import 'package:flutter_test/flutter_test.dart';
import 'package:testcar/main.dart';

void main() {
  testWidgets('App launch smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const CarEvaluationApp());

    // Verify that the title appears.
    expect(find.text('購車評估助手'), findsOneWidget);
  });
}