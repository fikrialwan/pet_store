class ApiConfig {
  // Default base URL - change this to update the API endpoint for the entire app
  static const String baseUrl = 'http://localhost:8080/api/v3';
  
  // Alternative URLs for different environments
  static const String prodUrl = 'https://petstore.swagger.io/v2';
  static const String devUrl = 'http://localhost:8080/api/v3';
  static const String stagingUrl = 'https://staging-api.petstore.com/v3';
  
  // Method to get URL based on environment (if needed in the future)
  static String getBaseUrlForEnvironment(String environment) {
    switch (environment.toLowerCase()) {
      case 'production':
      case 'prod':
        return prodUrl;
      case 'staging':
      case 'stage':
        return stagingUrl;
      case 'development':
      case 'dev':
      default:
        return devUrl;
    }
  }
}