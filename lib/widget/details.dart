import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
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

  List<MyTransectionModel> list = [];

  @override
  @override
  Widget build(BuildContext context) {
    list = Provider.of<MyTransectionprovider>(context).details;
    return Scaffold(
        backgroundColor: BrandColors.colorPrimaryDark,
        appBar: AppBar(
          centerTitle: true,
          backgroundColor: BrandColors.colorPrimaryDark,
          elevation: 0,
          /*title: Text(
          "${list[0].date}",
          style: myStyle(
            17,
            Colors.white,
          ),
        ) ,*/
        ),
        body: Container(
          padding: EdgeInsets.symmetric(
            horizontal: 15,
          ),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                list[0].friendName == null
                    ? SizedBox(
                        height: 50,
                      )
                    : Center(
                        child: Column(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10.0),
                                  color: BrandColors.colorPrimary),
                              padding: EdgeInsets.all(15),
                              margin: EdgeInsets.only(bottom: 8),
                              child: Image(
                                image: AssetImage(
                                  'assets/user.jpg',
                                ),
                                height: 80,
                                width: 70,
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                              "${list[0].friendName??""}",
                              style: myStyle(
                                18,
                                Colors.white,
                              ),
                            ),
                            Text(
                              "${list[0].eventType??""}",
                              style: myStyle(
                                14,
                                BrandColors.colorDimText,
                              ),
                            )
                          ],
                        ),
                      ),
                Padding(
                  padding: EdgeInsets.only(top: 20, bottom: 5),
                  child: Text(
                    "Transaction type ",
                    style:
                        myStyle(16, BrandColors.colorWhite, FontWeight.w600),
                  ),
                ),
                Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0)
                  ),
                  color: BrandColors.colorPrimary,
                  margin: EdgeInsets.symmetric(vertical: 15),
                  child: Container(
                    width: MediaQuery.of(context).size.width,
                    padding: const EdgeInsets.symmetric(
                        horizontal: 15, vertical: 15),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${list[0].eventSubCategoryName??""}",
                          style: myStyle(
                            16,
                            Colors.white,
                          ),
                        ),
                        SizedBox(height: 2,),
                        Text(
                          "${list[0].formatedDate}",
                          style: myStyle(
                            14,
                            BrandColors.colorDimText,
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),

                        ListView.builder(
                          itemCount: list.length,
                          shrinkWrap: true,
                          scrollDirection: Axis.vertical,
                          itemBuilder: (context,index){
                            return Container(
                              margin: EdgeInsets.symmetric(vertical: 5),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(10.0),
                                color: BrandColors.colorPrimaryDark,
                              ),
                              padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    "${list[index].transactionTypeName}",
                                    style: myStyle(
                                      14,
                                      BrandColors.colorDimText,
                                    ),
                                  ),
                                  Text(
                                    NumberFormat.currency(
                                        symbol: ' ৳ ',
                                        decimalDigits: (list[index].amount) is int
                                            ? 0
                                            : 2,
                                        locale: "en-in")
                                        .format(
                                        list[index].amount?? ""),
                                    style: myStyle(16, Colors.red,FontWeight.w800),
                                  )
                                ],
                              ),
                            );
                          },
                        ),


                        /*list[1]==null?SizedBox(height: 1,): Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            color: BrandColors.colorPrimaryDark,
                          ),
                          padding:
                              EdgeInsets.symmetric(horizontal: 15, vertical: 8),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "${list[1].transactionTypeName??""}",
                                style: myStyle(
                                  14,
                                  Colors.white,
                                ),
                              ),
                              Text(
                                "${list[1].amount}",
                                style: myStyle(
                                  14,
                                  Colors.green,
                                ),
                              ),
                            ],
                          ),
                        ),*/
                        SizedBox(
                          height: 20,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Column(
                              children: [
                                Text(
                                  "Storage : ",
                                  style: myStyle(14, Colors.white),
                                ),Text(
                                  "",
                                ),
                              ],
                            ),
                            list[0].storageHubCategoryId == 7
                                ? Text("Cash",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white70))
                                : Text(
                                    "${list[0].storageHubName ?? "No Storage Hub"} ${"\n"} ${list[0].userStorageHubAccountNumber ?? ""}",
                                    style: TextStyle(
                                        fontSize: 14, color: Colors.white),
                                    overflow: TextOverflow.ellipsis,
                                    maxLines: 2,
                                  ),
                          ],
                        ),
                        
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Expanded(
                              flex: 8,
                              child: Row(
                                children: [
                                  Text("Details   ",style: myStyle(14,Colors.white,FontWeight.w500),),
                                  Expanded(
                                    child: Column(
                                      children: [
                                        Text("${list[0].details ?? "No details added"}",style: myStyle(14,BrandColors.colorDimText,FontWeight.w600),maxLines: 5,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            Expanded(
                              flex: 3,
                              child: FittedBox(
                                child: Row(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    InkWell(
                                      child: Container(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 8, vertical: 8),
                                        alignment: Alignment.center,
                                        margin: EdgeInsets.symmetric(vertical: 2),
                                        decoration: BoxDecoration(
                                            borderRadius:
                                            BorderRadius.circular(5),
                                            border: Border.all(
                                                color:
                                                Colors.deepPurpleAccent)),
                                        child: Icon(
                                          Icons.edit,
                                          size: 20,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        showDialog(
                                            context: context,
                                            barrierDismissible: false,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                shape: RoundedRectangleBorder(
                                                    borderRadius:
                                                    BorderRadius.circular(
                                                        13.0)),
                                                title: Text(
                                                  "Are You Sure ?",
                                                  style: myStyle(
                                                      16,
                                                      Colors.black54,
                                                      FontWeight.w800),
                                                ),
                                                content: Text(
                                                    "You want to delete !"),
                                                actions: <Widget>[
                                                  FlatButton(
                                                      onPressed: () {
                                                        Navigator.of(context)
                                                            .pop(false);
                                                      },
                                                      child: Text("No")),
                                                  FlatButton(

                                                      child: Text("Yes"))
                                                ],
                                              );
                                            });
                                      },
                                      icon: Icon(
                                        Icons.delete_forever_outlined,
                                        color: Colors.redAccent,
                                      ),
                                    )
                                  ],
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        )

        /*Container(
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
          )),*/
        );
  }
}
