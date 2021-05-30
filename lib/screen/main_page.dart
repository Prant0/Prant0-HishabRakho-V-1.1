import 'dart:async';

import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/entries_Home_Model.dart';
import 'package:anthishabrakho/screen/addEntriesCategories.dart';
import 'package:anthishabrakho/screen/addEntriesSubCategories.dart';
import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'file:///H:/antipoints/hishabRakho%20v1.0/anthishabrakho/lib/screen/tabs/home_page.dart';
import 'package:anthishabrakho/screen/profile/my_profile.dart';
import 'package:anthishabrakho/screen/tabs/myBudget.dart';
import 'package:anthishabrakho/screen/tabs/myReports.dart';
import 'package:anthishabrakho/screen/tabs/myStorageHubs.dart';
import 'package:anthishabrakho/screen/tabs/myTransection.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';

  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage>
    with SingleTickerProviderStateMixin {
  @override
  TabController tabController;

  List<EntriesHomeModel> dataa = [];

  void initState() {
    tabController = TabController(length: 5, vsync: this);
    check().then((intenet) {
      if (intenet != null && intenet) {
        if (mounted) {
          addEntryesHomee();
        }
      } else
        showInSnackBar("No Internet Connection");
    });
    super.initState();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<dynamic> addEntryesHomee() async {
    final data = await CustomHttpRequests.addEntriesHome();
    print("Entries home value are $data");
    for (var entries in data) {
      EntriesHomeModel model = EntriesHomeModel(
          id: entries["id"],
          position: entries["position"],
          classIcon: entries["class_icon"],
          eventClassName: entries["event_class_name"]);
      try {
        print(" view my entries are ${entries['position']}");
        dataa.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            dataa.add(model);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0)),
            title: Text(
              "Are You Sure ?",
              style: myStyle(16, Colors.white, FontWeight.w500),
            ),
            content: Text("You are going to exit the app !"),
            titlePadding:
                EdgeInsets.only(top: 30, bottom: 12, right: 30, left: 30),
            contentPadding: EdgeInsets.only(
              left: 30,
              right: 30,
            ),
            backgroundColor: BrandColors.colorPrimaryDark,
            contentTextStyle: myStyle(
                14, BrandColors.colorText.withOpacity(0.7), FontWeight.w400),
            titleTextStyle: myStyle(18, Colors.white, FontWeight.w500),
            actionsPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 12),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    "No",
                    style: myStyle(14, BrandColors.colorText),
                  )),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16, horizontal: 22),
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text(
                  'Yes',
                  style: myStyle(14, Colors.white, FontWeight.w500),
                ),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),
            ],
          );
        });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  SharedPreferences sharedPreferences;
  String userName;
  String image;

  loadUserImage() async {
    sharedPreferences = await SharedPreferences.getInstance();
    userName = sharedPreferences.getString("userName");
    print(
        "user anme isssssssssssssssssssssssssssssssssssssssssss ${userName}");
    image = sharedPreferences.getString("image");
    print("image is $image");
  }

  @override
  void didChangeDependencies() async {
    await loadUserImage();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
        appBar: AppBar(
          backgroundColor: BrandColors.colorPrimaryDark,
          title: Text(
            _currentSelected == 0
                ? ""
                : _currentSelected == 1
                    ? getTranslated(context,'t40')// "My Storage Hub"
                    : _currentSelected == 2
                        ? getTranslated(context,'t41')  //  "My Budget"
                        : _currentSelected == 3
                            ? getTranslated(context,'t42')  //  "My Reports"
                            : _currentSelected == 4
                                ?getTranslated(context,'t43')  //  "My Entries"
                                : "",
            style: myStyle(20),
          ),
          leading: IconButton(
            icon: SvgPicture.asset(
              "assets/drawer.svg",
              fit: BoxFit.contain,
              height: 20,
              width: 20,
            ),
            onPressed: () {
              _scaffoldKey.currentState.openDrawer();
            },
          ),
          // backgroundColor: BrandColors.colorPrimaryDark,
          elevation: 0,
          actions: [
            GestureDetector(
              onTap: () {
                Navigator.push(context,
                        MaterialPageRoute(builder: (context) => MyProfile()))
                    .then((value) => setState(() {
                          loadUserImage();
                        }));
              },
              child: Container(
                margin: EdgeInsets.only(top: 12, right: 8, left: 8, bottom: 5),

                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: BrandColors.colorText, width: 1.5),
                ),
                child: CircleAvatar(
                    backgroundColor: Colors.transparent,
                    backgroundImage: NetworkImage(
                      "http://hishabrakho.com/admin/user/$image",
                    )),
              ),
            ),
            SizedBox(
              width: 10,
            ),
          ],
        ),
        drawer: Drawerr(),
        body: WillPopScope(
          onWillPop: onBackPressed,
          child: Stack(
            children: [
              TabBarView(
                controller: tabController,
                physics: NeverScrollableScrollPhysics(),
                children: [
                  HomePage(),
                  MyStorageHubs(),
                  MyBudget(),
                  MyReports(),
                  //ReportCategory(),
                  MyTransection(),
                ],
              ),
              Visibility(
                visible: _currentSelected==0 || _currentSelected==1 || _currentSelected==2 || _currentSelected==4,
                child: Positioned(
                  bottom: 16,
                  right: 20,
                  height: 50,
                  width: 50,
                  child: FloatingActionButton(
                    // mini: true,
                    isExtended: true,
                    elevation: 8,
                    onPressed: () {
                      showModalBottomSheet(
                          useRootNavigator: true,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.only(
                                  topLeft: Radius.circular(13.0),
                                  topRight: Radius.circular(13.0))),
                          backgroundColor: BrandColors.colorPrimaryDark,
                          context: context,
                          isScrollControlled: true,
                          builder: (
                            context,
                          ) {
                            return FractionallySizedBox(
                              heightFactor: 0.4,
                              child: Padding(
                                  padding:
                                      EdgeInsets.only(top: 10, left: 8, right: 8),
                                  child: Column(
                                    children: [
                                      Center(
                                        child: Container(
                                          height: 2,
                                          width: 50,
                                          color: BrandColors.colorText
                                              .withOpacity(0.6),
                                        ),
                                      ),
                                      GridView.builder(
                                        gridDelegate:
                                            SliverGridDelegateWithFixedCrossAxisCount(
                                                crossAxisCount: 3,
                                                crossAxisSpacing: 5,
                                                mainAxisSpacing: 4),
                                        itemCount: dataa.length,
                                        shrinkWrap: true,
                                        scrollDirection: Axis.vertical,
                                        itemBuilder: (context, index) {
                                          return GestureDetector(
                                            onTap: () {
                                              print(
                                                  "event class name : ${dataa[index].eventClassName}");
                                              dataa[index].eventClassName ==
                                                      "Fund Transfer"
                                                  ? Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddEntriesSubCategories(
                                                                id: 28,
                                                                namee: dataa[
                                                                        index]
                                                                    .eventClassName,
                                                              )))
                                                  : Navigator.push(
                                                      context,
                                                      MaterialPageRoute(
                                                          builder: (context) =>
                                                              AddEntriesCategories(
                                                                id: dataa[index]
                                                                    .id,
                                                                name: dataa[index]
                                                                    .eventClassName,
                                                              )));
                                            },
                                            child: Container(
                                              // margin: EdgeInsets.only(top: 10),
                                              padding: EdgeInsets.only(
                                                top: 10,
                                              ),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Container(
                                                    //margin: EdgeInsets.all(5.0),
                                                    decoration: BoxDecoration(
                                                        color: Color(0xFFD2DCF7)
                                                            .withOpacity(0.15),
                                                        borderRadius:
                                                            BorderRadius.circular(
                                                                8.0)),
                                                    child: Image.network(
                                                      "http://hishabrakho.com/admin/${dataa[index].classIcon}",
                                                      width: 50,
                                                      height: 50,
                                                      fit: BoxFit.fill,
                                                    ),
                                                    padding: EdgeInsets.symmetric(
                                                        horizontal: 12,
                                                        vertical: 12),
                                                  ),
                                                  SizedBox(
                                                    height: 8,
                                                  ),
                                                  FittedBox(
                                                    child: Text(
                                                      dataa[index]
                                                          .eventClassName
                                                          .toString(),
                                                      style: myStyle(
                                                          15,
                                                          Colors.white,
                                                          FontWeight.w500),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )),
                            );
                          });
                    },
                    splashColor: Colors.teal,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                    backgroundColor: BrandColors.colorPurple,
                    child: Icon(
                      Icons.add,
                      color: Colors.white,
                    ),
                  ),
                ),
              )
            ],
          ),
        ),
        bottomNavigationBar: SafeArea(
          child: Container(
              padding: EdgeInsets.symmetric(vertical: 13, horizontal: 13),
              margin: EdgeInsets.only(bottom: 13, right: 17, left: 17, top: 8),
              decoration: BoxDecoration(
                  color: BrandColors.colorPrimary,
                  borderRadius: BorderRadius.all(Radius.circular(10)),
                  boxShadow: [
                    BoxShadow(
                      spreadRadius: -10,
                      blurRadius: 60,
                      color: Colors.black.withOpacity(0.4),
                      offset: Offset(0, 25),
                    ),
                  ]),
              child: FittedBox(
                child: GNav(

                  curve: Curves.fastOutSlowIn,
                  duration: Duration(milliseconds: 300),
                  tabs: [
                    GButton(
                      
                      gap: gap,
                      text:  getTranslated(context,'t12'), //home
                      leading:_currentSelected == 0 ? SvgPicture.asset(
                        "assets/home2.svg" ,
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                      ): SvgPicture.asset(
                        "assets/home.svg" ,
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                        color: BrandColors.colorText.withOpacity(0.6),
                      ),
                      textColor: BrandColors.colorPrimary,
                      padding: padding,
                      textStyle: myStyle(14, BrandColors.colorText, FontWeight.w500),
                      backgroundColor: BrandColors.colorPrimaryDark.withOpacity(0.8),
                    ),
                    GButton(
                      backgroundColor: BrandColors.colorPrimaryDark.withOpacity(0.8),
                      gap: gap,
                      text:  getTranslated(context,'t13'), //storage
                      leading:_currentSelected == 1 ? SvgPicture.asset(
                        "assets/storage2.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                      ) :SvgPicture.asset(
                        "assets/storage.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                        color: BrandColors.colorText.withOpacity(0.6),
                      ),
                      textColor: BrandColors.colorPrimary,
                      padding: padding,
                      textStyle:
                          myStyle(14, BrandColors.colorText, FontWeight.w500),

                    ),
                    GButton(
                      gap: gap,
                      text:  getTranslated(context,'t14'), //budget
                      leading: _currentSelected == 2 ? SvgPicture.asset(
                        "assets/budget2.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                      ):SvgPicture.asset(
                        "assets/budget.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                        color: BrandColors.colorText.withOpacity(0.6),
                      ),
                      textColor: BrandColors.colorPrimary,
                      padding: padding,
                      textStyle:
                          myStyle(14, BrandColors.colorText, FontWeight.w500),
                      backgroundColor:  BrandColors.colorPrimaryDark.withOpacity(0.8),
                    ),
                    GButton(
                      gap: gap,
                      text: getTranslated(context,'t15'), //reports
                      leading:_currentSelected == 3? SvgPicture.asset(
                        "assets/report2.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                      ):SvgPicture.asset(
                        "assets/report.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                        color: BrandColors.colorText.withOpacity(0.6),
                      ),
                      textColor: BrandColors.colorPrimary,
                      padding: padding,
                      backgroundColor:  BrandColors.colorPrimaryDark.withOpacity(0.8),
                      textStyle:
                          myStyle(14, BrandColors.colorText, FontWeight.w500),
                    ),
                    GButton(
                      gap: gap,
                      text:  getTranslated(context,'t16'), //entries
                      leading: _currentSelected == 4 ? SvgPicture.asset(
                        "assets/entries2.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                      ):SvgPicture.asset(
                        "assets/entries.svg",
                        fit: BoxFit.contain,
                        height: 21,
                        width: 21,
                        color: BrandColors.colorText.withOpacity(0.6),
                      ),
                      padding: padding,
                      backgroundColor:  BrandColors.colorPrimaryDark.withOpacity(0.8),
                      textStyle:
                          myStyle(14, BrandColors.colorText, FontWeight.w500),
                    ),
                  ],
                  selectedIndex: _currentSelected,
                  onTabChange: (index) {
                    setState(() {
                      _currentSelected = index;
                    });
                    tabController.index = index;
                  },
                ),
              )),
        ));

  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: myStyle(15, BrandColors.colorText),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  int _currentSelected = 0;



  var padding = EdgeInsets.symmetric(horizontal: 20, vertical: 18);
  double gap = 20;
}
