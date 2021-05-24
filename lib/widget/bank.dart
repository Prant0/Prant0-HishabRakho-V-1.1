import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'file:///H:/antipoints/hishabRakho%20v1.0/anthishabrakho/lib/screen/tabs/home_page.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:intl/intl.dart';

class BankWidget extends StatefulWidget {
  final List<BankDetails> model;
  final dynamic totalBankBalance;

  BankWidget({this.model, this.totalBankBalance});

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
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8,right: 12,left: 12,bottom: 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getTranslated(context,'t7'), //bank balance
                  style: myStyle(14, BrandColors.colorText.withOpacity(0.7),FontWeight.w400),
                ),
                moneyField(
                  amount: widget.totalBankBalance,
                  ts: myStyle(16, Colors.white, FontWeight.w500),
                  offset: Offset(0, -8),
                  tks: myStyle(12,Colors.white),

                ),
              ],
            ),
          ),
          ListView.builder(
            physics: NeverScrollableScrollPhysics(),
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: widget.model.length > 2
                ? widget.model.getRange(0, 2).length
                : widget.model.length == 1
                    ? widget.model.getRange(0, 1).length
                    : widget.model.length,
            itemBuilder: (context, index) {
              return widget.model == null
                  ? Text("Please Add account from Storage Hub")
                  : ListTile(
                      leading: Image.network(
                        "http://hishabrakho.com/admin/storage/hub/${widget.model[index].storageHubLogo}",
                        width: 44,
                        height: 44,
                        fit: BoxFit.cover,
                      ),
                      title: Text(
                        "${widget.model[index].storageHubName} ",
                        style: myStyle(
                            12, BrandColors.colorWhite, FontWeight.w600),
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: moneyField(
                        amount: widget.model[index].currentBankBalance,
                        ts: myStyle(12, Colors.white,FontWeight.w600),
                        offset: Offset(0, -8),
                        tks: myStyle(10,Colors.white),
                      ),

                      subtitle: Text(
                        "A/C: ${widget.model[index].userStorageHubAccountNumber.substring(0, 4) + " " + widget.model[index].userStorageHubAccountNumber.substring(4, 8) + " " + widget.model[index].userStorageHubAccountNumber.substring(8, 12) + " " + widget.model[index].userStorageHubAccountNumber.substring(12, widget.model[index].userStorageHubAccountNumber.length)} ",
                        style: myStyle(
                            12, BrandColors.colorDimText.withOpacity(0.5), FontWeight.w400),
                      ),
                    );
            },
          ),

        ],
      ),
    ));
  }

 //


  textFormatter(String x) {

    if (x.length == 4) {
      x = x.substring(0, 1) + "," + x.substring(1, x.length);
    }
    if (x.length == 5) {
      x = x.substring(0, 2) + "," + x.substring(2, x.length);
    }

    if (x.length == 6) {
      x = x.substring(0, 3) + "," + x.substring(3, x.length);
    }
    if (x.length == 7) {
      x = x.substring(0, 2) + "," + x.substring(2, x.length);
      x = x.substring(0, 5) + "," + x.substring(5, x.length);
    }
    if (x.length == 8) {
      x = x.substring(0, 1) + "," + x.substring(1, x.length);
      x = x.substring(0, 4) + "," + x.substring(4, x.length);
      x = x.substring(0, 7) + "," + x.substring(7, x.length);
    }
    if (x.length == 9) {
      x = x.substring(0, 3) + "," + x.substring(3, x.length);

      x = x.substring(0, 7) + "," + x.substring(7, x.length);
    }
    widget.model[0].userStorageHubAccountNumber = x;

    print(x);
  }
}
