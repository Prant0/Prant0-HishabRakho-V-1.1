import 'dart:async';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/main_page.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class FirstPage extends StatefulWidget {
  @override
  _FirstPageState createState() => _FirstPageState();
}

class _FirstPageState extends State<FirstPage> {
  SharedPreferences sharedPreferences;

  @override
  void initState() {
    super.initState();
    Timer(
      Duration(milliseconds: 2000),
          () => checkLoginStatus(),
    );
  }

  checkLoginStatus() async {
    sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("token") == null) {
      print(sharedPreferences.getString("token"));
      Navigator.of(context).pushReplacementNamed(LoginScreen.id);
    } else
      Navigator.of(context).pushReplacementNamed(MainPage.id);
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
          body: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 59),
                decoration: BoxDecoration(color: Colors.white),
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[

                  Expanded(
                    flex: 5,
                    child: Container(
                      padding: EdgeInsets.only(top: 30),
                      alignment: Alignment.topCenter,
                      child: Image(
                        image: AssetImage('assets/logo.png'),
                      ),
                      // color: Colors.white,
                    ),
                  ),

                  Expanded(
                    flex:5,
                    child: Center(
                      child: SpinKitFadingFour(
                        itemBuilder: (BuildContext context, int index) {
                          return DecoratedBox(
                            decoration: BoxDecoration(
                              color: index.isEven ? Colors.greenAccent : Colors.purple,
                            ),
                          );
                        },
                      ),
                    ),
                  ),


                ],
              ),
            ],
          )),
    );
  }
}
