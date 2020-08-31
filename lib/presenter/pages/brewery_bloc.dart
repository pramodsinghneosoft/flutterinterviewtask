import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/di/factory.dart';
import 'package:flutterinterviewtask/data/model/app_result.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';
import 'package:flutterinterviewtask/domain/usecase/brewery_usecase.dart';

class BreweryBloc {
  StreamController<List<BreweryModel>> streamcontroller =
      StreamController<List<BreweryModel>>.broadcast();

  BreweryUsecase _usecase = ObjectFactory.provideBreweryUsecase();

  void onDispose() {
    streamcontroller.close();
  }

  void getBreweryResponse(BuildContext context) async {
    final response = await _usecase.execute(context);
    switch (response.status) {
      case Status.SUCESS:
        streamcontroller.sink.add(response.data);
        break;
      case Status.FAILURE:
        break;
    }
  }
}
