import 'dart:convert';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/main_page.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter_svg/svg.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
 String userNames;
class LoginScreen extends StatefulWidget {
  static const String id = 'loginpage';

  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  final _formKey = GlobalKey<FormState>();
  bool onProgress = false;
  bool _obscureText = true;
  String token;

  String email;
  SharedPreferences sharedPreferences;
  String x, y;
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void initState() {
    checkLoginStatus();
    super.initState();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") != null) {
      print(sharedPreferences.getString("token"));
      Navigator.of(context).pushReplacementNamed(MainPage.id);
    }
  }

  Future<String> _submit() async {
    check().then((intenet) async {
      if (intenet != null && intenet) {
        if (mounted) {
          setState(() {
            onProgress = true;
          });
          final form = _formKey.currentState;
          if (form.validate()) {
            form.save();
            if (await getLogin()) {
              _emailController.clear();
              _passwordController.clear();
              Navigator.of(context).pushReplacementNamed(MainPage.id);
              return "Logged In";
            } else {
              setState(() {
                onProgress = false;
              });
              return "Incorrect Credentials";
            }
          } else {
            setState(() {
              onProgress = false;
            });
            return "Required email and password";
          }
        }
      } else
        showInSnackBar("No Internet Connection");
    });
  }

  Future<bool> getLogin() async {
    try {
      onProgress=true;
      sharedPreferences = await SharedPreferences.getInstance();
      final result = await CustomHttpRequests.login(
          _emailController.text.toString(),
          _passwordController.text.toString());
      final data = jsonDecode(result);
      print("Pranto the login data are : $data");
      if (data["token"] != null) {
        setState(() {
          onProgress = false;
          sharedPreferences.setString("token", data['token']);
          sharedPreferences.setString("userName", data['user_details']["name"]);
          sharedPreferences.setString("email", data['user_details']["email"]);
          sharedPreferences.setString("image", data['user_details']["image"]);
          token = sharedPreferences.getString("token");
          print('token is $token');
          print('email is ${sharedPreferences.getString("email")}');
          print('image is ${sharedPreferences.getString("image")}');
          userNames = sharedPreferences.getString("userName");
          print('nameeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeeee isssssssssssss is $userNames');
        });

        // getUserDetails();
        return true;
      } else {
        return false;
      }
    } catch (e) {
      setState(() {
        onProgress = false;
      });
      showInSnackBar("Email or Password  didn't match");
      print("something wrong pranto $e");
    }
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.purple,
    ));
  }
  List<UserModel> user = [];



  @override
  Widget build(BuildContext context) {

    return Scaffold(
     resizeToAvoidBottomInset: false,
       backgroundColor: BrandColors.colorPrimaryDark,
        key: _scaffoldKey,
        body: ModalProgressHUD(
          opacity: 0.5,
          progressIndicator: Spin(),
          inAsyncCall: onProgress,
          child: Container(
            height: MediaQuery.of(context).size.height,
            child: Form(
              key: _formKey,
              child: Stack(
                children: [
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Expanded(
                          flex: 2,
                          child: Container(
                            margin: EdgeInsets.only(top: 20.0),
                            padding: EdgeInsets.symmetric(vertical: 10),
                            child: Center(
                              child: Image(
                                image: AssetImage('assets/lgo.png'),
                                height: 60,
                                width: MediaQuery.of(context).size.width /1,
                                //width: 130.0,
                              ),
                            ),
                          ),
                        ),

                        Expanded(
                          flex: 7,
                          child: Container(
                            //color: Colors.red,
                            child: Center(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Container(
                                    margin: EdgeInsets.only(bottom: 25,),
                                    child: Text("Welcome back!",style: myStyle(22,Colors.white,FontWeight.w500),),
                                  ),


                                  Container(

                                    child: TextFormField(
                                      style: myStyle(14.0, BrandColors.colorDimText,FontWeight.w400),
                                      onSaved: (val) => x = val,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Email required";
                                        }
                                        if (!value.contains('@')) {
                                          return "Invalid Email";
                                        }
                                        if (!value.contains('.')) {
                                          return "Invalid Email";
                                        }
                                      },
                                      cursorColor: Colors.white70,
                                      controller: _emailController,
                                      decoration: InputDecoration(
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

                                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                                        filled: true,
                                        fillColor: BrandColors.colorPrimary,
                                        //focusedBorder: InputBorder.none,
                                        prefixIcon: Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SvgPicture.asset("assets/email.svg",
                                            alignment: Alignment.center,
                                            height: 15,width: 15,
                                            color: BrandColors.colorText.withOpacity(0.4),
                                          ),
                                        ),
                                        labelStyle: myStyle(16, BrandColors.colorDimText),
                                        hintText: 'Enter your email address',
                                        hintStyle:  myStyle(14, BrandColors.colorDimText,),
                                      ),
                                      keyboardType: TextInputType.emailAddress,
                                    ),
                                  ),

                                  SizedBox(height: 14,),

                                  Container(

                                    child: TextFormField(
                                      style: myStyle(14.0, BrandColors.colorDimText,FontWeight.w400),
                                      onSaved: (val) => y = val,
                                      controller: _passwordController,
                                      validator: (String value) {
                                        if (value.isEmpty) {
                                          return "Password required";
                                        }
                                        if (value.length < 6) {
                                          return "Password Too Short. ( 6 - 15 character )";
                                        }
                                        if (value.length > 15) {
                                          return "Password Too long. ( 6 - 15 character )";
                                        }
                                      },
                                      decoration: InputDecoration(
                                        suffixIcon: GestureDetector(
                                          onTap: () {
                                            setState(() {
                                              _obscureText = !_obscureText;
                                            });
                                          },
                                          child: Icon(
                                            _obscureText
                                                ? Icons.visibility
                                                : Icons.visibility_off,
                                            color: Color(0xFFD2DCF7).withOpacity(0.6),
                                            size: 18,
                                          ),
                                        ),
                                        contentPadding: EdgeInsets.symmetric(vertical: 20),
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
                                        filled: true,
                                        hintStyle:  myStyle(14, BrandColors.colorDimText),
                                        fillColor: BrandColors.colorPrimary,
                                        prefixIcon:Padding(
                                          padding: const EdgeInsets.all(15.0),
                                          child: SvgPicture.asset("assets/pass.svg",
                                            alignment: Alignment.center,
                                            height: 15,width: 15,
                                          ),
                                        ),
                                        hintText: 'Enter your password',
                                      ),
                                      obscureText: _obscureText,
                                    ),
                                  ),
                                  GestureDetector(
                                    onTap: () async {
                                      final response = await _submit();
                                      if (response != null) {
                                        showInSnackBar(response);
                                      }
                                      print("Tap");
                                    },
                                    child: Container(
                                      alignment: Alignment.center,
                                        decoration: BoxDecoration(
                                          color: BrandColors.colorPurple,
                                          borderRadius: BorderRadius.circular(10.0),
                                        ),
                                        width: MediaQuery.of(context).size.width,
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 30.0, vertical: 20.0),
                                        margin: EdgeInsets.symmetric(
                                             vertical: 24.0),
                                        child:Text(
                                          'Login',
                                          style: myStyle(14, Colors.white, FontWeight.w600),
                                        ),
                                    ),
                                  ),
                                  Container(
                                    alignment: Alignment.center,
                                    padding: EdgeInsets.only(top: 10),
                                    child: Text("Forget your password?",style: myStyle(14,BrandColors.colorPurple),),
                                  )
                                ],
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          flex:2 ,
                          child: Container(
                            padding: EdgeInsets.only(bottom: 8),
                            alignment: Alignment.bottomCenter,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  "@Copyright 2020 - 2021.",style: myStyle(12,BrandColors.colorText.withOpacity(0.6),FontWeight.w400),
                                ),
                                RichText(
                                  text: TextSpan(
                                    text: 'All rights Reserved by : ',
                                    style: myStyle(
                                        12,
                                       BrandColors.colorText.withOpacity(0.6),
                                    ),
                                    children: <TextSpan>[
                                      TextSpan(
                                        text: 'Sheehan Rahman',
                                        style: myStyle(
                                          14,
                                          BrandColors.colorText
                                        ),
                                      ),
                                    ],
                                  ),
                                ),


                              ],
                            ),
                          ),
                        )

                      ],
                    ),
                  ),
                 /* Positioned(
                    bottom: 15,
                    child: Container(
                     // height: 65,
                     padding: EdgeInsets.symmetric(horizontal: 10),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FittedBox(child: Text("Don't have an account?",style: myStyle(14,Colors.white,FontWeight.w400),)),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegistationPage()));
                            },
                            child: Container(
                              padding: EdgeInsets.symmetric(horizontal: 42,vertical: 20),
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                              ),
                              child: Center(child: Text("Create Account",style: myStyle(14,Colors.white,FontWeight.w500),)),
                            ),
                          )
                        ],
                      ),
                    ),
                  )*/
                ],
              )
            ),
          ),
        ));
  }
}
