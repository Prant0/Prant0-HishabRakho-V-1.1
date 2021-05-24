import 'dart:convert';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:anthishabrakho/widget/custom_TextField.dart';
class EditTransaction extends StatefulWidget {
  final MyTransectionModel model;
  String type;

  EditTransaction({this.model, this.type});

  @override
  _EditTransactionState createState() => _EditTransactionState();
}

class _EditTransactionState extends State<EditTransaction> {
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool isPayable = false;
  bool isReceive = false;

  updateItem() {
    if (widget.type == "Payable") {
      setState(() {
        isPayable = true;
      });
    } else if (widget.type == "Receivable") {
      setState(() {
        isPayable = false;isReceive=true;
      });
    }else if(widget.type=="Earning"){
      setState(() {
        isReceive = false; isPayable=false;
      });
    }else if(widget.type=="Expenditure"){
      setState(() {
        isReceive = false; isPayable=false;
      });
    }
  }
  DateTime _currentDate = DateTime.now();
  TextStyle _ts = TextStyle(fontSize: 18.0);


  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 3),
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
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.purple,
    ),);
  }

  bool onProgress=false;
  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    print(widget.model.amount);
    print("Type is ${widget.type}");
    print("Type is ${widget.model.transactionTypeId}");
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      key: _scaffoldKey,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(
          getTranslated(context,'t82'),   // "Edit Entries",
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
          progressIndicator: Spin(),
        inAsyncCall: onProgress,
        child: Stack(
          children: [
            Container(
              color:  BrandColors.colorPrimaryDark,
              child: Form(
                key: _formKey,
                child: Card(
                  color:  BrandColors.colorPrimaryDark,
                  elevation: 3,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 30.0,
                      ),
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
                                        getTranslated(context,'t56'),   // 'Date:',
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


                      Visibility(
                        visible: isPayable == true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25,),
                              child: Text( getTranslated(context,'t83'),   //"Pay/Payable to",
                                style: myStyle(16,BrandColors.colorWhite,FontWeight.w500),),
                            ),
                            SenderTextEdit(
                              keyy: "Payable",
                              data: _data,
                              name: nameController,
                              lebelText: "${widget.model.friendName} ?? ",
                              //hintText: " Payable to",
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
                                  return  getTranslated(context,'t84');   //"Name required";
                                }
                                if (value.length < 3) {
                                  return  getTranslated(context,'t85');   //"Name Too Short ( Min 3 character )";
                                }if (value.length > 30) {
                                  return  getTranslated(context,'t86');   // "Name Too long (Max 30 character)";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Visibility(
                        visible: isReceive == true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25,),
                              child: Text(getTranslated(context,'t87'),  //       "Receive/Receivable from",
                                style: myStyle(16,BrandColors.colorWhite,FontWeight.w500),),
                            ),
                            SenderTextEdit(
                              keyy: "Receivable",
                              data: _data,
                              name: nameController,
                              lebelText: "${widget.model.friendName} ?? "" ",
                              // hintText: " Receivable from",
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
                                  return getTranslated(context,'t84');    //"Name required";
                                }
                                if (value.length < 3) {
                                  return getTranslated(context,'t85');     // "Name Too Short. ( Min 3 character )";
                                }if (value.length > 30) {
                                  return getTranslated(context,'t86')  ;        // "Name Too long. ( Max 30 character )";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25,),
                        child: Text(getTranslated(context,'t88'),            //"Details",
                          style: myStyle(16,BrandColors.colorWhite,FontWeight.w600),),
                      ),
                      SenderTextEdit(
                        keyy: "Details",
                        maxNumber: 4,
                        data: _data,
                        name:detailsController ,
                        lebelText: widget.model.details ?? "",
                        hintText:getTranslated(context,'t88'),            // " Details",
                        //icon: Icons.details,
                        function: (String value) {

                        },
                      ),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 12),
                        child: MoneyTextFormField(
                          settings: MoneyTextFormFieldSettings(
                            controller: amountController,
                            moneyFormatSettings: MoneyFormatSettings(
                                amount: double.tryParse(widget.model.amount.toString()),
                                currencySymbol: ' ৳ ',
                                displayFormat: MoneyDisplayFormat.symbolOnLeft),
                            appearanceSettings: AppearanceSettings(

                                padding: EdgeInsets.all(15.0),
                                hintText:getTranslated(context,'t78'),            // 'Amount required',
                                labelText:getTranslated(context,'t89'),            // 'Amount ',
                                labelStyle: myStyle(20,Colors.white,FontWeight.w600),
                                inputStyle: _ts.copyWith(color: Colors.white),
                                formattedStyle:
                                _ts.copyWith(color: Colors.white)),

                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      // ignore: deprecated_member_use

                    ],
                  ),
                ),
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
                        onTap: (){
                          Navigator.pop(context);
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 20),
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
                                getTranslated(context,'t75'),            // "Go Back",
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

                          final note = MyTransectionModel(
                            amount: double.parse(amountController.text.toString()),
                            details:detailsController.text.toString(),
                            date: _currentDate.toString(),
                            eventId: widget.model.eventId.toInt(),
                            transactionTypeId: widget.model.transactionTypeId.toInt(),
                            eventType: widget.model.eventType.toString(),
                          );
                          final payableNote = MyTransectionModel(
                            amount: double.parse(amountController.text.toString()),
                            details:detailsController.text.toString(),
                            date: _currentDate.toString(),
                            eventId: widget.model.eventId,
                            transactionTypeId: widget.model.transactionTypeId,
                            eventType: widget.model.eventType.toString(),
                            friendName: nameController.text.toString(),
                          );
                          widget.type == "Earning"
                              ?amountController.text.toString().isEmpty?showInSnackBar(getTranslated(context,'t78')):updateEarning(note)   //amount required
                              : widget.type == "Expenditure"
                              ?amountController.text.toString().isEmpty?showInSnackBar(getTranslated(context,'t78')):updateExpenditure(note) //amount required
                              : widget.type == "Payable"
                              ?amountController.text.toString().isEmpty?showInSnackBar(getTranslated(context,'t78')):updatePayable(payableNote)//amount required
                              : widget.type == "Receivable"
                              ? amountController.text.toString().isEmpty?showInSnackBar(getTranslated(context,'t78')):updateReceivable(payableNote)//amount required
                              : "";
                          setState(() {
                            amountController.clear();
                            detailsController.clear();
                          });

                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 12,right: 20),
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
                                getTranslated(context,'t76'),               // "Proceed",
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
            )
          ],
        )
      ),
    );
  }


  static SharedPreferences sharedPreferences;
  updateEarning(MyTransectionModel item) async {
    setState(() {
      onProgress=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/user/personal/earning/update",
            headers: <String, String>{
              'Content-type': 'application/json',
              "Authorization": "bearer ${sharedPreferences.getString("token")}",
            },
            body: json.encode(item.toJson()),)
        .then((data) {
      try{
        if (data.statusCode == 201) {
          return {

            showInSnackBar(getTranslated(context,'t90')                 //"Updated successfully"
            ),
          Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction(),
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {

                onProgress=false;
                Navigator.of(context).pop();

              });
            }),
          };

        } else
          setState(() {
            onProgress=true;
            showInSnackBar(getTranslated(context,'t79')                 // update failed
                 );
          });
        throw Exception('Failed to update');
      }catch(e){
        print("Failedddd $e");
      }
    });
  }

  TextEditingController tx=TextEditingController();
  updateExpenditure(MyTransectionModel item) async {
    setState(() {
      onProgress=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/user/personal/expenditure/update",
            headers: <String, String>{
              'Content-type': 'application/json',
              "Authorization": "bearer ${sharedPreferences.getString("token")}",
            },
            body: json.encode(item.toJson()))
        .then((data) {
      if (data.statusCode == 201) {
        return {

          Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction(),
          showInSnackBar(getTranslated(context,'t90')                 //"Updated successfully"
          ),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              amountController.clear();
              onProgress=false;
              Navigator.of(context).pop();
            });
          }),
        };
      } else
        throw Exception('Failed to update');
    });
  }

  updatePayable(MyTransectionModel item) async {
    setState(() {
      onProgress=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/user/personal/update/payable",
            headers: <String, String>{
              'Content-type': 'application/json',
              "Authorization": "bearer ${sharedPreferences.getString("token")}",
            },
            body: json.encode(item.toPayable()))
        .then((data) {
      if (data.statusCode == 201) {
        return {
          showInSnackBar(getTranslated(context,'t90')                 //"Updated successfully"
               ),
          Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction(),
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              onProgress=false;
              Navigator.of(context).pop();
            });
          }),
        };
      } else
        print("responce ${data.body}");
        throw Exception('Failed to update');
    });
  }

  updateReceivable(MyTransectionModel item) async {
    setState(() {
      onProgress=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/user/personal/update/receivable",
            headers: <String, String>{
              'Content-type': 'application/json',
              "Authorization": "bearer ${sharedPreferences.getString("token")}",
            },
            body: json.encode(item.toReceivable()))
        .then((data) {
      if (data.statusCode == 201) {
        Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
          showInSnackBar(getTranslated(context,'t90')                 //"Updated successfully"
          );

          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              onProgress=false;
              Navigator.of(context).pop();
            });
          });

      } else
        throw Exception('Failed to update');
    });
  }

  @override
  void initState() {
    updateItem();
    nameController.text="${widget.model.friendName}";
    detailsController.text="${widget.model.details ?? ""}";
    amountController.text=NumberFormat.currency(
        symbol: ' ৳ ',
        decimalDigits: 2,
        locale: "en-in")
        .format(widget.model.amount);
    super.initState();
  }

  TextEditingValue formatEditUpdate(TextEditingValue oldValue, TextEditingValue newValue) {
    if(newValue.selection.baseOffset == 0){
      print(true);
      return newValue;
    }

    double value = double.parse(newValue.text);

    final formatter = NumberFormat.currency(
        symbol: '৳',
        decimalDigits: 0,
        locale: "en-in");
    String newText = formatter.format(value/1);
    return newValue.copyWith(
        text: newText,
        selection: new TextSelection.collapsed(offset: newText.length));
  }

}
