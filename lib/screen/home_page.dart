import 'dart:async';
import 'dart:convert';

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

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {

  bool isCash =false;
  bool isBank =true;
  bool isMfs=false;
  Color textColor = Color(0xFFce93d8);

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

  List<DashBoardModel> allData = [];
  DashBoardModel dashBoardModel;
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

  void loadDashBoardData() async {
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/summary",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("dashboard details are   ::  ${response.body}");
    dashBoardModel = DashBoardModel.fromJson(jsonResponce);
    try {
      allData.firstWhere(
          (element) => element.totalAmount == dashBoardModel.totalAmount);
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
      body: allData.isNotEmpty
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: allData.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: EdgeInsets.symmetric(horizontal: 11),
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 3,
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${userName ?? ""} ",
                                      style: myStyle(
                                        20,
                                        Colors.white,FontWeight.w500
                                      ),
                                    ),
                                    Text(
                                      "Welcome back !",
                                      style: myStyle(
                                        20,
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
                                      amount: 430000,
                                      ts: myStyle(18,Colors.white,FontWeight.w700),
                                      offset: Offset(-2, -7),
                                      tks: myStyle(14,Colors.white),
                                    ),
                                    Text(
                                      "Your financial position ",
                                      style: myStyle(
                                        14,
                                        BrandColors.colorText,FontWeight.w400
                                      ),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 13,
                        child: Card(
                          color: BrandColors.colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(10)),
                          child: Container(
                            padding: EdgeInsets.only(top: 8),
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 5,
                                  child: Container(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Column(
                                          children: [
                                            Text(" Money at hand",
                                                style: myStyle(16,
                                                    BrandColors.colorText,FontWeight.w400),),
                                            SizedBox(
                                              height: 8,
                                            ),
                                            moneyField(
                                              amount: allData[index].totalAmount,
                                              ts: myStyle(22,Colors.white,FontWeight.w700),
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
                                              indicatorColor: BrandColors.colorText,
                                              unselectedLabelColor:
                                                  Colors.transparent,
                                              controller: controller,

                                              tabs: <Widget>[
                                                Tab(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Cash",
                                                        style: myStyle(
                                                            14,
                                                           isCash==true? BrandColors
                                                                .colorText :Colors.grey,FontWeight.w400),
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
                                                                  index]
                                                                      .totalCashAmount),
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
                                                        "Bank",
                                                        style: myStyle(
                                                            14,
                                                           isBank==true? BrandColors
                                                                .colorText :Colors.grey,FontWeight.w400),
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
                                                                    index]
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
                                                        "MFS",
                                                        style: myStyle(
                                                            14,
                                                           isMfs==true? BrandColors
                                                                .colorText :Colors.grey,FontWeight.w400),
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
                                                                    index]
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
                                              color: BrandColors.colorText,
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
                                      padding:
                                          EdgeInsets.only(left: 6, right: 6),
                                      child: TabBarView(
                                        controller: controller,
                                        physics: BouncingScrollPhysics(),
                                        children: <Widget>[
                                          CashWidget(
                                            model: allData,
                                          ),
                                          BankWidget(
                                            model: dashBoardModel.bankDetails,
                                            totalBankBalance: allData[index]
                                                .totalBankAmount,
                                          ),
                                          MfsWidget(
                                            model: dashBoardModel.mfsDetails,
                                            totalMfsDetails:
                                                allData[index].totalMfsAmount,
                                          ),
                                        ],
                                      ),
                                    )),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 5,
                        child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 3),
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              MiniCart(
                                color: Colors.redAccent,
                                amount: allData[index].totalReceivable,
                                cartName: "My Receivables",
                                right: 4,
                                icon: SvgPicture.asset(
                                  "assets/myPay.svg",
                                  fit: BoxFit.contain,
                                  height: 30,
                                  width: 30,
                                ),
                              ),
                              MiniCart(
                                color: Colors.greenAccent,
                                amount: allData[index].totalPayable,
                                cartName: "My Payables",
                                left: 4,
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
                      Expanded(
                        flex: 8,
                        child: Column(
                          children: [
                            Container(
                                //color: Colors.greenAccent,
                                ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              })
          : Center(
              child: Spin(),
            ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: myStyle(15, BrandColors.colorWhite),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  bool x = false;
  bool y = false;
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

  List<ImageProvider> _images = [
    NetworkImage(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLe5PABjXc17cjIMOibECLM7ppDwMmiDg6Dw&usqp=CAU"),
    NetworkImage(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQm3Qiic3TbrQuhexXWniNXutqY7CKgUGiNog&usqp=CAU"),
    NetworkImage(
        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcRLe5PABjXc17cjIMOibECLM7ppDwMmiDg6Dw&usqp=CAU"),
  ];

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 25,vertical: 21),
        margin: EdgeInsets.only(
            top: 5, right: right ?? 0, bottom: 2, left: left ?? 0),
        decoration: BoxDecoration(
            color: BrandColors.colorPrimary,
            borderRadius: BorderRadius.circular(8.0)),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      cartName,
                      style: myStyle(12, BrandColors.colorDimText),
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
                  padding: EdgeInsets.only(left: 35),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: FlutterImageStack.providers(
                      providers: _images,
                      showTotalCount: true,
                      backgroundColor: BrandColors.colorText,

                      totalCount: 4,
                      imageRadius: 26,
                      imageCount: 3,
                      imageBorderWidth: 1,
                      imageBorderColor: BrandColors.colorPrimary,

                      extraCountTextStyle: myStyle(12, Colors.black54),
                    ),
                  ),
                )
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 00),
              child: Align(
                alignment: Alignment.topLeft,
                child: icon,
              ),
            ),
          ],
        ),
      ),
    );
  }

}
