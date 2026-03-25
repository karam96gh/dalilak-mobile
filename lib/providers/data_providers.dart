import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import '../models/governorate_model.dart';
import '../models/category_model.dart';
import '../models/listing_model.dart';
import '../models/notification_model.dart';
import '../models/ad_model.dart';
import '../models/api_response_model.dart';
import '../services/api_client.dart';
import '../services/dalilak_repository.dart';
import 'connectivity_providers.dart';
import 'app_providers.dart';

// API Client Provider
final apiClientProvider = Provider<ApiClient>((ref) {
  return ApiClient();
});

// Repository Provider
final dalilakRepositoryProvider = Provider<DalilakRepository>((ref) {
  final apiClient = ref.watch(apiClientProvider);
  final cacheService = ref.watch(cacheServiceProvider);
  final connectivityService = ref.watch(connectivityServiceProvider);
  return DalilakRepository(apiClient, cacheService, connectivityService);
});

// ============ CATEGORIES ============
final categoriesProvider = FutureProvider<List<Category>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getCategories();
});

final categoryByIdProvider =
    FutureProvider.family<Category, int>((ref, id) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getCategoryById(id);
});

final categoryChildrenProvider =
    FutureProvider.family<List<Category>, int>((ref, parentId) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getCategoryChildren(parentId);
});

// ============ GOVERNORATES ============
final governoratesProvider = FutureProvider<List<Governorate>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getGovernorates();
});

// ============ LISTINGS ============
final featuredListingsProvider = FutureProvider<List<Listing>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getFeaturedListings();
});

final latestListingsProvider = FutureProvider<List<Listing>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getLatestListings();
});

final listingsProvider = FutureProvider.family<
    PaginatedResponse<Listing>,
    ({int page, int limit, int? categoryId, int? governorateId})>((ref, params) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getListings(
    page: params.page,
    limit: params.limit,
    categoryId: params.categoryId,
    governorateId: params.governorateId,
  );
});

final listingByIdProvider =
    FutureProvider.family<Listing, int>((ref, id) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getListingById(id);
});

final searchListingsProvider = FutureProvider.family<
    PaginatedResponse<Listing>,
    ({
      String query,
      int page,
      int limit,
      int? categoryId,
      int? governorateId,
    })>((ref, params) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.searchListings(
    query: params.query,
    page: params.page,
    limit: params.limit,
    categoryId: params.categoryId,
    governorateId: params.governorateId,
  );
});

// ============ NOTIFICATIONS ============
final notificationsProvider = FutureProvider<List<Notification>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getNotifications();
});

// ============ ADS ============
final adsProvider = FutureProvider<List<Ad>>((ref) async {
  final repository = ref.watch(dalilakRepositoryProvider);
  return repository.getAds();
});

// ============ FAVORITES ============
final favoritesProvider = StateNotifierProvider<FavoritesNotifier, List<int>>((ref) {
  return FavoritesNotifier(ref);
});

class FavoritesNotifier extends StateNotifier<List<int>> {
  FavoritesNotifier(this.ref) : super([]) {
    _loadFavorites();
  }

  final Ref ref;

  Future<void> _loadFavorites() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      final favoritesJson = prefs.getString('favorites') ?? '[]';
      final List<dynamic> decoded = jsonDecode(favoritesJson);
      state = decoded.cast<int>();
    } catch (_) {
      state = [];
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await ref.read(sharedPreferencesProvider.future);
      await prefs.setString('favorites', jsonEncode(state));
    } catch (_) {}
  }

  void toggleFavorite(int listingId) {
    if (state.contains(listingId)) {
      state = state.where((id) => id != listingId).toList();
    } else {
      state = [...state, listingId];
    }
    _saveFavorites();
  }

  bool isFavorite(int listingId) => state.contains(listingId);
}

// ============ FAVORITE LISTINGS ============
final favoriteListingsProvider = FutureProvider<List<Listing>>((ref) async {
  final favoriteIds = ref.watch(favoritesProvider);
  if (favoriteIds.isEmpty) return [];

  final repository = ref.watch(dalilakRepositoryProvider);
  final listings = <Listing>[];
  for (final id in favoriteIds) {
    try {
      final listing = await repository.getListingById(id);
      listings.add(listing);
    } catch (_) {
      // Skip listings that fail to load
    }
  }
  return listings;
});
