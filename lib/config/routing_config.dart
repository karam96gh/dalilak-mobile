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
    Icons.home_rounded,
    Icons.grid_view_rounded,
    Icons.search_rounded,
    Icons.favorite_rounded,
    Icons.settings_rounded,
  ];

  static const List<IconData> _iconsOutlined = [
    Icons.home_outlined,
    Icons.grid_view_outlined,
    Icons.search_outlined,
    Icons.favorite_outline_rounded,
    Icons.settings_outlined,
  ];

  int _calculateSelectedIndex(BuildContext context) {
    final location = GoRouterState.of(context).uri.path;
    final index = _routes.indexOf(location);
    return index >= 0 ? index : 0;
  }

  @override
  Widget build(BuildContext context) {
    final selectedIndex = _calculateSelectedIndex(context);
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      body: Column(
        children: [
          const OfflineIndicator(),
          Expanded(child: widget.child),
        ],
      ),
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: isDark ? const Color(0xFF1C192E) : Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.08),
              blurRadius: 20,
              offset: const Offset(0, -4),
            ),
          ],
          border: Border(
            top: BorderSide(
              color: isDark
                  ? const Color(0xFF2E2A45)
                  : const Color(0xFFEEEBF8),
              width: 1,
            ),
          ),
        ),
        child: SafeArea(
          child: SizedBox(
            height: 64,
            child: Row(
              children: List.generate(_labels.length, (index) {
                final isSelected = index == selectedIndex;
                return Expanded(
                  child: InkWell(
                    onTap: () => GoRouter.of(context).go(_routes[index]),
                    borderRadius: BorderRadius.circular(16),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 200),
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(
                                horizontal: 16, vertical: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? const Color(0xFF5C35C9).withOpacity(0.12)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(
                              isSelected
                                  ? _icons[index]
                                  : _iconsOutlined[index],
                              color: isSelected
                                  ? const Color(0xFF5C35C9)
                                  : (isDark
                                      ? const Color(0xFF6B6880)
                                      : const Color(0xFF9E9BB8)),
                              size: 22,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _labels[index],
                            style: TextStyle(
                              fontSize: 10,
                              fontWeight: isSelected
                                  ? FontWeight.w700
                                  : FontWeight.w400,
                              color: isSelected
                                  ? const Color(0xFF5C35C9)
                                  : (isDark
                                      ? const Color(0xFF6B6880)
                                      : const Color(0xFF9E9BB8)),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                );
              }),
            ),
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
