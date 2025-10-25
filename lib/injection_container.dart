import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/config/api_config.dart';
import 'features/pet/data/datasources/pet_api_service.dart';
import 'features/pet/data/repositories/pet_repository_impl.dart';
import 'features/pet/domain/repositories/pet_repository.dart';
import 'features/pet/domain/usecases/find_pets_by_status.dart';
import 'features/pet/domain/usecases/find_pets_by_tags.dart';
import 'features/pet/domain/usecases/get_pet_by_id.dart';
import 'features/pet/presentation/bloc/pet_bloc.dart';

import 'features/auth/data/datasources/auth_api_service.dart';
import 'features/auth/data/datasources/auth_local_data_source.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/auth/domain/usecases/get_current_user.dart';
import 'features/auth/domain/usecases/login_user.dart';
import 'features/auth/domain/usecases/logout_user.dart';
import 'features/auth/presentation/bloc/auth_bloc.dart';

import 'features/store/data/datasources/store_api_service.dart';
import 'features/store/data/repositories/store_repository_impl.dart';
import 'features/store/domain/repositories/store_repository.dart';
import 'features/store/domain/usecases/place_order.dart';

final getIt = GetIt.instance;

Future<void> setupServiceLocator() async {
  // External dependencies
  final sharedPreferences = await SharedPreferences.getInstance();
  getIt.registerLazySingleton<SharedPreferences>(() => sharedPreferences);
  // External dependencies
  getIt.registerLazySingleton<Dio>(() {
    final dio = Dio();
    dio.options.baseUrl = ApiConfig.baseUrl;
    dio.options.connectTimeout = const Duration(seconds: 30);
    dio.options.receiveTimeout = const Duration(seconds: 30);
    
    // Add logging interceptor to see the actual requests
    dio.interceptors.add(LogInterceptor(
      requestBody: true,
      responseBody: true,
      logPrint: (obj) {
        // In production, consider using a proper logging framework
        // For now, we'll disable console logging to follow linting rules
      },
    ));
    
    return dio;
  });

  // Data sources
  getIt.registerLazySingleton<PetApiService>(
    () => PetApiService(getIt<Dio>(), baseUrl: ApiConfig.baseUrl),
  );
  
  getIt.registerLazySingleton<AuthApiService>(
    () => AuthApiService(getIt<Dio>(), baseUrl: ApiConfig.baseUrl),
  );
  
  getIt.registerLazySingleton<StoreApiService>(
    () => StoreApiService(getIt<Dio>(), baseUrl: ApiConfig.baseUrl),
  );
  
  getIt.registerLazySingleton<AuthLocalDataSource>(
    () => AuthLocalDataSourceImpl(sharedPreferences: getIt<SharedPreferences>()),
  );

  // Repositories
  getIt.registerLazySingleton<PetRepository>(
    () => PetRepositoryImpl(apiService: getIt<PetApiService>()),
  );
  
  getIt.registerLazySingleton<AuthRepository>(
    () => AuthRepositoryImpl(
      apiService: getIt<AuthApiService>(),
      localDataSource: getIt<AuthLocalDataSource>(),
    ),
  );
  
  getIt.registerLazySingleton<StoreRepository>(
    () => StoreRepositoryImpl(apiService: getIt<StoreApiService>()),
  );

  // Use cases
  getIt.registerLazySingleton(() => FindPetsByStatus(getIt<PetRepository>()));
  getIt.registerLazySingleton(() => FindPetsByTags(getIt<PetRepository>()));
  getIt.registerLazySingleton(() => GetPetById(getIt<PetRepository>()));
  
  getIt.registerLazySingleton(() => LoginUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => LogoutUser(getIt<AuthRepository>()));
  getIt.registerLazySingleton(() => GetCurrentUser(getIt<AuthRepository>()));
  
  getIt.registerLazySingleton(() => PlaceOrder(getIt<StoreRepository>()));

  // BLoCs
  getIt.registerFactory(
    () => PetBloc(
      findPetsByStatus: getIt<FindPetsByStatus>(),
      findPetsByTags: getIt<FindPetsByTags>(),
      getPetById: getIt<GetPetById>(),
    ),
  );
  
  getIt.registerLazySingleton(
    () => AuthBloc(
      loginUser: getIt<LoginUser>(),
      logoutUser: getIt<LogoutUser>(),
      getCurrentUser: getIt<GetCurrentUser>(),
    ),
  );
}