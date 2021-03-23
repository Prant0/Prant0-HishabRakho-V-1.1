import 'dart:async';
import 'dart:convert';

import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/profile/my_profile.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/bank.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/cash.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:anthishabrakho/widget/mfs.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  static const String id = 'homepage';

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage>
    with SingleTickerProviderStateMixin {
  Color textColor = Color(0xFFce93d8);
  SharedPreferences sharedPreferences ;


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
  String image;

  loadUserImage()async{
    sharedPreferences = await SharedPreferences.getInstance();
    userName= sharedPreferences.getString("userName");
    print("user anme issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss ${userName}");
    image= sharedPreferences.getString("image");
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
/*  List<UserModel> user = [];


  loadUserDetails() async {
    await Provider.of<UserDetailsProvider>(context, listen: false)
        .getUserDetails();

  }*/
  @override
  Widget build(BuildContext context) {
  //user = Provider.of<UserDetailsProvider>(context).userData;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        elevation: 8,
        actions: [
          GestureDetector(
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile())).then((value) => setState(() {
             loadUserImage();
              }));
            },
            child: Padding(
              padding: const EdgeInsets.all(4.0),
              child: CircleAvatar(
                backgroundColor: Colors.transparent,
                  radius: 30,
                  backgroundImage: NetworkImage("http://hishabrakho.com/admin/user/$image",)),
            ),
          ),
          SizedBox(
            width: 10,
          ),
        ],
      ),
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      drawer: Drawerr(_scaffoldKey),
      body: allData.isNotEmpty
          ? ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: allData.length,
              itemBuilder: (context, index) {
                return Container(
                  height: MediaQuery.of(context).size.height,
                  child: Column(
                    children: [
                      Expanded(
                          flex: 2,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 15),
                            child: Row(
                              mainAxisAlignment:
                              MainAxisAlignment.spaceBetween,
                              //crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "${userName ??""} " ,
                                      style: myStyle(18, Colors.white,
                                          FontWeight.w500),
                                    ),
                                    Text(
                                      "Welcome back !",
                                      style: myStyle(18, Colors.white,
                                          FontWeight.w500),
                                    ),
                                  ],
                                ),
                                Column(
                                  mainAxisAlignment:
                                  MainAxisAlignment.center,
                                  crossAxisAlignment:
                                  CrossAxisAlignment.end,
                                  children: [
                                    Text(
                                      "৳ 43,054.25",
                                      style: myStyle(16, Colors.white,
                                          FontWeight.w700),
                                    ),
                                    Text(
                                      "Your financial position ",
                                      style: myStyle(
                                          12,
                                          BrandColors.colorDimText,
                                          FontWeight.w600),
                                    ),
                                  ],
                                )
                              ],
                            ),
                          )),
                      Expanded(
                        flex: 13,
                        child: Card(
                          elevation: 10,
                          color: BrandColors.colorPrimary,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12)),
                          child: Container(
                            width: double.infinity,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 4,
                                  child: Column(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceAround,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Column(
                                        children: [
                                          Text(" Money at hand",
                                              style: myStyle(14,
                                                  BrandColors.colorDimText)),
                                          SizedBox(
                                            height: 5,
                                          ),
                                          Text(
                                            NumberFormat.currency(
                                                    decimalDigits: (allData[
                                                                index]
                                                            .totalAmount) is int
                                                        ? 0
                                                        : 2,
                                                    symbol: ' ৳ ',
                                                    locale: "en-in")
                                                .format(
                                                    allData[index].totalAmount),
                                            style: myStyle(
                                                18,
                                                BrandColors.colorWhite,
                                                FontWeight.w800),
                                          ),
                                        ],
                                      ),
                                      Container(
                                        //height: 50,
                                        child: Column(
                                          children: [
                                            TabBar(
                                              physics: BouncingScrollPhysics(),
                                              //automaticIndicatorColorAdjustment: true,
                                              labelColor: Colors.green,
                                              indicatorColor: Colors.grey,
                                              unselectedLabelColor:
                                                  Colors.blueGrey,
                                              controller: controller,
                                              tabs: <Widget>[
                                                Tab(
                                                  child: Column(
                                                    children: [
                                                      Text(
                                                        "Cash",
                                                        style: myStyle(
                                                            14,
                                                            BrandColors
                                                                .colorDimText),
                                                      ),
                                                      Text(
                                                          NumberFormat
                                                              .compactCurrency(
                                                            symbol: ' ৳ ',
                                                          ).format(
                                                              allData[index]
                                                                  .totalCashAmount),
                                                          style: myStyle(
                                                              14, Colors.white))
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
                                                            BrandColors
                                                                .colorDimText),
                                                      ),

                                                      Text(
                                                          NumberFormat
                                                              .compactCurrency(
                                                            symbol: ' ৳ ',
                                                          ).format(allData[
                                                                  index]
                                                              .totalBankAmount),
                                                          style: myStyle(
                                                              14, Colors.white))
                                                      // Text("${allData[index].totalBankAmount}",style: myStyle(14,Colors.white),),
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
                                                            BrandColors
                                                                .colorDimText),
                                                      ),
                                                      Text(
                                                          NumberFormat
                                                              .compactCurrency(
                                                            symbol: ' ৳ ',
                                                          ).format(allData[
                                                                  index]
                                                              .totalMfsAmount),
                                                          style: myStyle(
                                                              14, Colors.white))
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Divider(
                                              color: Colors.white70,
                                              height: 0,
                                            )
                                          ],
                                        ),

                                        /*ListView.builder(
                                          scrollDirection: Axis.horizontal,
                                          itemCount: name.length,
                                          itemBuilder: (context, index) {
                                            return tebItems(index);
                                          },
                                        ),*/
                                      ),
                                    ],
                                  ),
                                ),
                                Expanded(
                                    flex: 6,
                                    child: Container(
                                      padding: EdgeInsets.only(
                                          bottom: 6, left: 6, right: 6),
                                      child: TabBarView(
                                        controller: controller,
                                        physics: BouncingScrollPhysics(),
                                        children: <Widget>[
                                          CashWidget(
                                            model: allData,
                                          ),
                                          BankWidget(
                                            model: dashBoardModel.bankDetails,
                                            totalBankBalance:
                                                allData[index].totalBankAmount,
                                          ),
                                          MfsWidget(
                                            model: dashBoardModel.mfsDetails,
                                            totalMfsDetails:
                                                allData[index].totalMfsAmount,
                                          ),
                                        ],
                                      ),
                                    ))
                              ],
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 4,
                        child: Container(
                          color: Colors.transparent,
                          child: Row(
                            children: [
                              MiniCart(
                                color: Colors.redAccent,
                                amount: allData[index].totalReceivable,
                                cartName: "My Receivables",
                                right: 6,
                              ),
                              MiniCart(
                                color: Colors.greenAccent,
                                amount: allData[index].totalPayable,
                                cartName: "My Payables",
                                left: 6,
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        flex: 6,
                        child: Container(
                            //color: Colors.greenAccent,
                            ),
                      ),
                    ],
                  ),
                );
              })
          : Center(
              child: Spin(),
            ),

      /* SmartRefresher(
      enablePullDown: true,
      header: WaterDropHeader(),
      controller: _refreshController,
      onRefresh: _onRefresh,
      // onLoading: _onLoading,
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15, vertical: 12),
        decoration: BoxDecoration(
          color: BrandColors.colorPrimaryDark,
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                        onTap: () {
                          print("tap");
                          _scaffoldKey.currentState.openDrawer();
                        },
                        child: Icon(
                          Icons.menu,
                          color: Colors.purple,
                          size: 30,
                        )),
                  ),
                  Expanded(
                    flex: 8,
                    child: Container(
                      //margin: EdgeInsets.only(top: 10.0),
                      child: Shimmer.fromColors(
                        period: Duration(seconds: 3),
                        baseColor: Colors.purple,
                        highlightColor: Colors.deepPurpleAccent,
                        child: Image(
                          image: AssetImage('assets/lgo.png'),
                        ),
                      ),
                    ),
                  )
                ],
              ),
              allData.isNotEmpty
                  ? Container(
                      child: ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: allData.length,
                        itemBuilder: (context, index) {
                          print(
                              "xxxxxxxxxxxxxxxxxx  ${allData[index].totalPayable}");
                          print(
                              "xxxxxxxxxxxxxxxxxx  ${allData[index].totalReceivable}");
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Center(
                                child: Text(
                                  NumberFormat.currency(
                                          decimalDigits: (allData[index]
                                                  .totalAmount) is int
                                              ? 0
                                              : 2,
                                          symbol: ' ৳ ',
                                          locale: "en-in")
                                      .format(allData[index].totalAmount),
                                  style: myStyle(24, BrandColors.colorWhite,
                                      FontWeight.w800),
                                ),
                              ),
                              Center(
                                child: Text(
                                  "Money at Hand Balance",
                                  style: myStyle(16, textColor),
                                ),
                              ),
                              Container(
                                padding: EdgeInsets.symmetric(vertical: 20),
                                child: Row(
                                  children: [
                                    dashBoardCard(
                                      "My Payables",
                                      Color(0xFFff8a65),
                                      Color(0xFFff5722),
                                      Color(0xFFdd2c00),
                                      Color(0xFFbf360c),
                                      allData[index].totalPayable,
                                    ),
                                    dashBoardCard(
                                      "My Receivables",
                                      Color(0xFF4db6ac),
                                      Color(0xFF00796b),
                                      Color(0xFF006064),
                                      Color(0xFF004d40),
                                      allData[index].totalReceivable,
                                    ),
                                  ],
                                ),
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 25, bottom: 15),
                                child: Text(
                                  "Cash Balance",
                                  style: myStyle(
                                      22, Colors.white70, FontWeight.w800),
                                ),
                              ),
                              Divider(
                                endIndent: 20,
                                color: Colors.grey,
                                height: 0.5,
                              ),

                              Container(
                                child: ListTile(
                                  title: Text(
                                    "Total Amount ",
                                    style: myStyle(18, BrandColors.colorWhite,
                                        FontWeight.w600),
                                  ),
                                  trailing: Text(
                                    NumberFormat.currency(
                                            symbol: ' ৳ ',
                                            decimalDigits: allData[index]
                                                    .totalCashAmount is int
                                                ? 0
                                                : 2,
                                            //decimalDigits: 2,
                                            locale: "en-in")
                                        .format(
                                            allData[index].totalCashAmount),
                                    style: myStyle(20, Color(0xffa7ffeb),
                                        FontWeight.w800),
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 18),
                                decoration: BoxDecoration(
                                    border: Border.all(
                                        color: Colors.purple, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                              ),
                              // totalAmount(index),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Text(
                                  "Bank Balance",
                                  style: myStyle(
                                      22, Colors.white70, FontWeight.w800),
                                ),
                              ),
                              Divider(
                                endIndent: 20,
                                color: Colors.grey,
                                height: 0.5,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF021A2C),
                                    border: Border.all(
                                        color: Colors.purple, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                    leading: Text(
                                      "Total Amount ",
                                      style: myStyle(
                                          18,
                                          BrandColors.colorWhite,
                                          FontWeight.w600),
                                    ),
                                    title: Text(
                                      NumberFormat.currency(
                                              symbol: ' ৳ ',
                                              decimalDigits: (allData[index]
                                                      .totalBankAmount) is int
                                                  ? 0
                                                  : 2,
                                              locale: "en-in")
                                          .format(
                                              allData[index].totalBankAmount),
                                      style: myStyle(17, Color(0xffa7ffeb),
                                          FontWeight.w800),
                                    ),
                                    trailing: InkWell(
                                      onTap: () {
                                        print("tap");
                                        setState(() {
                                          y = !y;
                                        });
                                      },
                                      child: y == false
                                          ? Icon(
                                              Icons.add,
                                              color: BrandColors.colorWhite,
                                            )
                                          : Icon(
                                              Icons
                                                  .indeterminate_check_box_rounded,
                                              color: BrandColors.colorWhite),
                                    )),
                                margin: EdgeInsets.symmetric(vertical: 15),
                              ),
                              Visibility(
                                child: ListView.builder(
                                  physics: NeverScrollableScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount:
                                      dashBoardModel.bankDetails.length,
                                  itemBuilder: (context, index) {
                                    return dashBoardModel.bankDetails == null
                                        ? Text(
                                            "Please Add account from Storage Hub")
                                        : Container(
                                            decoration: BoxDecoration(
                                                color: Color(0xFF021A2C),
                                                border: Border.all(
                                                    color: Colors.red,
                                                    width: 1),
                                                borderRadius:
                                                    BorderRadius.circular(
                                                        12)),
                                            //color: Color(0xFF021A2C),
                                            child: ListTile(
                                              leading: Image.network(
                                                "http://hishabrakho.com/admin/storage/hub/${dashBoardModel.bankDetails[index].storageHubLogo}",
                                                width: 60,
                                                height: 50,
                                                fit: BoxFit.fill,
                                              ),
                                              title: Text(
                                                "${dashBoardModel.bankDetails[index].storageHubName} ",
                                                style: myStyle(
                                                    18,
                                                    BrandColors.colorWhite,
                                                    FontWeight.w600),
                                              ),
                                              trailing: Text(
                                                NumberFormat.currency(
                                                        symbol: ' ৳ ',
                                                        decimalDigits: (dashBoardModel
                                                                    .bankDetails[
                                                                        index]
                                                                    .currentBankBalance)
                                                                is int
                                                            ? 0
                                                            : 2,
                                                        locale: "en-in")
                                                    .format(dashBoardModel
                                                        .bankDetails[index]
                                                        .currentBankBalance),
                                                style: myStyle(
                                                    18,
                                                    Color(0xffa7ffeb),
                                                    FontWeight.w800),
                                              ),
                                              subtitle: Text(
                                                "A/C:${dashBoardModel.bankDetails[index].userStorageHubAccountNumber} ",
                                                style: myStyle(
                                                    14,
                                                    Color(0xffa7ffeb),
                                                    FontWeight.w800),
                                              ),
                                            ),
                                            margin: EdgeInsets.symmetric(
                                                vertical: 10),
                                          );
                                  },
                                ),
                                visible: y == true,
                              ),
                              Padding(
                                padding: EdgeInsets.only(top: 15, bottom: 15),
                                child: Text(
                                  "MFS Balance",
                                  style: myStyle(
                                      22, Colors.white70, FontWeight.w800),
                                ),
                              ),
                              Divider(
                                endIndent: 20,
                                color: Colors.grey,
                                height: 05,
                              ),
                              Container(
                                decoration: BoxDecoration(
                                    color: Color(0xFF021A2C),
                                    border: Border.all(
                                        color: Colors.purple, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: Text(
                                    "Total Amount ",
                                    style: myStyle(
                                        17, BrandColors.colorWhite, FontWeight.w600),
                                  ),
                                  title: Text(
                                    //"৳ ${allData[index].totalMfsAmount} ",
                                    NumberFormat.currency(
                                            symbol: ' ৳ ',
                                            decimalDigits: (allData[index]
                                                    .totalMfsAmount) is int
                                                ? 0
                                                : 2,
                                            //decimalDigits: 2,
                                            locale: "en-in")
                                        .format(
                                            allData[index].totalMfsAmount),

                                    style: myStyle(18, Color(0xffa7ffeb),
                                        FontWeight.w800),
                                  ),
                                  trailing: InkWell(
                                    onTap: () {
                                      print("tap");
                                      setState(() {
                                        x = !x;
                                      });
                                    },
                                    child: x == false
                                        ? Icon(
                                            Icons.add,
                                            color:BrandColors.colorWhite,
                                          )
                                        : Icon(
                                            Icons
                                                .indeterminate_check_box_rounded,
                                            color:BrandColors.colorWhite),
                                  ),
                                ),
                                margin: EdgeInsets.symmetric(vertical: 15),
                              ),
                              Visibility(
                                child: ListView.builder(
                                  physics: BouncingScrollPhysics(),
                                  scrollDirection: Axis.vertical,
                                  shrinkWrap: true,
                                  itemCount: dashBoardModel.mfsDetails.length,
                                  itemBuilder: (context, index) {
                                    return Container(
                                      decoration: BoxDecoration(
                                        border: Border.all(
                                            color: Colors.purple, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(12),
                                        color: Color(0xFF021A2C),
                                      ),
                                      child: ListTile(
                                        leading: Image.network(
                                          "http://api.hishabrakho.com/admin/storage/hub/${dashBoardModel.mfsDetails[index].storageHubLogo}",
                                          width: 60,
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                        title: Text(
                                          "${dashBoardModel.mfsDetails[index].storageHubName} ",
                                          style: myStyle(18,BrandColors.colorWhite,
                                              FontWeight.w600),
                                        ),
                                        trailing: Text(
                                          NumberFormat.currency(
                                                  symbol: ' ৳ ',
                                                  decimalDigits: (dashBoardModel
                                                              .mfsDetails[index]
                                                              .currentMfsBalance)
                                                          is int
                                                      ? 0
                                                      : 2,
                                                  locale: "en-in")
                                              .format(dashBoardModel
                                                  .mfsDetails[index]
                                                  .currentMfsBalance),
                                          style: myStyle(
                                              18,
                                              Color(0xffa7ffeb),
                                              FontWeight.w800),
                                        ),
                                        subtitle: Text(
                                          "A/C:${dashBoardModel.mfsDetails[index].userStorageHubAccountNumber} ",
                                          style: myStyle(
                                              14,
                                              Color(0xffa7ffeb),
                                              FontWeight.w800),
                                        ),
                                      ),
                                      margin:
                                          EdgeInsets.symmetric(vertical: 10),
                                    );
                                  },
                                ),
                                visible: x == true,
                              ),
                            ],
                          );
                        },
                      ),
                    )
                  : Center(child: Spin()),
            ],
          ),
        ),
      ),
    ),*/
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

class MiniCart extends StatelessWidget {
  final String cartName;
  final dynamic amount;
  final Color color;
  final double left;
  final double right;

  MiniCart({this.amount, this.color, this.cartName, this.left, this.right});

  @override
  Widget build(BuildContext context) {
    return Expanded(
      flex: 5,
      child: Container(
        padding: EdgeInsets.only(left: 12),
        margin: EdgeInsets.only(
            top: 8, right: right ?? 0, bottom: 8, left: left ?? 0),
        decoration: BoxDecoration(
            color: BrandColors.colorPrimary,
            borderRadius: BorderRadius.circular(12.0)),
        child: Row(
          children: [
            Expanded(
              flex: 5,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Flexible(
                    child: Text(
                      cartName,
                      style: myStyle(12, BrandColors.colorDimText),
                      //overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                    NumberFormat.compactCurrency(
                      decimalDigits: 0,
                      symbol: ' ৳ ',
                    ).format(amount),
                    style: myStyle(14, Colors.white),
                  )
                ],
              ),
            ),
            Expanded(
                flex: 5,
                child: Icon(
                  Icons.confirmation_num,
                  color: color,
                ))
          ],
        ),
      ),
    );
  }
}
