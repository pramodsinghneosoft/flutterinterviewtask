import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/datasource/DataSource.dart';
import 'package:flutterinterviewtask/data/model/app_result.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';
import 'package:flutterinterviewtask/domain/entities/error_response.dart';
import 'package:flutterinterviewtask/presenter/util/url_constant.dart';
import 'package:http/http.dart';

class RemoteDatasource extends Datasource {
  Future<bool> checkInternet() async {
    try {
      final result = await InternetAddress.lookup("www.google.com");
      if (result.isNotEmpty && result[0].rawAddress.isNotEmpty) {
        return true;
      }
    } on SocketException catch (_) {
      return false;
    }

    throw UnimplementedError();
  }

  bool _authError(int status, BuildContext context) {
    if (status == 401) {
      return true;
    }
    return false;
  }

  @override
  Future<AppResult<List<BreweryModel>>> getBreweryData(
      BuildContext context) async {
    // var status = await checkInternet();
    // if (!status) {
    //   print("Wifi/data not connected");
    // }
    Response response = await get(UrlConstant.baserUrl);
    if (response.statusCode == 200) {
      if (_authError(response.statusCode, context)) {
        return AppResult.failure("", response.statusCode);
      }
      // If the call to the server was successful, parse the JSON.
      final parsed = jsonDecode(response.body) as List;
      List<BreweryModel> data =
          parsed.map((e) => BreweryModel.fromJson(e)).toList();
      print(data);
      return AppResult.success(data);
    } else {
      final json = jsonDecode(response.body);
      ErrorModel data = ErrorModel.fromJson(json);
      return AppResult.failure(data.message, data.statusCode);
    }
  }
}
