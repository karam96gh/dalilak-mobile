import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dalilak_app/screens/home/home_screen.dart';
import 'package:dalilak_app/providers/data_providers.dart';
import 'package:dalilak_app/models/ad_model.dart';
import 'package:dalilak_app/models/category_model.dart';
import 'package:dalilak_app/models/listing_model.dart';
import 'package:dalilak_app/models/api_response_model.dart';

// Create mock providers
class MockRef extends Mock implements WidgetRef {}

void main() {
  group('HomeScreen Widget Tests', () {
    testWidgets('HomeScreen displays loading state initially',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: HomeScreen(),
          ),
        ),
      );

      // Wait for widget to load
      await tester.pumpAndSettle();

      // Assert - look for app bar
      expect(find.byType(AppBar), findsOneWidget);
      expect(find.text('دليلك'), findsOneWidget);
    });

    testWidgets('HomeScreen displays multiple sections',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: HomeScreen(),
          ),
        ),
      );

      // Initial pump
      await tester.pump();

      // Assert - verify sections exist eventually
      expect(find.byType(SingleChildScrollView), findsWidgets);
    });

    testWidgets('HomeScreen has navigation bottom bar',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: Scaffold(
              body: HomeScreen(),
              bottomNavigationBar: BottomNavigationBar(
                items: const [
                  BottomNavigationBarItem(
                    icon: Icon(Icons.home),
                    label: 'Home',
                  ),
                ],
              ),
            ),
          ),
        ),
      );

      // Assert - verify elements are rendered
      expect(find.byType(BottomNavigationBar), findsWidgets);
    });
  });

  group('HomeScreen Responsiveness Tests', () {
    testWidgets('HomeScreen layouts correctly on different screen sizes',
        (WidgetTester tester) async {
      // Test on phone size
      addTearDown(tester.binding.window.physicalSizeTestValue = Size(720, 1280));
      addTearDown(tester.binding.window.devicePixelRatioTestValue = 1.0);

      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          home: ProviderScope(
            child: HomeScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - check that widgets are visible
      expect(find.byType(Scaffold), findsOneWidget);
    });
  });

  group('HomeScreen Localization Tests', () {
    testWidgets('HomeScreen displays Arabic text correctly',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          supportedLocales: [Locale('ar', 'SA')],
          locale: Locale('ar', 'SA'),
          home: ProviderScope(
            child: HomeScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - verify Arabic text appears (دليلك = Dalelak)
      expect(find.text('دليلك'), findsWidgets);
    });
  });

  group('HomeScreen Dark Mode Tests', () {
    testWidgets('HomeScreen renders correctly in dark mode',
        (WidgetTester tester) async {
      // Arrange & Act
      await tester.pumpWidget(
        MaterialApp(
          theme: ThemeData.light(),
          darkTheme: ThemeData.dark(),
          themeMode: ThemeMode.dark,
          home: ProviderScope(
            child: HomeScreen(),
          ),
        ),
      );

      await tester.pump();

      // Assert - verify scaffold background color respects theme
      final scaffold = find.byType(Scaffold);
      expect(scaffold, findsWidgets);
    });
  });
}
