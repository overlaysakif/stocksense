import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:stocksense/data/sample_products.dart';
import 'package:stocksense/screens/dashboard_screen.dart';

void main() {
  testWidgets('StockSense dashboard smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: DashboardScreen(
            products: sampleProducts,
            onViewInventory: () {},
            onScan: () {},
            onAddProduct: () {},
          ),
        ),
      ),
    );

    await tester.pumpAndSettle();

    expect(find.text('StockSense'), findsOneWidget);
    expect(find.text('Products'), findsOneWidget);
    expect(find.text('Low stock'), findsOneWidget);
    expect(find.text('Total units'), findsOneWidget);
    expect(find.text('Stock value'), findsOneWidget);
    expect(find.text('Quick actions'), findsOneWidget);
    expect(find.text('Add a product'), findsOneWidget);
    expect(find.text('Scan product'), findsOneWidget);
    expect(find.text('View inventory'), findsOneWidget);
  });
}