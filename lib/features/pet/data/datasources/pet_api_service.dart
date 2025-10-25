import 'package:dio/dio.dart';
import 'package:retrofit/retrofit.dart';
import '../../../../core/config/api_config.dart';
import '../models/pet_model.dart';

part 'pet_api_service.g.dart';

@RestApi(baseUrl: ApiConfig.baseUrl)
abstract class PetApiService {
  factory PetApiService(Dio dio, {String baseUrl}) = _PetApiService;

  @GET('/pet/{petId}')
  Future<PetModel> getPetById(@Path('petId') int petId);

  @GET('/pet/findByStatus')
  Future<List<PetModel>> findPetsByStatus(
    @Query('status') List<String> status,
  );

  @GET('/pet/findByTags')
  Future<List<PetModel>> findPetsByTags(
    @Query('tags') List<String> tags,
  );
}