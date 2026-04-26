/**
 * Dependency Injection Container - GetIt
 */
import 'package:get_it/get_it.dart';
import 'package:dio/dio.dart';
import 'package:shopai_fe/core/network/dio_client.dart';

// Product Feature
import '../features/product/data/datasources/remote/product_remote_datasource.dart';
import '../features/product/data/repositories/product_repository_impl.dart';
import '../features/product/domain/repositories/product_repository.dart';
import '../features/product/domain/usecases/get_products.dart';
import '../features/product/presentation/bloc/product_bloc.dart';

final sl = GetIt.instance;

Future<void> init() async {
  // Core
  sl.registerSingleton<DioClient>(DioClient());
  sl.registerSingleton<Dio>(sl<DioClient>().dio);

  // Product Data sources
  sl.registerLazySingleton<ProductRemoteDatasource>(
    () => ProductRemoteDatasourceImpl(dio: sl()),
  );

  // Product Repository
  sl.registerLazySingleton<ProductRepository>(
    () => ProductRepositoryImpl(remoteDatasource: sl()),
  );

  // Product Use cases
  sl.registerLazySingleton(() => GetProducts(sl<ProductRepository>()));

  // Product BLoC
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(getProducts: sl<GetProducts>()),
  );
}

