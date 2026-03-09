import 'dart:convert';
import '../models/governorate_model.dart';
import '../models/category_model.dart';
import '../models/listing_model.dart';
import '../models/notification_model.dart';
import '../models/ad_model.dart';
import '../models/review_model.dart';
import '../models/api_response_model.dart';
import '../utils/exceptions.dart';
import 'api_client.dart';
import 'cache_service.dart';
import 'connectivity_service.dart';

class DalilakRepository {
  final ApiClient _apiClient;
  final CacheService _cacheService;
  final ConnectivityService _connectivityService;

  DalilakRepository(
    this._apiClient,
    this._cacheService,
    this._connectivityService,
  );

  // ============ CATEGORIES ============
  Future<List<Category>> getCategories() async {
    // Try to use cache first
    final cached = await _cacheService.getCachedCategories();
    if (cached != null) {
      return cached;
    }

    // Check connectivity before making API call
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/categories',
        fromJson: (data) => data as List<dynamic>,
      );
      final categories = response
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList();

      // Cache the result
      await _cacheService.cacheCategories(categories);
      return categories;
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedCategories();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  Future<Category> getCategoryById(int id) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/categories/$id',
      fromJson: (data) => data as Map<String, dynamic>,
    );
    return Category.fromJson(response);
  }

  // ============ GOVERNORATES ============
  Future<List<Governorate>> getGovernorates() async {
    // Try to use cache first
    final cached = await _cacheService.getCachedGovernorates();
    if (cached != null) {
      return cached;
    }

    // Check connectivity before making API call
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/governorates',
        fromJson: (data) => data as List<dynamic>,
      );
      final governorates = response
          .map((item) => Governorate.fromJson(item as Map<String, dynamic>))
          .toList();

      // Cache the result
      await _cacheService.cacheGovernorates(governorates);
      return governorates;
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedGovernorates();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  // ============ LISTINGS ============
  Future<PaginatedResponse<Listing>> getListings({
    int page = 1,
    int limit = 20,
    int? categoryId,
    int? governorateId,
    bool? isFeatured,
  }) async {
    // Try to use cache first
    final cached = await _cacheService.getCachedListingsPaginated(page, limit);
    if (cached != null) {
      try {
        final jsonData = jsonDecode(cached) as Map<String, dynamic>;
        return PaginatedResponse.fromJson(
          jsonData,
          (item) => Listing.fromJson(item as Map<String, dynamic>),
        );
      } catch (_) {}
    }

    // Check connectivity
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final queryParams = {
        'page': page,
        'limit': limit,
        if (categoryId != null) 'categoryId': categoryId,
        if (governorateId != null) 'governorateId': governorateId,
        if (isFeatured != null) 'isFeatured': isFeatured,
      };

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/listings',
        queryParameters: queryParams,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      // Cache as JSON string
      await _cacheService.cacheListingsPaginated(
        page,
        limit,
        jsonEncode(response),
      );

      return PaginatedResponse.fromJson(
        response,
        (item) => Listing.fromJson(item as Map<String, dynamic>),
      );
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedListingsPaginated(page, limit);
      if (cached != null) {
        try {
          final jsonData = jsonDecode(cached) as Map<String, dynamic>;
          return PaginatedResponse.fromJson(
            jsonData,
            (item) => Listing.fromJson(item as Map<String, dynamic>),
          );
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<Listing> getListingById(int id) async {
    // Check connectivity
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final response = await _apiClient.get<Map<String, dynamic>>(
        '/listings/$id',
        fromJson: (data) => data as Map<String, dynamic>,
      );
      
      // Cache the listing
      await _cacheService.cacheListing(id, jsonEncode(response));
      
      return Listing.fromJson(response);
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedListing(id);
      if (cached != null) {
        try {
          final jsonData = jsonDecode(cached) as Map<String, dynamic>;
          return Listing.fromJson(jsonData);
        } catch (_) {}
      }
      rethrow;
    }
  }

  Future<PaginatedResponse<Listing>> searchListings({
    required String query,
    int page = 1,
    int limit = 20,
    int? categoryId,
    int? governorateId,
  }) async {
    // Try to use cache first
    final cached = await _cacheService.getCachedSearch(query, page);
    if (cached != null) {
      try {
        final jsonData = jsonDecode(cached) as Map<String, dynamic>;
        return PaginatedResponse.fromJson(
          jsonData,
          (item) => Listing.fromJson(item as Map<String, dynamic>),
        );
      } catch (_) {}
    }

    // Check connectivity
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final queryParams = {
        'q': query,
        'page': page,
        'limit': limit,
        if (categoryId != null) 'categoryId': categoryId,
        if (governorateId != null) 'governorateId': governorateId,
      };

      final response = await _apiClient.get<Map<String, dynamic>>(
        '/search',
        queryParameters: queryParams,
        fromJson: (data) => data as Map<String, dynamic>,
      );

      // Cache the search results
      await _cacheService.cacheSearch(query, page, jsonEncode(response));

      return PaginatedResponse.fromJson(
        response,
        (item) => Listing.fromJson(item as Map<String, dynamic>),
      );
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedSearch(query, page);
      if (cached != null) {
        try {
          final jsonData = jsonDecode(cached) as Map<String, dynamic>;
          return PaginatedResponse.fromJson(
            jsonData,
            (item) => Listing.fromJson(item as Map<String, dynamic>),
          );
        } catch (_) {}
      }
      rethrow;
    }
  }

  // ============ NOTIFICATIONS ============
  Future<List<Notification>> getNotifications() async {
    // Try to use cache first
    final cached = await _cacheService.getCachedNotifications();
    if (cached != null) {
      return cached;
    }

    // Check connectivity
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/notifications',
        fromJson: (data) => data as List<dynamic>,
      );
      final notifications = response
          .map((item) => Notification.fromJson(item as Map<String, dynamic>))
          .toList();

      // Cache the notifications
      await _cacheService.cacheNotifications(notifications);
      return notifications;
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedNotifications();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  // ============ ADS ============
  Future<List<Ad>> getAds() async {
    // Try to use cache first
    final cached = await _cacheService.getCachedAds();
    if (cached != null) {
      return cached;
    }

    // Check connectivity
    final isConnected = await _connectivityService.isConnected();
    if (!isConnected) {
      throw NetworkException(
        message: 'No internet connection. Please check your network.',
        code: 'NO_INTERNET',
      );
    }

    try {
      final response = await _apiClient.get<List<dynamic>>(
        '/ads',
        fromJson: (data) => data as List<dynamic>,
      );
      final ads = response
          .map((item) => Ad.fromJson(item as Map<String, dynamic>))
          .toList();

      // Cache the ads
      await _cacheService.cacheAds(ads);
      return ads;
    } catch (e) {
      // Try to return cached data as fallback
      final cached = await _cacheService.getCachedAds();
      if (cached != null) {
        return cached;
      }
      rethrow;
    }
  }

  // ============ STATS ============
  Future<void> recordListingView(int listingId) async {
    await _apiClient.post(
      '/listings/$listingId/view',
      data: {},
      fromJson: (_) => null,
    );
  }

  // ============ REVIEWS & RATINGS ============
  Future<PaginatedResponse<Review>> getListingReviews({
    required int listingId,
    int page = 1,
    int limit = 10,
  }) async {
    final queryParams = {
      'page': page,
      'limit': limit,
    };

    final response = await _apiClient.get<Map<String, dynamic>>(
      '/listings/$listingId/reviews',
      queryParameters: queryParams,
      fromJson: (data) => data as Map<String, dynamic>,
    );

    return PaginatedResponse.fromJson(
      response,
      (item) => Review.fromJson(item as Map<String, dynamic>),
    );
  }

  Future<RatingStats> getListingRatingStats(int listingId) async {
    final response = await _apiClient.get<Map<String, dynamic>>(
      '/listings/$listingId/ratings',
      fromJson: (data) => data as Map<String, dynamic>,
    );
    return RatingStats.fromJson(response);
  }

  Future<Review> submitReview({
    required int listingId,
    required int rating,
    required String comment,
  }) async {
    final response = await _apiClient.post<Map<String, dynamic>>(
      '/listings/$listingId/reviews',
      data: {
        'rating': rating,
        'comment': comment,
      },
      fromJson: (data) => data as Map<String, dynamic>,
    );
    return Review.fromJson(response);
  }
}
