import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/cache_service.dart';
import '../services/connectivity_service.dart';

// ============ CACHE SERVICE PROVIDER ============
// Initialized instance set from main.dart
late CacheService _initializedCacheService;

void setCacheServiceInstance(CacheService service) {
  _initializedCacheService = service;
}

final cacheServiceProvider = Provider<CacheService>((ref) {
  return _initializedCacheService;
});

// ============ CONNECTIVITY SERVICE PROVIDER ============
final connectivityServiceProvider = Provider<ConnectivityService>((ref) {
  return ConnectivityService();
});

// ============ CONNECTIVITY STATE ============
/// Provides real-time connectivity status
final isConnectedProvider = StreamProvider<bool>((ref) {
  final connectivityService = ref.watch(connectivityServiceProvider);
  
  // Check initial state
  return connectivityService.onConnectivityChanged;
});

/// One-time check for connectivity
final connectivityStatusProvider = FutureProvider<bool>((ref) async {
  final connectivityService = ref.watch(connectivityServiceProvider);
  return connectivityService.isConnected();
});

// ============ OFFLINE MODE FLAG ============
/// Indicates if app is in offline mode
final offlineModeProvider = StateProvider<bool>((ref) {
  return false;
});

/// Set offline mode status
final setOfflineModeProvider = Provider<void Function(bool)>((ref) {
  return (bool isOffline) {
    ref.read(offlineModeProvider.notifier).state = isOffline;
  };
});
