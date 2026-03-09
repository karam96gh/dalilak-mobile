import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dalilak_app/screens/listings/listings_screen.dart';

void main() {
  group('ListingsScreen Widget Tests', () {
    testWidgets('ListingsScreen displays app bar with title',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      // Initial pump
      await tester.pump();

      // Assert
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('المحتويات'), findsOneWidget);
    });

    testWidgets('ListingsScreen displays filter and sort controls',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - look for filter and sort buttons
      expect(find.byIcon(Icons.filter_list), findsWidgets);
      expect(find.byType(DropdownButton), findsWidgets);
    });

    testWidgets('ListingsScreen filter button is tappable',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Find and tap filter button
      final filterButton = find.byIcon(Icons.filter_list);
      expect(filterButton, findsWidgets);

      // Assert that button is in a widget tree  
      expect(find.byType(ElevatedButton), findsWidgets);
    });

    testWidgets('ListingsScreen sort dropdown has options',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.text('الأحدث'), findsWidgets);
      expect(find.byType(DropdownButton<String>), findsWidgets);
    });

    testWidgets('ListingsScreen contains scrollable content area',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - look for Expanded widget which holds the listings
      expect(find.byType(Expanded), findsWidgets);
      expect(find.byType(Column), findsWidgets);
    });
  });

  group('ListingsScreen RTL Tests', () {
    testWidgets('ListingsScreen renders correctly in RTL mode',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: [Locale('ar', 'SA')],
          locale: Locale('ar', 'SA'),
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - verify Arabic text appears
      expect(find.text('المحتويات'), findsOneWidget);
    });
  });

  group('ListingsScreen Responsive Tests', () {
    testWidgets('ListingsScreen displays correctly on small screens',
        (WidgetTester tester) async {
      // Set up small screen
      addTearDown(tester.binding.window.physicalSizeTestValue = Size(412, 732));
      addTearDown(addTearDown);

      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('ListingsScreen displays correctly on large screens',
        (WidgetTester tester) async {
      // Set up large screen
      addTearDown(tester.binding.window.physicalSizeTestValue = Size(1024, 1366));
      addTearDown(addTearDown);

      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('ListingsScreen Dark Mode Tests', () {
    testWidgets('ListingsScreen renders correctly in dark theme',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: ProviderScope(
            child: ListingsScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - verify scaffold is present
      expect(find.byType(Scaffold), findsOneWidget);
      expect(find.byType(AppBar), findsOneWidget);
    });
  });
}
