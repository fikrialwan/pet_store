import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../entities/login_credentials.dart';
import '../repositories/auth_repository.dart';

class LoginUser implements UseCase<AuthUser, LoginCredentials> {
  final AuthRepository repository;

  LoginUser(this.repository);

  @override
  Future<Either<Failure, AuthUser>> call(LoginCredentials params) async {
    return await repository.login(params);
  }
}