// test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';

// 🔑 This is the corrected import path!
import '../lib/main.dart';

void main() {
  testWidgets('Unity Wallet app launches successfully', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pump(const Duration(seconds: 3));

    // This text must exactly match the title/text on your LoginPage
    expect(find.text('Unity Wallet Login'), findsOneWidget);
  });
}
