import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';


class MyBudget extends StatefulWidget {
  @override
  _MyBudgetState createState() => _MyBudgetState();
}

class _MyBudgetState extends State<MyBudget> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      
     backgroundColor: BrandColors.colorPrimaryDark,
      body: Container(
        child: Center(
          child:  Text(getTranslated(context,'t168'),//   "This Feature is coming soon ..."
           style: myStyle(16,BrandColors.colorDimText,FontWeight.w600),),
        ),
      ),
    );
  }
}
