import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:anthishabrakho/widget/custom_TextField.dart';

class ResetPassword extends StatefulWidget {
  @override
  _ResetPasswordState createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPassword> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool onProgress = false;
  Map<String, dynamic> _data = Map<String, dynamic>();
  TextEditingController passwordController=TextEditingController();
  TextEditingController confirmPasswordController=TextEditingController();
  TextEditingController oldPasswordController=TextEditingController();


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(getTranslated(context,'t122'),),              //"Reset password"),
        centerTitle: true,
      ),
      body: Container(
        height: double.infinity,
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ModalProgressHUD(
          inAsyncCall: onProgress,
          progressIndicator: Spin(),
          child: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      height: 20.0,
                    ),
                    SenderTextEdit(
                      keyy: "password",
                      data: _data,
                      name: oldPasswordController,
                      hintText:getTranslated(context,'t120'),              // "Old Password",
                      lebelText: "Enter your old Password",
                      icon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset("assets/pass.svg",
                          alignment: Alignment.center,
                          height: 15,width: 15,
                        ),
                      ),
                      function: (String value) {
                        if (value.isEmpty) {
                          return getTranslated(context,'t123');              //"Old Password required";
                        }
                        if (value.length < 6) {
                          return getTranslated(context,'t124');             //"Password Too Short. ( 6 - 15 character )";
                        }
                        if (value.length > 15) {
                          return getTranslated(context,'t125');              //"Password Too long. ( 6 - 15 character )";
                        }
                      },
                    ),
                    SenderTextEdit(
                      keyy: "password",
                      data: _data,
                      name: passwordController,
                      hintText:getTranslated(context,'t121'),              // "New Password",
                      lebelText: "Enter your new password",
                      icon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset("assets/pass.svg",
                          alignment: Alignment.center,
                          height: 15,width: 15,
                        ),
                      ),
                      function: (String value) {
                        if (value.isEmpty) {
                          return getTranslated(context,'t127');              //"New Password required.( 6 - 15 character/letter/digit/symbols )";
                        }
                        if (value.length < 6) {
                          return getTranslated(context,'t128');              //"Password Too Short. ( 6 - 15 character/letter/digit/symbols  )";
                        }
                        if (value.length > 15) {
                          return getTranslated(context,'t129');              //"Password Too long. ( 6 - 15 character/letter/digit/symbols  )";
                        }
                      },
                    ),
                    SenderTextEdit(
                      keyy: "confirmPassword",
                      data: _data,
                      name: confirmPasswordController,
                      lebelText:getTranslated(context,'t122'),             // "Confirm Password",
                      hintText:getTranslated(context,'t122'),             // "Confirm Password",
                      icon: Padding(
                        padding: const EdgeInsets.all(15.0),
                        child: SvgPicture.asset("assets/pass.svg",
                          alignment: Alignment.center,
                          height: 15,width: 15,
                        ),
                      ),
                      function: (String value) {
                        if (value.isEmpty) {
                          return getTranslated(context,'t130');              //"Confirm Password required.( 6 - 15 character/letter/digit/symbols )";
                        }
                        if (value.length < 6) {
                          return getTranslated(context,'t128');              //"Password Too Short. ( 6 - 15 character/letter/digit/symbols  )";
                        }
                        if (value.length > 15) {
                          return getTranslated(context,'t129');              //"Password Too long ( 6 - 15 character/letter/digit/symbols  )";
                        }
                        if (passwordController.text != confirmPasswordController.text) {
                          return getTranslated(context,'t131');              // "Password do not match";
                        }
                      },
                    ),

                    InkWell(
                      onTap: () async {
                          if (!_formKey.currentState.validate()) return;
                          _formKey.currentState.save();
                          resetPassword(context);
                          print("tap");

                      },
                      child: Container(
                        decoration: BoxDecoration(
                          color: BrandColors.colorPurple,
                         border: Border.all( color: BrandColors.colorPurple,width: 1),
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        width: MediaQuery.of(context).size.width,
                        padding: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 15.0),
                        margin: EdgeInsets.symmetric(
                            horizontal: 30.0, vertical: 30.0),
                        child: Center(
                          child: Text(
                              getTranslated(context,'t132'),             //'Submit',
                            style: myStyle(18, Colors.white, FontWeight.w600),
                          ),
                        ),
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
  Future resetPassword(BuildContext context) async {
    try {
      setState(() {
        onProgress = true;
      });
      final uri = Uri.parse("http://api.hishabrakho.com/api/user/password/change");
      var request = http.MultipartRequest("POST", uri);
      request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
      request.fields['old_password'] = oldPasswordController.text.toString();
      request.fields['password'] = passwordController.text.toString();
      request.fields['password_confirmation'] = confirmPasswordController.text.toString();
      print("processing");
      var response = await request.send();
      var responseData = await response.stream.toBytes();
      var responseString = String.fromCharCodes(responseData);
      print("responseBody " + responseString);
      if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        showInSnackBar(getTranslated(context,'t133'),);              //"Reset Password successful .");

        Future.delayed(const Duration(seconds: 2), () {
          setState(() {
            onProgress = false;
            Navigator.pop(context);
          });
        });
      } else {
        showInSnackBar(getTranslated(context,'t134'));              //" The current password is not matched !");
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

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,fontWeight: FontWeight.w700,
        ),
      ),
      backgroundColor: Colors.indigo,
    ));
  }
}
