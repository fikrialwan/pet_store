import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/pet.dart';
import '../repositories/pet_repository.dart';

class FindPetsByTags implements UseCase<List<Pet>, FindPetsByTagsParams> {
  final PetRepository repository;

  FindPetsByTags(this.repository);

  @override
  Future<Either<Failure, List<Pet>>> call(FindPetsByTagsParams params) async {
    return await repository.findPetsByTags(params.tags);
  }
}

class FindPetsByTagsParams extends Equatable {
  final List<String> tags;

  const FindPetsByTagsParams({required this.tags});

  @override
  List<Object> get props => [tags];
}