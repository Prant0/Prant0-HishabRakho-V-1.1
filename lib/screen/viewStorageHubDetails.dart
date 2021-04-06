

import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ViewStorageHubDetails extends StatefulWidget {
  final int id;
  final String name;
  final String image;
  final dynamic number;

  ViewStorageHubDetails({this.id, this.name,this.image,this.number});

  @override
  _ViewStorageHubDetailsState createState() => _ViewStorageHubDetailsState();
}

class _ViewStorageHubDetailsState extends State<ViewStorageHubDetails> {
  bool onProgress = false;
  Color boxColor = Color(0xFF021A2C);
  List<MyTransectionModel> dataa = [];

  @override
  Widget build(BuildContext context) {
    print("id is ${widget.id}");
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(widget.name ?? "Cash"),
      ),
      body: ModalProgressHUD(
        inAsyncCall: onProgress,
        child: Column(children: [
          Container(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10.0),
                    color: BrandColors.colorPrimary
                  ),
                  padding: EdgeInsets.symmetric(vertical: 23,horizontal: 12),
                  child: Card(
                    elevation: 15.0,
                      child: Image.network("http://hishabrakho.com/admin/storage/hub/${widget.image}",height: 40,width: 60,fit: BoxFit.fill,)),
                ),
                SizedBox(height: 10,),
                Text(" ${widget.name}",style: myStyle(18,BrandColors.colorWhite,FontWeight.w500),),
                SizedBox(height: 5,),
                Text("${widget.number}",style: myStyle(14,BrandColors.colorText,FontWeight.w400),)
              ],
            ),
          ),
          Padding(
            padding:EdgeInsets.only(top: 26),
            child: Divider(
              color: BrandColors.colorText.withOpacity(0.2),
              thickness:1,
            ),
          ),
          Container(
            padding: EdgeInsets.only(left: 0),
            margin: EdgeInsets.symmetric(vertical: 12,horizontal: 12),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 5,
                  child: Text("Title", style: myStyle(12, BrandColors.colorDimText.withOpacity(0.5),FontWeight.w400),),
                ),
                Expanded(
                  flex: 4,
                  child: Text("Transaction", style:  myStyle(12, BrandColors.colorDimText.withOpacity(0.5),FontWeight.w400),),
                ),
                Expanded(
                  flex: 3,
                  child: Text("Balance", style: myStyle(12, BrandColors.colorDimText.withOpacity(0.5),FontWeight.w400),),
                ),
              ],
            ),
          ),
          dataa.isEmpty?Center(child: Text("Empty List",style: myStyle(18,Colors.white,FontWeight.w600),),)  :ListView.builder(
              physics: BouncingScrollPhysics(),
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              itemCount: dataa.length,
              itemBuilder: (context, index) {
                return Slidable(
                  actionPane: SlidableDrawerActionPane(),
                  actionExtentRatio: 0.25,
                  child: new Container(
                      margin: EdgeInsets.only(left: 15),
                      padding: EdgeInsets.symmetric(vertical: 10,),
                      child: Row(
                        children: [
                          Expanded(
                            flex: 5,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "${dataa[index].friendName??""}",style: myStyle(14,Colors.white,FontWeight.w500),
                                ),
                                SizedBox(height: 3,),
                                Text(
                                  "${dataa[index].date ?? ""}",style: myStyle(12,BrandColors.colorDimText.withOpacity(0.6),FontWeight.w400),
                                )
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 3,
                              child: Text(
                                NumberFormat.currency(
                                    symbol: '',
                                    decimalDigits: (dataa[index]
                                        .amount) is int ? 0 :2,
                                    locale: "en-in").format(dataa[index].amount),
                                style: myStyle(
                                    12,dataa[index].amount>1? Colors.greenAccent:Colors.redAccent,FontWeight.w400),
                              )
                          ),

                          Expanded(
                            flex: 3,
                            child: Text(
                              NumberFormat.currency(
                                  symbol: ' ৳ ',
                                  decimalDigits: (dataa[index]
                                      .balance??"") is int ? 0 :2,
                                  locale: "en-in").format(dataa[index].balance??""),
                              style: myStyle(
                                  12, Colors.white,FontWeight.w400),
                            ),
                          ),
                        ],
                      )
                  ),
                );
              }
          )

        ]

        ),
      ),
    );
  }

  Future<dynamic> getData() async {
    setState(() {
      onProgress = true;
    });
    final data = await CustomHttpRequests.viewStorageEntries(widget.id);
    print("bank data areee $data");
    setState(() {
      onProgress = false;
    });
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        eventId: entries["event_id"],
        transactionTypeId: entries["transaction_type_id"],
        userPersonalStorageHubId: entries["user_personal_storage_hub_id"],
        amount: entries["amount"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        date: entries["formated_date"],
        friendName: entries["friend_name"],
        eventSubCategoryName: entries["event_sub_category_name"],
      );
      try {
        dataa.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          // onProgress=false;
          dataa.add(model);
        });
      }
    }
  }

  @override
  void initState() {
    getData();
    super.initState();
  }
}
