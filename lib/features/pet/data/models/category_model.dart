import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/category.dart' as entities;

part 'category_model.g.dart';

@JsonSerializable()
class CategoryModel extends entities.Category {
  const CategoryModel({
    super.id,
    super.name,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) =>
      _$CategoryModelFromJson(json);

  Map<String, dynamic> toJson() => _$CategoryModelToJson(this);

  entities.Category toEntity() {
    return entities.Category(
      id: id,
      name: name,
    );
  }

  factory CategoryModel.fromEntity(entities.Category category) {
    return CategoryModel(
      id: category.id,
      name: category.name,
    );
  }
}