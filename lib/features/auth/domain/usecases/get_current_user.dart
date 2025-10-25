import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/auth_user.dart';
import '../repositories/auth_repository.dart';

class GetCurrentUser implements UseCase<AuthUser?, NoParams> {
  final AuthRepository repository;

  GetCurrentUser(this.repository);

  @override
  Future<Either<Failure, AuthUser?>> call(NoParams params) async {
    // First try to get user from local storage
    final localUserResult = await repository.getCurrentUser();
    
    return localUserResult.fold(
      (failure) => Left(failure),
      (localUser) async {
        if (localUser != null) {
          // User exists locally, fetch and save updated info
          final updatedUserResult = await repository.fetchAndSaveCurrentUser();
          return updatedUserResult.fold(
            (failure) => Right(localUser), // Return local user if fetch fails
            (updatedUser) => Right(updatedUser), // Return updated user if fetch succeeds
          );
        } else {
          // No local user found
          return Right(null);
        }
      },
    );
  }
}