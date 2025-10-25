import 'package:equatable/equatable.dart';
import 'package:json_annotation/json_annotation.dart';

enum OrderStatus { 
  @JsonValue('pending')
  pending, 
  @JsonValue('available')
  available, 
  @JsonValue('sold')
  sold 
}

class Order extends Equatable {
  final int? id;
  final int? petId;
  final int? quantity;
  final DateTime? shipDate;
  final OrderStatus? status;
  final bool? complete;

  const Order({
    this.id,
    this.petId,
    this.quantity,
    this.shipDate,
    this.status,
    this.complete,
  });

  @override
  List<Object?> get props => [id, petId, quantity, shipDate, status, complete];

  Order copyWith({
    int? id,
    int? petId,
    int? quantity,
    DateTime? shipDate,
    OrderStatus? status,
    bool? complete,
  }) {
    return Order(
      id: id ?? this.id,
      petId: petId ?? this.petId,
      quantity: quantity ?? this.quantity,
      shipDate: shipDate ?? this.shipDate,
      status: status ?? this.status,
      complete: complete ?? this.complete,
    );
  }
}