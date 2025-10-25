import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/order.dart' as entities;

abstract class StoreRepository {
  Future<Either<Failure, entities.Order>> placeOrder(entities.Order order);
}