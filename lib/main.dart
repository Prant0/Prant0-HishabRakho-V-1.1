import 'package:flutter/material.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';

import 'file:///H:/antipoints/hishabRakho%20v1.0/anthishabrakho/lib/screen/tabs/home_page.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/main_page.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/screen/stapper/addBank.dart';
import 'package:anthishabrakho/screen/stapper/addMfs.dart';
import 'package:anthishabrakho/screen/tabs/myTransection.dart';


import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: UserDetailsProvider()),
        ChangeNotifierProvider.value(value: MyTransectionprovider()),
        ChangeNotifierProvider.value(value: StorageHubProvider()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Hishab Rakho',
        //initialRoute: LoginScreen.id,
        home: LoginScreen(),
        routes: {
          HomePage.id: (context) => HomePage(),
          LoginScreen.id: (context) => LoginScreen(),
          RegistationPage.id: (context) => RegistationPage(),
          MainPage.id:(context)=>MainPage(),
          MyTransection.id:(context)=>MyTransection(),
          AddBankStapper.id:(context)=>AddBankStapper(),
          AddMfsStapper.id:(context)=>AddMfsStapper(),
        },
      ),
    );
  }
}


