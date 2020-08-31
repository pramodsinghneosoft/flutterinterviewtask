import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/model/app_result.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';

abstract class Datasource {
  Future<AppResult<List<BreweryModel>>> getBreweryData(BuildContext context);
}
