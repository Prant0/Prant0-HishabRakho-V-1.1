

import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/main.dart';
import 'package:anthishabrakho/models/language_model.dart';
import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/demo_Localization.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SelectLanguage extends StatefulWidget {

  @override
  _SelectLanguageState createState() => _SelectLanguageState();
}

class _SelectLanguageState extends State<SelectLanguage> {


  String getTranslated(BuildContext context, String key) {
    return DemoLocalization.of(context).translate(key);
  }

  Future<Locale> setLocale(String languageCode) async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    await _prefs.setString(LAGUAGE_CODE, languageCode);


    String languageCodee = _prefs.getString(LAGUAGE_CODE) ?? "hi";
    print("language isssssssssssssssssssssss ${languageCodee}");
    //return _locale(languageCode);
  }
  void _changeLanguage(String language){
    print(language);
    Locale _temp;
    switch(language){
      case ENGLISH:
      _temp=Locale(language,'US');
      break;
        case  Bangla:
        _temp=Locale(language,"IN");
        break;
      default:_temp=Locale(language,'US');
    }

    MyApp.setLocale(context,_temp);

  }

  bool isBangla;
  bool isEnglish ;



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        title: Text(getTranslated(context, 'home_page')),
        backgroundColor: BrandColors.colorPrimaryDark,
      ),

      body: Container(

        padding: EdgeInsets.all(20),
        child:Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color:BrandColors.colorPrimary,
                borderRadius: BorderRadius.circular(8.0)
              ),
              child: ListTile(
                onTap: (){
                  setState((){
                    showInSnackBar("Language Change successfully");
                    _changeLanguage("en");
                    setLocale("en");
                    isEnglish=true;
                    isBangla=false;

                  });
                },
                leading:Text("🇺🇸",style: myStyle(30),),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0)
                ),
                trailing: Icon(Icons.done,color: isEnglish ==true? BrandColors.colorText:Colors.transparent,),

                title: Text("English",style: myStyle(16,Colors.white),),
              ),
            ),


            SizedBox(height: 20,),
            Container(
              decoration: BoxDecoration(
                  color: BrandColors.colorPrimary,
                  borderRadius: BorderRadius.circular(8.0)
              ),
              child: ListTile(
                onTap: (){
                  setState((){
                    showInSnackBar("ভাষা পরিবর্তন সম্পন্ন হয়েছে");
                    _changeLanguage("hi");
                    setLocale("hi");
                    isEnglish=false;isBangla=true;

                  });
                },
                leading:Text("🇧🇩",style: myStyle(30),),
                trailing: Icon(Icons.done,color: isBangla==true?BrandColors.colorText:Colors.transparent,),
                title: Text("বাংলা",style: myStyle(16,Colors.white),),
              ),
            ),


          ],
        )
      ),
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
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
  void initState() {

    getLocale().then((locale) {
      setState(() {

        print("mucking is ${locale.languageCode}");
        locale.languageCode=="hi"?isBangla=true:isEnglish=true;

      });
    } );


print("sssssss${isEnglish }    $isBangla");
  } // Locale _locale;




}