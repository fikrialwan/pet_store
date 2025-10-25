// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'pet_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PetModel _$PetModelFromJson(Map<String, dynamic> json) => PetModel(
      id: (json['id'] as num?)?.toInt(),
      name: json['name'] as String,
      categoryModel: json['category'] == null
          ? null
          : CategoryModel.fromJson(json['category'] as Map<String, dynamic>),
      photoUrls:
          (json['photoUrls'] as List<dynamic>).map((e) => e as String).toList(),
      tagModels: (json['tags'] as List<dynamic>?)
          ?.map((e) => TagModel.fromJson(e as Map<String, dynamic>))
          .toList(),
      status: $enumDecodeNullable(_$PetStatusEnumMap, json['status']),
    );

Map<String, dynamic> _$PetModelToJson(PetModel instance) => <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'photoUrls': instance.photoUrls,
      'status': _$PetStatusEnumMap[instance.status],
      'category': instance.categoryModel,
      'tags': instance.tagModels,
    };

const _$PetStatusEnumMap = {
  PetStatus.available: 'available',
  PetStatus.pending: 'pending',
  PetStatus.sold: 'sold',
};
