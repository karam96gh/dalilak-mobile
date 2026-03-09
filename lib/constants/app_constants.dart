// Constants for API endpoints and app configuration
class AppConstants {
  // API Configuration
  static const String apiBaseUrl = 'http://localhost:1996/api/v1';
  static const String apiTimeout = '30000'; // milliseconds

  // App Info
  static const String appName = 'دليلك';
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
