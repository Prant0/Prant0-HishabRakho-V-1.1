import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/screen/home_page.dart';
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
            title: Text("Cash",style: myStyle(14,BrandColors.colorText,FontWeight.w400),),
            trailing: moneyField(
              amount: widget.model[index].totalCashAmount,
              ts: myStyle(16,Colors.white,FontWeight.w500),
              offset: Offset(-1, -8),
              tks: myStyle(14,Colors.white),
            ),
            /*Text(
                NumberFormat
                    .compactCurrency(
                  symbol: ' ৳ ',
                ).format(
                    widget.model[index]
                        .totalCashAmount),
                style: myStyle(
                    14, Colors.white))*/
          );
        },

      ),
    );
  }
}
