
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/screen/stapper/add_Payable.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/chooseMfs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

class AddMfsStapper extends StatefulWidget {
  static const String id = 'addBank';
  final String types ;
  AddMfsStapper({this.types});
  @override
  _AddMfsStapperState createState() => _AddMfsStapperState();
}

class _AddMfsStapperState extends State<AddMfsStapper> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = Map<String, dynamic>();
  TextEditingController mfsNumberController = TextEditingController();
  TextEditingController mfsBalanceController = TextEditingController();
  bool onProgress = false;
  String _myMfs;
  DateTime _currentDate = DateTime.now();
  TextStyle _ts = TextStyle(fontSize: 18.0);

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
        mfsBalanceController.clear();
      });
    });
    super.didChangeDependencies();
  }


  @override
  void dispose() {
    mfsBalanceController.clear();
    mfsNumberController.clear();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    return Scaffold(
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
                      children: [
                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 20,top: 30,),
                            child: Text(
                              "Add a Mfs Account ",
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
                                  border:
                                  Border.all(width: 1, color: Colors.grey)),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 15),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "Date : ${formattedDate}",
                                    style: myStyle(
                                        16, Colors.white70, FontWeight.w700),
                                  ),
                                  Icon(Icons.date_range_outlined,color: Colors.white70,),
                                ],
                              )),
                        ),
                        Column(
                          children: [
                            GestureDetector(
                              onTap: () async {
                                List bal = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseMfs(
                                  types: "all",
                                )));
                                setState(() {
                                  _myMfs=bal[0];
                                  mfsName=bal[1];
                                  print("the Mfs is ${_myMfs}");
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
                                    Text(mfsName??"Choose Mfs",style: myStyle(16,Colors.white),),
                                    Icon(Icons.mobile_screen_share_rounded,color: Colors.white,),
                                  ],
                                ),
                              ),
                            ),
                            SenderTextEdit(
                              keyy: "name",
                              data: _data,
                              name: mfsNumberController,
                              lebelText: "MFS Number",
                              icon: Icons.drive_file_rename_outline,
                              keytype: TextInputType.number,
                              formatter: <TextInputFormatter>[
                                FilteringTextInputFormatter.allow(
                                    RegExp(r'[0-9]')),
                              ],
                              function: (String value) {
                                if (value.isEmpty) {
                                  return "Account Number required";
                                }
                                if (value.length < 11) {
                                  return "Number is Too Short.(Min 11 digits)";
                                }
                                if (value.length > 13) {
                                  return "Number is Too Long.(Max 13 digits)";
                                }
                              },
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 12,right: 12,bottom: 35),
                              child: MoneyTextFormField(
                                settings: MoneyTextFormFieldSettings(
                                  controller: mfsBalanceController,
                                  moneyFormatSettings: MoneyFormatSettings(
                                    // amount: double.tryParse(widget.model.balance.toString()),
                                      currencySymbol: ' ৳ ',
                                      displayFormat:
                                      MoneyDisplayFormat.symbolOnLeft),
                                  appearanceSettings: AppearanceSettings(
                                      padding: EdgeInsets.all(15.0),
                                      labelText: 'Enter Amount* ',
                                      hintText: 'Enter Amount',
                                      labelStyle: myStyle(
                                          20, Colors.white, FontWeight.w600),
                                      inputStyle:
                                      _ts.copyWith(color: BrandColors.colorDimText),
                                      formattedStyle:
                                      _ts.copyWith(color: BrandColors.colorDimText)),
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
                      child: InkWell(
                        onTap: () {
                          widget.types=="addStorageHub"? Navigator.pop(context):  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddPayableStepper()));
                        },
                        child: Container(
                            margin: EdgeInsets.only(
                                left: 12, bottom: 12, right: 12),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: BrandColors.colorPurple, width: 2)),
                            child: Center(
                                child: Text(widget.types=="addStorageHub"? "Back": "Skip",
                              style: myStyle(16, Colors.white),
                            ))),
                      ),
                    ),
                    Expanded(
                            flex: 5,
                        child: InkWell(
                          onTap:mfsName==null? (){
                            showInSnackBar("Please choose a Mfs");
                          }:() {
                            if (!_formKey.currentState.validate()) return;
                            _formKey.currentState.save();
                            print("true");
                            mfsBalanceController.text.toString().isEmpty
                                ? showInSnackBar("Amount Required")
                                : uploadMfs(context);
                          },
                          child: Container(
                            margin: EdgeInsets.only(right: 12, bottom: 12),
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: BrandColors.colorPurple,
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(
                                    color: BrandColors.colorPurple, width: 2)),
                            child: Center(
                                child: Text(
                              "Proceed",
                              style: myStyle(16, Colors.white, FontWeight.w500),
                            )),
                          ),
                        ))
                  ],
                ),
              )
            ],
          )),
        ),
      ),
    );
  }

  Future uploadMfs(BuildContext context) async {
    setState(() {
      onProgress = true;
    });
    final uri = Uri.parse(
        "http://api.hishabrakho.com/api/user/personal/storage/hub/create");
    var request = http.MultipartRequest("POST", uri);
    request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
    request.fields['storage_hub_category_id'] = "6";
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
          widget.types=="addStorageHub"? Navigator.pop(context) :  addMoreMfs(context);
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

  Future<void> addMoreMfs(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent.withOpacity(0.6),
        context: context,
        builder: (context) {
          return AlertDialog(
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            title: Text(
              'Mfs Storage created successful.',
              style: myStyle(22, Colors.black54),
            ),
            content: Text(" Do you want to add more Mfs account ?"),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                color: Colors.black,
                textColor: Colors.white,
                child: Text('Skip'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddPayableStepper()));
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
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMfsStapper()));
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
      duration: Duration(milliseconds: 3000),
      content: Text(
        value,
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      backgroundColor: Colors.purple,
    ));
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
              "Warning !",
              style: myStyle(16, Colors.black54, FontWeight.w800),
            ),
            content:widget.types=="addStorageHub"?Text("Are you sure want to close?"): Text("Do you want to close the stepper ?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No")),
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes"))
            ],
          );
        });
  }
  String mfsName;
}
