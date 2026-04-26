/**
 * Get Products UseCase
 */
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/core/usecases/usecase.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';
import 'package:shopai_fe/features/product/domain/repositories/product_repository.dart';

class GetProducts extends UseCase<Either<Failure, List<Product>>, NoParams> {
  final ProductRepository repository;

  GetProducts(this.repository);

  @override
  Future<Either<Failure, List<Product>>> call(NoParams params) {
    return repository.getProducts();
  }
}
