import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';

abstract class AIRepository {
  Future<Either<Failure, String>> sendMessage(String message);
}