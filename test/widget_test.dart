import 'package:flutter_test/flutter_test.dart';
import 'package:quran/app.dart';

void main() {
  testWidgets('QuranApp smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const QuranApp());
    await tester.pump(const Duration(seconds: 1));
    expect(find.byType(QuranApp), findsOneWidget);
  });
}
