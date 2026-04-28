import 'package:dartz/dartz.dart';
import 'package:flutter/widgets.dart';
import 'package:shopai_fe/core/error/failure.dart';
import '../../../../core/usecases/usecase.dart';
import '../repositories/ai_repository.dart';

class SendMessage implements UseCase<String, String> {
  final AIRepository repository;

  SendMessage(this.repository);

  @override
  Future<Either<Failure, String>> CallbackAction(String params) async {
    return repository.sendMessage(params);
  }
  
  @override
  Future<String> call(String 
  ) {
    // TODO: implement call
    throw UnimplementedError();
  }
}