import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
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
  StartingPayableModel model;
  ViewStartingPayable({this.model});

  @override
  _ViewStartingPayableState createState() => _ViewStartingPayableState();
}

class _ViewStartingPayableState extends State<ViewStartingPayable> {


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
     backgroundColor: BrandColors.colorPrimaryDark,
        body:Container(
          height: MediaQuery.of(context).size.height,

          child: SingleChildScrollView(
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.only(left: 20,bottom: 20),
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


              widget.model.total =='0'? Text("Empty List",style: myStyle(16,Colors.white),): ListView.builder(
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    itemCount: widget.model.payableDetails.length,
                    itemBuilder: (context, index) {
                      return  Slidable(
                        actionPane: SlidableDrawerActionPane(),
                        actionExtentRatio: 0.25,
                        child: new Container(
                            padding: EdgeInsets.only(left: 20,bottom: 20),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 6,
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${widget.model.payableDetails[index].friendName ?? ""}",
                                        style: myStyle(
                                            16, Colors.white, FontWeight.w600),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${widget.model.payableDetails[index].date2 ?? ""}",
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
                                          //"৳ ${list[index].amount.toString()}",
                                          NumberFormat.currency(
                                              symbol: ' ৳ ',
                                              decimalDigits: (widget.model
                                                  .payableDetails[index]
                                                  .amount) is int
                                                  ? 0
                                                  : 2,
                                              locale: "en-in")
                                              .format(widget.model
                                              .payableDetails[index].amount),
                                          style: myStyle(
                                              14,
                                              widget.model.payableDetails[index].amount > 1
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
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          EditStartingPayable(
                                            model: widget.model.payableDetails[index],
                                          ))).then((value) => setState(() {
                                //  fetchStartingPayableData();
                                Navigator.pop(context);
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
                                            child: Text("No",style: myStyle(14,Colors.white),)),
                                        FlatButton(
                                            onPressed: () {
                                              print("tap");
                                              CustomHttpRequests.deleteList(widget.model
                                                  .payableDetails[index]
                                                  .eventId)
                                                  .then((value) => value);
                                              setState(() {
                                                widget.model.payableDetails
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
                      );
                    })

              ],
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
      backgroundColor: Colors.indigo,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}
