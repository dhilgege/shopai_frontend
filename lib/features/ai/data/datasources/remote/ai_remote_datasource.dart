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
        },
      );

      final raw = response.data;

      // handle Laravel: {data: {...}} atau langsung [...]
      final responseText = raw is Map && raw.containsKey('data')
          ? raw['data']['response'] ?? raw['data']['text'] ?? ''
          : raw['response'] ?? raw['text'] ?? '';

      return responseText.toString();
    } catch (e) {
      throw Exception('Failed to send message to AI: $e');
    }
  }
}