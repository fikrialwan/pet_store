import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/order.dart' as entities;
import '../../domain/entities/order.dart' show OrderStatus;

part 'order_model.g.dart';

@JsonSerializable()
class OrderModel extends entities.Order {
  const OrderModel({
    super.id,
    super.petId,
    super.quantity,
    super.shipDate,
    super.status,
    super.complete,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) =>
      _$OrderModelFromJson(json);

  Map<String, dynamic> toJson() => _$OrderModelToJson(this);

  factory OrderModel.fromEntity(entities.Order order) {
    return OrderModel(
      id: order.id,
      petId: order.petId,
      quantity: order.quantity,
      shipDate: order.shipDate,
      status: order.status,
      complete: order.complete,
    );
  }

  entities.Order toEntity() {
    return entities.Order(
      id: id,
      petId: petId,
      quantity: quantity,
      shipDate: shipDate,
      status: status,
      complete: complete,
    );
  }
}