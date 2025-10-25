import 'package:flutter_bloc/flutter_bloc.dart';
import '../../domain/usecases/find_pets_by_status.dart';
import '../../domain/usecases/find_pets_by_tags.dart';
import '../../domain/usecases/get_pet_by_id.dart';
import 'pet_event.dart';
import 'pet_state.dart';

class PetBloc extends Bloc<PetEvent, PetState> {
  final FindPetsByStatus findPetsByStatus;
  final FindPetsByTags findPetsByTags;
  final GetPetById getPetById;

  PetBloc({
    required this.findPetsByStatus,
    required this.findPetsByTags,
    required this.getPetById,
  }) : super(PetInitial()) {
    on<LoadPets>(_onLoadPets);
    on<LoadPetsByTags>(_onLoadPetsByTags);
    on<LoadPetById>(_onLoadPetById);
  }

  Future<void> _onLoadPets(LoadPets event, Emitter<PetState> emit) async {
    emit(PetLoading());
    
    final result = await findPetsByStatus(
      FindPetsByStatusParams(status: event.status),
    );
    
    result.fold(
      (failure) => emit(PetError(message: failure.toString())),
      (pets) => emit(PetLoaded(pets: pets)),
    );
  }

  Future<void> _onLoadPetById(LoadPetById event, Emitter<PetState> emit) async {
    emit(PetLoading());
    
    final result = await getPetById(
      GetPetByIdParams(petId: event.petId),
    );
    
    result.fold(
      (failure) => emit(PetError(message: failure.toString())),
      (pet) => emit(PetDetailLoaded(pet: pet)),
    );
  }

  Future<void> _onLoadPetsByTags(LoadPetsByTags event, Emitter<PetState> emit) async {
    emit(PetLoading());
    
    final result = await findPetsByTags(
      FindPetsByTagsParams(tags: event.tags),
    );
    
    result.fold(
      (failure) => emit(PetError(message: failure.toString())),
      (pets) => emit(PetLoaded(pets: pets)),
    );
  }
}