/**
 * Delete Product UseCase
 */
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/product/domain/repositories/product_repository.dart';

class DeleteProduct {
  final ProductRepository repository;

  DeleteProduct(this.repository);

  Future<Either<Failure, void>> call(String id) {
    return repository.deleteProduct(id);
  }
}
