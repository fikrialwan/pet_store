import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/order.dart' as entities;
import '../repositories/store_repository.dart';

class PlaceOrder implements UseCase<entities.Order, PlaceOrderParams> {
  final StoreRepository repository;

  PlaceOrder(this.repository);

  @override
  Future<Either<Failure, entities.Order>> call(PlaceOrderParams params) async {
    return await repository.placeOrder(params.order);
  }
}

class PlaceOrderParams {
  final entities.Order order;

  PlaceOrderParams({required this.order});
}