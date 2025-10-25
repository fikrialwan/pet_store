import 'package:equatable/equatable.dart';

abstract class PetEvent extends Equatable {
  const PetEvent();

  @override
  List<Object> get props => [];
}

class LoadPets extends PetEvent {
  final List<String> status;
  
  const LoadPets({this.status = const ['available']});
  
  @override
  List<Object> get props => [status];
}

class LoadPetById extends PetEvent {
  final int petId;
  
  const LoadPetById({required this.petId});
  
  @override
  List<Object> get props => [petId];
}

class LoadPetsByTags extends PetEvent {
  final List<String> tags;
  
  const LoadPetsByTags({required this.tags});
  
  @override
  List<Object> get props => [tags];
}