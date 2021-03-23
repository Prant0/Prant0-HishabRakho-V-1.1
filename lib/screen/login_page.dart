import 'dart:convert';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:connectivity/connectivity.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:anthishabrakho/screen/main_page.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
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
          progressIndicator: Spin(),
          inAsyncCall: onProgress,
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                Expanded(
                  flex: 9,
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [

                        Container(
                          margin: EdgeInsets.only(top: 50.0),
                          child: Center(
                            child: Image(
                              image: AssetImage('assets/lgo.png'),
                              //height: 130.0,
                              //width: 130.0,
                            ),
                          ),
                        ),

                        Container(
                          margin: EdgeInsets.only(top: 50.0,bottom: 20,left: 20),
                          child: Text("Welcome back !",style: myStyle(22,Colors.white,FontWeight.w600),),
                        ),


                        Container(
                          margin: EdgeInsets.symmetric(horizontal: 20,vertical: 5),
                          child: TextFormField(
                            style: TextStyle(fontSize: 17.0, color:BrandColors.colorDimText),
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
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                              border : OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,)
                              ),
                              filled: true,
                              fillColor: BrandColors.colorPrimary,
                              focusedBorder: InputBorder.none,
                              //labelText: 'Email',
                              prefixIcon: const Icon(
                                Icons.email_sharp,
                                color: BrandColors.colorDimText,
                              ),
                              labelStyle: myStyle(16, BrandColors.colorDimText),
                              hintText: 'Write Email Here',
                              hintStyle:  myStyle(14, BrandColors.colorDimText,FontWeight.w500),
                            ),
                            keyboardType: TextInputType.emailAddress,
                          ),
                        ),

                        Container(
                          padding: EdgeInsets.all(20.0),
                          child: TextFormField(
                            style: TextStyle(fontSize: 17.0, color:BrandColors.colorDimText),
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
                                  color: BrandColors.colorDimText,
                                ),
                              ),
                              contentPadding: EdgeInsets.symmetric(vertical: 20),
                              border : OutlineInputBorder(
                                  borderRadius: BorderRadius.all(Radius.circular(12.0)),
                                  borderSide: BorderSide(
                                    color: Colors.transparent,)
                              ),
                              filled: true,
                              hintStyle:  myStyle(14, BrandColors.colorDimText,FontWeight.w500),
                              fillColor: BrandColors.colorPrimary,
                              focusedBorder: InputBorder.none,
                              prefixIcon: const Icon(
                                Icons.lock,
                                color: BrandColors.colorDimText,
                              ),
                              hintText: 'Write Password Here',
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
                            decoration: BoxDecoration(
                              color: BrandColors.colorPurple,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            width: MediaQuery.of(context).size.width,
                            padding: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 20.0),
                            margin: EdgeInsets.symmetric(
                                horizontal: 30.0, vertical: 20.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  'Login',
                                  style: myStyle(18, Colors.white, FontWeight.w600),
                                ),
                                Icon(Icons.arrow_forward_ios_sharp,color: Colors.white,size: 15,)
                              ],
                            )
                          ),
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
                        flex: 5,
                        child: Center(child: Text("Don't have an account?",style: myStyle(16,Colors.white),)),
                      ),

                      Expanded(
                          flex: 5,
                          child: InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => RegistationPage()));
                            },
                            child: Container(
                              margin: EdgeInsets.only(right: 12,bottom: 12),
                              height: double.infinity,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                              ),
                              child: Center(child: Text("Create Account",style: myStyle(16,Colors.white,FontWeight.w500),)),
                            ),
                          )
                      )
                    ],
                  ),
                )
              ],
            )
          ),
        ));
  }
}
