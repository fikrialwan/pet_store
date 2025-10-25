import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/tag.dart' as entities;

part 'tag_model.g.dart';

@JsonSerializable()
class TagModel extends entities.Tag {
  const TagModel({
    super.id,
    super.name,
  });

  factory TagModel.fromJson(Map<String, dynamic> json) =>
      _$TagModelFromJson(json);

  Map<String, dynamic> toJson() => _$TagModelToJson(this);

  entities.Tag toEntity() {
    return entities.Tag(
      id: id,
      name: name,
    );
  }

  factory TagModel.fromEntity(entities.Tag tag) {
    return TagModel(
      id: tag.id,
      name: tag.name,
    );
  }
}