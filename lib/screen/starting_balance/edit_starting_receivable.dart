import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/Starting_receivable_model.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:anthishabrakho/widget/custom_TextField.dart';
class EditStartingReceivable extends StatefulWidget {
  final ReceivableDetail model;
  EditStartingReceivable({this.model});
  @override
  _EditStartingReceivableState createState() => _EditStartingReceivableState();
}

class _EditStartingReceivableState extends State<EditStartingReceivable> {
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
      backgroundColor: BrandColors.colorPrimaryDark,
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
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
        progressIndicator: Spin(),
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
            key: _formKey,
            child: Card(
              color:  BrandColors.colorPrimaryDark,
              elevation: 0,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
              margin: EdgeInsets.symmetric(vertical: 10,),
              child: Column(
                children: [

                  Expanded(
                    flex: 9,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                                      width: 0.7, color: BrandColors.colorPurple.withOpacity(0.8))),
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
                        Padding(
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text("Pay/Payable to ",style: myStyle(16,BrandColors.colorDimText),),
                        ),
                        SenderTextEdit(
                          keyy: "Payable",
                          data: _data,
                          name: nameController,
                          lebelText: "${widget.model.friendName} ?? ",
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
                          padding: EdgeInsets.symmetric(vertical: 15),
                          child: Text("Details ",style: myStyle(16,BrandColors.colorDimText),),
                        ),
                        SenderTextEdit(
                          keyy: "Details",
                          maxNumber: 4,
                          data: _data,
                          name:detailsController ,
                          // lebelText: widget.model.details ?? "",

                          // icon: Icons.details,
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
                                  labelStyle: myStyle(16,Colors.white,FontWeight.w600),
                                  inputStyle: _ts.copyWith(color: Colors.white),
                                  formattedStyle:
                                  _ts.copyWith(color: Colors.white)),

                            ),
                          ),
                        ),
                      ],
                    )
                  ),


                Expanded(
                  flex: 1,
                  child: Container(
                    alignment: Alignment.bottomCenter,
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

                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                border: Border.all(
                                    color: BrandColors.colorPurple, width: 1.0),
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
                            onTap:() {
                              if (!_formKey.currentState.validate()) return;
                              _formKey.currentState.save();

                              final note = ReceivableDetail(

                                date: formattedDate.toString(),
                                amount: double.parse(amountController.text.toString()),
                                friendName: nameController.text.toString(),
                                details:detailsController.text.toString(),
                              );
                              updateReceivable(note);
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: BrandColors.colorPurple,
                                border: Border.all(
                                    color: BrandColors.colorPurple,
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
              ),
            ),
          ),
        ),
      ),
    );
  }
  static SharedPreferences sharedPreferences;
  updateReceivable(ReceivableDetail item) async {
    setState(() {
      onProgress=true;
    });
    sharedPreferences = await SharedPreferences.getInstance();
    return http
        .put("http://api.hishabrakho.com/api/user/personal/starting/receivable/update/${widget.model.eventId}",
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
      backgroundColor: Colors.indigo,
    ),);
  }
}
