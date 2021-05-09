import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:flutter/material.dart';
import 'file:///H:/antipoints/hishabRakho%20v1.0/anthishabrakho/lib/screen/tabs/home_page.dart';
import 'package:intl/intl.dart';

import '../globals.dart';
import 'brand_colors.dart';

class MfsWidget extends StatefulWidget {
  final List<MfsDetails> model;
  final dynamic totalMfsDetails;

  MfsWidget({this.model, this.totalMfsDetails});

  @override
  _MfsWidgetState createState() => _MfsWidgetState();
}

class _MfsWidgetState extends State<MfsWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
        child: SingleChildScrollView(
      child: Column(
        children: [

          Padding(
            padding: EdgeInsets.only(top: 8,right: 12,left: 12,bottom: 2),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "MFS Balance",
                  style: myStyle(14, BrandColors.colorDimText.withOpacity(0.7),FontWeight.w400),
                ),

                moneyField(
                  amount: widget.totalMfsDetails,
                  ts: myStyle(16,Colors.white,FontWeight.w500),
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
                        fit: BoxFit.fill,
                      ),
                      title: Text(
                        "${widget.model[index].storageHubName} ",
                        style: myStyle(
                            12, BrandColors.colorWhite, FontWeight.w500),
                      ),
                      trailing: moneyField(
                        amount: widget.model[index].currentMfsBalance,
                        ts: myStyle(12,Colors.white,FontWeight.w500),
                        offset: Offset(-1, -8),
                        tks: myStyle(12,Colors.white,FontWeight.w500) ,
                      ),
                      subtitle:  Text(
                        "A/C: ${widget.model[index].userStorageHubAccountNumber} ",
                        style: myStyle(
                            12, BrandColors.colorDimText.withOpacity(0.5), FontWeight.w400),
                      ),
                    );
            },
          ),
         // Text(  widget.model.length > 2 ? "View All  >" :"",style: myStyle(12,BrandColors.colorPurple),),
          SizedBox(height: 8,),
        ],
      ),
    ));
  }
}
