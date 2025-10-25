import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/pet.dart' as entities;
import '../../domain/entities/pet.dart' show PetStatus;
import 'category_model.dart';
import 'tag_model.dart';

part 'pet_model.g.dart';

@JsonSerializable()
class PetModel extends entities.Pet {
  @JsonKey(name: 'category')
  final CategoryModel? categoryModel;
  
  @JsonKey(name: 'tags')
  final List<TagModel>? tagModels;

  const PetModel({
    super.id,
    required super.name,
    this.categoryModel,
    required super.photoUrls,
    this.tagModels,
    super.status,
  }) : super(
          category: categoryModel,
          tags: tagModels,
        );

  factory PetModel.fromJson(Map<String, dynamic> json) =>
      _$PetModelFromJson(json);

  Map<String, dynamic> toJson() => _$PetModelToJson(this);

  entities.Pet toEntity() {
    return entities.Pet(
      id: id,
      name: name,
      category: categoryModel?.toEntity(),
      photoUrls: photoUrls,
      tags: tagModels?.map((tag) => tag.toEntity()).toList(),
      status: status,
    );
  }

  factory PetModel.fromEntity(entities.Pet pet) {
    return PetModel(
      id: pet.id,
      name: pet.name,
      categoryModel: pet.category != null 
          ? CategoryModel.fromEntity(pet.category!)
          : null,
      photoUrls: pet.photoUrls,
      tagModels: pet.tags?.map((tag) => TagModel.fromEntity(tag)).toList(),
      status: pet.status,
    );
  }
}