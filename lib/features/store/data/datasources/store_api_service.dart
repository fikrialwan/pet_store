import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/config/api_config.dart';
import '../models/order_model.dart';

part 'store_api_service.g.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class StoreApiService {
  factory StoreApiService(Dio dio, {String baseUrl}) = _StoreApiService;

  @POST('/store/order')
  Future<OrderModel> placeOrder(@Body() OrderModel order);
}