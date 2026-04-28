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
import '../features/product/domain/usecases/create_product.dart';
import '../features/product/domain/usecases/update_product.dart';
import '../features/product/domain/usecases/delete_product.dart';
import '../features/product/presentation/bloc/product_bloc.dart';

// AI Feature
import '../features/ai/data/datasources/remote/ai_remote_datasource.dart';
import '../features/ai/data/repositories/ai_repository_impl.dart';
import '../features/ai/domain/repositories/ai_repository.dart';
import '../features/ai/domain/usecases/send_message.dart';
import '../features/ai/presentation/bloc/chat/chat_bloc.dart';

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
  sl.registerLazySingleton(() => CreateProduct(sl<ProductRepository>()));
  sl.registerLazySingleton(() => UpdateProduct(sl<ProductRepository>()));
  sl.registerLazySingleton(() => DeleteProduct(sl<ProductRepository>()));

  // Product BLoC
  sl.registerLazySingleton<ProductBloc>(
    () => ProductBloc(
      getProducts: sl<GetProducts>(),
      createProduct: sl<CreateProduct>(),
      updateProduct: sl<UpdateProduct>(),
      deleteProduct: sl<DeleteProduct>(),
    ),
  );

  // AI Data sources
  sl.registerLazySingleton<AIRemoteDatasource>(
    () => AIRemoteDatasourceImpl(dio: sl()),
  );

  // AI Repository
  sl.registerLazySingleton<AIRepository>(
    () => AIRepositoryImpl(remoteDatasource: sl()),
  );

  // AI Use cases
  sl.registerLazySingleton(() => SendMessage(sl<AIRepository>()));

  // AI BLoC
  sl.registerLazySingleton<ChatBloc>(
    () => ChatBloc(sendMessage: sl<SendMessage>()),
  );
}