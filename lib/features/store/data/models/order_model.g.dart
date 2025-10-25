// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

OrderModel _$OrderModelFromJson(Map<String, dynamic> json) => OrderModel(
      id: (json['id'] as num?)?.toInt(),
      petId: (json['petId'] as num?)?.toInt(),
      quantity: (json['quantity'] as num?)?.toInt(),
      shipDate: json['shipDate'] == null
          ? null
          : DateTime.parse(json['shipDate'] as String),
      status: $enumDecodeNullable(_$OrderStatusEnumMap, json['status']),
      complete: json['complete'] as bool?,
    );

Map<String, dynamic> _$OrderModelToJson(OrderModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'petId': instance.petId,
      'quantity': instance.quantity,
      'shipDate': instance.shipDate?.toIso8601String(),
      'status': _$OrderStatusEnumMap[instance.status],
      'complete': instance.complete,
    };

const _$OrderStatusEnumMap = {
  OrderStatus.pending: 'pending',
  OrderStatus.available: 'available',
  OrderStatus.sold: 'sold',
};
