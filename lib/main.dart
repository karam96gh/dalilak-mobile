import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import 'config/app_theme.dart';
import 'config/routing_config.dart';
import 'constants/app_constants.dart';
import 'providers/app_providers.dart';
import 'providers/connectivity_providers.dart';
import 'services/api_client.dart';
import 'services/cache_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Hive
  await Hive.initFlutter();

  // Initialize Cache Service and register it globally
  final cacheService = CacheService();
  await cacheService.init();
  setCacheServiceInstance(cacheService);

  // Test API connection on startup
  _testApiConnection();

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

Future<void> _testApiConnection() async {
  if (!kDebugMode) return;

  debugPrint('');
  debugPrint('STARTUP API TEST');
  debugPrint('');

  final apiClient = ApiClient();

  try {
    // Test 1: Health Check
    final health = await apiClient.get<Map<String, dynamic>>(
      '/health',
      fromJson: (data) => data as Map<String, dynamic>,
    );
    debugPrint('Health Check: $health');
  } catch (e) {
    debugPrint('Health Check FAILED: $e');
  }

  try {
    // Test 2: Categories
    final categories = await apiClient.get<List<dynamic>>(
      '/categories',
      fromJson: (data) => data as List<dynamic>,
    );
    debugPrint('Categories: ${categories.length} items loaded');
  } catch (e) {
    debugPrint('Categories FAILED: $e');
  }

  try {
    // Test 3: Governorates
    final governorates = await apiClient.get<List<dynamic>>(
      '/governorates',
      fromJson: (data) => data as List<dynamic>,
    );
    debugPrint('Governorates: ${governorates.length} items loaded');
  } catch (e) {
    debugPrint('Governorates FAILED: $e');
  }

  try {
    // Test 4: Listings
    final listings = await apiClient.get<Map<String, dynamic>>(
      '/listings',
      queryParameters: {'page': 1, 'limit': 5},
      fromJson: (data) => data as Map<String, dynamic>,
    );
    final data = listings['data'] as List?;
    final meta = listings['meta'] as Map?;
    debugPrint('Listings: ${data?.length ?? 0} items (total: ${meta?['total'] ?? '?'})');
  } catch (e) {
    debugPrint('Listings FAILED: $e');
  }

  try {
    // Test 5: Ads
    final ads = await apiClient.get<List<dynamic>>(
      '/ads',
      fromJson: (data) => data as List<dynamic>,
    );
    debugPrint('Ads: ${ads.length} items loaded');
  } catch (e) {
    debugPrint('Ads FAILED: $e');
  }

  try {
    // Test 6: Notifications
    final notifications = await apiClient.get<Map<String, dynamic>>(
      '/notifications',
      fromJson: (data) => data as Map<String, dynamic>,
    );
    final data = notifications['data'] as List?;
    debugPrint('Notifications: ${data?.length ?? 0} items loaded');
  } catch (e) {
    debugPrint('Notifications FAILED: $e');
  }

  debugPrint('');
  debugPrint('STARTUP API TEST COMPLETE');
  debugPrint('');

  apiClient.close();
}

class MyApp extends ConsumerStatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  ConsumerState<MyApp> createState() => _MyAppState();
}

class _MyAppState extends ConsumerState<MyApp> {
  @override
  void initState() {
    super.initState();
    _initializeApp();
  }

  Future<void> _initializeApp() async {
    // Initialize app data
    ref.read(appInitializerProvider);
  }

  @override
  Widget build(BuildContext context) {
    final locale = ref.watch(localeProvider);
    final themeMode = ref.watch(themeModeProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: const [
        Locale('ar'),
        Locale('en'),
      ],
      locale: locale,
      themeMode: themeMode,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      routerConfig: routerProvider,
      debugShowCheckedModeBanner: false,
    );
  }
}
