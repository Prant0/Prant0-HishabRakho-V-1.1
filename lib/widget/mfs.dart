import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:flutter/material.dart';
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
          ListTile(
            leading: Text(
              "MFS Balance",
              style: myStyle(14, BrandColors.colorDimText),
            ),
            trailing: Text(
              NumberFormat.currency(
                      symbol: ' ৳ ',
                      decimalDigits: (widget.totalMfsDetails) is int ? 0 : 2,
                      locale: "en-in")
                  .format(widget.totalMfsDetails),
              style: myStyle(16, BrandColors.colorWhite, FontWeight.w800),
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
                        width: 60,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                      title: Text(
                        "${widget.model[index].storageHubName} ",
                        style: myStyle(
                            16, BrandColors.colorWhite, FontWeight.w600),
                      ),
                      trailing: Text(
                        NumberFormat.currency(
                                symbol: ' ৳ ',
                                decimalDigits: (widget
                                        .model[index].currentMfsBalance) is int
                                    ? 0
                                    : 2,
                                locale: "en-in")
                            .format(widget.model[index].currentMfsBalance),
                        style: myStyle(
                            14, BrandColors.colorWhite, FontWeight.w800),
                      ),
                      subtitle: Text(
                        "A/C:${widget.model[index].userStorageHubAccountNumber} ",
                        style: myStyle(
                            12, BrandColors.colorDimText, FontWeight.w800),
                      ),
                    );
            },
          ),
        ],
      ),
    ));
  }
}
