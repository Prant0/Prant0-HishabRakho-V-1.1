import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/providers/mySitationProvider.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/screen/myTransection/edit_transection.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/details.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransactionPayableEntries extends StatefulWidget {
  @override
  _TransactionPayableEntriesState createState() =>
      _TransactionPayableEntriesState();
}

class _TransactionPayableEntriesState extends State<TransactionPayableEntries> {

  myPayableView(int eventId) async {
    setState(() {
      onProgress=true;
    });
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .viewReceivablesEntries(eventId);
    setState(() {
      onProgress=false;
    });
    String bal = await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    setState(() {
      print("bal isssssssssssssssssssssssssssssss $bal");
      bal=="yes"? list.removeWhere((element) => element.eventId==eventId) : " ";
    });
  }

  List<MyTransectionModel> list = [];

  @override
  void initState() {
    getTransectionData();
    super.initState();
  }

  MyTransectionModel model;


  getTransectionData() async {
    print("get getMyPayableEntries");
    final data = await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyPayableEntries();
    print("getMyPayableEntries  ${data.toString()}");
  }

 /* Future<dynamic> getMyPayableEntries() async {
    setState(() {
      onProgress=true;
    });
    final data = await CustomHttpRequests.myPayableEntriesData();
    print("my Payable Entries data areeee $data");
    if(mounted){
      setState(() {
        onProgress=false;
      });
    }
    for (var entries in data) {
      model = MyTransectionModel(
        id: entries["id"],
        amount: entries["amount"],
        formatedDate: entries["formated_date"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        eventId: entries["event_id"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        transactionTypeId: entries["transaction_type_id"],
        details: entries["details"],
      );
      try {
        print(" Payable entries ${entries['id']}");
        list.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
       if(mounted){
         setState(() {
           list.add(model);
         });
       }
      }
    }
  }*/
  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getTransectionData();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  Color boxColor = Color(0xFF021A2C);
  double iconSize = 40;
  String type = "Payable";
  bool onProgress = false;
  @override
  Widget build(BuildContext context) {
    list = Provider.of<MyTransectionprovider>(context).myPayableEntriesList;
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: Colors.transparent,
      body: ModalProgressHUD(
        opacity: 0.0,
        progressIndicator: Spin(),
        inAsyncCall: onProgress,
        child: SmartRefresher(
          enablePullDown: true,
          header: WaterDropHeader(),
          controller: _refreshController,
          onRefresh: _onRefresh,
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
                            myPayableView(
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
                          },

                        ),
                        new IconSlideAction(

                          caption: 'Delete',
                          color: BrandColors.colorPrimary,
                          iconWidget: SvgPicture.asset("assets/delete.svg",
                            alignment: Alignment.center,
                            height: 20,width: 20,
                          ),
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
                                              //Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
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

            ]

            ),
          ),
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
