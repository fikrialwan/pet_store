import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/pet.dart';

abstract class PetRepository {
  Future<Either<Failure, Pet>> getPetById(int petId);
  Future<Either<Failure, List<Pet>>> findPetsByStatus(List<String> status);
  Future<Either<Failure, List<Pet>>> findPetsByTags(List<String> tags);
}