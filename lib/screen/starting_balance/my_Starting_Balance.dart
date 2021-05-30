import 'dart:convert';
import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:http/http.dart' as http;
import 'package:anthishabrakho/models/starting_payable_Model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';

import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/Starting_receivable_model.dart';
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

  List<StartingReceivableModel> receivableData = [];
  StartingReceivableModel model;

  List<StartingPayableModel> payableData = [];
  StartingPayableModel model2;
   fetchStartingReceivableData() async {

    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/receivable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting Receivable details are   ::  ${response.body}");
    model = StartingReceivableModel.fromJson(jsonResponce);
    if (this.mounted) {
      setState(() {
        receivableData.add(model);
      });
    }
    print("starting receivable total balance is :${model.total}");
  }



  fetchStartingPayableData() async {

    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/payable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
   if(response.statusCode==200){
     print("Starting payable details are   ::  ${response.body}");
     model2 = StartingPayableModel.fromJson(jsonResponce);
     if (this.mounted) {
       setState(() {
         payableData.add(model2);
       });
     }
   }else{
     return "Error";
   }
   // print("total starting payable amount  is :${model.total}");
  }

  Future _getPayable , getReceivable;
//  bool onProgress = false;
  @override
  void initState() {
    controller = TabController(length: 2, vsync: this, initialIndex: 1);
    _getPayable= fetchStartingPayableData();
    getReceivable= fetchStartingReceivableData();

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

        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text( getTranslated(context,'t31'), //My Starting balance

          style: myStyle(18,Colors.white),),
        centerTitle: true,

      ),

      body: Container(
        height: double.infinity,
        padding: EdgeInsets.only(left: 10,top: 8,bottom: 5),
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
                            getTranslated(context,'t50'),   //          "Starting Receivable",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            getTranslated(context,'t51'),      //"Starting Payables",
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
                flex: 8,
                child: Container(
                  padding: EdgeInsets.only(
                      bottom: 6, left: 6, right: 6),





                  child: TabBarView(
                    controller: controller,
                    physics: BouncingScrollPhysics(),
                    children: <Widget>[

                      FutureBuilder(
                          future: getReceivable,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done)
                              return ViewStartingReceivable(
                                model: model,
                              );
                            else
                              return Center(child: Text("Loading",style: myStyle(16,Colors.white),));
                          }),



                      FutureBuilder(
                          future: _getPayable,
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState == ConnectionState.done)
                              return  ViewStartingPayable(
                                model: model2,
                              );
                            else
                              return Center(child: Text("Loading",style: myStyle(16,Colors.white),));
                          }),


                    ],
                  ),
                ))
          ],
        ),
      )
    );
  }
}
