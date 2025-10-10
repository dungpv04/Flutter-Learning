class ApiConstants {
  // Base URLs for different environments
  static const String baseUrlDev = 'http://10.0.2.2:8000/api/v1';
  static const String baseUrlStaging = 'https://staging-api.yourapp.com/api/v1';
  static const String baseUrlProd = 'https://api.yourapp.com/api/v1';
  
  // Current environment
  static const String baseUrl = baseUrlDev; // Change based on build flavor
  
  // Endpoints
  static const String products = '/products/';
  static const String categories = '/categories/';
  
  // Timeouts
  static const Duration connectTimeout = Duration(seconds: 30);
  static const Duration receiveTimeout = Duration(seconds: 30);
  static const Duration sendTimeout = Duration(seconds: 30);
  
  // Headers
  static const Map<String, String> headers = {
    'Content-Type': 'application/json',
    'Accept': 'application/json',
  };
}
