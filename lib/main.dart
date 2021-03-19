import 'package:flutter/material.dart';
import 'package:anthishabrakho/providers/dashBoardProviders.dart';
import 'package:anthishabrakho/providers/mySitationProvider.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/add_Storage_hub.dart';
import 'package:anthishabrakho/screen/home_page.dart';
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
        ChangeNotifierProvider.value(value: DashBoardProviders()),
        ChangeNotifierProvider.value(value: UserDetailsProvider()),
        ChangeNotifierProvider.value(value: MyTransectionprovider()),
        ChangeNotifierProvider.value(value: MySituationProvider()),
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


