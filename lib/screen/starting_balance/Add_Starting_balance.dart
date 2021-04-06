import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:http/http.dart' as http;
///api/user/personal/starting/receivable/balance/create
class AddStartingBalance extends StatefulWidget {
  final String title;
  AddStartingBalance({this.title});
  @override
  _AddStartingBalanceState createState() => _AddStartingBalanceState();
}

class _AddStartingBalanceState extends State<AddStartingBalance> {
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

  @override
  Widget build(BuildContext context) {
    print("${widget.title}");
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      body:ModalProgressHUD(
        inAsyncCall: onProgress,
        child: Container(
          height: double.infinity,
          padding: EdgeInsets.only(top: 30,left: 14,right: 14),
          child: Form(
            key: _formKey,
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 22),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FittedBox(
                                child: widget.title=="payable"? Text(
                                  "Add your Payable ",
                                  style: myStyle(18, Colors.white, FontWeight.w700),
                                  textAlign: TextAlign.start,
                                )   :Text(
                                  "Add your Receivable ",
                                  style: myStyle(20, Colors.white, FontWeight.w700),
                                  textAlign: TextAlign.start,
                                )
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
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(width: 1, color: Colors.grey)),
                            padding:EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date : ${formattedDate}",
                                  style:
                                  myStyle(16, BrandColors.colorText, FontWeight.w700),
                                ),
                                Icon(Icons.date_range_outlined,color:BrandColors.colorText,),
                              ],
                            )),
                      ),

                      Padding(
                          padding:EdgeInsets.only(top: 20),
                          child: widget.title=="payable"? Text(
                            "Pay to ",
                            style: myStyle(16, BrandColors.colorText,  ),
                            textAlign: TextAlign.start,
                          )   :Text(
                            "Receive from  ",
                            style: myStyle(16,  BrandColors.colorText, ),
                            textAlign: TextAlign.start,
                          )
                      ),
                      SenderTextEdit(
                        keyy: "pay",
                        data: _data,
                        name: nameController,
                        lebelText: "Type name here",
                        suffixIcon: Padding(
                          padding: const EdgeInsets.all(15.0),
                          child: SvgPicture.asset("assets/user1.svg",
                            alignment: Alignment.center,
                            fit: BoxFit.contain,
                            height: 15,width: 15,
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
                      Padding(
                        child: Text("Add Details (optional)",style: myStyle(16,BrandColors.colorText),),
                        padding: EdgeInsets.only(top: 15,),
                      ),
                      SenderTextEdit(
                        keyy: "details",
                        data: _data,
                        name: details,
                        lebelText: "write details (optional)",

                      ),
                      MoneyTextFormField(
                        settings: MoneyTextFormFieldSettings(
                          controller: amountController,
                          moneyFormatSettings: MoneyFormatSettings(
                              currencySymbol: ' ৳ ',
                              displayFormat: MoneyDisplayFormat.symbolOnLeft),
                          appearanceSettings: AppearanceSettings(
                              padding: EdgeInsets.all(15.0),
                              labelText: 'Enter Amount* ',
                              hintText: 'Enter Amount',
                              labelStyle: myStyle(20, BrandColors.colorText,FontWeight.w600),
                              inputStyle: _ts.copyWith(color:  BrandColors.colorText),
                              formattedStyle:
                              _ts.copyWith(color:  BrandColors.colorText)),

                        ),
                      ),



                    ],
                  ),
                ),
                Positioned(
                  bottom: 8,
                  left: 0,
                  right: 0,
                  child: Container(
                    color: BrandColors.colorPrimaryDark,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 10,
                          child: GestureDetector(
                            onTap:widget.title=="payable"? (){
                              String type="receivable";
                              Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddStartingBalance(
                                  title:type,)));
                            } :(){
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
                                  SvgPicture.asset("assets/arrow2.svg",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                  ),
                                  SizedBox(width: 5,),
                                  Text(
                                    "Skip",
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
                            onTap:  () {
                              if (!_formKey.currentState.validate()) return;
                              _formKey.currentState.save();
                              amountController.text.toString().isEmpty?showInSnackBar("Amount Required"): widget.title=="payable"? uploadPayable(context) : uploadReceivable(context);
                            },
                            child: Container(
                              height: 50,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: Colors.deepPurpleAccent,
                                border: Border.all(
                                    color: BrandColors.colorPurple.withOpacity(0.8),
                                    width: 1.0),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "Proceed",
                                    style: myStyle(16, Colors.white),
                                  ),
                                  SvgPicture.asset("assets/arrow1.svg",
                                    alignment: Alignment.center,
                                    fit: BoxFit.contain,
                                  ),
                                ],
                              ),
                            ),
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
      ) ,
    );
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(seconds: 1),
      content: Text(
        value,
        style: TextStyle(
          color: BrandColors.snackBarColor,
        ),
      ),
      backgroundColor: Colors.purple,
    ));


  }
  Future uploadPayable(BuildContext context) async {
    try {
      setState(() {
        onProgress = true;
      });
      final uri = Uri.parse(
          "http://api.hishabrakho.com/api/user/personal/starting/payable/balance/create");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['date'] = _currentDate.toString();
      request.fields['amount'] = amountController.text.toString();
      request.fields['friend_name'] = nameController.text.toString();
      request.fields['details'] = details.text.toString();
      print("processing for payable uploading");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        showInSnackBar("Payable data added successfully");
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {

            onProgress = false;
            String type="receivable";
            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddStartingBalance(
              title:type ,
            )));
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
    } catch (e) {
      print("something went wrong $e");
    }
  }
  Future uploadReceivable(BuildContext context) async {
    try {
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
      print("processing for starting receivable uploading");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        showInSnackBar("Receivable data added successfully");
        Future.delayed(const Duration(seconds: 1), () {
          if(mounted){
            setState(() {
              onProgress = false;
              Navigator.pop(context);
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
}
