import 'dart:convert';

import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/Starting_receivable_model.dart';
import 'package:anthishabrakho/screen/starting_balance/Add_Starting_balance.dart';
import 'package:anthishabrakho/screen/starting_balance/edit_starting_receivable.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewStartingReceivable extends StatefulWidget {
  @override
  _ViewStartingReceivableState createState() => _ViewStartingReceivableState();
}

class _ViewStartingReceivableState extends State<ViewStartingReceivable> {
  List<StartingReceivableModel> receivableData = [];
  StartingReceivableModel model;

  void fetchStartingReceivableData() async {
    receivableData.clear();
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/receivable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting Receivable details are   ::  ${response.body}");
    model = StartingReceivableModel.fromJson(jsonResponce);
    if (this.mounted) {
      setState(() {
        receivableData.add(model);
      });
    }
    print("starting receivable total balance is :${model.total}");
  }

  @override
  void initState() {
    fetchStartingReceivableData();
    // TODO: implement initState
    super.initState();
  }

  bool onProgress = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: ModalProgressHUD(
        opacity: 0.0,
        progressIndicator: Spin(),
        inAsyncCall: onProgress,
        child: Container(
            height: MediaQuery.of(context).size.height,
          child: Stack(
            children: [

              SingleChildScrollView(
                child: Column(children: [
                  Container(
                    margin: EdgeInsets.symmetric(vertical: 15),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 6,
                          child: Text(
                            "Title",
                            style: myStyle(14, BrandColors.colorDimText),
                          ),
                        ),
                        Expanded(
                          flex: 4,
                          child: Text(
                            "Transaction",
                            style: myStyle(14, BrandColors.colorDimText),
                          ),
                        ),

                      ],
                    ),
                  ),
                  ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: receivableData.length,
                      itemBuilder: (context, index) {
                        return Slidable(
                          actionPane: SlidableDrawerActionPane(),
                          actionExtentRatio: 0.25,
                          child: new Container(
                              padding: EdgeInsets.symmetric(vertical: 10),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  Expanded(
                                    flex: 6,
                                    child: Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "${model.receivableDetails[index].friendName ?? ""}",
                                          style: myStyle(
                                              16, Colors.white, FontWeight.w600),
                                        ),
                                        SizedBox(
                                          height: 3,
                                        ),
                                        Text(
                                          "${model.receivableDetails[index].date ?? ""}",
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
                                                .receivableDetails[index]
                                                .amount) is int
                                                ? 0
                                                : 2,
                                            locale: "en-in")
                                            .format(model
                                            .receivableDetails[index].amount),
                                        style: myStyle(
                                            14,
                                            model.receivableDetails[index].amount > 1
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
                                onTap:  () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditStartingReceivable(
                                                model: model.receivableDetails[index],
                                              ))).then((value) => setState(() {
                                    fetchStartingReceivableData();
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
                                                    .receivableDetails[index]
                                                    .eventId)
                                                    .then((value) => value);
                                                setState(() {
                                                  model.receivableDetails
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

                  /*list.isEmpty
                  ? Container(
                      alignment: Alignment.center,
                      margin: EdgeInsets.only(top: 150),
                      child: Text(
                        "Empty Entries",
                        style: myStyle(18, Colors.white70, FontWeight.w700),
                        textAlign: TextAlign.center,
                      ),
                    )
                  : ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 8,
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: boxColor,
                                      border: Border.all(
                                          color: Colors.red, width: 1),
                                      borderRadius: BorderRadius.circular(12)),
                                  child: GestureDetector(
                                    onTap: () {
                                      print(
                                          "tap ${list[index].eventId}");
                                      if (mounted) {
                                        myEntriesView(
                                            list[index].eventId);
                                      }
                                    },
                                    child: ListTile(
                                        leading: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Date :",
                                              style: myStyle(13, Colors.white),
                                            ),
                                            SizedBox(
                                              height: 4,
                                            ),
                                            list[index]
                                                        .formatedDate !=
                                                    null
                                                ? Text(
                                                    list[index]
                                                        .formatedDate,
                                                    style: myStyle(
                                                        14, Colors.white),
                                                  )
                                                : Text(""),
                                          ],
                                        ),
                                        title: list[index]
                                                    .eventSubCategoryName !=
                                                null
                                            ? Text(
                                                list[index]
                                                    .eventSubCategoryName,
                                                style:
                                                    myStyle(16, Colors.white),
                                                maxLines: 1,
                                                overflow: TextOverflow.ellipsis,
                                              )
                                            : Text(""),
                                        subtitle: list[index]
                                                    .friendName !=
                                                null
                                            ? Text(
                                                list[index]
                                                    .friendName,
                                                style:
                                                    myStyle(16, Colors.white),
                                              )
                                            : Text(""),
                                        trailing: Column(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              "Amount ",
                                              style: myStyle(14, Colors.white),
                                            ),
                                            list[index].amount !=
                                                    null
                                                ? Text(
                                                    //"৳ ${list[index].amount.toString()}",
                                                    NumberFormat.currency(
                                                            symbol: ' ৳ ',
                                                        decimalDigits: (list[index]
                                                            .amount) is int ? 0 :2,
                                                            locale: "en-in")
                                                        .format(list[index]
                                                            .amount),

                                                    style: myStyle(
                                                        16, Colors.white),
                                                  )
                                                : Text(""),
                                          ],
                                        )),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    children: [
                                      InkWell(
                                        onTap: () {
                                          myEntriesView(list[index].eventId);
                                        },
                                        child: Icon(
                                          Icons.remove_red_eye_outlined,
                                          size: 25,
                                          color: Color(0xffa7ffeb),
                                        ),
                                      ),
                                      SizedBox(
                                        height: 12,
                                      ),
                                      InkWell(
                                        onTap: () {
                                          showDialog(
                                              context: context,
                                              barrierDismissible: false,
                                              builder: (BuildContext context) {
                                                return AlertDialog(
                                                  shape: RoundedRectangleBorder(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              13.0)),
                                                  title: Text(
                                                    "Are You Sure ?",
                                                    style: myStyle(
                                                        16,
                                                        Colors.black54,
                                                        FontWeight.w800),
                                                  ),
                                                  content: Text(
                                                      "You want to delete !"),
                                                  actions: <Widget>[
                                                    FlatButton(
                                                        onPressed: () {
                                                          Navigator.of(context)
                                                              .pop(false);
                                                        },
                                                        child: Text("No")),
                                                    FlatButton(
                                                        onPressed: () {
                                                          print("tap");
                                                          CustomHttpRequests
                                                                  .deleteList(list[
                                                                          index]
                                                                      .eventId)
                                                              .then((value) =>
                                                                  value);
                                                          setState(() {
                                                            list
                                                                .removeAt(
                                                                    index);
                                                            Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
                                                          });
                                                          showInSnackBar(
                                                            "1 Item Delete",
                                                          );
                                                          Navigator.pop(
                                                              context);
                                                        },
                                                        child: Text("Yes"))
                                                  ],
                                                );
                                              });
                                        },
                                        child: FaIcon(
                                          FontAwesomeIcons.trashAlt,
                                          size: 20,
                                          color: Colors.redAccent,
                                        ),
                                      ),
                                    ],
                                  ))
                            ],
                          ),
                        );
                      },
                    ),*/
                ]),
              ),
              Positioned(
                bottom: 15,right: 15,
                child: FloatingActionButton(
                  onPressed: (){
                    String type="receivable";
                    Navigator.push(context, MaterialPageRoute(builder: (context)=>AddStartingBalance(
                      title:type ,
                    ))).then((value) => setState(() {
                      fetchStartingReceivableData();
                    }));
                  },
                  child: Icon(Icons.add,color: Colors.white,),
                  mini: true,
                  backgroundColor: BrandColors.colorPurple,
                ),
              )
            ],
          )
        ),
      ),

      /*Container(
          height: MediaQuery.of(context).size.height,
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          child: SingleChildScrollView(
            child: Column(
              children: [
                ListView.builder(

                  shrinkWrap: true,
                  itemCount: receivableData.length,
                  itemBuilder: (c,i){
                    return Container(
                      decoration: BoxDecoration(
                          color: Color(0xFF021A2C),
                          border: Border.all(
                              color: Colors.purple, width: 1),
                          borderRadius: BorderRadius.circular(12)),
                      child: ListTile(

                        selectedTileColor:  Colors.red,
                        title: Text("Total Payable is :",style: myStyle(18,Colors.white),),
                        trailing: Text(
                          NumberFormat.currency(
                              symbol: ' ৳ ',
                              decimalDigits: (receivableData[i].total)is int
                                  ? 0
                                  : 2,
                              locale: "en-in")
                              .format(receivableData[i].total),
                          style: myStyle(
                              18,
                              Color(0xffa7ffeb),
                              FontWeight.w800),
                        ),
                      ),
                    );
                  },
                ),

                SizedBox(height: 50,),

                Container(
                  child: receivableData.isEmpty? Center(child: CircularProgressIndicator()): ListView.builder(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    itemCount: model.receivableDetails.length,
                    itemBuilder: (context,index){
                      return Row(
                        children: [
                          Expanded(
                            flex: 8,
                            child: Container(
                              margin: EdgeInsets.symmetric(vertical: 10),
                              decoration: BoxDecoration(
                                  color: Color(0xFF021A2C),
                                  border: Border.all(
                                      color: Colors.purple, width: 1),
                                  borderRadius: BorderRadius.circular(12)),
                              child: ListTile(
                                leading: Icon(Icons.person_outline,color: Colors.purple,),
                                title: Text("${model.receivableDetails[index].friendName}",style: myStyle(16,Colors.white),),
                                trailing: Text(
                                  NumberFormat.currency(
                                      symbol: ' ৳ ',
                                      decimalDigits: (model.receivableDetails[index].amount)is int
                                          ? 0
                                          : 2,
                                      locale: "en-in")
                                      .format(model.receivableDetails[index].amount),
                                  style: myStyle(
                                      18,
                                      Color(0xffa7ffeb),
                                      FontWeight.w800),
                                ),

                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child:InkWell(
                                onTap: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              EditStartingReceivable(
                                                model: model.receivableDetails[index],
                                              ))).then((value) => setState(() {
                                    fetchStartingReceivableData();
                                  }));
                                },
                                child: Icon(Icons.edit_outlined,color: Colors.red,)) ,
                          )
                        ],
                      );
                    },
                  ),
                )
              ],
            ),
          ),
        )*/
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
