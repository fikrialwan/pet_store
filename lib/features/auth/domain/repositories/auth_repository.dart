import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/auth_user.dart';
import '../entities/login_credentials.dart';

abstract class AuthRepository {
  Future<Either<Failure, AuthUser>> login(LoginCredentials credentials);
  Future<Either<Failure, void>> logout();
  Future<Either<Failure, AuthUser?>> getCurrentUser();
  Future<Either<Failure, AuthUser?>> fetchAndSaveCurrentUser();
  Future<Either<Failure, bool>> isLoggedIn();
}