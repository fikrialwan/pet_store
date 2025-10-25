import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import '../../../../core/error/failures.dart';
import '../../domain/entities/pet.dart';
import '../../domain/repositories/pet_repository.dart';
import '../datasources/pet_api_service.dart';

class PetRepositoryImpl implements PetRepository {
  final PetApiService apiService;

  PetRepositoryImpl({required this.apiService});

  Failure _handleError(Object error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
        case DioExceptionType.sendTimeout:
        case DioExceptionType.receiveTimeout:
          return ServerFailure(
            message: 'Connection timeout. Please check your internet connection.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.connectionError:
          return ServerFailure(
            message: 'Unable to connect to server. Please check your internet connection.',
            statusCode: error.response?.statusCode,
          );
        case DioExceptionType.badResponse:
          final statusCode = error.response?.statusCode;
          switch (statusCode) {
            case 400:
              return ServerFailure(
                message: 'Bad request. Please check your input.',
                statusCode: statusCode,
              );
            case 401:
              return ServerFailure(
                message: 'Unauthorized. Please login again.',
                statusCode: statusCode,
              );
            case 403:
              return ServerFailure(
                message: 'Access denied.',
                statusCode: statusCode,
              );
            case 404:
              return ServerFailure(
                message: 'Pet not found.',
                statusCode: statusCode,
              );
            case 500:
              return ServerFailure(
                message: 'Server error. Please try again later.',
                statusCode: statusCode,
              );
            default:
              return ServerFailure(
                message: error.message ?? 'Unknown server error occurred',
                statusCode: statusCode,
              );
          }
        default:
          return ServerFailure(
            message: error.message ?? 'Network error occurred',
            statusCode: error.response?.statusCode,
          );
      }
    }
    
    return ServerFailure(message: error.toString());
  }

  @override
  Future<Either<Failure, Pet>> getPetById(int petId) async {
    try {
      final result = await apiService.getPetById(petId);
      return Right(result.toEntity());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Pet>>> findPetsByStatus(List<String> status) async {
    try {
      final result = await apiService.findPetsByStatus(status);
      return Right(result.map((petModel) => petModel.toEntity()).toList());
    } catch (e) {
      return Left(_handleError(e));
    }
  }

  @override
  Future<Either<Failure, List<Pet>>> findPetsByTags(List<String> tags) async {
    try {
      final result = await apiService.findPetsByTags(tags);
      return Right(result.map((petModel) => petModel.toEntity()).toList());
    } catch (e) {
      return Left(_handleError(e));
    }
  }
}