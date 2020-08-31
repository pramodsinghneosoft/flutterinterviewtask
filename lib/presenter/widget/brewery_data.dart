import 'package:flutter/material.dart';
import 'package:flutterinterviewtask/domain/entities/brewery_model.dart';
import 'package:idb_shim/idb_client.dart';
import 'package:intl/intl.dart';

class BreweryDataView extends StatefulWidget {
  BreweryModel breweryModel;
  int index;

  BreweryDataView({this.breweryModel, this.index});
  @override
  _BreweryDataViewState createState() => _BreweryDataViewState();
}

class _BreweryDataViewState extends State<BreweryDataView> {
  static const String storeName = "records";
  Database db;
  var txn;
  var store;
  var key;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        child: Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
      child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15.0),
          ),
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(left: 45.0, top: 10),
            child: IntrinsicHeight(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    flex: 4,
                    child: Column(
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("Id")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(
                                    widget.breweryModel.id.toString())),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("Name")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(widget.breweryModel.name)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Expanded(flex: 3, child: titleText("Street")),
                          Expanded(child: Text(":")),
                          Expanded(
                            flex: 9,
                            child: titleVaueTV(widget.breweryModel.street),
                          ),
                        ]),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("City")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(widget.breweryModel.city)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("State")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(widget.breweryModel.city)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("Postal code")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(
                                    widget.breweryModel.postalCode)),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(children: [
                          Expanded(flex: 3, child: titleText("Country")),
                          Expanded(child: Text(":")),
                          Expanded(
                            flex: 9,
                            child: titleVaueTV(widget.breweryModel.country),
                          ),
                        ]),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                  Expanded(
                    flex: 2,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 15.0),
                      child: VerticalDivider(
                        thickness: 0.6,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("Brewery Type")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(
                                    widget.breweryModel.breweryType)),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(children: [
                          Expanded(flex: 3, child: titleText("Phone")),
                          Expanded(child: Text(":")),
                          Expanded(
                            flex: 9,
                            child: titleVaueTV(widget.breweryModel.phone),
                          ),
                        ]),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("Website Url")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(
                                    widget.breweryModel.websiteUrl)),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("latitude")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child:
                                    titleVaueTV(widget.breweryModel.latitude)),
                          ],
                        ),
                        SizedBox(
                          height: 14,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("longitude")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child:
                                    titleVaueTV(widget.breweryModel.longitude)),
                          ],
                        ),
                        SizedBox(
                          height: 12,
                        ),
                        Row(
                          children: [
                            Expanded(flex: 3, child: titleText("Updated At")),
                            Expanded(child: Text(":")),
                            Expanded(
                                flex: 9,
                                child: titleVaueTV(getDateString(
                                    widget.breweryModel.updatedAt))),
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          )),
    ));
  }

  Text titleText(String str) => Text(
        str,
        style: TextStyle(fontWeight: FontWeight.w500, fontSize: 14),
      );

  Text titleVaueTV(String str) => Text(
        str,
        style: TextStyle(
            fontFamily: "Raleway", fontWeight: FontWeight.w300, fontSize: 15),
      );

  String getDateString(String dateString) {
    var date = DateTime.parse(dateString);
    var formattedDate = DateFormat("EEE, d MMM").format(date);
    return formattedDate;
  }
}
