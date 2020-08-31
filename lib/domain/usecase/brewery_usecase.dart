import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/model/app_result.dart';
import 'package:flutterinterviewtask/data/repositories/user_repository.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';

class BreweryUsecase {
  final UserRepository repository;

  BreweryUsecase(this.repository);

  Future<AppResult<List<BreweryModel>>> execute(BuildContext context) async {
    final response = await repository.performBrewery(context);
    switch (response.status) {
      case Status.SUCESS:
        // print(response.data.data);
        return AppResult.success(response.data);
        break;
      default:
        return AppResult.failure(response.message, response.statusCode);
        break;
    }
  }
}
