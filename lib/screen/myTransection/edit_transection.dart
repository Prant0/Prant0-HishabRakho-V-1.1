import 'dart:convert';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
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
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(
          "Edit Entries",
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
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
                  margin: EdgeInsets.symmetric(vertical: 10,horizontal: 12),
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
                            margin: EdgeInsets.symmetric(horizontal: 0,vertical: 10),
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),
                                border: Border.all(width: 1, color: Colors.grey)),
                            padding: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  "Date : ${formattedDate}",
                                  style: myStyle(16, Colors.white, FontWeight.w700),
                                ),
                                Icon(Icons.date_range_outlined,color: Colors.white,),
                              ],
                            )),
                      ),
                      /*SenderTextEdit(
                    keytype: TextInputType.number,
                    formatter:  <TextInputFormatter>[
                      FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                     // CurrencyInputFormatter(),
                    ],
                    keyy: "Balance",
                    data: _data,
                    name: amountController,
                    lebelText: "Balance",
                    hintText: " Initial balance ",
                    icon: Icons.money,
                    function: (String value) {
                      if (value.isEmpty) {
                        return "Amount required";
                      }
                    },
                  ),*/

                      Visibility(
                        visible: isPayable == true,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Padding(
                              padding: EdgeInsets.only(top: 25,),
                              child: Text("Payable to",style: myStyle(16,BrandColors.colorWhite,FontWeight.w600),),
                            ),
                            SenderTextEdit(
                              keyy: "Payable",
                              data: _data,
                              name: nameController,
                              lebelText: "${widget.model.friendName} ?? ",
                              //hintText: " Payable to",
                              icon: Icons.person,
                              function: (String value) {
                                if (value.isEmpty) {
                                  return "Name required";
                                }
                                if (value.length < 3) {
                                  return "Name Too Short ( Min 3 character )";
                                }if (value.length > 30) {
                                  return "Name Too long (Max 30 character)";
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
                              child: Text("Receivable drom",style: myStyle(16,BrandColors.colorWhite,FontWeight.w600),),
                            ),
                            SenderTextEdit(
                              keyy: "Receivable",
                              data: _data,
                              name: nameController,
                              lebelText: "${widget.model.friendName} ?? "" ",
                              // hintText: " Receivable from",
                              icon: Icons.person,
                              function: (String value) {
                                if (value.isEmpty) {
                                  return "Name required";
                                }
                                if (value.length < 3) {
                                  return "Name Too Short. ( Min 3 character )";
                                }if (value.length > 30) {
                                  return "Name Too long. ( Max 30 character )";
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: EdgeInsets.only(top: 25,),
                        child: Text("Details",style: myStyle(16,BrandColors.colorWhite,FontWeight.w600),),
                      ),
                      SenderTextEdit(
                        keyy: "Details",
                        maxNumber: 4,
                        data: _data,
                        name:detailsController ,
                        lebelText: widget.model.details ?? "",
                        hintText: " Details",
                        icon: Icons.details,
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
                                hintText: 'Amount required',
                                labelText: 'Amount ',
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
                          margin: EdgeInsets.only(left: 12),
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
                          print("tap");
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
                              ?amountController.text.toString().isEmpty?showInSnackBar("Amount Required"):updateEarning(note)
                              : widget.type == "Expenditure"
                              ?amountController.text.toString().isEmpty?showInSnackBar("Amount Required"):updateExpenditure(note)
                              : widget.type == "Payable"
                              ?amountController.text.toString().isEmpty?showInSnackBar("Amount Required"):updatePayable(payableNote)
                              : widget.type == "Receivable"
                              ? amountController.text.toString().isEmpty?showInSnackBar("Amount Required"):updateReceivable(payableNote)
                              : "";
                          setState(() {
                            amountController.clear();
                            detailsController.clear();
                          });
                          print("event id is : ${widget.model.eventId.toString()}");
                        },
                        child: Container(
                          margin: EdgeInsets.only(left: 12),
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
            body: json.encode(item.toJson()))
        .then((data) {
      try{
        if (data.statusCode == 201) {
          return {print("Earaning Data updated succesfully"),
            showInSnackBar("Updated successfully"),
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
            showInSnackBar("Updated failed");
          });
        throw Exception('Failed to update');
      }catch(e){
        print("Failedddd $e");
      }
    });
  }

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
          print("Expenditure Data updated succesfully"),
          Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction(),
          showInSnackBar("Updated successfully"),
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
          print("payable Data updated succesfully"),
          showInSnackBar("Updated successfully"),
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
        print("updated value ${data.body}");
          print("Receivable Data updated successfully");
        Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
          showInSnackBar("Updated successfully");

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
