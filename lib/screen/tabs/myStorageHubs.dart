import 'dart:convert';

import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/screen/add_Storage_hub.dart';
import 'package:anthishabrakho/screen/home_page.dart';
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
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      resizeToAvoidBottomInset: true,
      backgroundColor: BrandColors.colorPrimaryDark,
      body:allData.isNotEmpty? Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        child: ListView.builder(
          scrollDirection: Axis.vertical,
          shrinkWrap: true,
          itemCount: allData.length,
          itemBuilder: (context,index){
            return SingleChildScrollView(
              physics: BouncingScrollPhysics(),
              child: Column(
                children: [
                  Container(
                    height: 80,
                    margin: EdgeInsets.only(bottom: 25, top: 8),
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
                                  "Cash",
                                  style: myStyle(14, BrandColors.colorDimText),
                                ),
                                SizedBox(height: 6,),
                                moneyField(
                                  amount: allData[index].totalCashAmount ?? 0,
                                  ts: myStyle(16, Colors.white, FontWeight.w500),
                                  offset: Offset(-1, -8),
                                  tks: myStyle(12,Colors.white),
                                ),
                                /*Text(
                                    NumberFormat
                                        .compactCurrency(
                                      symbol: ' ৳ ',
                                    ).format(allData[
                                    index]
                                        .totalCashAmount ?? 0),
                                    style: myStyle(
                                        14, Colors.white))*/
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Bank",
                                  style: myStyle(14, BrandColors.colorDimText),
                                ),
                                SizedBox(height: 6,),
                                moneyField(
                                  amount: allData[index].totalBankAmount ?? 0,
                                  ts: myStyle(16, Colors.white, FontWeight.w500),
                                  offset: Offset(-1, -8),
                                  tks: myStyle(12,Colors.white),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            flex: 5,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "MFS",
                                  style: myStyle(14, BrandColors.colorDimText),
                                ),
                                SizedBox(height: 6),
                                moneyField(
                                  amount: allData[index].totalMfsAmount ?? 0,
                                  ts: myStyle(16, Colors.white, FontWeight.w500),
                                  offset: Offset(-1, -8),
                                  tks: myStyle(12,Colors.white),
                                ),
                              ],
                            ),
                          ),

                        ],
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Cash Details",
                          style: myStyle(16, BrandColors.colorDimText),
                        ),
                        /*Text(
                          "+ Add Cash",
                          style: myStyle(
                              14, Colors.deepPurpleAccent, FontWeight.w600),
                        ),*/
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

                                  )));
                    },
                    child: ListView.builder(
                      itemCount: cashList.length,
                      shrinkWrap: true,
                      itemBuilder: (context,index){
                        return Container(
                            height: 80,
                            margin: EdgeInsets.only(bottom: 25),
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
                                      "Current Balance",
                                      style: myStyle(14, BrandColors.colorDimText),
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
                                    padding: EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                                    alignment: Alignment.center,
                                    margin: EdgeInsets.symmetric(vertical: 18),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(5),
                                        border: Border.all(color: Colors.deepPurpleAccent)),
                                    child: Icon(
                                      Icons.edit,
                                      size: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                                )
                              ],
                            ));
                      },
                    )
                  ),
                  Container(
                    padding: EdgeInsets.symmetric(vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "Bank Details",
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
                            "+ Add Bank",
                            style: myStyle(
                                14, BrandColors.colorPurple, FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ),
                  /*Container(
                    height: 160,
                    width: double.maxFinite,
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: bankList.length,
                      itemBuilder: (context, index) {
                        return Card(
                          color: BrandColors.colorPrimary,
                          elevation: 10,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12.0)),
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 15),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0)),
                            width: MediaQuery.of(context).size.width - 50,
                            height: 160,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                                          "${bankList[index].storageHubName ?? ""}",
                                          style:
                                              myStyle(14, BrandColors.colorWhite),
                                        ),
                                        Text(
                                          bankList[index]
                                                  .userStorageHubAccountNumber ??
                                              "",
                                          style:
                                              myStyle(14, BrandColors.colorWhite),
                                        )
                                      ],
                                    ),
                                    Container(
                                      margin: EdgeInsets.only(right: 20, top: 10),
                                      child: Image.network(
                                        "http://hishabrakho.com/admin/storage/hub/${bankList[index].photo ?? ""}",
                                        height: 50,
                                        width: 60,
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
                                          "Current Balance ",
                                          style:
                                              myStyle(14, BrandColors.colorWhite),
                                        ),
                                        Text(
                                          NumberFormat.currency(
                                                  symbol: ' ৳ ',
                                                  decimalDigits: (bankList[index]
                                                          .balance) is int
                                                      ? 0
                                                      : 2,
                                                  locale: "en-in")
                                              .format(
                                                  bankList[index].balance ?? ""),
                                          style: myStyle(16, Colors.white),
                                        )
                                      ],
                                    ),
                                    Container(
                                        child: Row(
                                      children: [
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                              horizontal: 8, vertical: 8),
                                          alignment: Alignment.center,
                                          margin:
                                              EdgeInsets.symmetric(vertical: 18),
                                          decoration: BoxDecoration(
                                              //color: BrandColors.colorPrimaryDark,
                                              borderRadius:
                                                  BorderRadius.circular(5),
                                              border: Border.all(
                                                  color:
                                                      Colors.deepPurpleAccent)),
                                          child: Icon(
                                            Icons.edit,
                                            size: 20,
                                            color: Colors.white,
                                          ),
                                        ),
                                        IconButton(
                                          onPressed: () {
                                            {
                                              showDialog(
                                                  context: context,
                                                  barrierDismissible: false,
                                                  builder:
                                                      (BuildContext context) {
                                                    return AlertDialog(
                                                      shape:
                                                          RoundedRectangleBorder(
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
                                                            child: Text("No")),
                                                        FlatButton(
                                                            onPressed: () {
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
                                                              Navigator.pop(
                                                                  context);
                                                            },
                                                            child: Text("Yes"))
                                                      ],
                                                    );
                                                  });
                                            }
                                          },
                                          icon: Icon(
                                            Icons.delete_forever_outlined,
                                            color: Colors.redAccent,
                                          ),
                                        )
                                      ],
                                    )
                                        //Image.network("https://media-exp1.licdn.com/dms/image/C510BAQFYQ12drExNfw/company-logo_200_200/0/1567518887113?e=2159024400&v=beta&t=NqOeHA9iax5LN_y6bQmgZx3a2020WUDr_x6JR1rFPIs",height: 60,width: 60,fit: BoxFit.cover,),
                                        )
                                  ],
                                )
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),*/
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
                    padding: EdgeInsets.symmetric(vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "MFS Details",
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
                            "+ Add MFS",
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
      ) : Center(child: Spin(),),
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
    return Card(
      color: BrandColors.colorPrimary,

      shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12.0)),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 15),
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12.0)),
        width: MediaQuery.of(context).size.width - 50,
        height: 160,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
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
                    Text(
                      accountNumber ??
                          "",
                      style:
                      myStyle(16, BrandColors.colorDimText),
                    )
                  ],
                ),
                Container(
                  margin: EdgeInsets.only(right: 20, top: 10),
                  child: Image.network(
                    "http://hishabrakho.com/admin/storage/hub/${photo?? ""}",
                    height: 50,
                    width: 60,
                    fit: BoxFit.fill,
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
                      "Current Balance ",
                      style:
                      myStyle(12, BrandColors.colorDimText),
                    ),
                    SizedBox(height: 4,),
                    SizedBox(height: 6,),
                    moneyField(
                      amount: balance ?? 0,
                      ts: myStyle(16, Colors.white, FontWeight.w500),
                      offset: Offset(-1, -8),
                      tks: myStyle(12,Colors.white),
                    ),
                    /*Text(
                      NumberFormat.currency(
                          symbol: ' ৳ ',
                          decimalDigits: (balance) is int
                              ? 0
                              : 2,
                          locale: "en-in")
                          .format(
                          balance?? ""),
                      style: myStyle(16, Colors.white,FontWeight.w800),
                    )*/
                  ],
                ),
                Container(
                    child: Row(
                      children: [
                        InkWell(
                          onTap: edit,
                          child: Container(
                            padding: EdgeInsets.symmetric(
                                horizontal: 8, vertical: 8),
                            alignment: Alignment.center,
                            margin:
                            EdgeInsets.symmetric(vertical: 18),
                            decoration: BoxDecoration(
                              //color: BrandColors.colorPrimaryDark,
                                borderRadius:
                                BorderRadius.circular(5),
                                border: Border.all(
                                    color:
                                    Colors.deepPurpleAccent)),
                            child: Icon(
                              Icons.edit,
                              size: 20,
                              color: Colors.white,
                            ),
                          ),
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
                                          onPressed: delete,
                                          child: Text("Yes"))
                                    ],
                                  );
                                });
                          },
                          icon: Icon(
                            Icons.delete_forever_outlined,
                            color: Colors.redAccent,
                          ),
                        )
                      ],
                    )
                )
              ],
            )
          ],
        ),
      ),
    );
  }





}