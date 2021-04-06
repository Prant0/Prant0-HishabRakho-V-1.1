import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/screen/stapper/add_Receivable.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:shimmer/shimmer.dart';
import 'package:http/http.dart' as http;

class AddPayableStepper extends StatefulWidget {
  @override
  _AddPayableStepperState createState() => _AddPayableStepperState();
}

class _AddPayableStepperState extends State<AddPayableStepper> {

  TextStyle _ts = TextStyle(fontSize: 18.0);
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
        amountController.clear();
      });
    });
    super.didChangeDependencies();
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
            child: Form(
              key: _formKey,
              child:Column(
                children: [
                  Expanded(
                    flex: 11,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          SizedBox(
                            height: 20,
                          ),
                          Container(
                              margin: EdgeInsets.only(bottom: 20,top: 30,),
                              child: Text(
                                "Add your payable ",
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
                                            'Date:',
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
                            height: 12,
                          ),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Payable to ",style: myStyle(16,BrandColors.colorText,FontWeight.w500),),
                          ),
                          SenderTextEdit(
                            keyy: "pay",
                            data: _data,
                            name: nameController,
                            lebelText: "Enter Name",
                            icon: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: SvgPicture.asset("assets/user1.svg",
                                alignment: Alignment.bottomCenter,
                                fit: BoxFit.contain,
                                color: BrandColors.colorText,
                              ),
                            ),
                            function: (String value) {
                              if (value.isEmpty) {
                                return "Name required";
                              }
                              if (value.length < 3) {
                                return "Name Too Short.(Min 3 character)";
                              }
                              if (value.length > 25) {
                                return "Name Too Long.(Max 25 character)";
                              }
                            },
                          ),
                          SizedBox(height: 10,),
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 8),
                            child: Text("Add details ",style: myStyle(16,BrandColors.colorText,FontWeight.w500),),
                          ),
                          SenderTextEdit(
                            keyy: "details",
                            data: _data,
                            name: details,
                            lebelText: "Write here...",
                           // icon: Icons.details_sharp,
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
                                    labelText: 'Enter Amount* ',
                                    hintText: 'Enter Amount',
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
                    child: Container(
                      margin: EdgeInsets.only(bottom: 8),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          InkWell(
                            onTap: () {
                              Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => AddReceivableStepper()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 70),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),
                                    border: Border.all(
                                        color: BrandColors.colorPurple, width: 2)),
                                child: Center(
                                    child: Text(
                                      "Skip",
                                      style: myStyle(16, Colors.white),
                                    ))),
                          ),

                          InkWell(
                            onTap: () {
                              if (!_formKey.currentState.validate()) return;
                              _formKey.currentState.save();
                              amountController.text.toString().isEmpty?showInSnackBar("Amount Required"): uploadPayable(context);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 50),
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
                          )
                        ],
                      ),
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

  Future uploadPayable(BuildContext context) async {
    try {
      setState(() {
        onProgress = true;
      });
      final uri = Uri.parse(
          "http://api.hishabrakho.com/api/user/personal/entry/loan/create");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['date'] = _currentDate.toString();
      request.fields['amount'] = amountController.text.toString();
      request.fields['event_type'] = "Take Loan";
      request.fields['friend_name'] = nameController.text.toString();
      request.fields['event_sub_category_id'] = 86.toString();
      request.fields['details'] = details.text.toString();
      print("processing for payable uploading");
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
        showInSnackBar("Payable Added successfully");
        Future.delayed(const Duration(seconds: 1), () {
          if(mounted){
            setState(() {
              addMoreMfs(context);
            });
          }
        });
      } else {
        showInSnackBar(" Failed, Try again please");
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

  Future<void> addMoreMfs(BuildContext context) async {
    return showDialog(
        context: context,
        barrierDismissible: false,
        barrierColor: Colors.transparent.withOpacity(0.6),
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),elevation: 5,
            title: Text('Payable entry added successful.',style: myStyle(22,Colors.black54),),
            content: Text(" Do you want to add more Payable entry ?"),
            actions: <Widget>[
              FlatButton(
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                color: Colors.black,
                textColor: Colors.white,
                child: Text('Skip'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                    Navigator.pushReplacement(
                        context, MaterialPageRoute(builder: (context) => AddReceivableStepper()));

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
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => AddPayableStepper()));
                    //
                  });
                },
              ),
            ],
          );
        });
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
            content: Text("Do you want to close the stepper ?"),
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
