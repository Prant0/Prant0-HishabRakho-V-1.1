import 'dart:convert';
import 'package:anthishabrakho/models/starting_payable_Model.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';

import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';


class EditStartingPayable extends StatefulWidget {
  final PayableDetail model;
      EditStartingPayable({this.model});
  @override
  _EditStartingPayableState createState() => _EditStartingPayableState();
}

class _EditStartingPayableState extends State<EditStartingPayable> {

  bool onProgress=false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController amountController = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  DateTime _currentDate = DateTime.now();
  TextStyle _ts = TextStyle(fontSize: 18.0);

  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(DateTime.now().year - 3),
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
  void initState() {
    nameController.text="${widget.model.friendName}";
    detailsController.text="${widget.model. details?? ""}";
    amountController.text=NumberFormat.currency(
        symbol: ' ৳ ',
        decimalDigits: 2,
        locale: "en-in")
        .format(widget.model.amount);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMMd().format(_currentDate);
    return Scaffold(
      resizeToAvoidBottomInset: true,
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(

        backgroundColor: BrandColors.colorPrimaryDark,
        elevation: 0.0,
        title: Text(
          "Edit Entries",
          style: TextStyle(),
        ),
        centerTitle: true,
      ),
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20,vertical: 10),
          child: Form(
            key: _formKey,
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
                          Icon(Icons.date_range_outlined,color: BrandColors.colorDimText,),
                        ],
                      )),
                ),


                SizedBox(height: 15,),
                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Text("Pay/Payable to ",style: myStyle(16,BrandColors.colorDimText),),
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

                Padding(
                  padding: EdgeInsets.symmetric(vertical: 0),
                  child: Text("Details ",style: myStyle(16,BrandColors.colorDimText),),
                ),
                SenderTextEdit(
                  keyy: "Details",
                  maxNumber: 4,
                  data: _data,
                  name:detailsController ,
                 // lebelText: widget.model.details ?? "",
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
                  height: 50,
                ),
                // ignore: deprecated_member_use




                Container(
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

                            final note = PayableDetail(

                              date: formattedDate.toString(),
                              amount: double.parse(amountController.text.toString()),
                              friendName: nameController.text.toString(),
                              details:detailsController.text.toString(),
                            );
                            updatePayable(note);


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
              ],
            ),
          ),
        ),
      ),
    );
  }
  static SharedPreferences sharedPreferences;
  updatePayable(PayableDetail item) async {
    setState(() {
      onProgress=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/user/personal/starting/payable/update/${widget.model.eventId}",
        headers: <String, String>{
          'Content-type': 'application/json',
          "Authorization": "bearer ${sharedPreferences.getString("token")}",
        },
        body: json.encode(item.toJsonn()))
        .then((data) {
      try{
        if (data.statusCode == 201) {
          return {print("Payable Data updated succesfully"),
            showInSnackBar("Updated successfully"),
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                onProgress=false;
                Navigator.of(context).pop();
              });
            }),
          };

        } else
          setState(() {
            onProgress=false;
            showInSnackBar("Updated failed");
          });
        throw Exception('Failed to update');
      }catch(e){
        print("Failedddd $e");
      }
    });
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

}
