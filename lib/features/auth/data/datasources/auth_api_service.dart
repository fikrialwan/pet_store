import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/config/api_config.dart';

part 'auth_api_service.g.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class AuthApiService {
  factory AuthApiService(Dio dio, {String baseUrl}) = _AuthApiService;

  @GET('/user/login')
  Future<String> login(
    @Query('username') String username,
    @Query('password') String password,
  );

  @GET('/user/logout')
  Future<void> logout();
}