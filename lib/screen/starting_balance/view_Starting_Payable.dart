import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/starting_payable_Model.dart';
import 'package:anthishabrakho/screen/starting_balance/Add_Starting_balance.dart';
import 'package:anthishabrakho/screen/starting_balance/editStartingPayable.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewStartingPayable extends StatefulWidget {

  @override
  _ViewStartingPayableState createState() => _ViewStartingPayableState();
}

class _ViewStartingPayableState extends State<ViewStartingPayable> {
  List<StartingPayableModel> payableData = [];
  StartingPayableModel model;

  Future<dynamic> fetchStartingPayableData() async {
    setState(() {
      onProgress=true;
    });
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/payable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting payable details are   ::  ${response.body}");
    model = StartingPayableModel.fromJson(jsonResponce);
    if (this.mounted) {
      setState(() {
        onProgress=false;
        payableData.add(model);
      });
    }
    print("total starting payable amount  is :${model.total}");
  }

  @override
  void initState() {
    fetchStartingPayableData();
    super.initState();
  }




  bool onProgress=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     backgroundColor: BrandColors.colorPrimaryDark,
        body:ModalProgressHUD(
          opacity: 0.0,
          progressIndicator: Spin(),
          inAsyncCall: onProgress,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Title",
                            style: myStyle(14, BrandColors.colorDimText.withOpacity(0.6)),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Transaction",
                            style: myStyle(14, BrandColors.colorDimText.withOpacity(0.6)),
                          ),
                        ),

                      ],
                    ),
                  ),


                model.payableDetails.length==0? Container():    ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: model.payableDetails.length,
                      itemBuilder: (context, index) {
                        return  Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: new Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${model.payableDetails[index].friendName ?? ""}",
                                          style: myStyle(
                                              16, Colors.white, FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "${model.payableDetails[index].date ?? ""}",
                                          style: myStyle(
                                            14,
                                            BrandColors.colorDimText,
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                  Expanded(
                                      flex: 4,
                                      child: Text(
                                        //"৳ ${list[index].amount.toString()}",
                                        NumberFormat.currency(
                                            symbol: ' ৳ ',
                                            decimalDigits: (model
                                                .payableDetails[index]
                                                .amount) is int
                                                ? 0
                                                : 2,
                                            locale: "en-in")
                                            .format(model
                                            .payableDetails[index].amount),
                                        style: myStyle(
                                            14,
                                            model.payableDetails[index].amount > 1
                                                ? Colors.greenAccent
                                                : Colors.redAccent),
                                      )),
                                ],
                              )),
                          secondaryActions: <Widget>[
                            new IconSlideAction(
                              caption: 'Edit',
                              color: Colors.black45,
                              icon: Icons.more_horiz,
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditStartingPayable(
                                              model: model.payableDetails[index],
                                            ))).then((value) => setState(() {
                                  fetchStartingPayableData();
                                }));
                              },
                              /*() {
                              print(
                                  "transection type id :${list[index].transactionTypeId}");
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditTransaction(
                                            model: list[
                                            index],
                                            type: type,
                                          ))) .then((value) => setState(() {
                                getTransectionData();
                              }));
                            },*/

                            ),
                            new IconSlideAction(
                              caption: 'Delete',
                              color: Colors.red,
                              icon: Icons.delete,
                              //onTap: () => _showSnackBar('Delete'),
                              onTap: () {
                                showDialog(
                                    context: context,
                                    barrierDismissible: false,
                                    builder: (BuildContext context) {
                                      return AlertDialog(
                                        shape: RoundedRectangleBorder(
                                            borderRadius:
                                            BorderRadius.circular(13.0)),
                                        title: Text(
                                          "Are You Sure ?",
                                          style: myStyle(
                                              16, Colors.black54, FontWeight.w800),
                                        ),
                                        content: Text("You want to delete !"),
                                        actions: <Widget>[
                                          FlatButton(
                                              onPressed: () {
                                                Navigator.of(context).pop(false);
                                              },
                                              child: Text("No")),
                                          FlatButton(
                                              onPressed: () {
                                                print("tap");
                                                CustomHttpRequests.deleteList(model
                                                    .payableDetails[index]
                                                    .eventId)
                                                    .then((value) => value);
                                                setState(() {
                                                  model.payableDetails
                                                      .removeAt(index);
                                                });
                                                showInSnackBar(
                                                  "1 Item Delete",
                                                );
                                                Navigator.pop(context);
                                              },
                                              child: Text("Yes"))
                                        ],
                                      );
                                    });
                              },
                            ),
                          ],
                        );
                      })

                ],
              ),
            ),
          ),
        )
    );
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: myStyle(15, Colors.white),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}
