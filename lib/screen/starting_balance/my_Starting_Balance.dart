import 'package:anthishabrakho/screen/starting_balance/view_Starting_Payable.dart';
import 'package:anthishabrakho/screen/starting_balance/view_Starting_Receivable.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';




class MyStartingBalance extends StatefulWidget {
  @override
  _MyStartingBalanceState createState() => _MyStartingBalanceState();
}

class _MyStartingBalanceState extends State<MyStartingBalance>with SingleTickerProviderStateMixin {
  TabController controller;


  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 1);
    super.initState();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text("My Starting Balance",style: myStyle(18,Colors.white),),
        centerTitle: true,

      ),

      body: Container(
        height: double.infinity,
        padding: EdgeInsets.only(left: 10,top: 15,bottom: 5),
        child: Column(
          children: [
            Expanded(
              flex: 1,
              child: Container(
                //height: 50,
                child: Column(
                  children: [
                    TabBar(
                      physics: BouncingScrollPhysics(),
                      labelColor: Colors.green,
                      indicatorColor: Colors.grey,
                      unselectedLabelColor:
                      Colors.blueGrey,
                      controller: controller,
                      isScrollable: true,
                      tabs: <Widget>[
                        Tab(
                          child: Text(
                            "Starting Receivable",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Starting Payables",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      color: Colors.white70,
                      height: 0,
                    )
                  ],
                ),
              ),
            ),
            Expanded(
                flex: 7,
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: 6, left: 6, right: 6),
                  child: TabBarView(
                    controller: controller,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[
                      ViewStartingReceivable(

                      ),
                      ViewStartingPayable(

                      ),

                    ],
                  ),
                ))
          ],
        ),
      )
    );
  }
}
