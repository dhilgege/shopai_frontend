import 'package:dio/dio.dart';
import 'package:shopai_fe/features/product/data/models/product_model.dart';

abstract class ProductRemoteDatasource {
  Future<List<ProductModel>> getProducts();
  Future<ProductModel> getProduct(String id);
  Future<ProductModel> createProduct(Map<String, dynamic> data);
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> data);
  Future<void> deleteProduct(String id);
}

class ProductRemoteDatasourceImpl implements ProductRemoteDatasource {
  final Dio dio;

  ProductRemoteDatasourceImpl({required this.dio});

  @override
  Future<List<ProductModel>> getProducts() async {
    try {
      final response = await dio.get('/products');

      final raw = response.data;

      // handle Laravel: {data: [...]} atau langsung [...]
      final List items = raw is Map ? raw['data'] : raw;

      return items
          .map((e) => ProductModel.fromJson(e))
          .toList()
          .cast<ProductModel>();
    } catch (e) {
      throw Exception('Failed to load products: $e');
    }


  }

  @override
  Future<ProductModel> getProduct(String id) async {
    try {
      final response = await dio.get('/products/$id');

      final raw = response.data;

      return ProductModel.fromJson(
        raw is Map && raw.containsKey('data') ? raw['data'] : raw,
      );
    } catch (e) {
      throw Exception('Failed to load product: $e');
    }
  }

  @override
  Future<ProductModel> createProduct(Map<String, dynamic> data) async {
    try {
      final response = await dio.post('/products', data: data);

      final raw = response.data;

      return ProductModel.fromJson(
        raw is Map && raw.containsKey('data') ? raw['data'] : raw,
      );
    } catch (e) {
      throw Exception('Failed to create product: $e');
    }
  }

  @override
  Future<ProductModel> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final response = await dio.put('/products/$id', data: data);

      final raw = response.data;

      return ProductModel.fromJson(
        raw is Map && raw.containsKey('data') ? raw['data'] : raw,
      );
    } catch (e) {
      throw Exception('Failed to update product: $e');
    }
  }

  @override
  Future<void> deleteProduct(String id) async {
    try {
      await dio.delete('/products/$id');
    } catch (e) {
      throw Exception('Failed to delete product: $e');
    }
  }
}