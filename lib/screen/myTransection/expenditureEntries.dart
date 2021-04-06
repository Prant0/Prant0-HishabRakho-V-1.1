import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anthishabrakho/screen/myTransection/edit_transection.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/details.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class TransactionExpenditure extends StatefulWidget {
  @override
  _TransactionExpenditureState createState() => _TransactionExpenditureState();
}

class _TransactionExpenditureState extends State<TransactionExpenditure> {
  myExpenditureView(int eventId) async {
    setState(() {
      onProgress=true;
    });
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .viewReceivablesEntries(eventId);
    setState(() {
      onProgress=false;
    });
    Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
  }

  TextEditingController xp = TextEditingController();

  List<MyTransectionModel> list = [];
  MyTransectionModel model;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String type = "Expenditure";
  bool onProgress = false;

/*  Future<dynamic> getMyExpenditureEntries() async {
    setState(() {
      onProgress = true;
    });
    final data = await CustomHttpRequests.myExpendituresEntriesData();
    print("my Expenditure data are the $data");
    setState(() {
      onProgress = false;
    });
    for (var entries in data) {
      model = MyTransectionModel(
        id: entries["id"],
        amount: entries["amount"],
        eventId: entries["event_id"],
        formatedDate: entries["formated_date"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        balance: entries["balance"],
        transactionTypeId: entries["transaction_type_id"],
        eventType: entries["event_type"],
        details: entries["details"],
      );
      try {
        print(" Expenditure entries ${entries['friend_name']}");
        list.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          list.add(model);
        });
      }
    }
  }*/
  getTransectionData() async {
    print("get getMyExpenditureEntries ");
    final data = await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyExpenditureEntries();
    print("getMyExpenditureEntries  ${data}");
  }

  @override
  void initState() {
    getTransectionData();
    super.initState();
  }
  Color boxColor = Color(0xFF021A2C);
  double iconSize = 40;
  @override
  Widget build(BuildContext context) {
    list = Provider.of<MyTransectionprovider>(context).myExpenditureEntriesList;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        opacity: 0.0,
        progressIndicator: Spin(),
        inAsyncCall: onProgress,
        child: SingleChildScrollView(
          child: Column(children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 15,horizontal: 0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 6,
                    child: Text("Title", style: myStyle(12,
                        BrandColors.colorDimText.withOpacity(0.5),FontWeight.w400),),
                  ),
                  Expanded(
                    flex: 4,
                    child: Text("Transaction", style: myStyle(12,
                        BrandColors.colorDimText.withOpacity(0.5),FontWeight.w400),),
                  ),
                  Expanded(
                    flex: 4,
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Text("Balance", style: myStyle(12,
                          BrandColors.colorDimText.withOpacity(0.5),FontWeight.w400),),
                    ),
                  ),
                ],
              ),
            ),
            ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return Slidable(
                    actionPane: SlidableDrawerActionPane(),
                    actionExtentRatio: 0.25,
                    child: GestureDetector(
                      onTap:  () {
                        print(
                            "tap ${list[index].eventId}");
                        if (mounted) {
                          myExpenditureView(
                              list[index].eventId);
                        }
                      },
                      child: new Container(
                          padding: EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${list[index].friendName??""}",style: myStyle(14,Colors.white,FontWeight.w500),
                                    ),
                                    SizedBox(height: 3,),
                                    Text(
                                      "${list[index].formatedDate ?? ""}",style: myStyle(12,BrandColors.colorDimText.withOpacity(0.6),),
                                    )
                                  ],
                                ),
                              ),
                              Expanded(
                                  flex: 3,
                                  child: Text(
                                    //"৳ ${list[index].amount.toString()}",
                                    NumberFormat.currency(
                                        symbol: '',
                                        decimalDigits: (list[index]
                                            .amount) is int ? 0 :2,
                                        locale: "en-in").format(list[index].amount),
                                    style: myStyle(
                                        12,list[index].amount>1? Colors.greenAccent:Colors.redAccent),
                                  )
                              ),

                              Expanded(
                                  flex: 3,
                                  child:  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        NumberFormat.currency(
                                            symbol: '',
                                            decimalDigits: (list[index]
                                                .balance) is int ? 0 :2,
                                            locale: "en-in")
                                            .format(list[index]
                                            .balance),

                                        style: myStyle(
                                            12, Colors.white,FontWeight.w500),
                                      ),

                                      Container(
                                        //height: double.infinity,
                                        height: 30,
                                        width: 3,
                                        color: BrandColors.colorText.withOpacity(0.2),
                                      )
                                    ],
                                  )
                              ),
                            ],
                          )
                      ),
                    ),

                    secondaryActions: <Widget>[
                      new IconSlideAction(
                        caption: 'Edit',
                        color: BrandColors.colorPrimary,
                        icon: Icons.more_horiz,
                        onTap:  () {
                          print(
                              "transection type id is :${list[index].transactionTypeId}");
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
                        },

                      ),
                      new IconSlideAction(
                        caption: 'Delete',
                        color: BrandColors.colorPrimary,
                        iconWidget: SvgPicture.asset("assets/delete.svg",
                          alignment: Alignment.center,
                          height: 20,width: 20,
                        ),
                        //onTap: () => _showSnackBar('Delete'),
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
                      ),
                    ],);
                }
            )

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
          ]

          ),
        ),
      ),
    );
    /*Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black87,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        title: Text(
          "Expenditure Entries",
          style: myStyle(17, Colors.white),
          textAlign: TextAlign.center,
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        child: Container(
            padding: EdgeInsets.only(top: 20, left: 15, right: 15),
            child: SingleChildScrollView(
              child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    transection.isEmpty
                        ? Container(
                            alignment: Alignment.center,
                            margin: EdgeInsets.only(top: 150),
                            child: Text(
                              "Empty Expenditure Entries",
                              style:
                                  myStyle(18, Colors.white70, FontWeight.w700),
                              textAlign: TextAlign.center,
                            ),
                          )
                        : ListView.builder(
                            scrollDirection: Axis.vertical,
                            physics: BouncingScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: transection.length,
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
                                            borderRadius:
                                                BorderRadius.circular(12)),
                                        child: ListTile(
                                            onTap: () {
                                              myExpenditureView(
                                                  transection[index].eventId);
                                            },
                                            leading: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Date :",
                                                  style:
                                                      myStyle(13, Colors.white),
                                                ),
                                                SizedBox(
                                                  height: 4,
                                                ),
                                                transection[index]
                                                            .formatedDate !=
                                                        null
                                                    ? Text(
                                                        transection[index]
                                                            .formatedDate,
                                                        style: myStyle(
                                                            14, Colors.white),
                                                      )
                                                    : Text(""),
                                              ],
                                            ),
                                            title: transection[index]
                                                        .eventSubCategoryName !=
                                                    null
                                                ? Text(
                                                    transection[index]
                                                        .eventSubCategoryName,
                                                    style: myStyle(
                                                        16, Colors.white),
                                                    maxLines: 1,
                                                    overflow:
                                                        TextOverflow.ellipsis,
                                                  )
                                                : Text(""),
                                            subtitle:
                                                transection[index].friendName !=
                                                        null
                                                    ? Text(
                                                        transection[index]
                                                            .friendName,
                                                        style: myStyle(
                                                            16, Colors.white),
                                                      )
                                                    : Text(""),
                                            trailing: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.center,
                                              children: [
                                                Text(
                                                  "Amount ",
                                                  style:
                                                      myStyle(14, Colors.white),
                                                ),
                                                transection[index].amount !=
                                                        null
                                                    ? Text(
                                                        NumberFormat.currency(
                                                                symbol: ' ৳ ',
                                                            decimalDigits: (transection[index].amount) is int ? 0 :2,
                                                                locale: "en-in")
                                                            .format(transection[
                                                                    index]
                                                                .amount),
                                                        style: myStyle(
                                                            16, Colors.white),
                                                      )
                                                    : Text(""),
                                              ],
                                            )),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 1,
                                        child: Column(
                                          children: [
                                            InkWell(
                                                onTap: () {
                                                  myExpenditureView(
                                                      transection[index]
                                                          .eventId);
                                                },
                                                child: Icon(
                                                  Icons.remove_red_eye_outlined,
                                                  size: 25,
                                                  color: Color(0xffa7ffeb),
                                                )),
                                            InkWell(
                                              onTap: () {
                                                Navigator.pushReplacement(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (context) =>
                                                            EditTransaction(
                                                              model:
                                                                  transection[
                                                                      index],
                                                              type: type,
                                                            )));
                                                print(
                                                    "expenditure index is :  ${transection[index]}");
                                                print(
                                                    "expenditure index is :  ${transection[index].eventType}");
                                              },
                                              child: Icon(
                                                Icons.edit_outlined,
                                                color: Colors.purple,
                                              ),
                                            ),
                                            InkWell(
                                              onTap: () {
                                                showDialog(
                                                    context: context,
                                                    barrierDismissible: false,
                                                    builder:
                                                        (BuildContext context) {
                                                      return AlertDialog(
                                                        shape: RoundedRectangleBorder(
                                                            borderRadius:
                                                                BorderRadius
                                                                    .circular(
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
                                                                Navigator.of(
                                                                        context)
                                                                    .pop(false);
                                                              },
                                                              child:
                                                                  Text("No")),
                                                          FlatButton(
                                                              onPressed: () {
                                                                print("tap");
                                                                CustomHttpRequests.deleteList(
                                                                        transection[index]
                                                                            .eventId)
                                                                    .then((value) =>
                                                                        value);
                                                                setState(() {
                                                                  transection
                                                                      .removeAt(
                                                                          index);
                                                                  Provider.of<MyTransectionprovider>(
                                                                          context,
                                                                          listen:
                                                                              false)
                                                                      .deleteTransaction();
                                                                });
                                                                showInSnackBar(
                                                                  "1 Item deleted",
                                                                );
                                                                Navigator.pop(
                                                                    context);
                                                              },
                                                              child:
                                                                  Text("Yes"))
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
                          ),
                  ]),
            )),
      ),
    );*/
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

}
