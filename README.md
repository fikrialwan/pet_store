# Pet Store Android App

A Flutter application for managing a pet store, built with Clean Architecture principles and based on the Swagger Petstore OpenAPI 3.0 specification.

## Features

- **Pet Management**: View, add, update, and delete pets
- **Status Filtering**: Filter pets by availability status (available, pending, sold)
- **Pet Details**: Detailed view with images, tags, and category information
- **Modern UI**: Material 3 design with smooth navigation
- **Clean Architecture**: Proper separation of concerns with Domain, Data, and Presentation layers

## Architecture

This project follows Clean Architecture principles with the following structure:

```
lib/
├── core/                    # Core utilities and base classes
│   ├── error/              # Error handling and failures
│   └── usecases/           # Base use case class
├── features/               # Feature modules
│   ├── pet/               # Pet management feature
│   │   ├── data/          # Data layer (models, repositories, API)
│   │   ├── domain/        # Domain layer (entities, repositories, use cases)
│   │   └── presentation/  # Presentation layer (BLoC, screens, widgets)
│   ├── store/             # Store management feature
│   └── user/              # User management feature
├── injection_container.dart # Dependency injection setup
├── app_router.dart         # Navigation configuration
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
- **get_it**: Dependency injection
- **dio**: HTTP client for API calls
- **retrofit**: Type-safe HTTP client generator
- **go_router**: Declarative routing
- **cached_network_image**: Image caching and loading
- **json_annotation**: JSON serialization
- **dartz**: Functional programming utilities
- **equatable**: Value equality for objects

### Development Dependencies
- **build_runner**: Code generation
- **json_serializable**: JSON serialization code generation
- **retrofit_generator**: HTTP client code generation
- **injectable_generator**: Dependency injection code generation

## API Integration

The app integrates with a local Pet Store API (http://localhost:8080/api/v3) and includes:

- **Pet Endpoints**: CRUD operations for pets
- **Store Endpoints**: Order management
- **User Endpoints**: User authentication and management

## Features Overview

### Pet Management
- View list of pets with filtering by status
- Pet detail screen with image gallery
- Add new pets (form implementation can be extended)
- Update existing pets
- Delete pets

### UI Components
- **PetCard**: Reusable card component for pet display
- **Status Chips**: Visual indicators for pet availability
- **Image Gallery**: Swipeable image viewer
- **Loading States**: Proper loading and error handling

## Testing

Run tests with:
```bash
flutter test
```

## Building for Production

### Android APK
```bash
flutter build apk --release
```

### Android App Bundle
```bash
flutter build appbundle --release
```

## Code Generation

When you modify models or API services, regenerate code with:
```bash
flutter packages pub run build_runner build --delete-conflicting-outputs
```

## Security Considerations

- API keys should be stored securely (not implemented in this demo)
- Network security with HTTPS endpoints
- Input validation on all user inputs
- Proper error handling to prevent information leakage

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

## Getting Started

This project is a starting point for a Flutter application.

A few resources to get you started if this is your first Flutter project:

- [Lab: Write your first Flutter app](https://docs.flutter.dev/get-started/codelab)
- [Cookbook: Useful Flutter samples](https://docs.flutter.dev/cookbook)

For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
