import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';

class TransectionStorageEntries extends StatefulWidget {
  final List<MyTransectionModel> transection;

  TransectionStorageEntries(this.transection);

  @override
  _TransectionStorageEntriesState createState() =>
      _TransectionStorageEntriesState();
}

class _TransectionStorageEntriesState extends State<TransectionStorageEntries> {
  bool onProgress = false;
  Color boxColor = Color(0xFF021A2C);
  double iconSize = 40;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  String storageType;
  int id;
  int cashId;
  List cashList;
  List mfsList;
  String _myMfs;
  List<MyTransectionModel> dataa = [];
  List bankList;
  String _myBank;
  int bankId;
  int mfsId;
  bool y = false;
  bool z = false;
  List<String> _getStorageHub = [
    "BANK",
    "MFS",
    "CASH",
  ];
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      body: ModalProgressHUD(
        opacity: 0.0,
        progressIndicator: Spin(),
        inAsyncCall: onProgress,
        child: Container(
            child: Form(
              key: _formKey,
              child: SingleChildScrollView(
                child: Column(children: <Widget>[

                  Container(
                    margin: EdgeInsets.only(bottom: 10),
                    child: Row(
                      children: [
                        Expanded(
                          flex: 3,
                          child: Container(
                            child: InputDecorator(
                              decoration: InputDecoration(
                                errorStyle: TextStyle(fontSize: 14.0),
                                hintText: 'Choose Storage Hub',
                                labelStyle: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.white,
                                    fontWeight: FontWeight.w600),
                              ),
                              isEmpty: storageType == '',
                              child: DropdownButtonHideUnderline(
                                child: DropdownButton<String>(
                                  isExpanded: true,
                                  dropdownColor: BrandColors.colorPrimary,
                                  icon: Icon(Icons.arrow_drop_down,size: 25,color: Colors.white,),
                                  hint: Text(
                                    "Choose Storage Hub ",
                                    style: myStyle(14, Colors.white70),
                                  ),
                                  value: storageType,
                                  style: myStyle(14, Colors.white),
                                  isDense: true,
                                  onChanged: (String newValue) {
                                    setState(() {
                                      storageType = newValue;
                                    });
                                  },
                                  items: _getStorageHub.map((String storageValue) {
                                    return DropdownMenuItem(

                                      value: storageValue,
                                      child: Text("$storageValue "),
                                      onTap: () {
                                        if (storageValue == "BANK") {
                                          setState(() {
                                            id = 5;
                                            y = true;
                                            z = false;
                                            getBankDetails();
                                          });
                                        } else if (storageValue == "MFS") {
                                          id = 6;
                                          y = false;
                                          z = true;

                                          getMfsDetails();
                                        } else {
                                          storageValue = "CASH";
                                          id = 7;
                                          y = false;
                                          z = false;
                                          getCashDetails();
                                        }
                                        print(id);
                                      },
                                    );
                                  }).toList(),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: y == true,
                          child: Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              margin: EdgeInsets.symmetric(horizontal: 8,),
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: BrandColors.colorPrimary,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,color: Colors.white,
                                  ),
                                  decoration: InputDecoration.collapsed(hintText: ''),
                                  hint: Text(
                                    "Select Bank ",
                                    style: myStyle(14, Colors.white),
                                  ),
                                  validator: (value) =>
                                  value == null ? 'field required' : null,
                                  value: _myBank,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dataa.clear();
                                      _myBank = newValue;
                                      bankId = int.parse(_myBank);
                                      print("my Bank is a ${_myBank}");
                                      // print();
                                    });
                                  },
                                  items: bankList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                          "${item['storage_hub_name']} ${item['user_storage_hub_account_number']}"),
                                      value: item['id'].toString(),
                                    );
                                  })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ),
                        Visibility(
                          visible: z == true,
                          child: Expanded(
                            flex: 5,
                            child: Container(
                              padding: EdgeInsets.only(left: 10),
                              margin: EdgeInsets.symmetric(horizontal: 8,),
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: BrandColors.colorPrimary,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 25,color: Colors.white,
                                  ),
                                  decoration: InputDecoration.collapsed(hintText: ''),
                                  hint: Text(
                                    "Select MFS ",
                                    style: myStyle(16, Colors.white),
                                  ),
                                  validator: (value) =>
                                  value == null ? 'field required' : null,
                                  value: _myMfs,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      dataa.clear();
                                      _myMfs = newValue;
                                      mfsId = int.parse(_myMfs);

                                      print("my Mfs is ${_myMfs}");
                                      // print();
                                    });
                                  },
                                  items: mfsList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                          "${item['storage_hub_name']} ${item['user_storage_hub_account_number']}"),
                                      value: item['id'].toString(),
                                    );
                                  })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  RaisedButton(
                    onPressed: () {
                      dataa.clear();
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      setState(() {
                         onProgress = true;
                      });
                      id == 5
                          ? getBankData(bankId)
                          : id == 6
                              ? getMfsData(mfsId)
                              : getCashData(cashId);
                    },
                    color: BrandColors.colorPurple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(11.0)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 50,
                    ),
                    child: Text(
                      "Submit",
                      style: myStyle(16, Colors.white),
                    ),
                  ),



                  Column(children: [
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Expanded(
                            flex: 7,
                            child: Text("Title", style: myStyle(12,
                                BrandColors.colorDimText),),
                          ),
                          Expanded(
                            flex: 6,
                            child: Text("Transaction", style: myStyle(12,
                                BrandColors.colorDimText),),
                          ),
                          Expanded(
                            flex: 3,
                            child: Align(
                              alignment: Alignment.centerRight,
                              child: Text("Balance", style: myStyle(12,
                                  BrandColors.colorDimText),),
                            ),
                          ),
                        ],
                      ),
                    ),

                    ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: dataa.length,
                        itemBuilder: (context, index) {
                          return Slidable(
                            actionPane: SlidableDrawerActionPane(),
                            actionExtentRatio: 0.25,
                            child: new Container(
                                padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                child: Row(
                                  children: [
                                    Expanded(
                                      flex: 5,
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            "${dataa[index].friendName??""}",style: myStyle(16,Colors.white,FontWeight.w600),
                                          ),
                                          SizedBox(height: 3,),
                                          Text(
                                            "${dataa[index].date ?? ""}",style: myStyle(14,BrandColors.colorDimText,),
                                          )
                                        ],
                                      ),
                                    ),
                                    Expanded(
                                        flex: 3,
                                        child: Text(
                                          NumberFormat.currency(
                                              symbol: '',
                                              decimalDigits: (dataa[index]
                                                  .amount) is int ? 0 :2,
                                              locale: "en-in").format(dataa[index].amount),
                                          style: myStyle(
                                              14,dataa[index].amount>1? Colors.greenAccent:Colors.redAccent),
                                        )
                                    ),

                                    Expanded(
                                        flex: 3,
                                        child:Container(
                                          padding: EdgeInsets.only(left: 12),
                                          alignment:Alignment.centerRight,
                                          child: Text(
                                            NumberFormat.currency(
                                                symbol: '',
                                                decimalDigits: (dataa[index]
                                                    .balance) is int ? 0 :2,
                                                locale: "en-in").format(dataa[index].balance),
                                            style: myStyle(
                                                14,Colors.white),
                                          ),
                                        )
                                    ),
                                  ],
                                )
                            ),
                          );
                        }
                    )


                  ]

                  ),

                ]),
              ),
            )),
      ),
    );
  }

  Future<dynamic> getMfsData(int id) async {
    dataa.clear();
    final data = await CustomHttpRequests.viewStorageEntries(id);
    setState(() {
      onProgress=false;
    });

    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        eventId: entries["event_id"],
        transactionTypeId: entries["transaction_type_id"],
        userPersonalStorageHubId: entries["user_personal_storage_hub_id"],
        amount: entries["amount"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        date: entries["date"],
        friendName: entries["friend_name"],
        eventSubCategoryName: entries["event_sub_category_name"],
      );
      try {
        dataa.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          dataa.add(model);
        });
      }
    }
  }

  Future<dynamic> getCashData(int id) async {
    dataa.clear();
    final data = await CustomHttpRequests.viewStorageEntries(id);
    setState(() {
      onProgress=false;
    });

    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        eventId: entries["event_id"],
        transactionTypeId: entries["transaction_type_id"],
        userPersonalStorageHubId: entries["user_personal_storage_hub_id"],
        amount: entries["amount"],
        balance: entries["balance"],

        eventType: entries["event_type"],
        date: entries["date"],
        friendName: entries["friend_name"],
        eventSubCategoryName: entries["event_sub_category_name"],
      );
      try {
        dataa.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          dataa.add(model);
        });
      }
    }
  }

  Future<dynamic> getBankData(int id) async {
    dataa.clear();
    final data = await CustomHttpRequests.viewStorageEntries(id);
    setState(() {
      onProgress=false;
    });

    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        eventId: entries["event_id"],
        transactionTypeId: entries["transaction_type_id"],
        userPersonalStorageHubId: entries["user_personal_storage_hub_id"],
        amount: entries["amount"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        date: entries["date"],
        friendName: entries["friend_name"],
        eventSubCategoryName: entries["event_sub_category_name"],
      );
      try {
        dataa.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          dataa.add(model);
        });
      }
    }
  }

  Future<dynamic> getBankDetails() async {
    await CustomHttpRequests.bankDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        bankList = dataa;
      });
    });
  }

  Future<dynamic> getMfsDetails() async {
    final data = await CustomHttpRequests.mfsDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        mfsList = dataa;
      });
    });
  }

  Future<dynamic> getCashDetails() async {
    await CustomHttpRequests.cashDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        cashId = dataa[0]["id"];
      });
    });
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }
}
