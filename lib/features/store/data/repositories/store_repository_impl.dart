import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/order.dart' as entities;
import '../../domain/repositories/store_repository.dart';
import '../datasources/store_api_service.dart';
import '../models/order_model.dart';

class StoreRepositoryImpl implements StoreRepository {
  final StoreApiService apiService;

  StoreRepositoryImpl({required this.apiService});

  @override
  Future<Either<Failure, entities.Order>> placeOrder(entities.Order order) async {
    try {
      final orderModel = OrderModel.fromEntity(order);
      final result = await apiService.placeOrder(orderModel);
      return Right(result.toEntity());
    } catch (e) {
      return Left(ServerFailure(message: 'Failed to place order'));
    }
  }
}