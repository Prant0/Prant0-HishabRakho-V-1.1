import 'dart:convert';
import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/demo_Localization.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'file:///H:/antipoints/hishabRakho%20v1.0/anthishabrakho/lib/screen/tabs/home_page.dart';
import 'package:anthishabrakho/screen/stapper/addBank.dart';
import 'package:anthishabrakho/screen/stapper/addMfs.dart';
import 'package:anthishabrakho/screen/viewStorageHubDetails.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/screen/form_screen/edit_storageHub_cash.dart';
import 'package:anthishabrakho/screen/form_screen/edit_storage_hub.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:anthishabrakho/widget/storageHubCard.dart';
import 'package:intl/intl.dart';
import 'package:http/http.dart' as http;
import 'package:pull_to_refresh/pull_to_refresh.dart';

class MyStorageHubs extends StatefulWidget {
  @override
  _MyStorageHubsState createState() => _MyStorageHubsState();
}

class _MyStorageHubsState extends State<MyStorageHubs> {
  Color boxColor = Color(0xFF021A2C);


  double iconSize = 40;
  List<MyTransectionModel> bankList = [];
  List<MyTransectionModel> mfsList = [];
  List<MyTransectionModel> cashList = [];

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  @override
  void initState() {
    check().then((intenet) {
      if (intenet != null && intenet) {
        myMfsDetails();
        myCashDetails();
        mybankDetails();
        loadDashBoardData();
      } else
        showInSnackBar("No Internet Connection");
    });

    super.initState();
  }
  Future<dynamic> mybankDetails() async {
    bankList.clear();
    final data = await CustomHttpRequests.userBankDetails();
    print("Bank Details are $data");
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        storageHubCategoryId: entries["storage_hub_category_id"],
        storageHubId: entries["storage_hub_id"],
        userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
        userStorageHubAccountName: entries["user_storage_hub_account_name"],
        balance: entries["single_bank_balance"],
        date: entries["formated_date"],
        storageHubName: entries["storage_hub_name"],
        hubCategoryName: entries["storage_hub_category_name"],
        photo: entries["storage_hub_logo"],
        totalBalance: entries["balance"],
      );
      try {
        bankList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            bankList.add(model);
          });
        }
      }
    }
  }

  Future<dynamic> myMfsDetails() async {
    mfsList.clear();
    final data = await CustomHttpRequests.userMfsDetails();
    print("MFS Details are $data");
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        storageHubCategoryId: entries["storage_hub_category_id"],
        storageHubId: entries["storage_hub_id"],
        userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
        userStorageHubAccountName: entries["user_storage_hub_account_name"],
        balance: entries["single_mfs_balance"],
        date: entries["formated_date"],
        storageHubName: entries["storage_hub_name"],
        hubCategoryName: entries["storage_hub_category_name"],
        totalBalance: entries["balance"],
        photo: entries["storage_hub_logo"],
      );
      try {
        mfsList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            mfsList.add(model);
          });
        }
      }
    }
  }

  Future<dynamic> myCashDetails() async {
    cashList.clear();
    final data = await CustomHttpRequests.userCashDetails();
    print("Cash Details are $data");
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        storageHubCategoryId: entries["storage_hub_category_id"],
        storageHubId: entries["storage_hub_id"],
        balance: entries["balance"],
        totalBalance: entries["total_balance"],
        hubCategoryName: entries["storage_hub_category_name"],
        date: entries["date"],
      );
      try {
        cashList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            cashList.add(model);
          });
        }
      }
    }
  }

  List<DashBoardModel> allData = [];
  DashBoardModel dashBoardModel;
  void loadDashBoardData() async {
    allData.clear();
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


 //


  RefreshController _refreshController = RefreshController(initialRefresh: false);

  void _onRefresh() async {
    myMfsDetails();
    myCashDetails();
    mybankDetails();
    await Future.delayed(Duration(seconds: 1));
    _refreshController.refreshCompleted();
  }

 /* String getTranslated(BuildContext context, String key) {
    return DemoLocalization.of(context).translate(key);
  }*/

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: BrandColors.colorPrimaryDark,
      body:SmartRefresher(

        enablePullDown: true,
        header: WaterDropHeader(),
        controller: _refreshController,
        onRefresh: _onRefresh,

        child: allData.isNotEmpty? SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Container(
            padding: EdgeInsets.only(left: 20,),
            child: ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: allData.length,
              itemBuilder: (context,index){
                return SingleChildScrollView(
                  physics: BouncingScrollPhysics(),
                  child: Column(
                    children: [
                       Container(
                        height: 88,
                        padding:EdgeInsets.symmetric(vertical: 20),
                        margin: EdgeInsets.only(bottom: 25, top: 15,right: 20),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(12.0),
                          color: BrandColors.colorPrimary,
                        ),
                        child: Center(
                          child: Row(
                            children: [
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated(context,'t4'),  // "Cash",
                                      style: myStyle(14, BrandColors.colorDimText.withOpacity(0.7)),),
                                    SizedBox(height: 6,),

                                    RichText(
                                      text: TextSpan(children: [

                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset:  Offset(-1, -8),
                                            child: Text(
                                              '৳',
                                              textScaleFactor: 1.0,
                                              style: myStyle(12,BrandColors.colorText),
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
                                                  ).format(allData[index].totalCashAmount ?? 0),
                                                  style:  myStyle(16, Colors.white, FontWeight.w700),)
                                          ),
                                        ),
                                      ]),
                                    )


                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated(context,'t5'), // "Bank",
                                      style: myStyle(14, BrandColors.colorDimText.withOpacity(0.7)),
                                    ),
                                    SizedBox(height: 6,),
                                    RichText(
                                      text: TextSpan(children: [

                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset:  Offset(-1, -8),
                                            child: Text(
                                              '৳',
                                              textScaleFactor: 1.0,
                                              style: myStyle(12,BrandColors.colorText),
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
                                                ).format(allData[index].totalBankAmount ?? 0,),
                                                style:  myStyle(16, Colors.white, FontWeight.w700),)
                                          ),
                                        ),
                                      ]),
                                    )

                                  ],
                                ),
                              ),
                              Expanded(
                                flex: 5,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      getTranslated(context,'t6'),  // "MFS",
                                      style: myStyle(14, BrandColors.colorDimText.withOpacity(0.7)),
                                    ),
                                    SizedBox(height: 6),
                                    RichText(
                                      text: TextSpan(children: [

                                        WidgetSpan(
                                          child: Transform.translate(
                                            offset:  Offset(-1, -8),
                                            child: Text(
                                              '৳',
                                              textScaleFactor: 1.0,
                                              style: myStyle(12,BrandColors.colorText),
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
                                                ).format(allData[index].totalMfsAmount ?? 0,),
                                                style:  myStyle(16, Colors.white, FontWeight.w700),)
                                          ),
                                        ),
                                      ]),
                                    )

                                  ],
                                ),
                              ),

                            ],
                          ),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 17),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context,'t17'),  //"Cash Details",
                              style: myStyle(16, BrandColors.colorDimText),
                            ),

                          ],
                        ),
                      ),
                      GestureDetector(
                          onTap:  () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        ViewStorageHubDetails(
                                          id: cashList[index].id,
                                          name: cashList[index]
                                              .storageHubName,
                                          balance: cashList[index].totalBalance,

                                        )));
                          },
                          child: ListView.builder(
                            itemCount: cashList.length,
                            shrinkWrap: true,
                            itemBuilder: (context,index){
                              return Container(
                                  height: 80,
                                  margin: EdgeInsets.only(bottom: 25,right: 20),
                                  padding: EdgeInsets.symmetric(horizontal: 25),

                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    color: BrandColors.colorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        mainAxisAlignment: MainAxisAlignment.center,
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            getTranslated(context,'t22'), // "Current Balance",
                                            style: myStyle(14, BrandColors.colorDimText.withOpacity(0.6)),
                                          ),
                                          SizedBox(height: 6,),
                                          moneyField(
                                            amount: cashList[index].totalBalance ?? 0,
                                            ts: myStyle(16, Colors.white, FontWeight.w500),
                                            offset: Offset(-1, -8),
                                            tks: myStyle(12,Colors.white),
                                          ),
                                          /*Text(
                                          NumberFormat
                                              .compactCurrency(
                                            symbol: ' ৳ ',
                                          ).format(cashList[
                                          index]
                                              .totalBalance ?? 0),
                                          style: myStyle(
                                              14, Colors.white))*/
                                        ],
                                      ),
                                      InkWell(
                                        onTap: () {
                                          String type = "cash";
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) => UpdateStorageHubCash(
                                                  model: cashList[index],
                                                  type: type,

                                                )),
                                          ).then((value) => setState(() {
                                            myCashDetails();
                                            loadDashBoardData();
                                          }));
                                        },
                                        child: Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 10, vertical: 8),
                                          alignment: Alignment.center,
                                          margin: EdgeInsets.symmetric(vertical: 18),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(5),
                                              border: Border.all(
                                                  color: Colors.deepPurpleAccent)),
                                          child: SvgPicture.asset("assets/edit.svg",
                                            alignment: Alignment.center,
                                            height: 18,width: 9,
                                          ),
                                        ),
                                      )
                                    ],
                                  ));
                            },
                          )
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 17),
                        margin: EdgeInsets.only(right: 20, ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context,'t18'), // "Bank Details",
                              style: myStyle(16, BrandColors.colorDimText),
                            ),

                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddBankStapper(
                                    types: "addStorageHub",
                                  )),
                                ).then((value) => setState(() {
                                  mybankDetails();
                                  loadDashBoardData();
                                }));
                              },
                              child: Text(
                                getTranslated(context,'t20'), //"+ Add Bank",
                                style: myStyle(
                                    14, BrandColors.colorPurple, FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 160,

                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: bankList.length,
                          itemBuilder: (context, index) {
                            return GestureDetector(
                              onTap:  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewStorageHubDetails(
                                              id: bankList[index].id,
                                              name: bankList[index]
                                                  .storageHubName,
                                              image: bankList[index].photo,
                                              number: bankList[index].userStorageHubAccountNumber,
                                              balance: bankList[index].totalBalance,
                                            )));
                              },
                              child: StorageCart(
                                balance: bankList[index].balance,
                                id: bankList[index].id,
                                photo: bankList[index].photo,
                                storageName: bankList[index].storageHubName,
                                accountNumber: bankList[index].userStorageHubAccountNumber,
                                delete:() {
                                  print("tap");
                                  CustomHttpRequests
                                      .deleteStorageHub(
                                      bankList[index]
                                          .id)
                                      .then((value) =>
                                  value);
                                  setState(() {
                                    bankList.removeAt(
                                        index);
                                  });
                                  showInSnackBar(
                                    "1 Item Delete",
                                  );
                                  Navigator.of(context).pop();
                                },

                                edit:() {
                                  String type = "bank";
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => EditStorageHub(
                                          model: bankList[index],
                                          type: type,
                                        )),
                                  ).then((value) => setState(() {
                                    mybankDetails();
                                    loadDashBoardData();
                                  }));
                                },

                              ),
                            );
                          },
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(vertical: 17),
                        margin: EdgeInsets.only(right: 20, ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              getTranslated(context,'t19'), //"MFS Details",
                              style: myStyle(16, BrandColors.colorDimText),
                            ),
                            GestureDetector(
                              onTap: () async {
                                await Navigator.push(
                                  context,
                                  MaterialPageRoute(builder: (context) => AddMfsStapper(
                                    types: "addStorageHub",
                                  )),
                                ).then((value) => setState(() {
                                  myMfsDetails();
                                  loadDashBoardData();
                                }));
                              },
                              child: Text(
                                getTranslated(context,'t21'), // "+ Add MFS",
                                style: myStyle(
                                    14, BrandColors.colorPurple, FontWeight.w600),
                              ),
                            ),
                          ],
                        ),
                      ),

                      Container(
                        height: 160,
                        width: double.maxFinite,
                        child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemCount: mfsList.length,
                          itemBuilder: (context, index) {
                            return InkWell(
                              onTap:  () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ViewStorageHubDetails(
                                              id: mfsList[index].id,
                                              name: mfsList[index]
                                                  .storageHubName,
                                              image: mfsList[index].photo,
                                              number: mfsList[index].userStorageHubAccountNumber,
                                              balance: mfsList[index].totalBalance,
                                            )));
                              },
                              child: StorageCart(
                                balance: mfsList[index].balance,
                                id: mfsList[index].id,
                                photo: mfsList[index].photo,
                                storageName: mfsList[index].storageHubName,
                                accountNumber: mfsList[index].userStorageHubAccountNumber,
                                delete:() {
                                  print("tap");
                                  CustomHttpRequests
                                      .deleteStorageHub(
                                      mfsList[index]
                                          .id)
                                      .then(
                                          (value) => value);
                                  setState(() {
                                    mfsList.removeAt(index);
                                  });
                                  showInSnackBar(
                                    "1 Item deleted",
                                  );
                                  Navigator.pop(context);
                                },
                                edit: () {
                                  String type = "mfs";
                                  Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            EditStorageHub(
                                              model: mfsList[index],
                                              type: type,
                                            )),
                                  ).then((value) => setState(() {
                                    myMfsDetails();
                                    loadDashBoardData();
                                  }));
                                },

                              ),
                            );
                          },
                        ),
                      ),

                      Container(
                        height: 70,
                      )
                    ],
                  ),
                );

              },
            ),
          ),
        ) : Center(child: Spin(),  ),
      )
    );
  }



  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        value,
        style: myStyle(15, Colors.white),
      ),
      backgroundColor: Colors.indigo,
    ));
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}


class StorageCart extends StatelessWidget {
  final String storageName;
  final String accountName;
  final String accountNumber;
  final dynamic balance;
  final String date;
  final Function edit;
  final Function delete;
  final String photo;
  final int id;
  final bool isBank;

  StorageCart(
      {this.id,
        this.isBank,
        this.balance,
        this.accountNumber,
        this.storageName,
        this.date,
        this.photo,
        this.accountName,
        this.edit,
        this.delete});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 20,vertical: 0),
      margin: EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
          color: BrandColors.colorPrimary,

          borderRadius: BorderRadius.circular(12.0)),
      width: 335,
      height: 160,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Row(
            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    "${storageName ?? ""}",
                    style:
                    myStyle(14, BrandColors.colorWhite),overflow: TextOverflow.ellipsis,
                  ),

                  SizedBox(height: 4,),
                 accountNumber.length >11? Text(
                    "A/C: ${accountNumber.substring(0, 4) + " " + accountNumber.substring(4, 8) + " " + accountNumber.substring(8, 12) + " " +accountNumber.substring(12, accountNumber.length)} " ??"",
                    style:
                    myStyle(12, BrandColors.colorDimText.withOpacity(0.6)),
                  ):Text(
                   "A/C: ${accountNumber} " ??"",
                   style:
                   myStyle(16, BrandColors.colorDimText.withOpacity(0.6)),
                 )
                ],
              ),
              Container(

                child: Image.network(
                  "http://hishabrakho.com/admin/storage/hub/${photo?? ""}",

                  fit: BoxFit.cover,
                ),
              )
            ],
          ),
          Row(

            mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment:
                CrossAxisAlignment.start,
                children: [
                  Text(
                    getTranslated(context,'t22'), // "Current Balance ",
                    style:
                    myStyle(12, BrandColors.colorDimText.withOpacity(0.6)),
                  ),
                  SizedBox(height: 8,),

                  moneyField(
                    amount: balance ?? 0,
                    ts: myStyle(16, Colors.white, FontWeight.w500),
                    offset: Offset(-1, -8),
                    tks: myStyle(12,Colors.white),
                  ),

                ],
              ),
              Container(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      InkWell(
                        onTap: edit,
                        child: Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 8),
                          alignment: Alignment.center,
                          margin: EdgeInsets.symmetric(vertical: 18),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(5),
                              border: Border.all(
                                  color: Colors.deepPurpleAccent)),
                          child: SvgPicture.asset("assets/edit.svg",
                            alignment: Alignment.center,
                            height: 18,width: 9,
                          ),
                        ),
                        /*Container(
                          padding: EdgeInsets.symmetric(
                              horizontal: 10, vertical: 10),
                          alignment: Alignment.center,

                          decoration: BoxDecoration(
                            //color: BrandColors.colorPrimaryDark,
                              borderRadius:
                              BorderRadius.circular(5),
                              border: Border.all(
                                  color:
                                  Colors.deepPurpleAccent)),
                          child: SvgPicture.asset("assets/edit.svg",
                            alignment: Alignment.center,
                            height: 20,width: 12,
                          ),
                        ),*/
                      ),
                      IconButton(
                        onPressed: () {
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
                                    getTranslated(context,'t61'),  // "Are You Sure ?",
                                    style: myStyle(
                                        16,
                                        Colors.black54,
                                        FontWeight.w800),
                                  ),
                                  content: Text(
                                    getTranslated(context,'t62'),  // "You want to delete !"
                                  ),
                                  actions: <Widget>[
                                    FlatButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text(getTranslated(context,'t64'),  //   "No"

                                        )),
                                    FlatButton(
                                        onPressed: delete,
                                        child: Text(getTranslated(context,'t63'),  //    "Yes"

                                        ))
                                  ],
                                );
                              });
                        },
                        icon: SvgPicture.asset("assets/delete.svg",
                          alignment: Alignment.center,
                          height: 20,width: 13,
                        ),
                      )
                    ],
                  )
              )
            ],
          )
        ],
      ),
    );
  }





}