class AppConstants {
  // App Info
  static const String appName = 'Product Management';
  static const String appVersion = '1.0.0';
  
  // Storage Keys
  static const String themeKey = 'theme_mode';
  static const String firstTimeKey = 'is_first_time';
  static const String userPrefsKey = 'user_preferences';
  
  // Pagination
  static const int defaultPageSize = 20;
  static const int maxPageSize = 100;
  
  // Cache durations
  static const Duration defaultCacheDuration = Duration(minutes: 5);
  static const Duration longCacheDuration = Duration(hours: 1);
  
  // Animation durations
  static const Duration shortAnimationDuration = Duration(milliseconds: 200);
  static const Duration mediumAnimationDuration = Duration(milliseconds: 400);
  static const Duration longAnimationDuration = Duration(milliseconds: 600);
  
  // Validation
  static const int maxProductNameLength = 100;
  static const int maxDescriptionLength = 500;
  static const double minPrice = 0.01;
  static const double maxPrice = 999999.99;
}
