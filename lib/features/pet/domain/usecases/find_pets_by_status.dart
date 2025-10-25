import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class FindPetsByStatus implements UseCase<List<Pet>, FindPetsByStatusParams> {
  final PetRepository repository;

  FindPetsByStatus(this.repository);

  @override
  Future<Either<Failure, List<Pet>>> call(FindPetsByStatusParams params) async {
    return await repository.findPetsByStatus(params.status);
  }
}

class FindPetsByStatusParams extends Equatable {
  final List<String> status;

  const FindPetsByStatusParams({required this.status});

  @override
  List<Object> get props => [status];
}