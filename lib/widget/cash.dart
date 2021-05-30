import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'file:///H:/antipoints/hishabRakho%20v1.0/anthishabrakho/lib/screen/tabs/home_page.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:intl/intl.dart';


class CashWidget extends StatefulWidget {
  final List<DashBoardModel>model;
  CashWidget({this.model});
  @override
  _CashWidgetState createState() => _CashWidgetState();
}

class _CashWidgetState extends State<CashWidget> {
  @override
  Widget build(BuildContext context) {
    return  Center(
      child: ListView.builder(
        itemCount: widget.model.length,
        itemBuilder: (context,index){
          return ListTile(
            leading: Icon(Icons.money,color: Colors.white70,size: 22,),
            title: Text( getTranslated(context,'t4'), //cash
              style: myStyle(14,BrandColors.colorText.withOpacity(0.7),FontWeight.w400),),
            trailing: moneyField(
              amount: widget.model[index].totalCashAmount,
              ts: myStyle(16,Colors.white,FontWeight.w500),
              offset: Offset(-0, -8),
              tks: myStyle(14,Colors.white),
            ),

          );
        },

      ),
    );
  }
}
