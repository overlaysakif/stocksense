import 'package:flutter_test/flutter_test.dart';
import 'package:stocksense/app.dart';

void main() {
  testWidgets('StockSense dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const StockSenseApp());
    await tester.pumpAndSettle();

    expect(find.text('StockSense'), findsOneWidget);
    expect(find.text('Dashboard'), findsOneWidget);
    expect(find.text('Inventory'), findsOneWidget);
    expect(find.text('Scan'), findsOneWidget);
    expect(find.text('Settings'), findsOneWidget);
  });
}
