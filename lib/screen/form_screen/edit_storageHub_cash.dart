import 'package:anthishabrakho/widget/extra%20widget.dart';
import 'package:flutter/services.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:provider/provider.dart';
class UpdateStorageHubCash extends StatefulWidget {
  final MyTransectionModel model;
  String type;
  UpdateStorageHubCash({this.model, this.type,});
  @override
  _UpdateStorageHubCashState createState() => _UpdateStorageHubCashState();
}

class _UpdateStorageHubCashState extends State<UpdateStorageHubCash> {

  TextEditingController amountController =  TextEditingController();

  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  DateTime _currentDate = DateTime.now();
  TextStyle _ts = TextStyle(fontSize: 16.0);
  var noSimbolInUSFormat = new NumberFormat.currency(locale: "en_US",symbol: "");
  bool isLoading=false;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: Text(
          "Edit Storage Hub",
          style: TextStyle(fontSize: 18),
        ),
        centerTitle: true,
      ),

      body: ModalProgressHUD(
        inAsyncCall: isLoading,
        child: Container(
          child: Form(
            key:_formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    height: 50.0,
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: MoneyTextFormField(
                      settings: MoneyTextFormFieldSettings(
                        controller: amountController,
                        moneyFormatSettings: MoneyFormatSettings(
                           amount: double.tryParse(widget.model.balance.toString()),
                           // amount: null,
                            currencySymbol: ' ৳ ',
                            displayFormat: MoneyDisplayFormat.symbolOnLeft),
                            appearanceSettings: AppearanceSettings(
                            padding: EdgeInsets.all(15.0),
                            labelText: 'Initial Balance* ',
                            hintText: ' Balance',
                            labelStyle: myStyle(20,Colors.purple,FontWeight.w600),
                            inputStyle: _ts.copyWith(color: Colors.purple),
                            formattedStyle:
                               _ts.copyWith(color: Colors.black54),
                        ),
                      ),
                    ),
                  ),
/*
                  SenderTextEdit(
                    keytype:  TextInputType.numberWithOptions(decimal: true),
                    // ignore: deprecated_member_use
                    onChangeFunction: (text){
                      text=double.parse(valuee);
                    },
                    formatter:[
                     // WhitelistingTextInputFormatter(RegExp(r"^\d?\.?\d{0,8}")),
                      //BlacklistingTextInputFormatter(RegExp("[a-zA-Z,]")),

                     // BlacklistingTextInputFormatter(RegExp("[/\\]"))
                    ],
                    keyy: "Balance",
                    data: _data,
                    name: amountController,
                    lebelText: "Balance",
                    hintText: "Current Balance",

                    icon: Icons.money,
                    function: (String value) {
                      if(value is int || value is double){
                        return "invalide amount";
                      }
                      if (value.isEmpty) {
                        return "Balance required";
                      }
                      if (value.length > 12) {
                        return "Amount is Too Long";
                      }
                      setState(() {
                        valuee=double.parse(amountController.text.toString());
                      });
                    },
                  ),*/


                /*TextField(
                 // controller: amountController,
                  onChanged:(value){
                    setState(() {
                      String amount=oCcy.format(value);

                      amountController.text=amount;
                      print("amount s xxxxxxxx  ${amountController.text}");
                    });

                  } ,

                ),*/

                 /* TextField(
                    keyboardType: TextInputType.numberWithOptions(decimal: true),
                    controller: amountController,
                    onChanged: (text) {

                      setState(() {

                        textFormatter(text);

                      }); // you need this
                    },
                  ),*/

                //  Text("$valuee"),

                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();

                     // double.parse(amountController.text.toString())<1? showInSnackBar("Amount is required") :
                      amountController.text.toString().isEmpty?showInSnackBar("Amount Required"):updateCash(context);
                    },
                    color: Colors.purple,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.0)),
                    padding: EdgeInsets.symmetric(
                      horizontal: 100,
                    ),
                    child: Text(
                      "Submit",
                      style: myStyle(18, Colors.white),
                    ),
                  ),
                  SizedBox(
                    height: 20,
                  ),
                ],
              ),
            ),
          ),
        ),
      ),



    );
  }


  void textFormatter (String x){
    amountController.clear();
    if(x.length==4){
      x = x.substring(0, 1) + "," + x.substring(1, x.length);
    }
    if(x.length==5){
      x = x.substring(0, 2) + "," + x.substring(2, x.length);
    }


    if(x.length==6){
      x = x.substring(0, 3) + "," + x.substring(3, x.length);
    }
    if(x.length==7){
      x = x.substring(0, 2) + "," + x.substring(2, x.length);
      x = x.substring(0, 5) + "," + x.substring(5, x.length);
    }
    if(x.length==8){
      x = x.substring(0, 1) + "," + x.substring(1, x.length);
      x = x.substring(0, 4) + "," + x.substring(4, x.length);
      x = x.substring(0, 7) + "," + x.substring(7, x.length);
    }
    if(x.length==9){
      x = x.substring(0, 3) + "," + x.substring(3, x.length);

      x = x.substring(0, 7) + "," + x.substring(7, x.length);
    }
    amountController.text=x;

    print(x);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  Future updateCash(BuildContext context) async {
    try {
      setState(() {
        isLoading=true;
      });
      final uri = Uri.parse("http://api.hishabrakho.com/api/user/personal/storage/hub/update/${widget.model.id}");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['storage_hub_category_id'] = widget.model.storageHubCategoryId.toString();
      request.fields['balance'] = amountController.text.toString();
      request.fields['date'] = _currentDate.toString();
      print("processing");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        print("doneeeeeeee");
        showInSnackBar("updated Storage successful");
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading=false;
            Navigator.of(context).pop(HomePage.id);
          });
        });
        Provider.of<StorageHubProvider>(context, listen: false)
            .editCashData(
          widget.model.id,double.parse(amountController.text),
        );

      } else {

        showInSnackBar("update Failed, Try again please");
        print("update failed " + responseString);

      }
    } catch (e) {
      print("something went wrong $e");
    }
  }
  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

}
