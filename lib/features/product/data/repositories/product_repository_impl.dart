/**
 * Product Repository Implementation
 */
import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/exceptions.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/product/data/datasources/remote/product_remote_datasource.dart';
import 'package:shopai_fe/features/product/data/models/product_model.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';
import 'package:shopai_fe/features/product/domain/repositories/product_repository.dart';

class ProductRepositoryImpl implements ProductRepository {
  final ProductRemoteDatasource remoteDatasource;

  ProductRepositoryImpl({required this.remoteDatasource});

  @override
  Future<Either<Failure, List<Product>>> getProducts() async {
    try {
      final result = await remoteDatasource.getProducts();
      return Right(result.map((model) => _toEntity(model)).toList());
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> getProduct(String id) async {
    try {
      final result = await remoteDatasource.getProduct(id);
      return Right(_toEntity(result));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> createProduct(Map<String, dynamic> data) async {
    try {
      final result = await remoteDatasource.createProduct(data);
      return Right(_toEntity(result));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, Product>> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final result = await remoteDatasource.updateProduct(id, data);
      return Right(_toEntity(result));
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  @override
  Future<Either<Failure, void>> deleteProduct(String id) async {
    try {
      await remoteDatasource.deleteProduct(id);
      return const Right(null);
    } on ServerException {
      return Left(ServerFailure());
    }
  }

  Product _toEntity(ProductModel model) {
    return Product(
      id: model.id,
      name: model.name,
      description: model.description,
      price: model.price,
      stock: model.stock,
      imageUrl: model.imageUrl,
      category: model.category,
      createdAt: model.createdAt,
      updatedAt: model.updatedAt,
    );
  }
}

