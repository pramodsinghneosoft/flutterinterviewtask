import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/datasource/RemoteDatasource.dart';
import 'package:flutterinterviewtask/data/di/factory.dart';
import 'package:flutterinterviewtask/data/model/app_result.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';

class UserRepository {
  final RemoteDatasource remoteDatasource =
      ObjectFactory.provideRemoteDatasource();

  Future<AppResult<List<BreweryModel>>> performBrewery(BuildContext context) {
    return remoteDatasource.getBreweryData(context);
  }
}
