import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:anthishabrakho/screen/myTransection/edit_transection.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class TransactionEarningEntries extends StatefulWidget {
  @override
  _TransactionEarningEntriesState createState() =>
      _TransactionEarningEntriesState();
}

class _TransactionEarningEntriesState extends State<TransactionEarningEntries> {
  Color boxColor = Color(0xFF021A2C);
  double iconSize = 40;
  List<MyTransectionModel> list = [];

  myEarningView(int eventId) async {
    setState(() {
      onProgress = true;
    });
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .viewEarningEntries(eventId);
    setState(() {
      onProgress = false;
    });
    String bal = await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    setState(() {
      bal=="yes"? list.removeWhere((element) => element.eventId==eventId) : " ";
    });
  }

  getTransectionData() async {
    final data =
        await Provider.of<MyTransectionprovider>(context, listen: false)
            .getMyEarningEntries();
  }

  @override
  void initState() {
    getTransectionData();
    super.initState();
  }

  MyTransectionModel model;

  bool onProgress = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getTransectionData();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
    list = Provider.of<MyTransectionprovider>(context).myEarningEntriesList;
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
                margin: EdgeInsets.symmetric(vertical: 15, horizontal: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 6,
                      child: Text(
                        getTranslated(context,'t52'),  //  "Title",
                        style: myStyle(
                            12,
                            BrandColors.colorDimText.withOpacity(0.5),
                            FontWeight.w400),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Text(
                        getTranslated(context,'t26'),  //  "Transaction",
                        style: myStyle(
                            12,
                            BrandColors.colorDimText.withOpacity(0.5),
                            FontWeight.w400),
                      ),
                    ),
                    Expanded(
                      flex: 4,
                      child: Align(
                        alignment: Alignment.centerLeft,
                        child: Text(
                          getTranslated(context,'t67'),  //    "Balance",
                          style: myStyle(
                              12,
                              BrandColors.colorDimText.withOpacity(0.5),
                              FontWeight.w400),
                        ),
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
                        onTap: () {

                          if (mounted) {
                            myEarningView(list[index].eventId);
                          }
                        },
                        child: new Container(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${list[index].friendName ?? ""}",
                                        style: myStyle(
                                            14, Colors.white, FontWeight.w500),
                                      ),
                                      SizedBox(
                                        height: 3,
                                      ),
                                      Text(
                                        "${list[index].formatedDate ?? ""}",
                                        style: myStyle(
                                          12,
                                          BrandColors.colorDimText
                                              .withOpacity(0.6),
                                        ),
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
                                              decimalDigits:
                                                  (list[index].amount) is int
                                                      ? 0
                                                      : 2,
                                              locale: "en-in")
                                          .format(list[index].amount),
                                      style: myStyle(
                                          12,
                                          list[index].amount > 1
                                              ? Colors.greenAccent
                                              : Colors.redAccent),
                                    )),
                                Expanded(
                                    flex: 3,
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          NumberFormat.currency(
                                                  symbol: '',
                                                  decimalDigits: (list[index]
                                                          .balance) is int
                                                      ? 0
                                                      : 2,
                                                  locale: "en-in")
                                              .format(list[index].balance),
                                          style: myStyle(12, Colors.white,
                                              FontWeight.w500),
                                        ),
                                        Container(
                                          //height: double.infinity,
                                          height: 30,
                                          width: 3,
                                          color: BrandColors.colorText
                                              .withOpacity(0.2),
                                        )
                                      ],
                                    )),
                              ],
                            )),
                      ),
                      secondaryActions: <Widget>[
                        new IconSlideAction(
                          caption: getTranslated(context,'t53'),  //    "Edit",
                          color: BrandColors.colorPrimary,
                          icon: Icons.more_horiz,
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => EditTransaction(
                                          model: list[index],
                                          type: type,
                                        ))).then((value) => setState(() {
                                  getTransectionData();
                                }));
                          },
                        ),
                        new IconSlideAction(
                          caption:  getTranslated(context,'t54'),  // delete
                          color: BrandColors.colorPrimary,
                          iconWidget: SvgPicture.asset(
                            "assets/delete.svg",
                            alignment: Alignment.center,
                            height: 20,
                            width: 20,
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
                                            BorderRadius.circular(13.0)),
                                    title: Text(
                                      getTranslated(context,'t61'),  // "Are You Sure ?",
                                      style: myStyle(
                                          16, Colors.black54, FontWeight.w800),
                                    ),
                                    content:  Text(getTranslated(context,'t62'),  // "You want to delete !"
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                          onPressed: () {
                                            Navigator.of(context).pop(false);
                                          },
                                          child: Text(getTranslated(context,'t64'),  //   "No"
                                          )
                                      ),
                                      FlatButton(
                                          onPressed: () {

                                            CustomHttpRequests.deleteList(list[index].eventId).then((value) => value);
                                            setState(() {
                                              list.removeAt(index);
                                              //  Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
                                            });
                                            showInSnackBar(
                                              getTranslated(context,'t65'),  //  "1 Item Delete",
                                            );
                                            Navigator.pop(context);
                                          },
                                          child: Text(getTranslated(context,'t63'),  //    "Yes"
                                          ))
                                    ],
                                  );
                                });
                          },
                        ),
                      ],
                    );
                  })


            ]),
          ),
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        value,
        style: myStyle(15, Colors.white),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final type = "Earning";
}
