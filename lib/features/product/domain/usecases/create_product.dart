/**
 * Create Product UseCase
 */
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/product/domain/repositories/product_repository.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';

class CreateProduct {
  final ProductRepository repository;

  CreateProduct(this.repository);

  Future<Either<Failure, Product>> call(Map<String, dynamic> data) {
    return repository.createProduct(data);
  }
}
