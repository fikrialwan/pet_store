import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/auth_user.dart';
import '../../domain/entities/login_credentials.dart';
import '../../domain/repositories/auth_repository.dart';
import '../datasources/auth_api_service.dart';
import '../datasources/auth_local_data_source.dart';
import '../models/auth_user_model.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthApiService apiService;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.apiService,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, AuthUser>> login(LoginCredentials credentials) async {
    try {
      // Call the login API directly
      await apiService.login(
        credentials.username,
        credentials.password,
      );

      // Create user model with basic info
      final user = AuthUserModel.fromLoginResponse(
        username: credentials.username,
        email: '${credentials.username}@petstore.com', // Default email format
        firstName: credentials.username,
        lastName: '',
      );

      await localDataSource.saveUser(user);
      return Right(user.toEntity());
    } on DioException catch (e) {
      // Handle login-specific errors
      if (e.response?.statusCode == 400) {
        return Left(ServerFailure(
          message: 'Invalid username or password',
          statusCode: 400,
        ));
      }
      return Left(ServerFailure(
        message: e.response?.data?['message'] ?? 'Login failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, void>> logout() async {
    try {
      await apiService.logout();
      await localDataSource.removeUser();
      return const Right(null);
    } on DioException catch (e) {
      // Even if API logout fails, remove local user data
      await localDataSource.removeUser();
      return Left(ServerFailure(
        message: e.message ?? 'Logout failed',
        statusCode: e.response?.statusCode,
      ));
    } catch (e) {
      await localDataSource.removeUser();
      return Left(ServerFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> getCurrentUser() async {
    try {
      final user = await localDataSource.getUser();
      return Right(user?.toEntity());
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<Failure, AuthUser?>> fetchAndSaveCurrentUser() async {
    try {
      // Get current user from local storage to get username
      final currentUser = await localDataSource.getUser();
      if (currentUser == null) {
        return Left(CacheFailure(message: 'No user logged in'));
      }

      // For now, we'll create an updated user model with current timestamp
      // In a real app, you would fetch user details from an API endpoint
      final updatedUser = AuthUserModel(
        username: currentUser.username,
        email: currentUser.email ?? '${currentUser.username}@petstore.com',
        firstName: currentUser.firstName ?? currentUser.username,
        lastName: currentUser.lastName ?? '',
        expiresAt: DateTime.now().add(const Duration(hours: 24)), // Refresh expiry
      );

      // Save the updated user info
      await localDataSource.saveUser(updatedUser);
      return Right(updatedUser.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to fetch user info: ${e.toString()}'));
    }
  }

  @override
  Future<Either<Failure, bool>> isLoggedIn() async {
    try {
      final isLoggedIn = await localDataSource.isLoggedIn();
      return Right(isLoggedIn);
    } catch (e) {
      return Left(CacheFailure(message: e.toString()));
    }
  }
}