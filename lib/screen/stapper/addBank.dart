import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
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
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:anthishabrakho/widget/custom_TextField.dart';
class AddBankStapper extends StatefulWidget {
  static const String id = 'addBank';
  final String types;

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
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now().subtract(Duration(days: 0)),
        //initialDatePickerMode: DatePickerMode.day,
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
        resizeToAvoidBottomInset: false,
        backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
        body: WillPopScope(
          onWillPop: onBackPressed,
          child: ModalProgressHUD(
            progressIndicator: Spin(),
            inAsyncCall: onProgress,
            child: Container(
                margin: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [
                    Expanded(
                      flex: 10,
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
                                  margin: EdgeInsets.only(
                                    bottom: 35,
                                    top: 30,
                                  ),
                                  child: Text(
                                    getTranslated(context,'t151'), // "Add a Bank Account ",
                                    style: myStyle(
                                        20, Colors.white, FontWeight.w600),
                                    textAlign: TextAlign.start,
                                  )),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    seleceDate(context);
                                  });
                                },
                                child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 10),
                                    decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                        border: Border.all(
                                            width: 0.5,
                                            color: BrandColors.colorPurple
                                                .withOpacity(0.8))),
                                    padding: EdgeInsets.symmetric(
                                        horizontal: 20, vertical: 20),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        RichText(
                                          text: TextSpan(children: [
                                            WidgetSpan(
                                              child: Text(
                                                getTranslated(context,'t56'), // 'Date:',
                                                textScaleFactor: 1.0,
                                                style: myStyle(
                                                    14, BrandColors.colorText),
                                              ),
                                            ),
                                            WidgetSpan(
                                              child: Text(
                                                "  ${formattedDate}",
                                                style: myStyle(
                                                    14,
                                                    BrandColors.colorWhite,
                                                    FontWeight.w500),
                                              ),
                                            ),
                                          ]),
                                        ),
                                        SvgPicture.asset(
                                          "assets/calender.svg",
                                          alignment: Alignment.center,
                                          height: 15,
                                          width: 15,
                                        ),
                                      ],
                                    )),
                              ),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Padding(
                                    padding: EdgeInsets.only(
                                      top: 25,
                                    ),
                                    child: Text(
                                      getTranslated(context,'t102'), //       "Choose your bank",
                                      style: myStyle(14, BrandColors.colorText,
                                          FontWeight.w400),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      List bal = await Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (context) => ChooseBank(
                                                    types: "all",
                                                  )));
                                      setState(() {
                                        _myBank = bal[0];
                                        bankName = bal[1];
                                        print("the bal is ${bal[1]}");
                                      });
                                    },
                                    child: Container(
                                      margin:
                                          EdgeInsets.only(top: 14, bottom: 10),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 20, vertical: 20),
                                      decoration: BoxDecoration(
                                        borderRadius:
                                            BorderRadius.circular(10.0),
                                        color: BrandColors.colorPrimary,
                                      ),
                                      child: Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            bankName ?? getTranslated(context,'t153'), // "Select Your Bank ",
                                            style: myStyle(
                                                12,
                                                BrandColors.colorDimText,
                                                FontWeight.w400),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SvgPicture.asset(
                                            "assets/select bank.svg",
                                            alignment: Alignment.center,
                                            height: 20,
                                            width: 20,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 25, bottom: 6),
                                    child: Text(
                                      getTranslated(context,'t70'), // "Account Number",
                                      style: myStyle(14, BrandColors.colorText,
                                          FontWeight.w400),
                                    ),
                                  ),
                                  SenderTextEdit(
                                    keyy: "number",
                                    keytype: TextInputType.number,
                                    data: _data,
                                    name: bankAccountNumberController,
                                    lebelText:getTranslated(context,'t155'), // "Enter your account no",
                                    formatter: <TextInputFormatter>[
                                      FilteringTextInputFormatter.allow(
                                          RegExp(r'[0-9]')),
                                    ],
                                    function: (String value) {
                                      if (value.isEmpty) {
                                        return getTranslated(context,'t72'); // "Account Number required";
                                      }
                                      if (value.length < 11) {
                                        return getTranslated(context,'t73'); //"Account Number is Too Short( Min 11 digit )";
                                      }
                                      if (value.length > 18) {
                                        return getTranslated(context,'t74'); //"Account Number is Too Long ( Max 18 digit )";
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding:
                                        EdgeInsets.only(top: 25, bottom: 6),
                                    child: Text(
                                      getTranslated(context,'t69'), //    "Account Name",
                                      style: myStyle(14, BrandColors.colorText,
                                          FontWeight.w400),
                                    ),
                                  ),
                                  SenderTextEdit(
                                    keyy: "name",
                                    data: _data,
                                    name: bankAccountNameController,
                                    lebelText: getTranslated(context,'t156'), // "Enter your account name",
                                    // hintText: "Account Holder Name",

                                    function: (String value) {
                                      if (value.isEmpty) {
                                        return getTranslated(context,'t84'); //   "Name required";
                                      }
                                      if (value.length < 3) {
                                        return getTranslated(context,'t85'); //"Name is Too Short.(Min 3 character)";
                                      }
                                      if (value.length > 25) {
                                        return getTranslated(context,'t86'); // "Account Number is Too Long ( Max 25 character )";
                                      }
                                    },
                                  ),
                                  Padding(
                                    padding: EdgeInsets.only(bottom: 20),
                                    child: MoneyTextFormField(
                                      settings: MoneyTextFormFieldSettings(
                                        controller: bankBalanceController,
                                        moneyFormatSettings:
                                            MoneyFormatSettings(
                                                currencySymbol: ' ??? ',
                                                displayFormat:
                                                    MoneyDisplayFormat
                                                        .symbolOnLeft),
                                        appearanceSettings: AppearanceSettings(
                                            padding: EdgeInsets.all(15.0),
                                            labelText:getTranslated(context,'t60'), // 'Enter Amount* ',
                                            labelStyle: myStyle(
                                                16,
                                                BrandColors.colorText,
                                                FontWeight.w600),
                                            inputStyle: _ts.copyWith(
                                                color:
                                                    BrandColors.colorDimText),
                                            formattedStyle: _ts.copyWith(
                                                color: BrandColors.colorText)),
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 150,
                                  )
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
                              onTap: () {
                                widget.types == "addStorageHub"
                                    ? Navigator.pop(context)
                                    : Navigator.pushReplacement(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => AddMfsStapper(
                                                  types: "stapper",
                                                )));
                              },
                              child: Container(
                                  margin: EdgeInsets.only(
                                      left: 2, bottom: 12, right: 12),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: BrandColors.colorPurple,
                                          width: 2)),
                                  child: Center(
                                      child: Text(
                                    widget.types == "addStorageHub"
                                        ?getTranslated(context,'t75') // "Back"
                                        :getTranslated(context,'t81'), // "Skip",
                                    style: myStyle(16, Colors.white),
                                  ))),
                            ),
                          ),
                          Expanded(
                              flex: 5,
                              child: GestureDetector(
                                onTap: bankName == null
                                    ? () {
                                        showInSnackBar(getTranslated(context,'t102'),); //   "Choose a Bank");
                                      }
                                    : () {
                                        if (!_formKey.currentState.validate())
                                          return;
                                        _formKey.currentState.save();
                                        print("true");
                                        bankBalanceController.text
                                                .toString()
                                                .isEmpty
                                            ? showInSnackBar(getTranslated(context,'t78')) // "Amount Required")
                                            : uploadBank(context);
                                      },
                                child: Container(
                                  margin: EdgeInsets.only(right: 5, bottom: 12),
                                  height: double.infinity,
                                  decoration: BoxDecoration(
                                      color: BrandColors.colorPurple,
                                      borderRadius: BorderRadius.circular(12.0),
                                      border: Border.all(
                                          color: BrandColors.colorPurple,
                                          width: 2)),
                                  child: Center(
                                      child: Text(
                                        getTranslated(context,'t76'), // "Proceed",
                                    style: myStyle(
                                        16, Colors.white, FontWeight.w500),
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
      showInSnackBar(getTranslated(context,'t157'),); // "Add Bank Storage successful");
      Future.delayed(const Duration(seconds: 1), () {
        setState(() {
          onProgress = false;
          widget.types == "addStorageHub"
              ? Navigator.pop(context)
              : addMoreBank(context);
        });
      });
    } else {
      showInSnackBar(getTranslated(context,'t95'),); //   " Failed, Try again please");
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
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            elevation: 5,
            title: Text(
              getTranslated(context,'t158'), //'Bank Storage created successful.',
              style: myStyle(16,Colors.white,FontWeight.w500),),
            content: Text(getTranslated(context,'t159'),), //" Do you want to add more Bank account ?"),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8)),
                
                textColor: Colors.white,
                child: Text(getTranslated(context,'t64'),), //       'No'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddMfsStapper()));
                  });
                },
              ),

              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text(getTranslated(context,'t63'), //             'Yes',
                  style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  setState(() {
                    //codeDialog = valueText;
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                            builder: (context) => AddBankStapper()));
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
        style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
      ),
      backgroundColor: Colors.indigo,
    ));
  }

  Future<bool> onBackPressed() {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return AlertDialog(
            elevation: 1,
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0)),
            title: Text(
              getTranslated(context,'t145'), //   "Warning !",
              style: myStyle(16, Colors.white, FontWeight.w500),
            ),
            content: widget.types == "addStorageHub"
                ? Text(getTranslated(context,'t160'),)// "Are you sure want to close?")
                : Text(getTranslated(context,'t146'),), //"Do you want to close the stepper ?"),
            actions: <Widget>[
              FlatButton(
                  onPressed: () {
                    Navigator.of(context).pop(false);
                  },
                  child: Text(
                    getTranslated(context,'t64'), // "No",
                    style: myStyle(14, BrandColors.colorText),
                  )),

              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 16,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text(getTranslated(context,'t63'), //       'Yes',
                  style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
              ),

            ],
          );
        });
  }

  String bankName;
}
