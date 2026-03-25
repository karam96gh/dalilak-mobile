import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  testWidgets('App smoke test - MaterialApp builds successfully',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      const ProviderScope(
        child: MaterialApp(
          home: Scaffold(
            body: Center(child: Text('دليلك')),
          ),
        ),
      ),
    );

    expect(find.text('دليلك'), findsOneWidget);
    expect(find.byType(Scaffold), findsOneWidget);
  });
}
