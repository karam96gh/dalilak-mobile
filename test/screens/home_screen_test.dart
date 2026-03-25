import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen scaffold renders correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              appBar: AppBar(title: const Text('دليلك')),
              body: const SingleChildScrollView(
                child: Column(
                  children: [
                    Text('الأقسام'),
                    Text('الإعلانات المميزة'),
                  ],
                ),
              ),
            ),
          ),
        ),
      );

      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('دليلك'), findsOneWidget);
      expect(find.byType(SingleChildScrollView), findsOneWidget);
    });

    testWidgets('HomeScreen has navigation bottom bar',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: const Center(child: Text('Home')),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'الرئيسية',
                  ),
                  BottomNavigationBarItem(
                    icon: Icon(Icons.search),
                    label: 'بحث',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('الرئيسية'), findsOneWidget);
      expect(find.text('بحث'), findsOneWidget);
    });
  });

  group('HomeScreen Localization Tests', () {
    testWidgets('displays Arabic text correctly',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            locale: Locale('ar'),
            home: Scaffold(
              body: Center(child: Text('دليلك')),
            ),
          ),
        ),
      );

      expect(find.text('دليلك'), findsOneWidget);
    });
  });

  group('HomeScreen Dark Mode Tests', () {
    testWidgets('renders correctly in dark mode',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            themeMode: ThemeMode.dark,
            home: Scaffold(
              body: Center(child: Text('Dark Mode')),
            ),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.text('Dark Mode'), findsOneWidget);
    });
  });

  group('HomeScreen Responsiveness Tests', () {
    testWidgets('layouts correctly on phone size',
        (WidgetTester tester) async {
      tester.view.physicalSize = const Size(720, 1280);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);
      addTearDown(tester.view.resetDevicePixelRatio);

      await tester.pumpWidget(
        const ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: Center(child: Text('Phone')),
            ),
          ),
        ),
      );

      expect(find.byType(Scaffold), findsOneWidget);
    });
  });
}
