import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
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

const activeColor = Colors.transparent;
const inactiveColor = BrandColors.colorPrimary;
const activeColorr = Colors.transparent;
const inactiveColorr = BrandColors.colorPrimary;

const activeBorderColor = Colors.white;
const inactiveBorderColor = Colors.transparent;
const activeBorderColorr = Colors.white;
const inactiveBorderColorr = Colors.transparent;

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
        showInSnackBar("No Internet Connection");
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
      if (isGetMoneyNow == true) {
        if (isBank == true) {
          print("send to bank");
          setState(() {
            onProgress = true;
          });
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
              //Provider.of<StorageHubProvider>(context,listen: false).addMfsData();
              onProgress = false;
              detailsController.clear();
              amountController.clear();
              receiveFrom.clear();
            });
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(" Failed, Try again please");
            print(" failed " + responseString);
            setState(() {
              onProgress = false;
            });
          }
        } else if (isMfs == true) {
          print("send to mfs");
          setState(() {
            onProgress = true;
          });
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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
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
              showInSnackBar("Added successfully");
              Future.delayed(const Duration(seconds: 1), () {
                setState(() {
                  Navigator.of(context).pop();
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
          }
        }
      } else if (isGetMoneyLater) {
        setState(() {
          onProgress = true;
        });
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
          showInSnackBar("Added successfully");
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Navigator.of(context).pop();
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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
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
        } else {
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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
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
          showInSnackBar("Added successfully");
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Navigator.of(context).pop();
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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
              });
            });
          } else {
            showInSnackBar(" Failed, Try again please");

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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
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
            showInSnackBar("Added successfully");
            Future.delayed(const Duration(seconds: 1), () {
              setState(() {
                Navigator.of(context).pop();
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
          showInSnackBar("Added successfully");
          Future.delayed(const Duration(seconds: 1), () {
            setState(() {
              Navigator.of(context).pop();
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

  Color getNowColor = activeColor;
  Color getNowBorderColor = activeBorderColor;
  Color getlaterColor = inactiveColor;
  Color getlaterBorderColor = inactiveBorderColor;

  Color cashColor = activeColor;
  Color bankColor = inactiveColor;
  Color mfsColor = inactiveColor;

  void updateColor(int types) {
    if (types == 2) {
      if (getlaterColor == inactiveColor) {
        getlaterColor = activeColor;
        getlaterBorderColor = activeBorderColor;
        getNowBorderColor = inactiveBorderColor;
        getNowColor = inactiveColor;
      } else {
        getlaterColor = inactiveColor;
      }
    }
    if (types == 1) {
      if (getNowColor == inactiveColor) {
        getNowColor = activeColor;
        getNowBorderColor = activeBorderColor;
        getlaterBorderColor = inactiveBorderColor;
        getlaterColor = inactiveColor;
      } else {
        getNowColor = inactiveColor;
      }
    }
  }

  Widget _showChoiceChip(String name, int id, Function function, Color clr) {
    return ChoiceChip(
        selectedColor: clr,
        //selectedShadowColor: Colors.green,
        backgroundColor: BrandColors.colorPrimary,
        shape:
        RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
        label: Text(
          name,
          style: TextStyle(color: Colors.white),
        ),
        selected: _value == id,
        onSelected: function);
  }

  int _value;

  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat("d-MMMM-y").format(_currentDate);
    print("widget name is : ${widget.name}");
    return SafeArea(
      child: Scaffold(

        backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
        body: ModalProgressHUD(
          inAsyncCall: onProgress,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.only(top: 15, left: 20, right: 20,bottom: 8),
            child: Form(
                key: _formKey,
                child: Column(
                  children: [
                    Expanded(
                      flex: 9,
                      child: SingleChildScrollView(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              margin: EdgeInsets.symmetric(vertical: 22),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Flexible(
                                    child: Text(
                                      widget.title,
                                      style:
                                      myStyle(20, Colors.white, FontWeight.w500),overflow: TextOverflow.ellipsis,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: (){
                                      Navigator.pop(context);
                                    },
                                    child: Icon(
                                      Icons.close,
                                      color: Colors.white,
                                      size: 25,
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
                            Visibility(
                              visible: x!=true,
                              child: Padding(
                                padding: EdgeInsets.only(bottom: 14, top: 25),
                                child: Text(
                                  "Transaction Type",
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
                                          updateColor(1);
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
                                              ? "Pay Now"
                                              : "Get Money Now",
                                          style: myStyle(12,isGetMoneyNow==true? Colors.white :Colors.grey,FontWeight.w500),
                                        ),
                                      ),
                                    ),
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          updateColor(2);
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
                                              ? "Pay Later"
                                              : "Get Money Later",
                                          style: myStyle(12,isGetMoneyLater == true? Colors.white :Colors.grey,FontWeight.w500),
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
                                    child: Text("Choose Storage Hub",style: myStyle(14,BrandColors.colorText,),),
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
                                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
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
                                              Text("Cash",style: myStyle(12,BrandColors.colorText,FontWeight.w500),),
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
                                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color:isBank ==true?Colors.transparent: BrandColors.colorPrimary,
                                              border: Border.all(color:isBank ==true?Colors.white: Colors.transparent)
                                          ),
                                          child: Row(
                                            children: [


                                              SvgPicture.asset("assets/select bank.svg",
                                                alignment: Alignment.bottomCenter,
                                                fit: BoxFit.contain,
                                              ),

                                              SizedBox(width: 8,),
                                              Text("Bank",style: myStyle(12,BrandColors.colorText,FontWeight.w500),),
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
                                          padding: EdgeInsets.symmetric(horizontal: 18,vertical: 18),
                                          decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(8.0),
                                              color:isMfs ==true?Colors.transparent: BrandColors.colorPrimary,
                                              border: Border.all(color:isMfs ==true?Colors.white: Colors.transparent)
                                          ),
                                          child: Row(
                                            children: [
                                              SvgPicture.asset("assets/select MFS.svg",
                                                alignment: Alignment.bottomCenter,
                                                fit: BoxFit.contain,
                                              ),

                                              SizedBox(width: 8,),
                                              Text("Mfs",style: myStyle(12,BrandColors.colorText,FontWeight.w500),),
                                            ],
                                          ),
                                        ),
                                      )
                                    ],
                                  ),



                                ],
                              ),
                            ),
                            SizedBox(height: 14,),
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
                                        Text(bankName??"Choose Bank",style: myStyle(14,BrandColors.colorText),),
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
                                        Text(mfsName??"Choose Mfs",style: myStyle(14,BrandColors.colorText),),
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
                                    ? "Receive/Receivable from"
                                    : widget.name == "Expenditure"
                                    ? "Pay/Payable to"
                                    : widget.name == "Loan"
                                    ? loanType == "Take Loan"
                                    ? "Name "
                                    : loanType == "Give Loan"
                                    ? "Name"
                                    : "Name"
                                    : "Pay Back Loan To",style: myStyle(14,Color(0xFFD2DCF7)),
                              ),
                            ),

                            SenderTextEdit(
                              keyy: "receive",
                              data: _data,
                              name: receiveFrom,
                              lebelText: "Type name here....",
                             // icon: Icon(Icons.airline_seat_flat,color: Colors.red,size: 1,),
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
                                  return "Name Too Short. ( Min 3 character )";
                                }
                                if (value.length > 30) {
                                  return "Name Too Long. ( Max 30 character )";
                                }
                              },
                            ),

                            Padding(
                              padding: EdgeInsets.only(top: 20,bottom: 4),
                              child: Text("Add details (optionala)",style: myStyle(14,BrandColors.colorText),
                              ),
                            ),
                           /* SenderTextEdit(
                              keyy: "details",
                              maxNumber: 3,
                              data: _data,
                              name: detailsController,
                              lebelText: "     Write here",

                            ),*/

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
                                      labelText: ' Balance* ',
                                      labelStyle: myStyle(16, BrandColors.colorText, FontWeight.w600),
                                      inputStyle: _ts.copyWith(color: Colors.white),
                                      formattedStyle:
                                      _ts.copyWith(fontSize: 18, color: Colors.white)),
                                ),
                              ),
                            ),

                            SizedBox(
                              height: 50,
                            ),
                          ],
                        ),
                      ),
                    ),

                    Expanded(
                      flex: 1,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 12,
                            child: GestureDetector(
                              onTap: (){
                                Navigator.pop(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20,),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  border: Border.all(
                                      color: BrandColors.colorPurple, width: 1.0),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    SvgPicture.asset("assets/arrow2.svg",
                                      alignment: Alignment.center,
                                      height: 15,width: 15,
                                    ),
                                    SizedBox(
                                      width: 8,
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
                            flex: 12,
                            child: InkWell(
                              onTap: () {

                                print("storage hub type issssssssssssssssssss $storageType");
                                if (!_formKey.currentState.validate()) return;
                                _formKey.currentState.save();
                                print("widget name ${widget.name}");
                                transactionType ==false? showInSnackBar("Choose  a  Transaction type"):  isStorage==false? showInSnackBar("Choose a storage Hub"): amountController.text.toString().isEmpty ? showInSnackBar("Amount Required") :   widget.name == "Earning"
                                    ?  uploadEarningData(context)
                                    : widget.name == "Expenditure"
                                    ?
                                uploadExpenditureData(context)
                                    : widget.name == "Loan"
                                    ?  uploadLoanData(context)
                                    : uploadFundData(context);
                              },
                              child: Container(
                                padding: EdgeInsets.symmetric(vertical: 20,),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color:  BrandColors.colorPurple,
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
                                    SizedBox(
                                      width: 8,
                                    ),
                                    SvgPicture.asset("assets/arrow1.svg",
                                      alignment: Alignment.center,
                                      height: 15,width: 15,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          )
                        ],
                      ),
                    )


                  ],
                )),
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
