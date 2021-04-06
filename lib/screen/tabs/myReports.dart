import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:flutter/material.dart';


class MyReports extends StatefulWidget {
  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> {
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
