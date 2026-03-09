import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/onboarding/onboarding_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/categories/categories_screen.dart';
import '../screens/categories/category_detail_screen.dart';
import '../screens/listings/listings_screen.dart';
import '../screens/search/search_screen.dart';
import '../screens/favorites/favorites_screen.dart';
import '../screens/settings/settings_screen.dart';
import '../screens/listing_detail/listing_detail_screen.dart';
import '../screens/notifications/notifications_screen.dart';
import '../widgets/offline_indicator.dart';

final routerProvider = GoRouter(
  initialLocation: '/',
  routes: [
    // Splash
    GoRoute(
      path: '/',
      builder: (context, state) => const SplashScreen(),
    ),
    // Onboarding
    GoRoute(
      path: '/onboarding',
      builder: (context, state) => const OnboardingScreen(),
    ),
    // Home (shell route with bottom nav)
    ShellRoute(
      builder: (context, state, child) {
        return MainNavigationShell(child: child);
      },
      routes: [
        GoRoute(
          path: '/home',
          builder: (context, state) => const HomeScreen(),
        ),
        GoRoute(
          path: '/categories',
          builder: (context, state) => const CategoriesScreen(),
        ),
        GoRoute(
          path: '/search',
          builder: (context, state) => const SearchScreen(),
        ),
        GoRoute(
          path: '/favorites',
          builder: (context, state) => const FavoritesScreen(),
        ),
        GoRoute(
          path: '/settings',
          builder: (context, state) => const SettingsScreen(),
        ),
      ],
    ),
    // Listings
    GoRoute(
      path: '/listings',
      builder: (context, state) {
        final categoryId = state.uri.queryParameters['categoryId'];
        final governorateId = state.uri.queryParameters['governorateId'];
        return ListingsScreen(
          categoryId: categoryId != null ? int.tryParse(categoryId) : null,
          governorateId: governorateId != null ? int.tryParse(governorateId) : null,
        );
      },
    ),
    // Listing Detail
    GoRoute(
      path: '/listing/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        if (id == null) {
          return const ErrorPage();
        }
        final listingId = int.tryParse(id);
        if (listingId == null) {
          return const ErrorPage();
        }
        return ListingDetailScreen(listingId: listingId);
      },
    ),
    // Category Detail
    GoRoute(
      path: '/categories/:id',
      builder: (context, state) {
        final id = state.pathParameters['id'];
        if (id == null) {
          return const ErrorPage();
        }
        final categoryId = int.tryParse(id);
        if (categoryId == null) {
          return const ErrorPage();
        }
        return CategoryDetailScreen(categoryId: categoryId);
      },
    ),
    // Notifications
    GoRoute(
      path: '/notifications',
      builder: (context, state) => const NotificationsScreen(),
    ),
  ],
  errorBuilder: (context, state) => const ErrorPage(),
);

class MainNavigationShell extends StatefulWidget {
  final Widget child;

  const MainNavigationShell({
    Key? key,
    required this.child,
  }) : super(key: key);

  @override
  State<MainNavigationShell> createState() => _MainNavigationShellState();
}

class _MainNavigationShellState extends State<MainNavigationShell> {
  int _selectedIndex = 0;

  static const List<String> _routes = [
    '/home',
    '/categories',
    '/search',
    '/favorites',
    '/settings',
  ];

  static const List<String> _labels = [
    'الرئيسية',
    'التصنيفات',
    'بحث',
    'المفضلة',
    'الإعدادات',
  ];

  static const List<IconData> _icons = [
    Icons.home,
    Icons.category,
    Icons.search,
    Icons.favorite,
    Icons.settings,
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(40),
        child: const OfflineIndicator(),
      ),
      body: widget.child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (index) {
          setState(() => _selectedIndex = index);
          GoRouter.of(context).go(_routes[index]);
        },
        type: BottomNavigationBarType.fixed,
        items: List.generate(
          _labels.length,
          (index) => BottomNavigationBarItem(
            icon: Icon(_icons[index]),
            label: _labels[index],
          ),
        ),
      ),
    );
  }
}

class ErrorPage extends StatelessWidget {
  const ErrorPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('خطأ')),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error, size: 80, color: Colors.red[400]),
            const SizedBox(height: 20),
            Text(
              'حدث خطأ',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () => GoRouter.of(context).go('/'),
              child: const Text('العودة للرئيسية'),
            ),
          ],
        ),
      ),
    );
  }
}
