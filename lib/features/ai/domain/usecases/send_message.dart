import 'package:dartz/dartz.dart';
import 'package:shopai_fe/core/error/failure.dart';
import 'package:shopai_fe/core/usecases/usecase.dart';
import 'package:shopai_fe/features/ai/domain/repositories/ai_repository.dart';

class SendMessage implements UseCase<Either<Failure, String>, String> {
  final AIRepository repository;
  SendMessage(this.repository);
  @override
  Future<Either<Failure, String>> call(String params) async {
    return repository.sendMessage(params);
  }
}
