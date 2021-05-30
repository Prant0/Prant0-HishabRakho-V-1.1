import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/localization/localization_Constants.dart';
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

class TransectionMyEntries extends StatefulWidget {
  @override
  _TransectionMyEntriesState createState() => _TransectionMyEntriesState();
}

class _TransectionMyEntriesState extends State<TransectionMyEntries> {
  MyTransectionModel model;
  List<MyTransectionModel> list = [];
  Color boxColor = Color(0xFF021A2C);
  double iconSize = 40;

  myEntriesView(int eventId) async {
    setState(() {
      onProgress = true;
    });
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .viewMyEntries(eventId);
    if (mounted) {
      setState(() {
        onProgress = false;
      });
      String bal = await Navigator.push(context, MaterialPageRoute(builder: (context) => Details()));
    setState(() {

      bal=="yes"? list.removeWhere((element) => element.eventId==eventId) : " ";
      Provider.of<MyTransectionprovider>(
          context,
          listen: false)
          .deleteTransaction();
    });


    }



  }

  @override
  void initState() {
    getMyEntriesDetails();
    super.initState();
  }

  Future<dynamic> getMyEntriesDetails() async {
    setState(() {
      onProgress = true;
    });
    final data = await CustomHttpRequests.myEntriesData();

    for (var entries in data) {
      setState(() {
        onProgress = false;
      });
      model = MyTransectionModel(
        amount: entries["amount"],
        id: entries["id"],
        formatedDate: entries["formated_date"],
        eventType: entries["event_type"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        balance: entries["balance"],
        eventId: entries["event_id"],
      );
      try {
        list.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          list.add(model);
        });
      }
    }
    onProgress = false;
  }

  bool onProgress = false;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  void _onRefresh() async {
    getMyEntriesDetails();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  Widget build(BuildContext context) {
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
                margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      flex: 7,
                      child: Text(
                        getTranslated(context,'t52'),  //  "Title",
                        style: myStyle(
                            12,
                            BrandColors.colorDimText.withOpacity(0.5),
                            FontWeight.w400),
                      ),
                    ),
                    Expanded(
                      flex: 5,
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
              list.isNotEmpty
                  ? ListView.builder(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      itemCount: list.length,
                      itemBuilder: (context, index) {
                        return GestureDetector(
                          onTap: () {
                            if (mounted) {
                              myEntriesView(list[index].eventId);
                            }
                          },
                          child: Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: new Container(
                                margin: EdgeInsets.only(left: 6),
                                padding: EdgeInsets.symmetric(vertical: 13),
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
                                            style: myStyle(14, Colors.white,
                                                FontWeight.w500),
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
                                              FontWeight.w400,
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
                                                  decimalDigits: (list[index]
                                                          .amount) is int
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
                                            Align(
                                              child: Text(
                                                NumberFormat.currency(
                                                        symbol: ' ',
                                                        decimalDigits: (list[
                                                                    index]
                                                                .balance) is int
                                                            ? 0
                                                            : 2,
                                                        locale: "en-in")
                                                    .format(
                                                        list[index].balance),
                                                style: myStyle(12, Colors.white,
                                                    FontWeight.w500),
                                              ),
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
                            secondaryActions: <Widget>[
                              new IconSlideAction(
                                caption: getTranslated(context,'t54'),  // delete
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
                                            style: myStyle(16, Colors.black54,
                                                FontWeight.w800),
                                          ),
                                          content: Text(getTranslated(context,'t62'),  // "You want to delete !"
                                         ),
                                          actions: <Widget>[
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.of(context)
                                                      .pop(false);
                                                },
                                                child: Text(getTranslated(context,'t64'),  //   "No"

                                                )),
                                            FlatButton(
                                                onPressed: () {
                                                  CustomHttpRequests.deleteList(list[index].eventId).then((value) => value);
                                                  setState(() {
                                                    list.removeAt(index);
                                                    Provider.of<MyTransectionprovider>(
                                                            context,
                                                            listen: false)
                                                        .deleteTransaction();
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
                          ),
                        );
                      })
                  : Container(
                      height: MediaQuery.of(context).size.height - 150,
                      alignment: Alignment.center,
                      child: Text(
                        getTranslated(context,'t66'),  //     "Empty entries",
                        style: myStyle(
                          16,
                          BrandColors.colorText,
                        ),
                      ),
                    )
            ]),
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
      backgroundColor: Colors.indigo,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}
