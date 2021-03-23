import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/starting_payable_Model.dart';
import 'package:anthishabrakho/screen/starting_balance/Add_Starting_balance.dart';
import 'package:anthishabrakho/screen/starting_balance/editStartingPayable.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewStartingPayable extends StatefulWidget {

  @override
  _ViewStartingPayableState createState() => _ViewStartingPayableState();
}

class _ViewStartingPayableState extends State<ViewStartingPayable> {
  List<StartingPayableModel> payableData = [];
  StartingPayableModel model;

  Future<dynamic> fetchStartingPayableData() async {
    payableData.clear();
    setState(() {
      onProgress=true;
    });
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/payable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting payable details are   ::  ${response.body}");
    model = StartingPayableModel.fromJson(jsonResponce);
    if (this.mounted) {
      setState(() {
        onProgress=false;
        payableData.add(model);
      });
    }
    print("total starting payable amount  is :${model.total}");
  }

  @override
  void initState() {
    fetchStartingPayableData();
    super.initState();
  }

bool onProgress=false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
        appBar: AppBar(
          actions: [
            InkWell(
              onTap: (){
                String type="payable";
                Navigator.push(context, MaterialPageRoute(builder: (context)=>AddStartingBalance(
                  title:type,
                ))).then((value) => setState(() {
                  fetchStartingPayableData();
                }));
              },
              child: Icon(Icons.add,color: Colors.white,size: 30,),
            ),
            SizedBox(width: 10,)
          ],
          backgroundColor: Colors.black,
          centerTitle: true,
          title: Text("Starting Payable",style: myStyle(16,Colors.white),),
        ),


        body:ModalProgressHUD(
          inAsyncCall: onProgress==true,
          child: Container(
            height: MediaQuery.of(context).size.height,
            padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
            child: SingleChildScrollView(
              child: Column(
                children: [
                  ListView.builder(

                    shrinkWrap: true,
                    itemCount: payableData.length,
                    itemBuilder: (c,i){
                      return Container(
                        decoration: BoxDecoration(
                            color: Color(0xFF021A2C),
                            border: Border.all(
                                color: Colors.purple, width: 1),
                            borderRadius: BorderRadius.circular(12)),
                        child: ListTile(

                          selectedTileColor:  Colors.red,
                          title: Text("Total Payable is :",style: myStyle(18,Colors.white),),
                          trailing: Text(
                            NumberFormat.currency(
                                symbol: ' ৳ ',
                                decimalDigits: (payableData[i].total)is int
                                    ? 0
                                    : 2,
                                locale: "en-in")
                                .format(payableData[i].total),
                            style: myStyle(
                                18,
                                Color(0xffa7ffeb),
                                FontWeight.w800),
                          ),
                        ),
                      );
                    },
                  ),

                  SizedBox(height: 50,),

                  Container(
                    child: ListView.builder(
                      shrinkWrap: true,
                      physics: BouncingScrollPhysics(),
                      itemCount: payableData.length,
                      itemBuilder: (context,index){
                        return Row(
                          children: [
                            Expanded(
                              flex: 8,
                              child: Container(
                                margin: EdgeInsets.symmetric(vertical: 10),
                                decoration: BoxDecoration(
                                    color: Color(0xFF021A2C),
                                    border: Border.all(
                                        color: Colors.purple, width: 1),
                                    borderRadius: BorderRadius.circular(12)),
                                child: ListTile(
                                  leading: Icon(Icons.person_outline,color: Colors.purple,),
                                  title: Text("${model.payableDetails[index].friendName}",style: myStyle(16,Colors.white),),
                                  trailing: Text(
                                    NumberFormat.currency(
                                        symbol: ' ৳ ',
                                        decimalDigits: (model.payableDetails[index].amount)is int
                                            ? 0
                                            : 2,
                                        locale: "en-in")
                                        .format(model.payableDetails[index].amount),
                                    style: myStyle(
                                        18,
                                        Color(0xffa7ffeb),
                                        FontWeight.w800),
                                  ),

                                ),
                              ),
                            ),
                            Expanded(
                              flex: 1,
                              child:InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) =>
                                                EditStartingPayable(
                                                  model: model.payableDetails[index],
                                                ))).then((value) => setState(() {
                                      fetchStartingPayableData();
                                    }));
                                  },
                                  child: Icon(Icons.edit_outlined,color: Colors.red,)) ,
                            )

                          ],
                        );
                      },
                    ),
                  )
                ],
              ),
            ),
          ),
        )
    );
  }
}
