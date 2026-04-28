import 'package:dio/dio.dart';

abstract class AIRemoteDatasource {
  Future<String> sendMessage(String message);
}

class AIRemoteDatasourceImpl implements AIRemoteDatasource {
  final Dio dio;

  AIRemoteDatasourceImpl({required this.dio});

  @override
  Future<String> sendMessage(String message) async {
    try {
      final response = await dio.post(
        '/ai/chat',
        data: {
          'message': message,
          'user_id': 1,
        },
      );

      final data = response.data;

      final messageText = (data is Map<String, dynamic>)
          ? (data['data']?['message'] ??
              data['data']?['response'] ??
              data['data']?['text'] ??
              data['message'] ??
              data['response'] ??
              data['text'])
          : null;

      return messageText?.toString() ?? 'No response from AI';
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