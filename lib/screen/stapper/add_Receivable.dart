import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';
import 'package:anthishabrakho/screen/main_page.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/widget/custom_TextField.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:provider/provider.dart';

import 'package:http/http.dart' as http;

class AddReceivableStepper extends StatefulWidget {
  @override
  _AddReceivableStepperState createState() => _AddReceivableStepperState();
}

class _AddReceivableStepperState extends State<AddReceivableStepper> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  Map<String, dynamic> _data = Map<String, dynamic>();
  TextEditingController amountController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController details = TextEditingController();
  bool onProgress = false;
  DateTime _currentDate = DateTime.now();


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


  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        amountController.clear();
      });
    });
    super.didChangeDependencies();
  }
  TextStyle _ts = TextStyle(fontSize: 18.0);
  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BrandColors.colorPrimaryDark,
      key: _scaffoldKey,
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        progressIndicator: Spin(),
        child: Container(
          margin: EdgeInsets.symmetric( horizontal: 20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  flex:10,
                  child: SingleChildScrollView(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        SizedBox(
                          height: 20,
                        ),
                        Container(
                            margin: EdgeInsets.only(bottom: 40,top: 30,),
                            child: Text(
                              getTranslated(context,'t147'), // "Add your Receivable ",
                              style: myStyle(20, Colors.white, FontWeight.w500),
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
                                  borderRadius: BorderRadius.circular(12.0),
                                  border: Border.all(
                                      width: 0.5, color: Colors.grey.withOpacity(0.4))),
                              padding: EdgeInsets.symmetric(
                                  horizontal: 20, vertical: 20),
                              child: Row(
                                mainAxisAlignment:
                                MainAxisAlignment.spaceBetween,
                                children: [

                                  RichText(
                                    text: TextSpan(children: [

                                      WidgetSpan(
                                        child:Text(
                                          getTranslated(context,'t56'), //    'Date:',
                                          textScaleFactor: 1.0,
                                          style: myStyle(14,BrandColors.colorText),
                                        ),
                                      ),

                                      WidgetSpan(
                                        child: Text(
                                          "  ${formattedDate}",
                                          style: myStyle(
                                              14, BrandColors.colorWhite, FontWeight.w500),
                                        ),
                                      ),

                                    ]),
                                  ),

                                  SvgPicture.asset("assets/calender.svg",
                                    alignment: Alignment.center,
                                    height: 15,width: 15,
                                  ),
                                ],
                              )),
                        ),


                        SizedBox(
                          height: 15,
                        ),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(getTranslated(context,'t148'),   //"Receivable to ",
                            style: myStyle(16,BrandColors.colorText,FontWeight.w500),),
                        ),
                        SenderTextEdit(
                          keyy: "pay",
                          data: _data,
                          name: nameController,
                          lebelText:getTranslated(context,'t87'), // "Receivable from",
                          icon: Padding(
                            padding: const EdgeInsets.all(15.0),
                            child: SvgPicture.asset("assets/user1.svg",
                              alignment: Alignment.bottomCenter,
                              fit: BoxFit.contain,
                              color: BrandColors.colorText,
                            ),
                          ),
                          function: (String value) {
                            if (value.isEmpty) {
                              return getTranslated(context,'t84'); // "Name required";
                            }
                            if (value.length < 3) {
                              return getTranslated(context,'t85'); //"Name Too Short.(Min 3 character)";
                            }if (value.length > 25) {
                              return getTranslated(context,'t86'); // "Name Too Long.(Max 25 character)";
                            }
                          },
                        ),
                        SizedBox(height: 10,),
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 8),
                          child: Text(getTranslated(context,'t59'), //   "Add details ",
                            style: myStyle(16,BrandColors.colorText,FontWeight.w500),),
                        ),
                        SenderTextEdit(
                          keyy: "details",
                          data: _data,
                          name: details,
                          lebelText:getTranslated(context,'t142'), // "Write details here...",

                          //icon: Icons.details_sharp,
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
                                  labelText:getTranslated(context,'t60'), // 'Enter Amount* ',
                                  hintText:getTranslated(context,'t60'), // 'Enter Amount',
                                  labelStyle: myStyle(20,Colors.white,FontWeight.w600),
                                  inputStyle: _ts.copyWith(color: BrandColors.colorDimText),
                                  formattedStyle:
                                  _ts.copyWith(color: BrandColors.colorDimText)),

                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),

                      ],
                    ),
                  ),
                ),
                Expanded(
                  flex: 1,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        flex:5,
                        child: GestureDetector(
                          onTap: () {
                            Provider.of<StorageHubProvider>(context, listen: false)
                                .clearAllStorage();
                            Navigator.pushReplacement(context,MaterialPageRoute(builder: (context)=>MainPage()));
                          },
                          child:  Container(
                              margin: EdgeInsets.only(left: 2,bottom: 12,right: 12),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                              ),
                              child: Center(
                                  child: Text(
                                    getTranslated(context,'t81'), //   "Skip",
                                    style: myStyle(16, Colors.white),
                                  ))),
                        ),
                      ),
                      Expanded(
                        flex:5,
                        child: InkWell(
                          onTap:  () {
                            if (!_formKey.currentState.validate()) return;
                            _formKey.currentState.save();
                            amountController.text.toString().isEmpty?showInSnackBar(getTranslated(context,'t78')): uploadReceivable(context);
                          },
                          child:  Container(
                            margin: EdgeInsets.only(right: 5,bottom: 12),
                            height: double.infinity,
                            decoration: BoxDecoration(
                                color: BrandColors.colorPurple,
                                borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                            ),
                            child: Center(child: Text(getTranslated(context,'t76') //"Proceed"
                              ,style: myStyle(16,Colors.white,FontWeight.w500),)),
                          ),
                        ),
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ),
      ),
    );


  }
  Future<void> addMoreReceivable(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        barrierColor: Colors.transparent.withOpacity(0.6),
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            titlePadding: EdgeInsets.only(top: 30,bottom: 12,right: 30,left: 30),
            contentPadding: EdgeInsets.only(left: 30,right: 30,),
            backgroundColor:  BrandColors.colorPrimaryDark,
            actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
            contentTextStyle: myStyle(14,BrandColors.colorText.withOpacity(0.7),FontWeight.w400),
            titleTextStyle: myStyle(18,Colors.white,FontWeight.w500),

            title: Text(getTranslated(context,'t149'), //    'Receivable entry added successful.',
              style: myStyle(22,Colors.white),),
            content: Text(getTranslated(context,'t150'),), //" Do you want to add more Receivable entry ?"),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                textColor: Colors.white,
                child: Text(getTranslated(context,'t64'),), //           NO    ),
                onPressed: () {
                  setState(() {
                    Provider.of<StorageHubProvider>(context, listen: false)
                        .clearAllStorage();
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => MainPage()));
                  });
                },
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text(getTranslated(context,'t63'), //           'Yes',
                  style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => AddReceivableStepper()));
                  });
                },
              ),

            ],
          );
        });
  }
  Future uploadReceivable(BuildContext context) async {
    try {
      print("Waliur bhai");
      setState(() {
        onProgress = true;
      });
      final uri = Uri.parse(
          "http://api.hishabrakho.com/api/user/personal/starting/receivable/balance/create");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['date'] = _currentDate.toString();
      request.fields['amount'] = amountController.text.toString();
      request.fields['friend_name'] = nameController.text.toString();
      request.fields['details'] = details.text.toString();
      print("processing for loan uploading");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("responseBody " + responseString);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        setState(() {
          onProgress = false;
          details.clear();
          amountController.clear();
          nameController.clear();
        });
        showInSnackBar(getTranslated(context,'t94'),); //"Add successfully");
        Future.delayed(const Duration(seconds: 1), () {
          if(mounted){
            setState(() {
              addMoreReceivable(context);

            });
          }
        });
      } else {
        showInSnackBar(getTranslated(context,'t95'), );//" Failed, Try again please");
        print(" failed " + responseString);
        setState(() {
          onProgress = false;
        });
        //return false;
      }
    } catch (e) {
      print("something went wrong $e");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }
}
