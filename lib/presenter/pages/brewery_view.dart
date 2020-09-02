import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/di/factory.dart';
import 'package:flutterinterviewtask/data/model/idb_data.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';
import 'package:flutterinterviewtask/presenter/widget/brewery_data.dart';
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

  var txn;
  var store;
  var key;
  Map value;
  bool isLoading = false;
  bool isConnection = false;
  bool isDataCleared = false;
  bool isLoader = false;
  IdRepository idRepository = IdRepository();
  String strData;
  String strBrewerdata;
  Stream stream;

  @override
  void initState() {
    getDatafromStorage();
    getConcurrentValue();
    super.initState();
  }

  getConcurrentValue() {
    _timer = Timer.periodic(Duration(seconds: 10), (t) {
      setState(() {
        isLoader = true;
      });
      getDatafromStorage();
    });
  }

  callApi() {
    breweryBloc.getBreweryResponse(context);
    breweryBloc.streamcontroller.stream.listen((event) {
      if (event != null) {
        _getData(event);
      } else {}
    });
  }

  _getData(List<BreweryModel> event) async {
    setState(() {
      brewerList = event;
      print("-------Response------>");
      print(brewerList);
      strBrewerdata = jsonEncode(brewerList);
      idRepository.save(strBrewerdata);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text("BreweryDB_InterviewTask"),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: Stack(alignment: Alignment.center, children: <Widget>[
        Container(
            child: brewerList != null && brewerList.length != 0
                ? ListView.builder(
                    itemCount: getItemLength(),
                    itemBuilder: (context, index) {
                      return BreweryDataView(
                        breweryModel: brewerList[index],
                        index: index,
                      );
                    })
                : loaderWidget()),
        isLoader ? CircularProgressIndicator() : Text("")
      ]),
    );
  }

  int getItemLength() {
    if (brewerList != null) {
      if (brewerList.length != 0) {
        setState(() {
          isLoading = true;
        });
        return brewerList.length;
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

  getDatafromStorage() {
    idRepository.getId().then((value) {
      if (value != null) {
        print("-------------value from window storage------>");
        print(value);
        setState(() {
          strData = value;
          final parsed = jsonDecode(strData) as List;
          List<BreweryModel> data =
              parsed.map((e) => BreweryModel.fromJson(e)).toList();
          print("value from db to model----->");
          print(data);
          brewerList = null;
          brewerList = data;
        });
        callApi();
      } else {
        callApi();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    breweryBloc.onDispose();
    super.dispose();
  }
}
