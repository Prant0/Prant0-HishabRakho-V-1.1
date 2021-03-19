import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:anthishabrakho/screen/stapper/addMfs.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/chooseBank.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

class AddBankStapper extends StatefulWidget {
  static const String id = 'addBank';
  final String types ;
  AddBankStapper({this.types});
  @override
  _AddBankStapperState createState() => _AddBankStapperState();
}

class _AddBankStapperState extends State<AddBankStapper> {


  TextStyle _ts = TextStyle(fontSize: 18.0);
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  TextEditingController bankAccountNumberController = TextEditingController();
  TextEditingController bankAccountNameController = TextEditingController();
  TextEditingController bankBalanceController = TextEditingController();
  Map<String, dynamic> _data = Map<String, dynamic>();
  bool onProgress = false;
  String _myBank;
  DateTime _currentDate = DateTime.now();

  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now().subtract(Duration(days: 0)),
        initialDatePickerMode: DatePickerMode.day,
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
      setState(() {
        bankBalanceController.clear();
      });
    });
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    bankBalanceController.clear();
    bankAccountNumberController.clear();
    bankAccountNameController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    return SafeArea(
      child: Scaffold(
        backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: onBackPressed,
          child: ModalProgressHUD(
            inAsyncCall: onProgress,
            child: Container(
              margin: EdgeInsets.symmetric( horizontal: 20),
              child: Column(
                children: [
                  Expanded(
                    flex: 9,
                    child: SingleChildScrollView(
                      physics: BouncingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [

                            Container(
                                margin: EdgeInsets.only(bottom: 35,top: 30,),
                                child: Text(
                                  "Add a Bank Account ",
                                  style: myStyle(20, Colors.white, FontWeight.w600),
                                  textAlign: TextAlign.start,
                                )),

                            InkWell(
                              onTap: () {
                                setState(() {
                                  seleceDate(context);
                                });
                              },
                              child: Container(
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
                                        myStyle(16, Colors.white, FontWeight.w700),
                                      ),
                                      Icon(Icons.date_range_outlined,color: BrandColors.colorDimText,),
                                    ],
                                  )),
                            ),
                            Column(
                              children: [
                                GestureDetector(
                                  onTap: () async {
                                    List bal= await Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseBank(
                                      types: "all",
                                    )));
                                    setState(() {
                                      _myBank=bal[0];
                                      bankName=bal[1];
                                      print("the bal is ${bal[1]}");
                                    });
                                  },
                                  child: Container(
                                    margin: EdgeInsets.only(top: 25,bottom: 10),
                                    padding: EdgeInsets.symmetric(horizontal: 15),
                                    height: 60,
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: BrandColors.colorPrimary,
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(bankName??"Choose Bank",style: myStyle(16,Colors.white),overflow: TextOverflow.ellipsis,),
                                        Icon(Icons.mobile_screen_share_rounded,color: Colors.white,),
                                      ],
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
                                  formatter:  <TextInputFormatter>[
                                    FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                                  ],
                                  icon: Icons.confirmation_number_outlined,
                                  function: (String value) {
                                    if (value.isEmpty) {
                                      return "Account Number required";
                                    }
                                    if (value.length < 11) {
                                      return "Account Number is Too Short( Min 11 digit )";
                                    }
                                    if (value.length > 18) {
                                      return "Account Number is Too Long ( Max 18 digit )";
                                    }
                                  },
                                ),
                                SenderTextEdit(
                                  keyy: "name",
                                  data: _data,
                                  name: bankAccountNameController,
                                  lebelText: "Your Name",
                                  hintText: "Account Holder Name",
                                  icon: Icons.drive_file_rename_outline,
                                  function: (String value) {
                                    if (value.isEmpty) {
                                      return "Name required";
                                    }
                                    if (value.length < 3) {
                                      return "Name is Too Short.(Min 3 character)";
                                    }
                                    if (value.length > 25) {
                                      return "Account Number is Too Long ( Max 25 character )";
                                    }
                                  },
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 22,right: 22,bottom: 20),
                                  child: MoneyTextFormField(
                                    settings: MoneyTextFormFieldSettings(
                                      controller: bankBalanceController,
                                      moneyFormatSettings: MoneyFormatSettings(
                                          currencySymbol: ' ৳ ',
                                          displayFormat: MoneyDisplayFormat.symbolOnLeft),
                                      appearanceSettings: AppearanceSettings(
                                          padding: EdgeInsets.all(15.0),
                                          labelText: 'Enter Amount* ',
                                          labelStyle: myStyle(20,Colors.white,FontWeight.w600),
                                          inputStyle: _ts.copyWith(color: BrandColors.colorDimText),
                                          formattedStyle:
                                          _ts.copyWith(color:BrandColors.colorDimText)),

                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),

                  Expanded(
                    flex: 1,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 5,
                          child: GestureDetector(
                            onTap:  () {
                            widget.types=="addStorageHub"? Navigator.pop(context):  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddMfsStapper(
                              types: "stapper",
                            )));
                            },
                            child: Container(
                                margin: EdgeInsets.only(left: 12,bottom: 12,right: 12),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                                ),
                                child: Center(
                                    child: Text(widget.types=="addStorageHub"? "Back": "Skip",style: myStyle(16,Colors.white),))),
                          ),
                        ),
                        Expanded(
                            flex: 5,
                            child: InkWell(
                              onTap:bankName==null? (){
                                showInSnackBar("Choose a Bank");
                              } :  () {
                                if (!_formKey.currentState.validate()) return;
                                _formKey.currentState.save();
                                print("true");
                                bankBalanceController.text.toString().isEmpty?
                                showInSnackBar("Amount Required"): uploadBank(context) ;
                              },
                              child: Container(
                                margin: EdgeInsets.only(right: 12,bottom: 12),
                                height: double.infinity,
                                decoration: BoxDecoration(
                                  color: BrandColors.colorPurple,
                                    borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                                ),
                                child: Center(child: Text("Proceed",style: myStyle(16,Colors.white,FontWeight.w500),)),
                              ),
                            )
                        )
                      ],
                    ),
                  )
                ],
              )
            ),
          ),
        ),
      ),
    );
  }


  Future uploadBank(BuildContext context) async {
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/storage/hub/create");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['storage_hub_category_id'] = "5";
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
      print("responseBody1 " + responseString);
      showInSnackBar("Add Bank Storage successful");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          onProgress = false;
          widget.types=="addStorageHub"? Navigator.pop(context) :  addMoreBank(context);
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
  Future<void> addMoreBank(BuildContext context) async {
    return showDialog(
      barrierDismissible: false,
        barrierColor: Colors.transparent.withOpacity(0.6),
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),elevation: 5,
            title: Text('Bank Storage created successful.',style: myStyle(22,Colors.black54),),
            content: Text(" Do you want to add more Bank account ?"),
            actions: <Widget>[
              FlatButton(
                shape:RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)) ,
                color: Colors.black,
                textColor: Colors.white,
                child: Text('Skip'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddMfsStapper()));
                  });
                },
              ),

              FlatButton(
                color: Colors.purple,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () {
                  setState(() {
                    //codeDialog = valueText;
                    Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddBankStapper()));
                   //
                  });
                },
              ),
            ],
          );
        });
  }
  void showInSnackBar(String value) {
    //  delay(1500);
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        value,
        style: TextStyle(
            color: Colors.white,fontWeight: FontWeight.w800
        ),
      ),
      backgroundColor: Colors.teal,
    ));
  }

  Future<bool> onBackPressed(){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){

          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0)
            ),
            title: Text("Warning !",style: myStyle(16,Colors.black54,FontWeight.w800),),
            content:widget.types=="addStorageHub"?Text("Are you sure want to close?"): Text("Do you want to close the stepper ?"),
            actions:<Widget> [
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No")
              ),

              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes")
              )
            ],
          );
        }
    );
  }
  String bankName;


}
