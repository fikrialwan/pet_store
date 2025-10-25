import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class GetPetById implements UseCase<Pet, GetPetByIdParams> {
  final PetRepository repository;

  GetPetById(this.repository);

  @override
  Future<Either<Failure, Pet>> call(GetPetByIdParams params) async {
    return await repository.getPetById(params.petId);
  }
}

class GetPetByIdParams extends Equatable {
  final int petId;

  const GetPetByIdParams({required this.petId});

  @override
  List<Object> get props => [petId];
}