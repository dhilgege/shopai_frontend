import 'package:dio/dio.dart';
import 'package:shopai_fe/features/product/domain/entities/product.dart';

abstract class AIRemoteDatasource {
  Future<String> sendMessage(String message, List<Product> products);
}

class AIRemoteDatasourceImpl implements AIRemoteDatasource {
  final Dio dio;

  AIRemoteDatasourceImpl({required this.dio});

  @override
  Future<String> sendMessage(String message, List<Product> products) async {
    try {
      final productsData = products.map((product) => {
        'id': product.id,
        'name': product.name,
        'description': product.description,
        'price': product.price,
        'stock': product.stock,
        'image_url': product.imageUrl,
        'category': product.category,
        'created_at': product.createdAt?.toIso8601String(),
        'updated_at': product.updatedAt?.toIso8601String(),
      }).toList();

      final response = await dio.post(
        '/ai/chat',
        data: {
          'message': message,
          'products': productsData,
          'user_id': 1,
        },
      );

      final data = response.data;

      if (data is Map<String, dynamic>) {
        // ✅ NEW BACKEND FORMAT
        if (data.containsKey('reply')) {
          return (data['reply'] ?? 'No response from AI').toString();
        }

        // 🔁 fallback lama (jaga-jaga)
        final fallbackMessage =
            data['data']?['message'] ??
            data['message'] ??
            data['response'] ??
            data['text'];

        return fallbackMessage?.toString() ?? 'No response from AI';
      }

      return data?.toString() ?? 'No response from AI';

    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw Exception('Connection timeout');
      } else if (e.type == DioExceptionType.connectionError) {
        throw Exception('Tidak bisa connect ke backend Laravel');
      } else {
        throw Exception('AI Error: ${e.message}');
      }
    } catch (e) {
      throw Exception('Unexpected error: $e');
    }
  }
}