import 'package:anthishabrakho/widget/demo_Localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String LAGUAGE_CODE = 'languageCode';

//languages code
const String ENGLISH = 'en';
const String Bangla = 'hi';

Future<Locale> setLocale(String languageCode) async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  await _prefs.setString(LAGUAGE_CODE, languageCode);
  return _locale(languageCode);
}

Future<Locale> getLocale() async {
  SharedPreferences _prefs = await SharedPreferences.getInstance();
  String languageCode = _prefs.getString(LAGUAGE_CODE) ?? "en";
  print("language is ${_prefs.getString(LAGUAGE_CODE)}");
  return _locale(languageCode);
}

Locale _locale(String languageCode) {
  Locale _temp;
  switch(languageCode){
    case ENGLISH:
      _temp=Locale(languageCode,'US');
      break;
    case  Bangla:
      _temp=Locale(languageCode,"IN");
      break;
    default:_temp=Locale(languageCode,'US');
  }
  return _temp;
}

String getTranslated(BuildContext context, String key) {
  return DemoLocalization.of(context).translate(key);
}