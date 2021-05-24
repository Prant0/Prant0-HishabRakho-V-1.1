import 'dart:convert';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/Starting_receivable_model.dart';
import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/screen/starting_balance/Add_Starting_balance.dart';
import 'package:anthishabrakho/screen/starting_balance/edit_starting_receivable.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';

class ViewStartingReceivable extends StatefulWidget {
  StartingReceivableModel model;
  ViewStartingReceivable({this.model});
  @override
  _ViewStartingReceivableState createState() => _ViewStartingReceivableState();
}

class _ViewStartingReceivableState extends State<ViewStartingReceivable> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,

      body: Container(
          height: MediaQuery.of(context).size.height,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              padding: EdgeInsets.only(left: 20,bottom: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text(
                      getTranslated(context,'t52'),                 //  "Title",
                      style: myStyle(14, BrandColors.colorDimText.withOpacity(0.6)),
                    ),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text(
                      getTranslated(context,'t26'),                              // "Transaction",
                      style: myStyle(14, BrandColors.colorDimText.withOpacity(0.6)),
                    ),
                  ),

                ],
              ),
            ),
           ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount:widget.model.receivableDetails.length,
                itemBuilder: (context, index) {
                  return widget.model.receivableDetails.isNotEmpty? Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: new Container(
                        padding: EdgeInsets.only(left: 20,bottom: 20),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Expanded(
                              flex: 6,
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    "${widget.model.receivableDetails[index].friendName ?? ""}",
                                    style: myStyle(
                                        16, Colors.white, FontWeight.w600),
                                  ),
                                  SizedBox(
                                    height: 3,
                                  ),
                                  Text(
                                    "${widget.model.receivableDetails[index].date2 ?? ""}",
                                    style: myStyle(
                                      14,
                                      BrandColors.colorDimText.withOpacity(0.6),
                                    ),
                                  )
                                ],
                              ),
                            ),
                            Expanded(
                                flex: 4,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      NumberFormat.currency(
                                          symbol: ' ৳ ',
                                          decimalDigits: (widget.model
                                              .receivableDetails[index]
                                              .amount) is int
                                              ? 0
                                              : 2,
                                          locale: "en-in")
                                          .format(widget.model
                                          .receivableDetails[index].amount),
                                      style: myStyle(
                                          14,
                                          widget.model.receivableDetails[index].amount > 1
                                              ? Colors.greenAccent
                                              : Colors.redAccent),
                                    ),
                                    Container(
                                      //height: double.infinity,
                                      height: 30,
                                      width: 3,
                                      color: BrandColors.colorText.withOpacity(0.2),
                                    )
                                  ],
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
                                        model: widget.model.receivableDetails[index],
                                      ))).then((value) => setState(() {
                           // fetchStartingReceivableData();
                          }));
                        },


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
                                  backgroundColor: BrandColors.colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                      BorderRadius.circular(13.0)),
                                  title: Text(
                                    "Are You Sure ?",
                                    style: myStyle(
                                        16, Colors.white, FontWeight.w800),
                                  ),
                                  content: Text("You want to delete !",style: myStyle(14,BrandColors.colorText),),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text("No",style: myStyle(14,Colors.white))),
                                    FlatButton(
                                        onPressed: () {
                                          print("tap");
                                          CustomHttpRequests.deleteList(widget.model
                                              .receivableDetails[index]
                                              .eventId)
                                              .then((value) => value);
                                          setState(() {
                                            widget. model.receivableDetails
                                                .removeAt(index);
                                          });
                                          showInSnackBar(
                                            "1 Item Delete",
                                          );
                                          Navigator.pop(context);
                                        },
                                        child: Text("Yes",style: myStyle(14,Colors.white)))
                                  ],
                                );
                              });
                        },
                      ),
                    ],
                  ) :Container();
                })


          ]),
        ),
      ),


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
