import 'dart:async';
import 'dart:convert';

import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_stack/flutter_image_stack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:anthishabrakho/screen/profile/my_profile.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/bank.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/cash.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:anthishabrakho/widget/extra.dart';
import 'package:anthishabrakho/widget/mfs.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with SingleTickerProviderStateMixin {




  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());

    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }


  String userName;


  SharedPreferences sharedPreferences;
  String image;


  loadUserImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("userName");
    print(
        "user anme issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss ${userName}");
    image = sharedPreferences.getString("image");
    print("image is $image");
  }



  @override
  void didChangeDependencies() {
    loadUserImage();
    super.didChangeDependencies();
  }


  List<DashBoardModel> allData = [];
  DashBoardModel dashBoardModel;

  void loadDashBoardData() async {
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/summary",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("dashboard details are   ::  ${response.body}");
    dashBoardModel = DashBoardModel.fromJson(jsonResponce);
    try {
      allData.firstWhere((element) => element.totalAmount == dashBoardModel.totalAmount);
    } catch (e) {
      if (this.mounted) {
        setState(() {
          allData.add(dashBoardModel);
        });
      }
    }
    print("totalBankAmount is :${dashBoardModel.bankDetails}");
  }

  RefreshController _refreshController =
  RefreshController(initialRefresh: false);

  void _onRefresh() async {
    loadDashBoardData();
    await Future.delayed(Duration(milliseconds: 1000));
    _refreshController.refreshCompleted();
  }

  @override
  void initState() {
    check().then((intenet) {
      if (intenet != null && intenet) {
        if (mounted) {
          loadDashBoardData();
        }
      } else
        showInSnackBar("No Internet Connection");
    });
    controller = TabController(length: 3, vsync: this, initialIndex: 1);
    super.initState();
  }

  TabController controller;

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }



  GlobalKey<ScaffoldState> _drawerKey = GlobalKey();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _drawerKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      drawer: Drawerr(),

      body:allData.isNotEmpty
          ?  SmartRefresher(
        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,
            child: Container(
        // height: 500,
        padding: EdgeInsets.only(left:17.0,right: 17,bottom: 40),
        //height: MediaQuery.of(context).size.height,
        child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "${userName ?? ""}",
                            style: myStyle(
                                19,
                                Colors.white,FontWeight.w500
                            ),
                          ),
                          Text(
                            getTranslated(context,'t1'), //welcome back
                            style: myStyle(
                                19,
                                Colors.white,FontWeight.w500
                            ),
                          ),
                        ],
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          moneyField(
                            amount: allData[0].totalFinancialPosition ?? 0,
                            ts: myStyle(18,Colors.white,FontWeight.w700),
                            offset: Offset(0, -8),
                            tks: myStyle(14,Colors.white),
                          ),
                          Text(
                            getTranslated(context,'t2'), //your financial position
                            style: myStyle(
                                14,
                                BrandColors.colorText.withOpacity(0.7),FontWeight.w400
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 9,
                child: Container(
                  padding: EdgeInsets.only(top: 6),
                  child: Card(
                    color: BrandColors.colorPrimary,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      // width: double.infinity,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 6,
                            child: Container(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [

                                      Text(getTranslated(context,'t3'), //money at hand
                                        style: myStyle(16,
                                            BrandColors.colorText.withOpacity(0.7),FontWeight.w400),),
                                      SizedBox(
                                        height: 8,
                                      ),
                                      moneyField(
                                        amount: allData[0].totalAmount,
                                        ts: myStyle(22,Colors.white,FontWeight.w500),
                                        offset: Offset(-1, -12),
                                        tks: myStyle(14,Colors.white,),
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      TabBar(
                                        physics: BouncingScrollPhysics(),
                                        //automaticIndicatorColorAdjustment: true,
                                        labelColor: Colors.green,
                                        indicatorColor: BrandColors.colorText.withOpacity(0.5),
                                        indicatorWeight: 1,
                                        unselectedLabelColor:
                                        Colors.transparent,
                                        controller: controller,

                                        tabs: <Widget>[
                                          Tab(
                                            child: Column(
                                              children: [
                                                Text(
                                                 getTranslated(context,'t4'), //cash
                                                  style: myStyle(
                                                      14, BrandColors.colorText.withOpacity(0.6) ),
                                                ),
                                                SizedBox(height: 8,),

                                                RichText(
                                                  text: TextSpan(children: [

                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                        offset:  Offset(-1, -8),
                                                        child: Text(
                                                          '৳',
                                                          textScaleFactor: 1.0,
                                                          style: myStyle(14,Colors.white),
                                                        ),
                                                      ),
                                                    ),

                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                          offset: const Offset(1, -4),
                                                          child: Text(
                                                              NumberFormat
                                                                  .compactCurrency(
                                                                symbol: '',
                                                              ).format(allData[0].totalCashAmount),
                                                              style: myStyle(
                                                                  16, Colors.white,FontWeight.w700))
                                                      ),
                                                    ),

                                                  ]),
                                                )
                                              ],
                                            ),
                                          ),
                                          Tab(
                                            child: Column(
                                              children: [
                                                Text(

                                                     getTranslated(context,'t5'), //bank
                                                  style: myStyle(
                                                      14,
                                                      BrandColors
                                                          .colorText ),
                                                ),
                                                SizedBox(height: 8,),
                                                RichText(
                                                  text: TextSpan(children: [

                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                        offset:  Offset(-1, -8),
                                                        child: Text(
                                                          '৳',
                                                          textScaleFactor: 1.0,
                                                          style: myStyle(14,Colors.white),
                                                        ),
                                                      ),
                                                    ),

                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                          offset: const Offset(1, -4),
                                                          child: Text(
                                                              NumberFormat
                                                                  .compactCurrency(
                                                                symbol: '',
                                                              ).format(allData[
                                                              0]
                                                                  .totalBankAmount),
                                                              style: myStyle(
                                                                  16, Colors.white,FontWeight.w700))
                                                      ),
                                                    ),
                                                  ]),
                                                )
                                              ],
                                            ),
                                          ),
                                          Tab(
                                            child: Column(
                                              children: [
                                                Text(
                                                  getTranslated(context,'t6'), //mfs
                                                  style: myStyle(
                                                      14,
                                                      BrandColors.colorText.withOpacity(0.6) ),
                                                ),
                                                SizedBox(height: 8,),
                                                RichText(
                                                  text: TextSpan(children: [
                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                        offset:  Offset(-1, -8),
                                                        child: Text(
                                                          '৳',
                                                          textScaleFactor: 1.0,
                                                          style: myStyle(14,Colors.white),
                                                        ),
                                                      ),
                                                    ),

                                                    WidgetSpan(
                                                      child: Transform.translate(
                                                          offset: const Offset(1, -4),
                                                          child: Text(
                                                              NumberFormat
                                                                  .compactCurrency(
                                                                symbol: '',
                                                              ).format(allData[
                                                              0]
                                                                  .totalMfsAmount),
                                                              style: myStyle(
                                                                  16, Colors.white,FontWeight.w700))
                                                      ),
                                                    ),

                                                  ]),
                                                )
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                      Divider(
                                        color: BrandColors.colorText.withOpacity(0.5),
                                        height: 0,thickness: 0.5,
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 7,
                              child: Container(
                                padding: EdgeInsets.only(left: 6, right: 6),
                                child: TabBarView(
                                  controller: controller,
                                  physics: BouncingScrollPhysics(),
                                  children: <Widget>[
                                    CashWidget(
                                      model: allData,
                                    ),
                                    BankWidget(
                                      model: dashBoardModel.bankDetails,
                                      totalBankBalance: allData[0]
                                          .totalBankAmount,
                                    ),
                                    MfsWidget(
                                      model: dashBoardModel.mfsDetails,
                                      totalMfsDetails:
                                      allData[0].totalMfsAmount,
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      ),
                    ),
                  ),
                ),
              ),



              Expanded(
                flex: 3,
                child: Container(
                  margin: EdgeInsets.only(top: 8),
                  color: Colors.transparent,
                  child: Row(
                    children: [
                      MiniCart(
                        color: Colors.greenAccent,
                        amount: allData[0].totalPayable,
                        cartName: getTranslated(context,'t10'),  //my payabales

                        icon: SvgPicture.asset(
                          "assets/myPay2.svg",
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                      ),
                      SizedBox(
                        width: 10,
                      ),
                      MiniCart(
                        color: Colors.redAccent,
                        amount: allData[0].totalReceivable,
                        cartName: getTranslated(context,'t11'),  //my receivables
                       // left: 4,
                        icon: SvgPicture.asset(
                          "assets/myRec.svg",
                          fit: BoxFit.contain,
                          height: 30,
                          width: 30,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
        ),
      ),
          ) : Spin(),
    );
  }




  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: myStyle(15, BrandColors.colorWhite),
      ),
      backgroundColor: Colors.indigo,
    ));
  }
}


class moneyField extends StatelessWidget {
  final Offset offset;
  final dynamic amount;
  final TextStyle ts;
  final TextStyle tks;
  moneyField({this.amount,this.ts,this.offset,this.tks});
  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(children: [

        WidgetSpan(
          child: Transform.translate(
            offset: offset,
            child: Text(
                '৳',
                textScaleFactor: 1.0,
                style: tks
            ),
          ),
        ),

        WidgetSpan(
          child: Transform.translate(
            offset: const Offset(1, -4),
            child: Text(
                NumberFormat.currency(
                    decimalDigits: (amount)
                    is int
                        ? 0
                        : 2,
                    symbol: '',
                    locale: "en-in")
                    .format(amount??0),
                style: ts
            ),
          ),
        ),

      ]),
    );
  }
}


class MiniCart extends StatelessWidget {
  final String cartName;
  final dynamic amount;
  final Color color;
  final double left;
  final double right;
  final dynamic icon;

  MiniCart(
      {this.amount,
        this.color,
        this.cartName,
        this.left,
        this.right,
        this.icon});


  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        alignment: Alignment.center,

        margin: EdgeInsets.only(top: 5, right: right ?? 0, bottom: 2, left: left ?? 0),
        decoration: BoxDecoration(
            color: BrandColors.colorPrimary,
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  cartName,
                  style: myStyle(12, BrandColors.colorDimText.withOpacity(0.6)),
                  //overflow: TextOverflow.ellipsis,
                ),
                SizedBox(height: 10,),
                RichText(
                  text: TextSpan(children: [

                    WidgetSpan(
                      child: Transform.translate(
                        offset: Offset(-1, -8),
                        child: Text(
                            '৳',
                            textScaleFactor: 1.0,
                            style: myStyle(14,Colors.white)
                        ),
                      ),
                    ),

                    WidgetSpan(
                      child: Transform.translate(
                        offset: const Offset(1, -4),
                        child: Text(
                          NumberFormat.compactCurrency(
                            decimalDigits: 0,
                            symbol: '',
                          ).format(amount),
                          style: myStyle(16, Colors.white,FontWeight.w500),
                        ),
                      ),
                    ),

                  ]),
                ),

              ],
            ),
            Container(
              child: FittedBox(
                child: Align(
                  alignment: Alignment.centerRight,
                  child: icon,
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

}

