import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:intl/intl.dart';


class BankWidget extends StatefulWidget {
  final List<BankDetails>model;
  final dynamic totalBankBalance;
  BankWidget({this.model,this.totalBankBalance});
  @override
  _BankWidgetState createState() => _BankWidgetState();
}

class _BankWidgetState extends State<BankWidget> {
 // List<DashBoardModel> allData = [];
  DashBoardModel dashBoardModel;
  @override
  Widget build(BuildContext context) {
    return Container(

      child: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [

            ListTile(
              leading: Text("Bank Balance",style: myStyle(14,BrandColors.colorDimText),),
              trailing: Text(
                NumberFormat.currency(
                    symbol: ' ৳ ',
                    decimalDigits: (widget.totalBankBalance) is int
                        ? 0
                        : 2,
                    locale: "en-in")
                    .format(
                    widget.totalBankBalance),
                style: myStyle(16, BrandColors.colorWhite,
                    FontWeight.w800),
              ),
            ),
            ListView.builder(
              physics: NeverScrollableScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount:
             widget.model.length >2 ? widget.model.getRange(0, 2).length :widget.model.length == 1?widget.model.getRange(0, 1).length :widget.model.length  ,
              itemBuilder: (context, index) {
                return widget.model == null
                    ? Text(
                    "Please Add account from Storage Hub")
                    : ListTile(
                      leading: Image.network(
                        "http://hishabrakho.com/admin/storage/hub/${widget.model[index].storageHubLogo}",
                        width: 60,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                      title: Text(
                        "${widget.model[index].storageHubName} ",
                        style: myStyle(
                            14,
                            BrandColors.colorWhite,
                            FontWeight.w600),overflow: TextOverflow.ellipsis,
                      ),
                      trailing: Text(
                        NumberFormat.currency(
                            symbol: ' ৳ ',
                            decimalDigits: (widget.model[index].currentBankBalance)
                            is int
                                ? 0
                                : 2,
                            locale: "en-in")
                            .format(widget.model[index]
                            .currentBankBalance),
                        style: myStyle(
                            14,
                            BrandColors.colorWhite,
                            FontWeight.w800),
                      ),
                      subtitle: Text(
                        "A/C:${widget.model[index].userStorageHubAccountNumber} ",
                        style: myStyle(
                            12,
                            BrandColors.colorDimText,
                            FontWeight.w800),
                      ),
                    );
              },
            ),


            widget.model.length >2? Center(child: Text("View All >",style: myStyle(14,Colors.deepPurpleAccent),),):Text("")
          ],
        ),
      )
    );
  }
}
