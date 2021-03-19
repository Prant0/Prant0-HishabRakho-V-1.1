import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class Details extends StatefulWidget {



  @override
  _DetailsState createState() => _DetailsState();
}

class _DetailsState extends State<Details> {
  Color boxColor = Color(0xFF021A2C);

  double iconSize = 40;

  List<MyTransectionModel> list=[];

  @override
  @override
  Widget build(BuildContext context) {
    list = Provider.of<MyTransectionprovider>(context).details;
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        backgroundColor: Colors.black,
        elevation: 20,
        title: Text(
          "Details",
          style: myStyle(
            17,
            Colors.white,
          ),
        ) ,
      ),
      body:Container(
          padding: EdgeInsets.only(top: 40, left: 15, right: 15),
          child: SingleChildScrollView(
            child: Column(children: <Widget>[


              ListView.builder(
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: list.length,
                itemBuilder: (context,index){
                  return Container(
                    padding: EdgeInsets.symmetric(vertical: 15,horizontal: 10),
                      height: 200,
                      width: MediaQuery.of(context).size.width,
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(15.0),
                          border: Border.all(color: Colors.red,width: 1)
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [

                          Expanded(
                            flex: 4,
                            child: Row(
                              children: [
                                Expanded(
                                  flex: 3,
                                  child: ListView(
                                    children: [
                                      Text("Date",style: TextStyle(fontSize: 16,color: Colors.white,decoration: TextDecoration.underline,decorationColor: boxColor,decorationThickness: 5),textAlign: TextAlign.center,),
                                      Text(list[index].formatedDate ?? "",style: TextStyle(fontSize: 16,color: Colors.white70),textAlign: TextAlign.center,),

                                    ],
                                  ),
                                ),
                                Expanded(
                                  flex: 6,
                                  child: ListView(
                                    children: [
                                      Text("Event Type",style: myStyle(16,Colors.white,FontWeight.w800),textAlign: TextAlign.center,),
                                      Text(list[index].eventType ?? "",style: TextStyle(fontSize: 16,color: Colors.white70),textAlign: TextAlign.center,overflow: TextOverflow.ellipsis,)

                                    ],
                                  ),
                                ),

                                Expanded(
                                  flex: 3,
                                  child: ListView(
                                    children: [
                                      Text("Amount",style: TextStyle(fontSize: 16,color: Colors.white),textAlign: TextAlign.center,),

                                      Text(NumberFormat.currency(
                                          symbol: ' ৳ ',
                                          decimalDigits: (list[index].amount) is int ? 0 :2,
                                          locale: "en-in")
                                          .format(list[index]
                                          .amount) ?? "",style: TextStyle(fontSize: 16,color: Colors.white70),textAlign: TextAlign.center,)
                                    ],
                                  ),
                                ),

                              ],
                            ),
                          ),

                          Expanded(
                            flex: 6,
                            child: SingleChildScrollView(
                              child: Column(
                                //mainAxisAlignment: MainAxisAlignment.spaceAround,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [

                                  Row(
                                    children: [
                                      Text("Transaction Type :  ",style: myStyle(18,Colors.white,FontWeight.w800),),
                                      Text(list[index].transactionTypeName ?? "",style: TextStyle(fontSize: 16,color: Colors.white70),),
                                    ],
                                  ),
                                  list[index].storageHubCategoryId==7 ? Text("Storage Hub =>  Cash",style: TextStyle(fontSize: 16,color: Colors.white70)): Text("Storage Hub =>  ${list[index].storageHubName ?? "No Storage Hub"}  ${list[index].userStorageHubAccountNumber ?? ""}",style: TextStyle(fontSize: 16,color: Colors.white),overflow: TextOverflow.ellipsis, maxLines: 2,),
                                  SizedBox(height: 8,),
                                  RichText(
                                    text: TextSpan(
                                      text: 'Details : ',
                                      style: TextStyle(
                                          fontSize: 16,
                                          color: Colors.white,
                                          fontWeight: FontWeight.w700),
                                      children: <TextSpan>[
                                        TextSpan(
                                          text: '${list[index].details ?? ""}',
                                          style: TextStyle(
                                              color: Colors.white70,
                                              fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),



                                ],
                              ),
                            ),
                          ),

                        ],
                      )
                  );
                },
              ),

            ]),
          )),
    );
  }
}
