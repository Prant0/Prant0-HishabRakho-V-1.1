import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';
class EditStorageHub extends StatefulWidget {
  final MyTransectionModel model;
  String type;
  EditStorageHub({this.model, this.type,});
  @override
  _EditStorageHubState createState() => _EditStorageHubState();
}
class _EditStorageHubState extends State<EditStorageHub> {
  TextEditingController amountController = TextEditingController();
  TextEditingController accountname = TextEditingController();
  TextEditingController accountnumber = TextEditingController();
  TextEditingController detailsController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  DateTime _currentDate = DateTime.now();

  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime(DateTime.now().year),
        firstDate: DateTime(DateTime.now().year - 15),
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

  bool isBank = false;
  bool isCash = false;
  bool isMfs = false;
  List mfsList;
  String cashId;
  List bankList;

  bool isLoading = false;

  updateList() {
    if (widget.type == "bank") {
      setState(() {
        isBank = true;
        isMfs = false;
      });
    } else if (widget.type == "mfs") {

      isMfs = true;
      isBank = false;
    }
  }
  initialValue(val) {
    return TextEditingController(text: widget.model.userStorageHubAccountName);
  }
  TextStyle _ts = TextStyle(fontSize: 18.0);


  @override
  void dispose() {
    amountController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {

    print("Update type isssss :${widget.type} ");
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

                  /*SenderTextEdit(
                    formatter: <TextInputFormatter>[

                    ],
                    keytype: TextInputType.numberWithOptions(
                      decimal: true,
                      signed: false,
                    ),
                    keyy: "Balance",
                    data: _data,
                    name: amountController,
                    hintText: "৳ ${widget.model.totalBalance}",
                    lebelText: " Initial balance ",
                    icon: Icons.money,
                    function: (String value) {
                      if (value.isEmpty) {
                        return "Amount required";
                      }
                      if (value.length > 17) {
                        return "Amount is Too Long.(Max 10 digits)";
                      }
                    },
                  ),*/
                  Visibility(
                    visible: isBank == true,
                    child: SenderTextEdit(
                      keyy: "name",
                      data: _data,
                      name:nameController,
                      //initialText: widget.model.userStorageHubAccountName,
                      hintText: "Account Name",
                      lebelText:  "Account Name" ,
                      icon: Icons.drive_file_rename_outline,
                      function: (String value) {
                        if (value.isEmpty) {
                          return "Account Name required";
                        }
                        if (value.length < 3) {
                          return "Account Name is Too Short. ( Min 3 character )";
                        }
                        if (value.length > 30) {
                          return "Account Name is Too Long. ( Max 30 character )";
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: isBank == true || isMfs == true,
                    child: SenderTextEdit(
                      keytype: TextInputType.number,
                      formatter:  <TextInputFormatter>[
                        FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                      ],
                      keyy: "number",
                      data: _data,
                      name:  accountnumber,
                      lebelText: "Account Number",
                      hintText: "Account Number",
                      icon: Icons.confirmation_number_outlined,
                      function: (String value) {
                        if (value.isEmpty) {
                          return "Account Number required";
                        }
                        if (value.length < 11) {
                          return "Account Number is Too Short( Min 11 digit )";
                        }
                        if (value.length > 18) {
                          return "Account Number is Too Long ( Max 18 digit )";
                        }
                      },
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 12),
                    child: MoneyTextFormField(
                      settings: MoneyTextFormFieldSettings(

                        controller: amountController,
                        moneyFormatSettings: MoneyFormatSettings(
                            amount: double.tryParse(widget.model.totalBalance.toString()),
                            currencySymbol: ' ৳ ',
                            displayFormat: MoneyDisplayFormat.symbolOnLeft),
                        appearanceSettings: AppearanceSettings(
                            padding: EdgeInsets.all(15.0),
                            labelText: 'Initial balance ',
                            hintText: ' Initial balance',
                            labelStyle: myStyle(20,Colors.purple,FontWeight.w600),
                            inputStyle: _ts.copyWith(color: Colors.purple),
                            formattedStyle:
                            _ts.copyWith(color: Colors.black54)),

                      ),
                    ),
                  ),
                  SizedBox(
                    height: 10,
                  ),
                  RaisedButton(
                    onPressed: () {
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      widget.type == "bank"
                          ?amountController.text.toString().isEmpty?showInSnackBar("Amount Required"): updateBankData(context)
                          : widget.type == "mfs"
                          ?amountController.text.toString().isEmpty?showInSnackBar("Amount Required"): updateMfs(context):"";
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
  Future updateBankData(BuildContext context) async {
    try {
      setState(() {
        isLoading=true;
      });
      final uri = Uri.parse("http://api.hishabrakho.com/api/user/personal/storage/hub/update/${widget.model.id}");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['storage_hub_category_id'] = widget.model.storageHubCategoryId.toString();
      request.fields['user_storage_hub_account_number_bank'] = accountnumber.text.toString();
      request.fields['storage_hub_id'] = widget.model.storageHubId.toString();
      request.fields['user_storage_hub_account_name'] = nameController.text.toString();
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
        Future.delayed(const Duration(seconds: 1), () {
          setState(() {
            isLoading=false;
            Navigator.of(context).pop(HomePage.id);
          });
        });
      } else {
        showInSnackBar("update Failed, Try again please");
        print("update failed " + responseString);
      }
    } catch (e) {
      print("something went wrong $e");
    }
  }

  Future updateMfs(BuildContext context) async {
    try {
      setState(() {
        isLoading=true;
      });
      final uri = Uri.parse("http://api.hishabrakho.com/api/user/personal/storage/hub/update/${widget.model.id}");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['storage_hub_category_id'] = widget.model.storageHubCategoryId.toString();
      request.fields['user_storage_hub_account_number_mfs'] = accountnumber.text.toString();
      request.fields['storage_hub_id'] = widget.model.storageHubId.toString();
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

      } else {

        showInSnackBar("update Failed, Try again please");
        print("update failed " + responseString);

      }
    } catch (e) {
      print("something went wrong $e");
    }
  }
  @override
  void initState() {
    getBankDetails();
    getMfsDetails();
    updateList();
    nameController.text="${widget.model.userStorageHubAccountName}";
    accountnumber.text="${widget.model.userStorageHubAccountNumber}";
    amountController.text="৳ ${widget.model.totalBalance}";
    super.initState();
  }
  Future<dynamic> getBankDetails() async {
    await CustomHttpRequests.allBankDetails().then((responce) {
      var dataa = json.decode(responce.body);
      if(mounted){
        setState(() {
          bankList = dataa;
          print("all bank are : ${bankList}");
        });
      }
    });
  }

  Future<dynamic> getMfsDetails() async {
    await CustomHttpRequests.allMfsDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        mfsList = dataa;
        print("all Mfs are : ${mfsList}");
      });
    });
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

}

