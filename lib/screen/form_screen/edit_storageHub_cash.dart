import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:anthishabrakho/screen/stapper/add_Payable.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';

class UpdateStorageHubCash extends StatefulWidget {
  final MyTransectionModel model;

  String type;

  UpdateStorageHubCash({
    this.model,
    this.type,
  });

  @override
  _UpdateStorageHubCashState createState() => _UpdateStorageHubCashState();
}

class _UpdateStorageHubCashState extends State<UpdateStorageHubCash> {
  TextEditingController amountController = TextEditingController();

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  DateTime _currentDate = DateTime.now();
  TextStyle _ts = TextStyle(fontSize: 16.0);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      progressIndicator: Spin(),
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: BrandColors.colorPrimaryDark,
          title: Text(
            widget.type == "cash" ? "Edit Storage Hub" : "Add Initial Balance",
            style: TextStyle(fontSize: 18),
          ),
        ),
        body: Container(
          height: double.infinity,
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(
                              horizontal: 0, vertical: 30),
                          child: MoneyTextFormField(
                            settings: MoneyTextFormFieldSettings(
                              controller: amountController,
                              moneyFormatSettings: MoneyFormatSettings(
                                /*amount: widget.type == "cash"
                                        ? double.tryParse(
                                            widget.model.balance.toString())
                                        : 0,*/
                                // amount: null,
                                  currencySymbol: ' ৳ ',
                                  displayFormat:
                                  MoneyDisplayFormat.symbolOnLeft),
                              appearanceSettings: AppearanceSettings(
                                padding: EdgeInsets.all(15.0),
                                labelText: 'Initial Balance* ',
                                hintText: ' Balance',
                                labelStyle: myStyle(
                                    20, Colors.white, FontWeight.w600),
                                inputStyle: _ts.copyWith(color: Colors.white),
                                formattedStyle:
                                _ts.copyWith(color: Colors.white),
                              ),
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
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
                              onTap: () {
                                widget.type == "cash"?  Navigator.pop(context) : Navigator.pushReplacement(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => AddPayableStepper(
                                        )));
                              },
                              child: Container(
                                  alignment: Alignment.center,
                                  padding: EdgeInsets.symmetric(vertical: 20),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    border: Border.all(
                                        color: Colors.deepPurpleAccent,
                                        width: 1.0),
                                  ),
                                  child: Text(
                                    widget.type == "cash"
                                        ? "Go Back"
                                        : "Skip",
                                    style: myStyle(16, Colors.white),
                                  )),
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
                                amountController.text.toString().isEmpty
                                    ? showInSnackBar("Amount Required")
                                    : updateCash(context);
                              },
                              child: Container(
                                alignment: Alignment.center,
                                padding: EdgeInsets.symmetric(vertical: 20),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: BrandColors.colorPurple,
                                  border: Border.all(
                                      color: BrandColors.colorPurple,
                                      width: 1.0),
                                ),
                                child: Text(
                                  "Proceed",
                                  style: myStyle(16, Colors.white),
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  void textFormatter(String x) {
    amountController.clear();
    if (x.length == 4) {
      x = x.substring(0, 1) + "," + x.substring(1, x.length);
    }
    if (x.length == 5) {
      x = x.substring(0, 2) + "," + x.substring(2, x.length);
    }

    if (x.length == 6) {
      x = x.substring(0, 3) + "," + x.substring(3, x.length);
    }
    if (x.length == 7) {
      x = x.substring(0, 2) + "," + x.substring(2, x.length);
      x = x.substring(0, 5) + "," + x.substring(5, x.length);
    }
    if (x.length == 8) {
      x = x.substring(0, 1) + "," + x.substring(1, x.length);
      x = x.substring(0, 4) + "," + x.substring(4, x.length);
      x = x.substring(0, 7) + "," + x.substring(7, x.length);
    }
    if (x.length == 9) {
      x = x.substring(0, 3) + "," + x.substring(3, x.length);

      x = x.substring(0, 7) + "," + x.substring(7, x.length);
    }
    amountController.text = x;

    print(x);
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      duration: Duration(milliseconds: 1000),
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white70,
        ),
      ),
      backgroundColor: Colors.indigo,
    ));
  }

  Future updateCash(BuildContext context) async {
    try {
      setState(() {
        isLoading = true;
      });
      final uri = Uri.parse(
          "http://api.hishabrakho.com/api/user/personal/storage/hub/update/${widget.model.id}");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['storage_hub_category_id'] = widget.model.storageHubCategoryId.toString() ?? 7;
      request.fields['balance'] = amountController.text.toString();
      request.fields['date'] = _currentDate.toString();
      print("processing");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);

        showInSnackBar("updated Storage successful");
        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            isLoading = false;
            widget.type == "cash"
                ? Navigator.of(context).pop(HomePage.id)
                : Navigator.pushReplacement(
                    context,
                    MaterialPageRoute(
                        builder: (context) => AddPayableStepper()));
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
  void dispose() {
    amountController.dispose();
    super.dispose();
  }
}
