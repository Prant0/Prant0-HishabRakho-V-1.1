import 'dart:convert';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/chooseBank.dart';
import 'package:anthishabrakho/widget/chooseMfs.dart';
import 'package:flutter/rendering.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

class FundTransferForm extends StatefulWidget {
  int id;
  String title;
  String name;

  FundTransferForm({this.id, this.title, this.name});

  @override
  _FundTransferFormState createState() => _FundTransferFormState();
}

class _FundTransferFormState extends State<FundTransferForm> {
  bool onProgress = false;
  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController receiveFrom = TextEditingController();
  final TextEditingController detailsController = TextEditingController();

  TextStyle _ts = TextStyle(fontSize: 18.0);
  DateTime _currentDate = DateTime.now();
  List mfsList;
  String _myMfs;
  String cashId;
  List bankList;
  String _myBank;
  String banktext;
  String mfstext;
  bool isBank = false;
  bool isMfs = false;
  bool isCash = false;
  String bankName;
  String mfsName;

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
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now().subtract(Duration(days: 0)),
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

  updateForm() {
    if (widget.title == "Bank to MFS") {
      setState(() {
        isBank = true;
        isMfs = true;
        banktext = "Choose Bank (from)";
        mfstext = "Choose MFS (to)";
      });
    } else if (widget.title == "Bank to Cash") {
      setState(() {
        isBank = true;
        isMfs = false;
        banktext = "Choose Bank (from)";
        mfstext = "";
      });
    } else if (widget.title == "Cash to Bank") {
      isBank = true;
      isMfs = false;
      banktext = "Choose Bank (to)";
      mfstext = "";
    } else if (widget.title == "Cash to MFS") {
      isBank = false;
      isMfs = true;
      mfstext = "Choose MFS (to)";
      banktext = "";
    } else if (widget.title == "MFS to Bank") {
      isBank = true;
      isMfs = true;
      banktext = "Choose Bank (to)";
      mfstext = "Choose MFS (From)";
    } else {
      isMfs = true;
      isBank = false;
      banktext = "";
      mfstext = "Choose MFS (from)";
    }
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

  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        amountController.clear();
      });
    });
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    amountController.dispose();
    receiveFrom.dispose();
    detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat("d-MMMM-y").format(_currentDate);
    return Scaffold(

      backgroundColor: BrandColors.colorPrimaryDark,
      key: _scaffoldKey,

      body: ModalProgressHUD(
        progressIndicator: Spin(),
        inAsyncCall: onProgress,
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.only(top: 30,left: 18,right: 18),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Stack(
                children: [

                  Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              widget.title,
                              style:
                              myStyle(18, Colors.white, FontWeight.w700),
                            ),
                            GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Icon(
                                Icons.close,
                                color: Colors.white,
                                size: 20,
                              ),
                            )
                          ],
                        ),
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            seleceDate(context);
                          });
                        },
                        child: Container(
                            margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(width: 1, color: Colors.grey)),
                            padding:
                            EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date : ${formattedDate}",
                                  style:
                                  myStyle(16, Colors.white, FontWeight.w500),
                                ),
                                Icon(Icons.date_range_outlined,color: Colors.white,),
                              ],
                            )),
                      ),
                      /*Visibility(
                        visible: isBank == true,
                        child: Column(
                          children: [
                            Container(
                                padding: EdgeInsets.only(top: 8),
                                margin: EdgeInsets.symmetric(vertical: 15),
                                child: Text(
                                  banktext ?? "",
                                  style:
                                  myStyle(16, Colors.white, FontWeight.w700),
                                )),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              margin: EdgeInsets.symmetric(
                                  horizontal: 0, vertical: 15),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(12.0)),
                              height: 60,
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: BrandColors.colorPrimary,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                    color: Colors.white,
                                  ),
                                  decoration:
                                  InputDecoration.collapsed(hintText: ''),
                                  hint: Text(
                                    "Select Bank ",
                                    style: myStyle(16, Colors.white),
                                  ),
                                  validator: (value) =>
                                  value == null ? 'field required' : null,
                                  value: _myBank,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _myBank = newValue;
                                      print("my Bank is ${_myBank}");
                                      // print();
                                    });
                                  },
                                  items: bankList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                        "${item['storage_hub_name']} ${item['user_storage_hub_account_number']}",style: myStyle(16,Colors.white),),
                                      value: item['id'].toString(),
                                    );
                                  })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ],
                          crossAxisAlignment: CrossAxisAlignment.start,
                        ),
                      ),*/

                      SizedBox(height: 20,),
                      Visibility(
                          visible: isBank==true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              Text(banktext ??"",style: myStyle(16,BrandColors.colorDimText),),
                              GestureDetector(
                                onTap:  () async {
                                  List bal= await Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseBank(
                                    types: "single",
                                  )));
                                  setState(() {
                                    _myBank=bal[0];
                                    bankName=bal[1];
                                    print("the bal is ${bal[0]}");
                                    print("the bal is ${bal[1]}");
                                    //isStorage=true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.symmetric(vertical: 15,),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: BrandColors.colorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(bankName??"Choose Bank",style: myStyle(16,Colors.white),),
                                      Icon(Icons.mobile_screen_share_rounded,color: Colors.white,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Visibility(
                          visible: isMfs==true,
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(mfstext??"",style: myStyle(16,BrandColors.colorDimText),),

                              GestureDetector(
                                onTap: () async {
                                  List bal = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseMfs(
                                    types: "single",
                                  )));
                                  setState(() {
                                    _myMfs=bal[0];
                                    mfsName=bal[1];
                                    print("the Mfs is ${mfsName}");
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.symmetric(vertical: 15,),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: BrandColors.colorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(mfsName??"Choose Mfs",style: myStyle(16,Colors.white),),
                                      Icon(Icons.mobile_screen_share_rounded,color: Colors.white,),
                                    ],
                                  ),
                                ),
                              )
                            ],
                          )
                      ),
                      /*Visibility(
                        visible: isMfs == true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                                margin: EdgeInsets.only(top: 20, ),
                                child: Text(
                                  mfstext ?? "",
                                  style:
                                  myStyle(16, Colors.white, FontWeight.w700),
                                )),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 16),
                              margin: EdgeInsets.symmetric( vertical: 22),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1),
                                  borderRadius: BorderRadius.circular(12.0)),
                              //margin: EdgeInsets.only(top: 20),
                              height: 60,
                              child: Center(
                                child: DropdownButtonFormField<String>(
                                  dropdownColor: BrandColors.colorPrimary,
                                  isExpanded: true,
                                  icon: Icon(
                                    Icons.arrow_drop_down,
                                    size: 30,
                                  ),
                                  decoration:
                                  InputDecoration.collapsed(hintText: ''),
                                  hint: Text(
                                    "Select MFS ",
                                    style: myStyle(16, Colors.white),
                                  ),
                                  validator: (value) =>
                                  value == null ? 'field required' : null,
                                  value: _myMfs,
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 16,
                                  ),
                                  onChanged: (String newValue) {
                                    setState(() {
                                      _myMfs = newValue;
                                      print("my Mfs is ${_myMfs}");
                                      // print();
                                    });
                                  },
                                  items: mfsList?.map((item) {
                                    return new DropdownMenuItem(
                                      child: new Text(
                                        "${item['storage_hub_name']} ${item['user_storage_hub_account_number']}",style: myStyle(16,Colors.white),),
                                      value: item['id'].toString(),
                                    );
                                  })?.toList() ??
                                      [],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),*/
                      SenderTextEdit(
                        keyy: "details",
                        data: _data,
                        name: detailsController,
                        lebelText: "Details",
                        hintText: "Add Details",
                        icon: Icons.person,
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 0),
                        child: MoneyTextFormField(
                          settings: MoneyTextFormFieldSettings(
                            controller: amountController,
                            moneyFormatSettings: MoneyFormatSettings(
                                currencySymbol: ' ৳ ',
                                displayFormat: MoneyDisplayFormat.symbolOnLeft),
                            appearanceSettings: AppearanceSettings(
                                padding: EdgeInsets.all(15.0),
                                labelText: ' Balance* ',

                                labelStyle:
                                myStyle(20, Colors.white, FontWeight.w600),
                                inputStyle: _ts.copyWith(color: Colors.white),
                                formattedStyle:
                                _ts.copyWith(color: Colors.white)),
                          ),
                        ),
                      ),
                      /*SenderTextEdit(
                    keytype: TextInputType.number,
                    */ /*formatter:  <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      CurrencyInputFormatter(),
                    ],*/ /*
                    keyy: "amount",
                    data: _data,
                    name: amountController,
                    lebelText: "Enter Amount",
                    hintText: "Amount",
                    icon: Icons.person,
                    function: (String value) {
                      if (value.isEmpty) {
                        return "Amount is required";
                      }
                      if (value.length < 1) {
                        return "Amount Too Short";
                      }if (value.length > 12) {
                        return "Amount Too long ( Max 12 digit )";
                      }
                    },
                  ),*/

                      SizedBox(
                        height: 10,
                      ),
                      /*RaisedButton(
                        onPressed: () {
                          if (!_formKey.currentState.validate()) return;
                          _formKey.currentState.save();
                          print("widget name ${widget.name}");
                          print("widget name ${widget.title}");
                          widget.title == "Bank to Cash"
                              ? amountController.text.toString().isEmpty
                              ? showInSnackBar("Amount Required")
                              : bankToCash(context)
                              : widget.title == "Bank to MFS"
                              ? amountController.text.toString().isEmpty
                              ? showInSnackBar("Amount Required")
                              : bankToMfs(context)
                              : widget.title == "Cash to Bank"
                              ? amountController.text.toString().isEmpty
                              ? showInSnackBar("Amount Required")
                              : cashToBank(context)
                              : widget.title == "Cash to MFS"
                              ? amountController.text.toString().isEmpty
                              ? showInSnackBar("Amount Required")
                              : cashToMfs(context)
                              : widget.title == "MFS to Bank"
                              ? amountController.text
                              .toString()
                              .isEmpty
                              ? showInSnackBar(
                              "Amount Required")
                              : mfsToBank(context)
                              : amountController.text
                              .toString()
                              .isEmpty
                              ? showInSnackBar(
                              "Amount Required")
                              : mfsTOCash(context);
                        },
                        color: Colors.purple,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0)),
                        padding: EdgeInsets.symmetric(
                          horizontal: 100,
                        ),
                        child: Text(
                          "Submit",
                          style: myStyle(18, Colors.white),
                        ),
                      ),*/
                      SizedBox(
                        height: 80,
                      ),
                    ],
                  ),
                  Positioned(
                    bottom: 10,
                    left: 0,
                    right: 0,
                    child: Container(
                      color: BrandColors.colorPrimaryDark,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 10,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: Colors.deepPurpleAccent, width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.arrow_back_ios,
                                      color: Colors.white70,
                                      size: 15,
                                    ),
                                    Text(
                                      "Go Back",
                                      style: myStyle(16, Colors.white),
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            flex: 1,
                            child: Container(),
                          ),
                          Expanded(
                            flex: 10,
                            child: InkWell(
                              onTap: () {
                                if (!_formKey.currentState.validate()) return;
                                _formKey.currentState.save();
                                print("widget name ${widget.name}");
                                print("widget name ${widget.title}");
                                widget.title == "Bank to Cash"
                                    ? amountController.text.toString().isEmpty
                                    ? showInSnackBar("Amount Required")
                                    : bankToCash(context)
                                    : widget.title == "Bank to MFS"
                                    ? amountController.text.toString().isEmpty
                                    ? showInSnackBar("Amount Required")
                                    : bankToMfs(context)
                                    : widget.title == "Cash to Bank"
                                    ? amountController.text.toString().isEmpty
                                    ? showInSnackBar("Amount Required")
                                    : cashToBank(context)
                                    : widget.title == "Cash to MFS"
                                    ? amountController.text.toString().isEmpty
                                    ? showInSnackBar("Amount Required")
                                    : cashToMfs(context)
                                    : widget.title == "MFS to Bank"
                                    ? amountController.text
                                    .toString()
                                    .isEmpty
                                    ? showInSnackBar(
                                    "Amount Required")
                                    : mfsToBank(context)
                                    : amountController.text
                                    .toString()
                                    .isEmpty
                                    ? showInSnackBar(
                                    "Amount Required")
                                    : mfsTOCash(context);
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: Colors.deepPurpleAccent,
                                  border: Border.all(
                                      color: Colors.deepPurpleAccent,
                                      width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Proceed",
                                      style: myStyle(16, Colors.white),
                                    ),
                                    Icon(
                                      Icons.arrow_forward_ios_rounded,
                                      color: Colors.white70,
                                      size: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            )
          ),
        ),
      ),
    );
  }

  @override
  void initState() {
    check().then((intenet) {
      if (intenet != null && intenet) {
        if (mounted) {
          updateForm();
          getBankDetails();
          getMfsDetails();
          getCashDetails();
        }
      } else
        showInSnackBar("No Internet Connection");
    });

    super.initState();
  }

  Future<dynamic> getBankDetails() async {
    setState(() {
      onProgress = true;
    });
    await CustomHttpRequests.bankDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        onProgress = false;
        bankList = dataa;
        bankList.isEmpty ? showInSnackBar("Empty Bank Storage") : "";
        print("bank list${bankList}");
      });
    });
  }

  Future<dynamic> getMfsDetails() async {
    setState(() {
      onProgress = true;
    });
    await CustomHttpRequests.mfsDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        onProgress = false;
        mfsList = dataa;
        mfsList.isEmpty ? showInSnackBar("Empty MFS Storage") : "";
        print("mfs list${mfsList}");
      });
    });
  }

  Future<dynamic> getCashDetails() async {
    await CustomHttpRequests.cashDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        cashId = dataa[0]["id"].toString();
        print("cash data${dataa}");
        print("cash id ${cashId}");
      });
    });
  }

  Future bankToCash(BuildContext context) async {
    print("send to bank to cash");
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/entry/fund/transfer");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['date'] = _currentDate.toString();
    request.fields['amount'] = amountController.text.toString();
    request.fields['details'] = detailsController.text.toString();
    // request.fields['storage_hub_cat_id'] = id.toString();
    //request.fields['user_personal_storage_hub_id'] = _myBank.toString();
    request.fields['transfer_from'] = _myBank.toString();
    request.fields['transfer_to'] = cashId.toString();
    request.fields['event_sub_category_id'] = widget.id.toString();
    request.fields['details'] = detailsController.text.toString();
    print("processing bank to cash");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      setState(() {
        onProgress = false;
        detailsController.clear();
        amountController.clear();
        receiveFrom.clear();
      });
      showInSnackBar("Add successfully");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pop();
        });
      });
    } else {
      showInSnackBar(" Failed , Choose Storage Hub.");
      print(" failed " + responseString);
      setState(() {
        onProgress = false;
      });
      //return false;
    }
  }

  Future bankToMfs(BuildContext context) async {
    print("send to bank to mfs");
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/entry/fund/transfer");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['date'] = _currentDate.toString();
    request.fields['amount'] = amountController.text.toString();
    request.fields['details'] = detailsController.text.toString();
    request.fields['transfer_from'] = _myBank.toString();
    request.fields['transfer_to'] = _myMfs.toString();
    request.fields['event_sub_category_id'] = widget.id.toString();
    request.fields['details'] = detailsController.text.toString();
    print("processing bank to mfs");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      setState(() {
        onProgress = false;
        detailsController.clear();
        amountController.clear();
        receiveFrom.clear();
      });
      showInSnackBar("Add successfully");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pop();
        });
      });
    } else {
      showInSnackBar(" Failed , Choose Storage Hub.");
      print(" failed " + responseString);
      setState(() {
        onProgress = false;
      });
      //return false;
    }
  }

  Future cashToBank(BuildContext context) async {
    print("send to bank to mfs");
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/entry/fund/transfer");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['date'] = _currentDate.toString();
    request.fields['amount'] = amountController.text.toString();
    request.fields['details'] = detailsController.text.toString();
    request.fields['transfer_from'] = cashId.toString();
    request.fields['transfer_to'] = _myBank.toString();
    request.fields['event_sub_category_id'] = widget.id.toString();
    request.fields['details'] = detailsController.text.toString();
    print("processing bank to mfs");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      setState(() {
        onProgress = false;
        detailsController.clear();
        amountController.clear();
        receiveFrom.clear();
      });
      showInSnackBar("Add successfully");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pop();
        });
      });
    } else {
      showInSnackBar(" Failed , Choose Storage Hub.");
      print(" failed " + responseString);
      setState(() {
        onProgress = false;
      });
      //return false;
    }
  }

  Future cashToMfs(BuildContext context) async {
    print("send to cash to mfs");
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/entry/fund/transfer");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['date'] = _currentDate.toString();
    request.fields['amount'] = amountController.text.toString();
    request.fields['details'] = detailsController.text.toString();
    request.fields['transfer_from'] = cashId.toString();
    request.fields['transfer_to'] = _myMfs.toString();
    request.fields['event_sub_category_id'] = widget.id.toString();
    request.fields['details'] = detailsController.text.toString();
    print("processing cash to mfs");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      setState(() {
        onProgress = false;
        detailsController.clear();
        amountController.clear();
        receiveFrom.clear();
      });
      showInSnackBar("Add successfully");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pop();
        });
      });
    } else {
      showInSnackBar(" Failed , Choose Storage Hub.");
      print(" failed " + responseString);
      setState(() {
        onProgress = false;
      });
      //return false;
    }
  }

  Future mfsToBank(BuildContext context) async {
    print("send to mfs to bank");
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/entry/fund/transfer");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['date'] = _currentDate.toString();
    request.fields['amount'] = amountController.text.toString();
    request.fields['details'] = detailsController.text.toString();
    request.fields['transfer_from'] = _myMfs.toString();
    request.fields['transfer_to'] = _myBank.toString();
    request.fields['event_sub_category_id'] = widget.id.toString();
    request.fields['details'] = detailsController.text.toString();
    print("processing mfs to bank");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      setState(() {
        onProgress = false;
        detailsController.clear();
        amountController.clear();
        receiveFrom.clear();
      });
      showInSnackBar("Add successfully");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pop();
        });
      });
    } else {
      showInSnackBar(" Failed , Choose Storage Hub.");
      print(" failed " + responseString);
      setState(() {
        onProgress = false;
      });
    }
  }

  Future mfsTOCash(BuildContext context) async {
    print("send to mfs to cash");
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/entry/fund/transfer");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['date'] = _currentDate.toString();
    request.fields['amount'] = amountController.text.toString();
    request.fields['details'] = detailsController.text.toString();
    request.fields['transfer_from'] = _myMfs.toString();
    request.fields['transfer_to'] = cashId.toString();
    request.fields['event_sub_category_id'] = widget.id.toString();
    request.fields['details'] = detailsController.text.toString();
    print("processing mfs to cash");
    var response = await request.send();
    var responseData = await response.stream.toBytes();
    var responseString = String.fromCharCodes(responseData);
    print("responseBody " + responseString);
    if (response.statusCode == 201) {
      print("responseBody1 " + responseString);
      setState(() {
        onProgress = false;
        detailsController.clear();
        amountController.clear();
        receiveFrom.clear();
      });
      showInSnackBar("Add successfully");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          Navigator.of(context).pop();
        });
      });
    } else {
      showInSnackBar(" Failed , Choose Storage Hub.");
      print(" failed " + responseString);
      setState(() {
        onProgress = false;
      });
    }
  }
}
