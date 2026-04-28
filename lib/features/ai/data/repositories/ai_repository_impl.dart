import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/exceptions.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/features/ai/domain/repositories/ai_repository.dart';
import 'package:shopai_fe/features/ai/data/datasources/remote/ai_remote_datasource.dart';

class AIRepositoryImpl implements AIRepository {
  final AIRemoteDatasource remoteDatasource;
  AIRepositoryImpl({required this.remoteDatasource});
  @override
  Future<Either<Failure, String>> sendMessage(String message) async {
    try {
      final result = await remoteDatasource.sendMessage(message);
      return Right(result);
    } on ServerException {
      return Left(ServerFailure());
    }
  }
}
