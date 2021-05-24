
import 'dart:convert';
import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/chooseBank.dart';
import 'package:anthishabrakho/widget/chooseMfs.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:provider/provider.dart';
import 'package:flutter_svg/svg.dart';
import 'package:anthishabrakho/widget/custom_TextField.dart';

class EarningForm extends StatefulWidget {
  int id;
  String title;
  String name;

  EarningForm({this.id, this.title, this.name});

  @override
  _EarningFormState createState() => _EarningFormState();
}

class _EarningFormState extends State<EarningForm> {
  bool isStorage=false;
  String loanType;
  bool onProgress = false;
  Map<String, dynamic> _data = Map<String, dynamic>();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController amountController = TextEditingController();
  final TextEditingController receiveFrom = TextEditingController();
  final TextEditingController detailsController = TextEditingController();
  DateTime _currentDate = DateTime.now();
  TextStyle _ts = TextStyle(fontSize: 18.0);
  bool isCash = false;
  List mfsList;
  String cashId;

  String storageHubId;
  bool isGetMoneyNow = false;
  bool isGetMoneyLater = false;
  bool isBank = false;
  bool isMfs = false;
  bool others = true;
  bool x = false;
  bool y = false;
  bool transactionType =false;
  @override
  void initState() {
    check().then((intenet) {
      if (intenet != null && intenet) {
        if (mounted) {
          loanTypee();
        }
      } else
        showInSnackBar(getTranslated(context,'t93'),              //  "No Internet Connection"
        );
    });
    super.initState();
  }

  loanTypee() {
    if (widget.title == "Pay Back Loan You Took from Someone") {
      loanType = "Pay Back Loan";
      setState(() {
        others = false;
        x = true;
        isGetMoneyNow = true;
        transactionType=true;
      });
    } else if (widget.title == "Take Loan from Someone") {
      loanType = "Take Loan";
      setState(() {
        others = false;
        x = true;
        isGetMoneyNow = true;
        transactionType=true;
      });
    } else if (widget.title == "Give Loan to Someone") {
      loanType = "Give Loan";
      setState(() {
        others = false;
        x = true;
        isGetMoneyNow = true;
        transactionType=true;
      });
    } else if (widget.title == "Get Back Loan You Gave to Someone") {
      loanType = "Get Back Loan";
      setState(() {
        others = false;
        x = true;
        isGetMoneyNow = true;
        transactionType=true;
      });
    }

    print("loan type is  ${loanType}");
    print("Title type is  ${widget.title}");
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
  void dispose() {
    amountController.dispose();
    receiveFrom.dispose();
    detailsController.dispose();
    super.dispose();
  }

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

  String storageType;
  int id;
  String moneyType;

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future uploadEarningData(BuildContext context) async {
    try {
      setState(() {
        onProgress = true;
      });
      if (isGetMoneyNow == true) {
        if (isBank == true) {
          print("send to bank");
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/earning/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = moneyType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = storageHubId.toString();
          request.fields['create_receivable_to'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();
          print("processing bank");
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print("responseBody " + responseString);
          if (response.statusCode == 201) {
            Provider.of<StorageHubProvider>(context, listen: false).clearBank();
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   // "Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   // " Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
          }
        } else if (isMfs == true) {
          print("send to mfs");
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/earning/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = moneyType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = storageHubId.toString();
          request.fields['create_receivable_to'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          if (response.statusCode == 201) {
            Provider.of<StorageHubProvider>(context, listen: false).clearMfs();
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //  "Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        } else  {
          {
            setState(() {
              onProgress = true;
            });

            final uri = Uri.parse(
                "http://api.hishabrakho.com/api/user/personal/entry/earning/create");
            var request = http.MultipartRequest("POST", uri);
            request.headers
                .addAll(await CustomHttpRequests.getHeaderWithToken());
            request.fields['date'] = _currentDate.toString();
            request.fields['amount'] = amountController.text.toString();
            request.fields['event_type'] = moneyType.toString();
            request.fields['storage_hub_cat_id'] = id.toString();
            request.fields['user_personal_storage_hub_id'] = cashId;
            request.fields['create_receivable_to'] =
                receiveFrom.text.toString();
            request.fields['event_sub_category_id'] = widget.id.toString();
            request.fields['details'] = detailsController.text.toString();

            var response = await request.send();
            var responseData = await response.stream.toBytes();
            var responseString = String.fromCharCodes(responseData);

            if (response.statusCode == 201) {
              Provider.of<StorageHubProvider>(context, listen: false)
                  .clearCash();
              setState(() {
                onProgress = false;
                detailsController.clear();
                amountController.clear();
                receiveFrom.clear();
              });
              showInSnackBar(getTranslated(context,'t94')   // "Added successfully"
              );
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  Navigator.of(context).pop();
                });
              });
            } else {
              showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
              );
              print(" failed " + responseString);
              setState(() {
                onProgress = false;
              });
              //return false;
            }
          }
        }
      } else if (isGetMoneyLater) {

        final uri = Uri.parse(
            "http://api.hishabrakho.com/api/user/personal/entry/earning/create");
        var request = http.MultipartRequest("POST", uri);
        request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
        request.fields['date'] = _currentDate.toString();
        request.fields['amount'] = amountController.text.toString();
        request.fields['event_type'] = moneyType.toString();
        request.fields['create_receivable_to'] = receiveFrom.text.toString();
        request.fields['event_sub_category_id'] = widget.id.toString();
        request.fields['details'] = detailsController.text.toString();

        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);

        if (response.statusCode == 201) {
          print("responseBody1 " + responseString);
          setState(() {
            onProgress = false;
            detailsController.clear();
            amountController.clear();
            receiveFrom.clear();
          });
          showInSnackBar(getTranslated(context,'t94')   // "Added successfully"
          );
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Navigator.of(context).pop();
            });
          });
        } else {
          showInSnackBar(getTranslated(context,'t95')   // " Failed, Try again please"
          );
          print(" failed " + responseString);
          setState(() {
            onProgress = false;
          });
          //return false;
        }
      }
    } catch (e) {
      print("something went wrong $e");
    }
  }

  Future uploadExpenditureData(BuildContext context) async {
    try {
      if (isGetMoneyNow == true) {
        if (isBank == true) {
          setState(() {
            onProgress = true;
          });
          print("Bankkkkkkkkkkkkkkkkkkkkkkkk");
          final uri = Uri.parse("http://api.hishabrakho.com/api/user/personal/entry/expenditure/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = moneyType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = storageHubId.toString();
          request.fields['create_payable_to'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();
          print("processing expenditure bank");
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          if (response.statusCode == 201) {
            Provider.of<StorageHubProvider>(context, listen: false).clearBank();
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        } else if (isMfs == true) {
          setState(() {
            onProgress = true;
          });
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/expenditure/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = moneyType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = storageHubId.toString();
          request.fields['create_payable_to'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          if (response.statusCode == 201) {
            print("responseBody1 " + responseString);
            Provider.of<StorageHubProvider>(context, listen: false).clearMfs();
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        } else {
          setState(() {
            onProgress = true;
          });

          print("cashhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh");
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/expenditure/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = moneyType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = cashId.toString();
          request.fields['create_payable_to'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          if (response.statusCode == 201) {
            print("responseBody1 " + responseString);
            Provider.of<StorageHubProvider>(context, listen: false).clearCash();
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        }
      } else if (isGetMoneyLater) {
        setState(() {
          onProgress = true;
        });
        final uri = Uri.parse(
            "http://api.hishabrakho.com/api/user/personal/entry/expenditure/create");
        var request = http.MultipartRequest("POST", uri);
        request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
        request.fields['date'] = _currentDate.toString();
        request.fields['amount'] = amountController.text.toString();
        request.fields['event_type'] = moneyType.toString();
        request.fields['create_payable_to'] = receiveFrom.text.toString();
        request.fields['event_sub_category_id'] = widget.id.toString();
        request.fields['details'] = detailsController.text.toString();
        print("processing expenditure get money later");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        if (response.statusCode == 201) {
          setState(() {
            onProgress = false;
            detailsController.clear();
            amountController.clear();
            receiveFrom.clear();
          });
          showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
          );
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Navigator.of(context).pop();
            });
          });
        } else {
          showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
          );
          print(" failed " + responseString);
          setState(() {
            onProgress = false;
          });
          //return false;
        }
      }
    } catch (e) {
      print("something went wrong $e");
    }
  }

  Future uploadLoanData(BuildContext context) async {
    try {
      if (isGetMoneyNow == true) {
        if (isBank == true) {
          setState(() {
            onProgress = true;
          });
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/loan/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = loanType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = storageHubId.toString();
          request.fields['friend_name'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          if (response.statusCode == 201) {
            Provider.of<StorageHubProvider>(context, listen: false).clearBank();
            print("responseBody1 " + responseString);
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   // " Failed, Try again please"
            );

            setState(() {
              onProgress = false;
            });
            //return false;
          }
        } else if (isMfs == true) {
          setState(() {
            onProgress = true;
          });
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/loan/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = loanType.toString();
          request.fields['storage_hub_cat_id'] = id.toString();
          request.fields['user_personal_storage_hub_id'] = storageHubId.toString();
          request.fields['friend_name'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();

          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);

          if (response.statusCode == 201) {
            Provider.of<StorageHubProvider>(context, listen: false).clearMfs();
            print("responseBody1 " + responseString);
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        } else {
          setState(() {
            onProgress = true;
          });
          final uri = Uri.parse(
              "http://api.hishabrakho.com/api/user/personal/entry/loan/create");
          var request = http.MultipartRequest("POST", uri);
          request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
          request.fields['date'] = _currentDate.toString();
          request.fields['amount'] = amountController.text.toString();
          request.fields['event_type'] = loanType.toString();
          request.fields['user_personal_storage_hub_id'] = cashId.toString();
          request.fields['friend_name'] = receiveFrom.text.toString();
          request.fields['event_sub_category_id'] = widget.id.toString();
          request.fields['details'] = detailsController.text.toString();
          print("processing loan cash");
          var response = await request.send();
          var responseData = await response.stream.toBytes();
          var responseString = String.fromCharCodes(responseData);
          print("responseBody " + responseString);
          if (response.statusCode == 201) {
            Provider.of<StorageHubProvider>(context, listen: false).clearCash();
            print("responseBody1 " + responseString);
            setState(() {
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
            );
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
            );
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
            //return false;
          }
        }
      } else if (isGetMoneyLater) {
        setState(() {
          onProgress = true;
        });
        final uri = Uri.parse(
            "http://api.hishabrakho.com/api/user/personal/entry/loan/create");
        var request = http.MultipartRequest("POST", uri);
        request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
        request.fields['date'] = _currentDate.toString();
        request.fields['amount'] = amountController.text.toString();
        request.fields['event_type'] = loanType.toString();
        request.fields['friend_name'] = receiveFrom.text.toString();
        request.fields['event_sub_category_id'] = widget.id.toString();
        request.fields['details'] = detailsController.text.toString();
        print("processing  ggg");
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        print("responseBody " + responseString);
        if (response.statusCode == 201) {
          print("responseBody1 " + responseString);
          setState(() {
            onProgress = false;
            detailsController.clear();
            amountController.clear();
            receiveFrom.clear();
          });
          showInSnackBar(getTranslated(context,'t94')   //"Added successfully"
          );
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Navigator.of(context).pop();
            });
          });
        } else {
          showInSnackBar(getTranslated(context,'t95')   //" Failed, Try again please"
          );
          print(" failed " + responseString);
          setState(() {
            onProgress = false;
          });
          //return false;
        }
      }
    } catch (e) {
      print("something went wrong $e");
    }
  }

  Future uploadFundData(BuildContext context) async {}

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





  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat("d-MMMM-y").format(_currentDate);
    print("widget name is : ${widget.name}");
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      key: _scaffoldKey,
      body: SafeArea(
        child: ModalProgressHUD(
          inAsyncCall: onProgress,
          progressIndicator: Spin(),
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: 10, left: 20, right: 20),
              child: Form(
                  key: _formKey,
                  child: Stack(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            margin: EdgeInsets.symmetric(vertical: 22),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                FittedBox(
                                  child: Text(
                                    widget.title,
                                    style: myStyle(15, Colors.white, FontWeight.w700),overflow: TextOverflow.ellipsis,maxLines: 2,
                                  ),
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
                            visible: x!=true,
                            child: Padding(
                              padding: EdgeInsets.only(bottom: 14, top: 25),
                              child: Text(
                                getTranslated(context,'t96'),   // "Transaction Type",
                                style: myStyle(14, BrandColors.colorText),
                              ),
                            ),
                          ),
                          Visibility(
                            visible: x==false,
                            child: Container(
                              child: Row(
                                children: [
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                        //updateColor(1);
                                        moneyType = widget.name == "Expenditure"
                                            ? "Pay Now"
                                            : "Get Money Now";
                                        // x = true;
                                        y = false;
                                        transactionType =true;
                                        isGetMoneyNow = true;
                                        isGetMoneyLater = false;
                                      });
                                    },
                                    child: Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 18),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: isGetMoneyNow == true
                                              ?Colors.transparent
                                              : BrandColors.colorPrimary,
                                          border: Border.all(
                                              color: isGetMoneyNow == true
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: 1)),
                                      child: Text(
                                        widget.name == "Expenditure"
                                            ?getTranslated(context,'t97')   // "Pay Now"
                                            : getTranslated(context,'t98'),   //"Get Money Now",
                                        style: myStyle(12,isGetMoneyNow==true? Colors.white :BrandColors.colorText.withOpacity(0.7),FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      setState(() {
                                       // updateColor(2);
                                        x = false;
                                        y = false;
                                        transactionType =true;
                                        isGetMoneyNow = false;
                                        isGetMoneyLater = true;
                                        isStorage=true;
                                        moneyType = widget.name == "Expenditure"
                                            ? "Pay Later"
                                            : "Get Money Later";
                                      });
                                    },
                                    child: Container(
                                      margin: EdgeInsets.only(left: 15),
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 22, vertical: 18),
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: isGetMoneyLater == true
                                              ?Colors.transparent
                                              :  BrandColors.colorPrimary,
                                          border: Border.all(
                                              color: isGetMoneyLater == true
                                                  ? Colors.white
                                                  : Colors.transparent,
                                              width: 1)),
                                      child: Text(
                                        widget.name == "Expenditure"
                                            ?getTranslated(context,'t99')   // "Pay Later"
                                            :getTranslated(context,'t100'),   // "Get Money Later",
                                        style: myStyle(12,isGetMoneyLater == true? Colors.white :BrandColors.colorText.withOpacity(0.7),FontWeight.w500),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                          Visibility(
                            visible: isGetMoneyNow == true,
                            child: Column(

                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: EdgeInsets.only(bottom: 14,top: 25),
                                  child: Text(getTranslated(context,'t101')   //      "Choose Storage Hub"
                                    ,style: myStyle(14,BrandColors.colorText,),),
                                ),


                                Row(
                                  children: [
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          id = 7;
                                          isBank = false;
                                          isMfs = false;
                                          isCash = true;
                                          isStorage=true;
                                        });
                                        getCashDetails();
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 14),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            color:isCash ==true?Colors.transparent: BrandColors.colorPrimary,
                                            border: Border.all(color: isCash ==true?Colors.white:Colors.transparent)
                                        ),
                                        child: Row(
                                          children: [


                                            SvgPicture.asset("assets/cash.svg",
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.contain,
                                            ),

                                            SizedBox(width: 8,),
                                            Text(getTranslated(context,'t4')   //         "Cash"
                                              ,style: myStyle(12,BrandColors.colorText.withOpacity(0.7),FontWeight.w500),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          id = 5;
                                          isBank = true;
                                          isMfs = false;
                                          isCash = false;
                                          isStorage=false;

                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 14),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            color:isBank ==true?Colors.transparent: BrandColors.colorPrimary,
                                            border: Border.all(color:isBank ==true?Colors.white: Colors.transparent)
                                        ),
                                        child: Row(
                                          children: [


                                            SvgPicture.asset("assets/select bank.svg",
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.contain,height: 15,width: 20,
                                            ),

                                            SizedBox(width: 8,),
                                            Text(getTranslated(context,'t5')   //       "Bank"
                                              ,style: myStyle(12,BrandColors.colorText.withOpacity(0.7),FontWeight.w500),),
                                          ],
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: (){
                                        setState(() {
                                          id = 6;
                                          isBank = false;
                                          isMfs = true;
                                          isCash = false;
                                          isStorage=false;
                                        });
                                      },
                                      child: Container(
                                        margin: EdgeInsets.only(right: 10),
                                        padding: EdgeInsets.symmetric(horizontal: 14,vertical: 14),
                                        decoration: BoxDecoration(
                                            borderRadius: BorderRadius.circular(8.0),
                                            color:isMfs ==true?Colors.transparent: BrandColors.colorPrimary,
                                            border: Border.all(color:isMfs ==true?Colors.white: Colors.transparent)
                                        ),
                                        child: Row(
                                          children: [
                                            SvgPicture.asset("assets/select MFS.svg",
                                              alignment: Alignment.bottomCenter,
                                              fit: BoxFit.contain,height: 15,width: 20,
                                            ),

                                            SizedBox(width: 8,),
                                            Text(getTranslated(context,'t6')   //    "Mfs"
                                              ,style: myStyle(12,BrandColors.colorText.withOpacity(0.7),FontWeight.w500),),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),



                              ],
                            ),
                          ),
                          SizedBox(height: 10,),
                          Visibility(
                              visible:isGetMoneyNow && isBank==true,
                              child: GestureDetector(
                                onTap: () async {
                                  List bal= await Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseBank(
                                    types: "single",
                                  )));
                                  setState(() {
                                    storageHubId=bal[0];
                                    bankName=bal[1];
                                    print("the bal is ${bal[0]}");
                                    print("the bal is ${bal[1]}");
                                    isStorage=true;
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.symmetric(vertical: 15,),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: BrandColors.colorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(bankName?? getTranslated(context,'t102')   //"Choose Bank"
                                        ,style: myStyle(14,BrandColors.colorText),),
                                      Icon(Icons.mobile_screen_share_rounded,color: BrandColors.colorText,),
                                    ],
                                  ),
                                ),
                              )
                          ),
                          Visibility(
                              visible:isGetMoneyNow && isMfs==true,
                              child:GestureDetector(
                                onTap: () async {
                                  List bal = await Navigator.push(context, MaterialPageRoute(builder: (context)=>ChooseMfs(
                                    types: "single",
                                  )));
                                  setState(() {
                                    storageHubId=bal[0];
                                    mfsName=bal[1];
                                    isStorage=true;
                                    print("the Mfs is ${storageHubId}");
                                  });
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(horizontal: 15),
                                  margin: EdgeInsets.symmetric(vertical: 15,),
                                  height: 60,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10.0),
                                    color: BrandColors.colorPrimary,
                                  ),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(mfsName??getTranslated(context,'t103')   //  "Choose Mfs"
                                        ,style: myStyle(14,BrandColors.colorText),),
                                      Icon(Icons.mobile_screen_share_rounded,color: BrandColors.colorText,),
                                    ],
                                  ),
                                ),
                              )

                          ),

                          Padding(
                            padding: EdgeInsets.only(top: 15,bottom: 10),
                            child: Text(
                              widget.name == "Earning"
                                  ?getTranslated(context,'t104')   //   "Receive/Receivable from"
                                  : widget.name == "Expenditure"
                                  ?getTranslated(context,'t83')   //   "Pay/Payable to"
                                  : widget.name == "Loan"
                                  ? loanType == "Take Loan"
                                  ?getTranslated(context,'t105')   //   "Name "
                                  : loanType == "Give Loan"
                                  ?getTranslated(context,'t105')   // "Name"
                                  :getTranslated(context,'t105')   // "Name"
                                  :getTranslated(context,'t106')   // "Pay Back Loan To"
                              ,style: myStyle(14,Color(0xFFD2DCF7)),
                            ),
                          ),

                          SenderTextEdit(
                            keyy: "receive",
                            data: _data,
                            name: receiveFrom,
                            lebelText:getTranslated(context,'t107') ,  // "Type name here....",
                            // icon: Icon(Icons.airline_seat_flat,color: Colors.red,size: 1,),
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
                                return getTranslated(context,'t84');   // "Name required";
                              }
                              if (value.length < 3) {
                                return getTranslated(context,'t85');   //       "Name Too Short. ( Min 3 character )";
                              }
                              if (value.length > 30) {
                                return getTranslated(context,'t86');   // "Name Too Long. ( Max 30 character )";
                              }
                            },
                          ),



                          Padding(
                            padding: EdgeInsets.only(top: 20,bottom: 4),
                            child: Text(getTranslated(context,'t59')   //   "Add details (optional)"
                              ,style: myStyle(14,BrandColors.colorText),
                            ),
                          ),


                          Container(
                            padding: EdgeInsets.symmetric( vertical: 15),
                            child: TextFormField(
                              maxLines: 4,
                              controller: detailsController,
                              style: TextStyle(fontSize: 16.0, color: BrandColors.colorDimText),
                              decoration: InputDecoration(hoverColor: Colors.black,
                                filled: true,
                                contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
                                fillColor: BrandColors.colorPrimary,
                                focusedBorder:OutlineInputBorder(
                                  borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                                  borderRadius: BorderRadius.circular(12.0),
                                ),

                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,
                                    width: 2.0,
                                  ),
                                ),
                                hintStyle: myStyle(14, BrandColors.colorDimText),
                                hintText: " Write here",
                              ),
                            ),
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
                                    labelText:getTranslated(context,'t89'),   // ' Amount* ',
                                    labelStyle: myStyle(16, BrandColors.colorText, FontWeight.w600),
                                    inputStyle: _ts.copyWith(color: Colors.white),
                                    formattedStyle:
                                    _ts.copyWith(fontSize: 18, color: Colors.white)),
                              ),
                            ),
                          ),


                          SizedBox(
                            height: 100,
                          ),
                        ],
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
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      border: Border.all(
                                          color:BrandColors.colorPurple, width: 1.0),
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
                                            getTranslated(context,'t75') ,  // "Go Back",
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

                                    print("storage hub type issssssssssssssssssss $storageType");
                                    if (!_formKey.currentState.validate()) return;
                                    _formKey.currentState.save();
                                    print("widget name ${widget.name}");
                                    transactionType ==false? showInSnackBar(getTranslated(context,'t108')):  isStorage==false? showInSnackBar(getTranslated(context,'t109')): amountController.text.toString().isEmpty ? showInSnackBar(getTranslated(context,'t78')) :   widget.name == "Earning"
                                        ?  uploadEarningData(context)
                                        : widget.name == "Expenditure"
                                        ?
                                    uploadExpenditureData(context)
                                        : widget.name == "Loan"
                                        ?  uploadLoanData(context)
                                        : uploadFundData(context);
                                  },
                                  child: Container(
                                    padding: EdgeInsets.symmetric(vertical: 20),
                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color:BrandColors.colorPurple,
                                      border: Border.all(
                                          color: BrandColors.colorPurple,
                                          width: 1.0),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                        getTranslated(context,'t76'),   // "Proceed",
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
                  )),
            ),
          ),
        ),
      ),
    );
  }




  Future<dynamic> getCashDetails() async {
    await CustomHttpRequests.cashDetails().then((responce) {
      var dataa = json.decode(responce.body);
      setState(() {
        cashId = dataa[0]["id"].toString();
        print("cash data${dataa}");
        print("cash id ${cashId}");
      });
    });
  }


  String bankName;
  String mfsName;

}
