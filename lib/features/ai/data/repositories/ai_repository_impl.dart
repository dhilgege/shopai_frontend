import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/exceptions.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/ai/domain/repositories/ai_repository.dart';
import 'package:shopai_fe/features/ai/data/datasources/remote/ai_remote_datasource.dart';
import 'package:shopai_fe/features/product/domain/repositories/product_repository.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDatasource remoteDatasource;
  final ProductRepository productRepository;
  AIRepositoryImpl({required this.remoteDatasource, required this.productRepository});
  @override
  Future<Either<Failure, String>> sendMessage(String message) async {
    try {
      // First fetch products
      final productsResult = await productRepository.getProducts();
      final products = productsResult.fold(
        (failure) => <Product>[], // Proceed with empty list if fetch fails
        (productList) => productList,
      );

      final result = await remoteDatasource.sendMessage(message, products);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
