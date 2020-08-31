import 'dart:async';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';

class ConstantValue {
  static Future<bool> checkInternet() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return false;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    } else {
      return false;
    }
  }

  static Future<bool> checkInternetStatus() async {
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

  static Future<bool> checkConnectivity(context) async {
    String connectionStatus;
    StreamSubscription<ConnectivityResult> _connectivitySubscription;
    final Connectivity _connectivity = new Connectivity();
    try {
      connectionStatus = (await _connectivity.checkConnectivity()).toString();
      _connectivity.onConnectivityChanged.listen((ConnectivityResult result) {
        connectionStatus = result.toString();
        print(connectionStatus);
        if (connectionStatus == "ConnectivityResult.wifi") {
          return true;
        } else {
          return false;
        }
      });
    } on PlatformException catch (e) {
      print(e.toString());
      connectionStatus = 'Failed to get connectivity.';
    }
    if (connectionStatus == "ConnectivityResult.none") {}
  }
}
