import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/demo_Localization.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
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

class MyApp extends StatefulWidget {

  /*static void setLocale(BuildContext context,Locale locale) async{
    _MyAppState state =context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(locale);
  }*/

  static void setLocale(BuildContext context, Locale newLocale) {
    _MyAppState state = context.findAncestorStateOfType<_MyAppState>();
    state.setLocale(newLocale);
  }


  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale;
  void setLocale(Locale locale){
    setState(() {
      _locale=locale;
    });
  }


  @override
  void didChangeDependencies() {
    getLocale().then((locale) {
      setState(() {
        this._locale=locale;
      });
    } );
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    if(_locale==null){
      return Container(
        child: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }else{
      return MultiProvider(
        providers: [
          ChangeNotifierProvider.value(value: UserDetailsProvider()),
          ChangeNotifierProvider.value(value: MyTransectionprovider()),
          ChangeNotifierProvider.value(value: StorageHubProvider()),
        ],
        child: MaterialApp(
          locale: _locale,
          supportedLocales: [
            Locale("en", "US"),
            Locale("bn", "BN"),
            Locale("bn", "IN")
          ],
          localizationsDelegates: [
            DemoLocalization.delegate,
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          localeResolutionCallback: (deviceLocale,supportedLocales){
            for(var locale in supportedLocales){
              if(locale.languageCode==deviceLocale.languageCode && locale.countryCode==deviceLocale.countryCode ){
                return deviceLocale;
              }
            }
            return supportedLocales.first;
          },
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
}


