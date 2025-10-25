# Pet Store Flutter App

A Flutter application for managing a pet store, built with Clean Architecture principles and based on the Swagger Petstore OpenAPI 3.0 specification.

## Features

- **Authentication System**: User login with persistent sessions
- **Pet Management**: View and browse pets with detailed information
- **Pet Adoption**: Place orders for pet adoption
- **Status Filtering**: Filter pets by availability status (available, pending, sold)
- **Search & Tags**: Search pets by tags and filter results
- **Pet Details**: Detailed view with images, category, and adoption functionality
- **Modern UI**: Material 3 design with smooth navigation and responsive layouts
- **Clean Architecture**: Proper separation of concerns with Domain, Data, and Presentation layers
- **Centralized Configuration**: Global API configuration for easy maintenance

## Architecture

This project follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core utilities and base classes
│   ├── config/             # Global configuration (API endpoints)
│   ├── error/              # Error handling and failures
│   └── usecases/           # Base use case class
├── features/               # Feature modules
│   ├── auth/              # Authentication feature
│   │   ├── data/          # Data layer (models, repositories, API, local storage)
│   │   ├── domain/        # Domain layer (entities, repositories, use cases)
│   │   └── presentation/  # Presentation layer (BLoC, screens, widgets)
│   ├── pet/               # Pet management feature
│   │   ├── data/          # Data layer (models, repositories, API)
│   │   ├── domain/        # Domain layer (entities, repositories, use cases)
│   │   └── presentation/  # Presentation layer (BLoC, screens, widgets)
│   └── store/             # Store management feature (order placement)
│       ├── data/          # Data layer (models, repositories, API)
│       ├── domain/        # Domain layer (entities, repositories, use cases)
│       └── presentation/  # Presentation layer (BLoC, screens, widgets)
├── injection_container.dart # Dependency injection setup
├── app_router.dart         # Navigation configuration with authentication
└── main.dart              # App entry point
```

## Getting Started

### Prerequisites

- Flutter SDK (3.9.0 or later)
- Dart SDK
- Android Studio / VS Code
- An Android device or emulator

### Installation

1. Clone the repository:
```bash
git clone <repository-url>
cd pet_store
```

2. Install dependencies:
```bash
flutter pub get
```

3. Generate code (for JSON serialization and API client):
```bash
flutter packages pub run build_runner build
```

4. Run the app:
```bash
flutter run
```

## Dependencies

### Core Dependencies
- **flutter_bloc**: State management using BLoC pattern
- **get_it**: Dependency injection container
- **dio**: HTTP client for API calls
- **retrofit**: Type-safe HTTP client generator
- **go_router**: Declarative routing with authentication guards
- **cached_network_image**: Image caching and loading
- **shared_preferences**: Local data persistence
- **json_annotation**: JSON serialization
- **dartz**: Functional programming utilities (Either, etc.)
- **equatable**: Value equality for objects

### Development Dependencies
- **build_runner**: Code generation runner
- **json_serializable**: JSON serialization code generation
- **retrofit_generator**: HTTP client code generation

## API Integration

The app integrates with a Pet Store API via centralized configuration (`lib/core/config/api_config.dart`):

- **Base URL**: `http://localhost:8080/api/v3` (configurable)
- **Authentication Endpoints**: Login and logout operations
- **Pet Endpoints**: Browse and view pet information
- **Store Endpoints**: Place orders for pet adoption

### API Configuration

The application uses a centralized API configuration system:

```dart
// lib/core/config/api_config.dart
class ApiConfig {
  static const String baseUrl = 'http://localhost:8080/api/v3';
}
```

To change the API endpoint, simply update the `baseUrl` in `ApiConfig` class.

## Features Overview

### Authentication System
- **Login Screen**: Username/password authentication
- **Session Management**: Persistent login with SharedPreferences
- **Authentication Guards**: Protected routes requiring login
- **Auto Login**: Automatic login on app startup if session exists

### Pet Management
- **Pet List**: Browse pets with status filtering and search
- **Pet Details**: Detailed view with images and adoption functionality
- **Status Filtering**: Filter by available, pending, sold status
- **Tag Search**: Search pets by tags with real-time filtering
- **Pet Adoption**: Place orders directly from pet details

### UI Components
- **PetCard**: Reusable card component for pet display
- **Status Chips**: Visual indicators for pet availability
- **Search Bar**: Real-time tag-based search functionality
- **Image Gallery**: Cached network images with loading states
- **Loading States**: Proper loading, error, and empty state handling
- **Navigation**: Responsive navigation with authentication flow

### Data Management
- **Local Storage**: User session and data persistence
- **Error Handling**: Comprehensive error handling with user-friendly messages
- **State Management**: BLoC pattern for reactive state management
- **API Integration**: Type-safe API calls with automatic serialization

## Code Generation

When you modify models or API services, regenerate code with:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Run tests and ensure code quality
5. Submit a pull request

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## API Reference

Based on the Swagger Petstore OpenAPI 3.0 specification:
- [Pet Store Repository](https://github.com/swagger-api/swagger-petstore)
- [API Definition](https://github.com/swagger-api/swagger-petstore/blob/master/src/main/resources/openapi.yaml)

## Project Status

### Current Implementation
✅ Authentication system with persistent sessions  
✅ Pet browsing with filtering and search  
✅ Pet details with adoption functionality  
✅ Order placement for pet adoption  
✅ Clean Architecture implementation  
✅ Centralized API configuration  
✅ Comprehensive error handling  
✅ Material 3 UI design  

### Code Quality
- **Linting**: Follows Flutter/Dart best practices
- **Architecture**: Clean Architecture with proper separation of concerns  
- **State Management**: BLoC pattern implementation
- **Type Safety**: Strong typing with code generation
- **Error Handling**: Comprehensive error handling throughout the app

## Flutter Resources

For developers new to Flutter:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)
- [Online documentation](https://docs.flutter.dev/) - tutorials, samples, and API reference
- [BLoC Pattern Guide](https://bloclibrary.dev/) - State management documentation
- [Clean Architecture in Flutter](https://resocoder.com/2019/08/27/flutter-tdd-clean-architecture-course-1-explanation-project-structure/) - Architecture guidance
