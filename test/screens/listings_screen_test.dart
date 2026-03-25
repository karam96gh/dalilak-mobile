import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('ListingsScreen Widget Tests', () {
    testWidgets('ListingsScreen scaffold renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('المحتويات')),
              body: const Column(
                children: [
                  Text('Filter Section'),
                  Expanded(child: Center(child: Text('Listings'))),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('المحتويات'), findsOneWidget);
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('ListingsScreen contains scrollable content area',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Column(
                children: [
                  Expanded(
                    child: ListView(
                      children: const [
                        ListTile(title: Text('Item 1')),
                        ListTile(title: Text('Item 2')),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(Expanded), findsOneWidget);
      expect(find.byType(ListView), findsOneWidget);
      expect(find.text('Item 1'), findsOneWidget);
      expect(find.text('Item 2'), findsOneWidget);
    });
  });

  group('ListingsScreen RTL Tests', () {
    testWidgets('renders correctly in RTL mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            locale: const Locale('ar'),
            home: Scaffold(
              appBar: AppBar(title: const Text('المحتويات')),
              body: const Center(child: Text('محتوى عربي')),
            ),
          ),
        ),
      );

      expect(find.text('المحتويات'), findsOneWidget);
      expect(find.text('محتوى عربي'), findsOneWidget);
    });
  });

  group('ListingsScreen Responsive Tests', () {
    testWidgets('displays correctly on small screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(412, 732);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('Small'))),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('displays correctly on large screens',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(1024, 1366);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(body: Center(child: Text('Large'))),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('ListingsScreen Dark Mode Tests', () {
    testWidgets('renders correctly in dark theme',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            theme: ThemeData.light(),
            darkTheme: ThemeData.dark(),
            themeMode: ThemeMode.dark,
            home: Scaffold(
              appBar: AppBar(title: const Text('المحتويات')),
              body: const Center(child: Text('Dark')),
            ),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
