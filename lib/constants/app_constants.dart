// Constants for API endpoints and app configuration
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://217.76.53.136/dalilak/api/v1';
  static const String serverBaseUrl = 'http://217.76.53.136/dalilak';
  static const String apiTimeout = '30000'; // milliseconds

  /// Build full image URL from relative path (e.g. /uploads/image.jpg)
  static String imageUrl(String path) {
    if (path.startsWith('http')) return path;
    return '$serverBaseUrl$path';
  }

  // App Info
  static const String appName = 'دليلك بموبايلك';
  static const String appVersion = '1.0.0';

  // Shared Preferences Keys
  static const String spKeyFirstRun = 'first_run';
  static const String spKeyLanguage = 'language';
  static const String spKeyTheme = 'theme';
  static const String spKeyFavorites = 'favorites';

  // Hive Boxes
  static const String hiveBoxCategories = 'categories';
  static const String hiveBoxListings = 'listings';
  static const String hiveBoxGovernrates = 'governorates';
}
