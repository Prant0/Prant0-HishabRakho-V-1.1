import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/my_situation%20model.dart';
import 'package:intl/intl.dart';

class ViewMySituation extends StatefulWidget {
  final List<MySituationModel> payable;
  final String title;

  ViewMySituation({this.payable, this.title});

  @override
  _ViewMySituationState createState() => _ViewMySituationState();
}

class _ViewMySituationState extends State<ViewMySituation> {
  Color textColor = Colors.white.withOpacity(0.7);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.black,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: Colors.black,
          title: Text(
            widget.title,
            style: myStyle(20, Colors.white),
          ),
        ),
        body: Container(
            padding: EdgeInsets.symmetric(horizontal: 20),
            child: ListView(
              children: [
                SizedBox(
                  height: 30,
                ),
                widget.payable.isNotEmpty
                    ? ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        scrollDirection: Axis.vertical,
                        shrinkWrap: true,
                        itemCount: widget.payable.length,
                        itemBuilder: (context, index) {
                          return widget.payable.length < 0
                              ? Container(
                                  color: Colors.red,
                                  child: Text(
                                    "No Data fount",
                                    style: TextStyle(color: Colors.white),
                                  ),
                                )
                              : Center(
                                  child: Container(
                                    margin: EdgeInsets.symmetric(vertical: 12),
                                    decoration: BoxDecoration(
                                        color: Color(0xFF021A2C),
                                        border: Border.all(
                                            color: Colors.purple, width: 1),
                                        borderRadius:
                                            BorderRadius.circular(12)),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          flex: 8,
                                          child: ListTile(
                                            leading: Icon(
                                              Icons.person,
                                              size: 30,
                                              color: textColor,
                                            ),
                                            title: Text(
                                              "${widget.payable[index].name}",
                                              style: myStyle(16, Colors.white,
                                                  FontWeight.w600),
                                            ),
                                            trailing: Text(
                                              NumberFormat.currency(
                                                      symbol: ' ৳ ',
                                                  decimalDigits: (widget
                                                      .payable[index].amount) is int ? 0 :2,
                                                      locale: "en-in")
                                                  .format(widget
                                                      .payable[index].amount),
                                              style: myStyle(
                                                  16,
                                                  widget.title ==
                                                          "My Receivable"
                                                      ? Color(0xffa7ffeb)
                                                      : Colors.red,
                                                  FontWeight.w800),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Icon(
                                            Icons.edit_outlined,
                                            color: Colors.transparent,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                );
                        },
                      )
                    : Center(
                        child: Container(
                          margin: EdgeInsets.only(top: 120),
                          child: Text(
                            "Empty List",
                            style: myStyle(18, Colors.white70, FontWeight.w800),
                          ),
                        ),
                      ),
              ],
            )));
  }
}
