/**
 * Product Repository Interface
 */
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';

abstract class ProductRepository {
  Future<Either<Failure, List<Product>>> getProducts();
  Future<Either<Failure, Product>> getProduct(String id);
  Future<Either<Failure, Product>> createProduct(Map<String, dynamic> data);
  Future<Either<Failure, Product>> updateProduct(String id, Map<String, dynamic> data);
  Future<Either<Failure, void>> deleteProduct(String id);
}
