// Example usage of ApiConfig:
// 
// To change the API endpoint for the entire app:
// 1. Update ApiConfig.baseUrl in lib/core/config/api_config.dart
// 2. Run: flutter packages pub run build_runner build --delete-conflicting-outputs
// 3. Restart the app
//
// Current API endpoint: http://localhost:8080/api/v3
//
// Alternative endpoints available:
// - Development: http://localhost:8080/api/v3
// - Staging: https://staging-api.petstore.com/v3  
// - Production: https://petstore.swagger.io/v2
//
// For environment-specific URLs, you can modify injection_container.dart:
// dio.options.baseUrl = ApiConfig.getBaseUrlForEnvironment('production');