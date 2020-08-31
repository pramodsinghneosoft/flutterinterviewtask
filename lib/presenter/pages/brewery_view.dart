import 'dart:async';
import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/di/factory.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';
import 'package:flutterinterviewtask/presenter/util/constant.dart';
import 'package:flutterinterviewtask/presenter/widget/brewery_data.dart';
import 'package:idb_shim/idb_browser.dart';
import 'package:idb_shim/idb_client.dart';
import 'brewery_bloc.dart';

class BreweryView extends StatefulWidget {
  @override
  _BreweryViewState createState() => _BreweryViewState();
}

class _BreweryViewState extends State<BreweryView> {
  final BreweryBloc breweryBloc = ObjectFactory.provideBreweryBloc();
  List<BreweryModel> brewerList = [];
  List<BreweryModel> brewerList1 = [];
  Timer _timer;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  StreamSubscription<ConnectivityResult> _connectivitySubscription;

  static const String storeName = "records";
  Database db;
  var txn;
  var store;
  var key;
  Map value;
  bool isLoading = false;
  bool isConnection = false;
  bool isDataCleared = false;
  bool isLoader = false;

  @override
  void initState() {
    // checkInternet();
    getIndexedDb();
    getConcurrentValue();
    print("------init called----->");
    // callApi();
    super.initState();
  }

  checkInternet() {
    ConstantValue.checkInternet().then((value) {
      if (value != null) {
        if (value == true) {
          print("-------wifi connected------>");
          showInSnackBar("You are online");
        } else {
          print("no internet connected");
          showInSnackBar("You are offline");
        }
      } else {
        print("no internet connected");
        showInSnackBar("You are offline");
      }
    });
  }

  getConcurrentValue() {
    _timer = Timer.periodic(Duration(seconds: 5), (t) {
      setState(() {
        isLoader = true;
      });
      getIndexedDb();
    });
  }

  callApi() {
    breweryBloc.getBreweryResponse(context);
    breweryBloc.streamcontroller.stream.listen((event) {
      if (event != null) {
        _getData(event);
      } else {
        print("event null---->");
      }
    });
  }

  _getData(List<BreweryModel> event) async {
    setState(() {
      brewerList = event;
      print("-------Response------>");
      print(brewerList);
    });

    txn = db.transaction(storeName, "readwrite");
    store = txn.objectStore(storeName);
    String str = jsonEncode(brewerList);
    key = await store.put({"some": str});
    await txn.completed;

    getDatafromDB();
  }

  getIndexedDb() async {
    IdbFactory idbFactory = getIdbFactory();

    db = await idbFactory.open("my_records.db", version: 1,
        onUpgradeNeeded: (VersionChangeEvent event) {
      Database db = event.database;
      db.createObjectStore(storeName, autoIncrement: true);
    });

    getDatafromDB();
  }

  getDatafromDB() async {
    txn = db.transaction(storeName, "readonly");
    store = txn.objectStore(storeName);
    print("------key is----->");
    print(key);
    if (key != null) {
      value = await store.getObject(key);
      await txn.completed;

      if (value != null) {
        print("----value from db--->");
        print(value);

        String str1 = value.toString();
        String str2 = str1.substring(0, str1.length - 1);
        String str3 = str2.substring(6);
        final parsed = jsonDecode(str3) as List;
        List<BreweryModel> data =
            parsed.map((e) => BreweryModel.fromJson(e)).toList();
        print("value from db to model----->");
        print(data);
        setState(() {
          brewerList1 = data;
        });
        Future.delayed(Duration(seconds: 2), () {
          setState(() {
            isLoader = false;
          });
        });
      } else {
        setState(() {
          isLoader = false;
        });
        callApi();
      }
    } else {
      setState(() {
        isLoader = false;
      });
      callApi();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("BreweryDB_InterviewTask"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
        actions: [
          // InkWell(
          //     onTap: () {
          //       ConstantValue.checkInternet().then((value) {
          //         if (value != null) {
          //           if (value == true) {
          //             getConcurrentValue();
          //           } else {
          //             showInSnackBar("You are offline");
          //           }
          //         } else {
          //           showInSnackBar("You are offline");
          //         }
          //       });
          //     },
          //     child: Chip(
          //         label: Text(
          //       "Get Data",
          //       style: TextStyle(color: Colors.black),
          //     ))),
          // SizedBox(width: 5),
          // InkWell(
          //   onTap: () {
          //     getClearedBtn();
          //   },
          //   child: Chip(
          //     label: Text(
          //       "Clear Data",
          //       style: TextStyle(color: Colors.black),
          //     ),
          //   ),
          // ),
          SizedBox(width: 5),
        ],
      ),
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
            child: brewerList1 != null && brewerList1.length != 0
                ? ListView.builder(
                    itemCount: getItemLength(),
                    itemBuilder: (context, index) {
                      return BreweryDataView(
                        breweryModel: brewerList1[index],
                        index: index,
                      );
                    })
                : loaderWidget()),
        isLoader ? CircularProgressIndicator() : Text("")
      ]),
    );
  }

  int getItemLength() {
    if (brewerList1 != null) {
      if (brewerList1.length != 0) {
        setState(() {
          isLoading = true;
        });
        return brewerList1.length;
      } else {
        setState(() {
          isLoading = false;
        });
        return 0;
      }
    } else {
      setState(() {
        isLoading = false;
      });
      return 0;
    }
  }

  Center loaderWidget() {
    return Center(
        child: isDataCleared
            ? Text(
                "Records cleared",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              )
            : Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  CircularProgressIndicator(),
                  SizedBox(height: 5),
                  Text("No data found")
                ],
              ));
  }

  void getClearedBtn() async {
    txn = db.transaction(storeName, "readwrite");
    store = txn.objectStore(storeName).clear();
    // txn.objectStore(storeName).delete(key);
    _timer.cancel();
    if (key != null) {
      try {
        value = await store.getObject(key);
        await txn.completed;
      } catch (e) {
        print("error while get value");
        print(e);
        setState(() {
          brewerList1 = null;
          isDataCleared = true;
        });
      }

      if (value == null) {
        print("db cleared----->");
        print(value);
      }
    } else {
      print("no key found");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState
        .showSnackBar(new SnackBar(content: new Text(value)));
    return;
  }

  @override
  void dispose() {
    _timer.cancel();
    breweryBloc.onDispose();
    super.dispose();
  }
}
