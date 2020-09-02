import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/data/di/factory.dart';
import 'package:flutterinterviewtask/data/model/idb_data.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';
import 'package:flutterinterviewtask/presenter/util/strings.dart';
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
    super.initState();
  }

  void _getBreweries() {
    breweryBloc.getBreweryResponse(context);
  }

  void _getData(List<BreweryModel> event) async {
    brewerList = event;
    strBrewerdata = jsonEncode(brewerList);
    idRepository.save(strBrewerdata);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text(Strings.title),
        centerTitle: true,
        backgroundColor: Colors.indigo,
      ),
      body: StreamBuilder<List<BreweryModel>>(
        stream: breweryBloc.streamcontroller.stream,
        builder:
            (BuildContext context, AsyncSnapshot<List<BreweryModel>> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return SizedBox.fromSize(
                  size: MediaQuery.of(context).size,
                  child: Center(child: CircularProgressIndicator()));
              break;
            case ConnectionState.active:
              {
                if (snapshot.hasError || !snapshot.hasData) {
                  return nodataView();
                } else {
                  _getData(snapshot.data);
                  return ListView.builder(
                      itemCount: getItemLength(),
                      itemBuilder: (context, index) {
                        return BreweryDataView(
                          breweryModel: brewerList[index],
                          index: index,
                        );
                      });
                }
              }
              break;
            default:
              return nodataView();
          }
        },
      ),
    );
  }

  int getItemLength() {
    if (brewerList != null) {
      if (brewerList.length != 0) {
        return brewerList.length;
      } else {
        return 0;
      }
    } else {
      return 0;
    }
  }

  Center nodataView() {
    return Center(
        child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        CircularProgressIndicator(),
        SizedBox(height: 5),
        Text(Strings.nodatafound)
      ],
    ));
  }

  getDatafromStorage() {
    idRepository.getId().then((value) {
      if (value != null) {
        setState(() {
          strData = value;
          final parsed = jsonDecode(strData) as List;
          List<BreweryModel> data =
              parsed.map((e) => BreweryModel.fromJson(e)).toList();
          brewerList = null;
          brewerList = data;
        });
      } else {
        _getBreweries();
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
