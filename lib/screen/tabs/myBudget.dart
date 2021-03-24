import 'package:anthishabrakho/globals.dart';
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
          child:  Text("This Feature is coming soon ...",style: myStyle(22,BrandColors.colorDimText,FontWeight.w600),),
        ),
      ),
    );
  }
}
