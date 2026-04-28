/**
 * Update Product UseCase
 */
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/product/domain/repositories/product_repository.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';

class UpdateProduct {
  final ProductRepository repository;

  UpdateProduct(this.repository);

  Future<Either<Failure, Product>> call(String id, Map<String, dynamic> data) {
    return repository.updateProduct(id, data);
  }
}
