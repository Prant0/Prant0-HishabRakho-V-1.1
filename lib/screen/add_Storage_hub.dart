import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/services.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

/*class AddStorageHub extends StatefulWidget {
  static const String id = 'addStorageHub';

  @override
  _AddStorageHubState createState() => _AddStorageHubState();
}

class _AddStorageHubState extends State<AddStorageHub> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController bankAccountNameController = TextEditingController();
  TextEditingController bankBalanceController = TextEditingController();
  TextEditingController mfsNumberController = TextEditingController();
  TextEditingController mfsBalanceController = TextEditingController();
  bool onProgress = false;
  int id;
  String storageType;
  List bankList;
  String _myBank;


  List mfsList;
  String _myMfs;

  TextStyle _ts = TextStyle(fontSize: 18.0);
  bool isBank = false;
  bool isMfs = false;
  DateTime _currentDate = DateTime.now();


  List<String> _getStorageHub = [
    "BANK",
    "MFS",
  ];


  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(DateTime.now().year - 3),
        lastDate: DateTime.now().subtract(Duration(days: 0)),
        initialDatePickerMode: DatePickerMode.year,
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_seldate != null) {
      setState(() {
        _currentDate = _seldate;
      });
    }
  }


  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if(mounted){
        setState(() {
          bankBalanceController.clear();
          mfsBalanceController.clear();
        });
      }
    });
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat("d-MMMM-y").format(_currentDate);
    return Scaffold(
      backgroundColor: Colors.white,
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.white,
        centerTitle: true,
        title: Text(
          "Add Storage Hub",
          style: myStyle(17, Colors.purple, FontWeight.w700),
        ),
      ),
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        child: Container(
          color: Colors.white70,
          child: Card(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
            elevation: 5,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
            child: Container(
              height: MediaQuery.of(context).size.height,
              padding: EdgeInsets.symmetric(vertical: 15),
              child: Form(
                key: _formKey,
                child: ListView(
                  children: [

                    InkWell(
                      onTap: () {
                        setState(() {
                          seleceDate(context);
                        });
                      },
                      child: Container(
                          margin: EdgeInsets.symmetric(horizontal: 20),
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12.0),
                              border: Border.all(width: 1, color: Colors.grey)),
                          padding: EdgeInsets.symmetric(
                              horizontal: 20, vertical: 15),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Date : ${formattedDate}",
                                style:
                                myStyle(16, Colors.purple, FontWeight.w700),
                              ),
                              Icon(Icons.date_range_outlined),
                            ],
                          )),
                    ),


                    Container(
                      padding:EdgeInsets.symmetric(horizontal: 16, vertical: 20),
                      margin: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
                      decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(12.0)),
                      //margin: EdgeInsets.only(top: 20),
                      height: 60,
                      child: Center(
                        child: DropdownButtonFormField<String>(
                          icon: Icon(
                            Icons.arrow_drop_down,
                            size: 35,
                          ),
                          decoration: InputDecoration.collapsed(hintText: ''),
                          value: storageType,
                          hint: Text(
                            'Choose Storage Hub Category',
                            style: TextStyle(
                                fontSize: 16,
                                color: Colors.purple,
                                fontWeight: FontWeight.w800),
                          ),
                          onChanged: (String newValue) {
                            setState(() {
                              storageType = newValue;
                            });
                          },
                          validator: (value) =>
                              value == null ? 'field required' : null,
                          items: _getStorageHub.map((String storageValue) {
                            return DropdownMenuItem(
                              value: storageValue,
                              child: Text(
                                "$storageValue ",
                                style: myStyle(16, Colors.purple),
                              ),
                              onTap: () {
                                if (storageValue == "BANK") {
                                  setState(() {
                                    id = 5;
                                    isBank = true;
                                    isMfs = false;
                                    getBankDetails();
                                  });
                                } else {
                                  id = 6;
                                  isBank = false;
                                  isMfs = true;
                                  getMfsDetails();
                                }

                                print(id);
                              },
                            );
                          }).toList(),
                        ),
                      ),
                    ),
                    Visibility(
                      visible: isBank == true,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(12.0)),
                            height: 60,
                            child: Center(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 35,
                                ),
                                decoration:
                                    InputDecoration.collapsed(hintText: ''),
                                value: _myBank,
                                hint: Text(
                                  'Select Bank',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 16),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _myBank = newValue;
                                    print("my Bank is ${_myBank}");
                                    if (_myBank.isEmpty) {
                                      return "Required";
                                    }
                                    // print();
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'field required' : null,
                                items: bankList?.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          "${item['storage_hub_name']}",
                                          style: myStyle(16, Colors.purple),
                                          overflow: TextOverflow.ellipsis,
                                          maxLines: 1,
                                        ),
                                        value: item['id'].toString(),
                                      );
                                    })?.toList() ??
                                    [],
                              ),
                            ),
                          ),
                          SenderTextEdit(
                            keyy: "number",
                            keytype: TextInputType.number,
                            data: _data,
                            name: bankAccountNumberController,
                            lebelText: "Account Number",
                            hintText: "Account Number",
                            formatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            icon: Icons.confirmation_number_outlined,
                            function: (String value) {
                              if (value.isEmpty) {
                                return "Account Number required.( Min 11 digit )";
                              }
                              if (value.length < 11) {
                                return "Number is Too Short. ( Min 11 digit )";
                              }
                              if (value.length > 18) {
                                return "Number is Too Long. ( Max 18 digit )";
                              }
                            },
                          ),
                          SenderTextEdit(
                            keyy: "name",
                            data: _data,
                            name: bankAccountNameController,
                            lebelText: "Your Name",
                            hintText: "Account Name",
                            icon: Icons.drive_file_rename_outline,
                            function: (String value) {
                              if (value.isEmpty) {
                                return "Account Name required";
                              }
                              if (value.length < 3) {
                                return "Account Name is Too Short.(Min 3 character)";
                              }
                              if (value.length > 30) {
                                return "Account Name is Too Long.(Max 30 character)";
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: MoneyTextFormField(
                              settings: MoneyTextFormFieldSettings(
                                  controller: bankBalanceController,
                                  moneyFormatSettings: MoneyFormatSettings(
                                      currencySymbol: ' ৳ ',
                                      displayFormat: MoneyDisplayFormat.symbolOnLeft),
                                  appearanceSettings: AppearanceSettings(
                                      padding: EdgeInsets.all(15.0),
                                      labelText: 'Initial Balance* ',
                                      hintText: 'Initial Balance',
                                      labelStyle: myStyle(20,Colors.purple,FontWeight.w600),
                                      inputStyle: _ts.copyWith(color: Colors.purple),
                                      formattedStyle:
                                      _ts.copyWith(color: Colors.black54)),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    Visibility(
                      visible: isMfs == true,
                      child: Column(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 16),
                            margin: EdgeInsets.symmetric(
                                horizontal: 20, vertical: 15),
                            decoration: BoxDecoration(
                                border:
                                    Border.all(color: Colors.grey, width: 1),
                                borderRadius: BorderRadius.circular(12.0)),
                            height: 60,
                            child: Center(
                              child: DropdownButtonFormField<String>(
                                isExpanded: true,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 35,
                                ),
                                decoration:
                                    InputDecoration.collapsed(hintText: ''),
                                value: _myMfs,
                                hint: Text(
                                  'Select MFS',
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                      color: Colors.purple, fontSize: 16),
                                ),
                                onChanged: (String newValue) {
                                  setState(() {
                                    _myMfs = newValue;
                                    print("my Mfs is ${_myMfs}");
                                    // print();
                                  });
                                },
                                validator: (value) =>
                                    value == null ? 'field required' : null,
                                items: mfsList?.map((item) {
                                      return new DropdownMenuItem(
                                        child: new Text(
                                          "${item['storage_hub_name']}",
                                          style: TextStyle(
                                              fontSize: 16,
                                              color: Colors.purple),
                                        ),
                                        value: item['id'].toString(),
                                      );
                                    })?.toList() ??
                                    [],
                              ),
                            ),
                          ),
                          SenderTextEdit(
                            keyy: "name",
                            data: _data,
                            name: mfsNumberController,
                            lebelText: "MFS Number",
                            hintText: "Account Number",
                            icon: Icons.drive_file_rename_outline,
                            keytype: TextInputType.number,
                            formatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                            ],
                            function: (String value) {
                              if (value.isEmpty) {
                                return "MFS Number required";
                              }
                              if (value.length < 11) {
                                return "MFS Number Too Short. ( Min 11 character )";
                              }
                              if (value.length > 18) {
                                return "MFS Number Too Long. ( Max 25 character )";
                              }
                            },
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(horizontal: 12),
                            child: MoneyTextFormField(
                              settings: MoneyTextFormFieldSettings(
                                controller: mfsBalanceController,
                                moneyFormatSettings: MoneyFormatSettings(
                                   // amount: 10,
                                    currencySymbol: ' ৳ ',
                                    displayFormat: MoneyDisplayFormat.symbolOnLeft),
                                appearanceSettings: AppearanceSettings(
                                    padding: EdgeInsets.all(15.0),
                                    labelText: 'Initial Balance* ',
                                    hintText: 'Initial Balance',
                                    labelStyle: myStyle(20,Colors.purple,FontWeight.w600),
                                    inputStyle: _ts.copyWith(color: Colors.purple),
                                    formattedStyle:
                                    _ts.copyWith(color: Colors.black54)),

                              ),
                            ),
                          ),
                          *//*SenderTextEdit(
                            *//**//*formatter: <TextInputFormatter>[
                              FilteringTextInputFormatter.allow(
                                  RegExp(r'[0-9]')),
                              CurrencyInputFormatter(),
                            ],*//**//*
                            keytype: TextInputType.number,
                            keyy: "balance",
                            data: _data,
                            name: mfsBalanceController,
                            lebelText: "Initial Balance",
                            hintText: "Initial Balance",
                            icon: Icons.monetization_on_outlined,
                            function: (String value) {
                              if (value.isEmpty) {
                                return "Initial Balance required";
                              }
                              if (value.length > 12) {
                                return "Amount Too Long. ( Max 12 character )";
                              }
                            },
                          )*//*
                        ],
                      ),
                    ),

                    SizedBox(
                      height: 18,
                    ),
                    Container(
                      margin: const EdgeInsets.symmetric(
                          horizontal: 40, vertical: 10),
                      child: RaisedButton(
                        elevation: 10,
                        onPressed: storageType != null
                            ? () {
                          

                                if (!_formKey.currentState.validate()) return;
                                _formKey.currentState.save();
                                print("true");
                                id == 5
                                    ?bankBalanceController.text.toString().isEmpty?showInSnackBar("Amount Required"):uploadBank(context)
                                    :mfsBalanceController.text.toString().isEmpty?showInSnackBar("Amount Required"):uploadMfs(context);
                              }
                            : () {},
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 20,
                        ),
                        child: Text(
                          "Submit",
                          style: myStyle(16, Colors.white),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future uploadBank(BuildContext context) async {
    check().then((intenet) async {
      if (intenet != null && intenet) {
        if (mounted) {
          setState(() {
            onProgress = true;
          });
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/storage/hub/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['storage_hub_category_id'] = id.toString();
          request.fields['storage_hub_id'] = _myBank.toString();
          request.fields['user_storage_hub_account_number_bank'] =
              bankAccountNumberController.text.toString();
          request.fields['user_storage_hub_account_name'] =
              bankAccountNameController.text.toString();
          request.fields['balance'] = bankBalanceController.text.toString();
          request.fields['date'] = _currentDate.toString();

          print("uploading bank storage");
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print("responseBody " + responseString);
          if (response.statusCode == 201) {
            setState(() {
              onProgress = false;
            });
            print("responseBody1 " + responseString);
            showInSnackBar("Add Bank Storage successful");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.pop(context);
              });
            });
          } else {
            showInSnackBar(" Failed, Try again please");
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
          }
        }
      } else
        showInSnackBar("No Internet Connection");
    });
  }

  Future uploadMfs(BuildContext context) async {
    check().then((intenet) async {
      if (intenet != null && intenet) {
        if (mounted) {
          setState(() {
            onProgress = true;
          });
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/storage/hub/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['storage_hub_category_id'] = id.toString();
          request.fields['storage_hub_id'] = _myMfs.toString();
          request.fields['user_storage_hub_account_number_mfs'] =
              mfsNumberController.text.toString();
          request.fields['balance'] = mfsBalanceController.text.toString();
          request.fields['date'] = _currentDate.toString();

          print("Ulpoad mfs ");
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print("responseBody " + responseString);
          if (response.statusCode == 201) {
            print("responseBody1 " + responseString);
            setState(() {
              onProgress = false;
            });
            showInSnackBar("Add MFS storage successful");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop(HomePage.id);
              });
            });
          } else {
            showInSnackBar(" Failed, Try again please");
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        }
      } else
        showInSnackBar("No Internet Connection");
    });
  }



  Map<String, dynamic> _data = Map<String, dynamic>();



  Future<dynamic> getBankDetails() async {
    setState(() {
      onProgress = true;
    });
    await CustomHttpRequests.allBankDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        bankList = dataa;
        onProgress = false;
        print("all bank are : ${bankList}");
      });
    });
  }

  Future<dynamic> getMfsDetails() async {
    setState(() {
      onProgress = true;
    });
    await CustomHttpRequests.allMfsDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        onProgress = false;
        mfsList = dataa;
        print("all Mfs are : ${mfsList}");
      });
    });
  }

  void showInSnackBar(String value) {
    //  delay(1500);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        value,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      backgroundColor: Colors.purple,
    ));
  }
}*/
