import 'package:flutter_svg/flutter_svg.dart';
import 'package:anthishabrakho/screen/profile/my_profile.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/myTransection/earningEntries.dart';
import 'package:anthishabrakho/screen/myTransection/expenditureEntries.dart';
import 'package:anthishabrakho/screen/myTransection/myEntries.dart';
import 'package:anthishabrakho/screen/myTransection/payableEntries.dart';
import 'package:anthishabrakho/screen/myTransection/receivableEntries.dart';
import 'package:anthishabrakho/screen/myTransection/storageEntries.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyTransection extends StatefulWidget {
  static const String id = 'storagehub';

  @override
  _MyTransectionState createState() => _MyTransectionState();
}

class _MyTransectionState extends State<MyTransection> with SingleTickerProviderStateMixin{
  Color textColor = Colors.white;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  /*List<MyTransectionModel> allEntries = [];
  List<MyTransectionModel> receivableEntries = [];
  List<MyTransectionModel> payableEntries = [];
  List<MyTransectionModel> earningEntries = [];
  List<MyTransectionModel> expenditureEntries = [];*/
  List<MyTransectionModel> storageEntries = [];

  @override
  void initState() {
    loadUserDetails();
    //myEntriesDetails();
   // myReceiveableEntries();
   // myPayableEntries();
   // myEarningEntries();
   // myExpenditureEntries();
    controller = TabController(length: 6, vsync: this, initialIndex: 1);
    super.initState();
  }
/*
  myEntriesDetails() async {
    final data =
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyEntriesDetails();
  }

  myReceiveableEntries() async {
    print("recievable entries are");
    final data =
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyRecievableEntries();
  }

  myPayableEntries() async {
    print("Payable entries are");
    final data =
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyPayableEntries();
  }

  myEarningEntries() async {
    print("earning entries are");
    final data =
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyEarningEntries();
  }

  myExpenditureEntries() async {
    print("expenditure entries are");
    final data =
    await Provider.of<MyTransectionprovider>(context, listen: false)
        .getMyExpenditureEntries();
  }*/
  String image;
  SharedPreferences sharedPreferences ;
  loadUserImage()async{
    sharedPreferences = await SharedPreferences.getInstance();
   image= sharedPreferences.getString("image");
    print("image isssssssssssssssssssssssssssssssssssssssssssssssssssssssss $image");
  }


  @override
  void didChangeDependencies() {
    loadUserImage();
    super.didChangeDependencies();
  }



  TabController controller;
  List<UserModel> user = [];
  loadUserDetails()async{
    await Provider.of<UserDetailsProvider>(context,listen: false).getUserDetails();
  }
  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    user=Provider.of<UserDetailsProvider>(context).userData;
    /*allEntries = Provider.of<MyTransectionprovider>(context).myEntriesList;
    receivableEntries =
        Provider.of<MyTransectionprovider>(context).myReceivableEntriesList;
    payableEntries =
        Provider.of<MyTransectionprovider>(context).myPayableEntriesList;
    earningEntries =
        Provider.of<MyTransectionprovider>(context).myEarningEntriesList;
    expenditureEntries =
        Provider.of<MyTransectionprovider>(context).myExpenditureEntriesList;*/
    return Scaffold(
      key: _scaffoldKey,
        backgroundColor: BrandColors.colorPrimaryDark,
        drawer: Drawerr(),
      body:Container(
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
                          child:Text(
                            "Storage",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "All Entries",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Receivable",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Payable",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Earning",
                            style: myStyle(
                                14,
                                BrandColors
                                    .colorDimText),
                          ),
                        ),
                        Tab(
                          child: Text(
                            "Expenditure",
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

                      TransectionStorageEntries(
                          storageEntries
                      ),
                      TransectionMyEntries(
                        //model: allData,
                      ),
                      TransactionReceivableEntries(

                      ),
                      TransactionPayableEntries(

                      ),
                      TransactionEarningEntries(

                      ),
                      TransactionExpenditure(

                      ),

                    ],
                  ),
                ))
          ],
        ),
      )

      /*Container(
        padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(
          color: Colors.black,
        ),
        child: Column(
          children: [
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: transectionCard(
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransectionMyEntries())).then((value) => setState(() {
                          myEntriesDetails();
                          myReceiveableEntries();
                          myPayableEntries();
                          myEarningEntries();
                          myExpenditureEntries();
                        }));
                      },
                      textColor: textColor,
                      g1: Color(0xFF7986cb),
                      g2: Color(0xFF3f51b5),
                      g3: Color(0xFF283593),
                      g4: Color(0xFF1a237e),
                      title: "My",
                      amount: allEntries.length.toString(),
                      subtitle: "Entries",
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: transectionCard(
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransectionStorageEntries(storageEntries)));
                      },
                      textColor: textColor,
                      g1: Color(0xFFffee58),
                      g2: Color(0xFFfbc02d),
                      g3: Color(0xFFf57c00),
                      g4: Color(0xFFe65100),
                      title: "Storage",
                      amount: "",
                      subtitle: " Entries",
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: transectionCard(
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionReceivableEntries(
                                    ))).then((value) => setState(() {
                          myEntriesDetails();
                          myReceiveableEntries();
                          myPayableEntries();
                          myEarningEntries();
                          myExpenditureEntries();
                        }));
                      },
                      textColor: textColor,
                      g1: Color(0xFFff8a65),
                      g2: Color(0xFFff5722),
                      g3: Color(0xFFbf360c),
                      g4: Color(0xFFdd2c00),
                      title: "Receivables",
                      amount: receivableEntries.length.toString(),
                      subtitle: " Entries",
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: transectionCard(
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionPayableEntries())).then((value) => setState(() {
                          myEntriesDetails();
                          myReceiveableEntries();
                          myPayableEntries();
                          myEarningEntries();
                          myExpenditureEntries();
                        }));
                      },
                      textColor: textColor,
                      g1: Color(0xFF4F0076),
                      g2: Color(0xFF7b1fa2),
                      g3: Color(0xFFd500f9),
                      g4: Color(0xFFec407a),
                      title: "Payables",
                      amount: payableEntries.length.toString(),
                      subtitle: " Entries",
                    ),
                  )
                ],
              ),
            ),
            Expanded(
              flex: 5,
              child: Row(
                children: [
                  Expanded(
                    flex: 5,
                    child: transectionCard(
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    TransactionEarningEntries(

                                    ))).then((value) => setState(() {
                          myEntriesDetails();
                          myReceiveableEntries();
                          myPayableEntries();
                          myEarningEntries();
                          myExpenditureEntries();
                        }));
                      },
                      textColor: textColor,
                      g1: Color(0xFF4db6ac),
                      g2: Color(0xFF006064),
                      g3: Color(0xFF00796b),
                      g4: Color(0xFF004d40),
                      title: "Earning",
                      amount: earningEntries.length.toString(),
                      subtitle: " Entries",
                    ),
                  ),
                  Expanded(
                    flex: 5,
                    child: transectionCard(
                      ontap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => TransactionExpenditure(
                                ))).then((value) => setState(() {
                          myEntriesDetails();
                          myReceiveableEntries();
                          myPayableEntries();
                          myEarningEntries();
                          myExpenditureEntries();
                        }));
                      },
                      textColor: textColor,
                      g1: Color(0xFF7986cb),
                      g2: Color(0xFF3f51b5),
                      g3: Color(0xFF283593),
                      g4: Color(0xFF1a237e),
                      title: "Expenditure",
                      amount: expenditureEntries.length.toString(),
                      subtitle: " Entries",
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),*/
    );
  }
}

/*class transectionCard extends StatelessWidget {
  final Color textColor;
  final Color g1;
  final Color g2;
  final Color g3;
  final Color g4;
  final Function ontap;
  final String amount;
  final String title;
  final String subtitle;

  transectionCard(
      {this.textColor,
        this.g1,
        this.g2,
        this.g3,
        this.g4,
        this.ontap,
        this.title,
        this.amount,
        this.subtitle});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: ontap,
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(colors: [
              g1,
              g2,
              g3,
              g4,
            ], begin: Alignment.centerRight, end: Alignment.bottomLeft)),
        margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),

        padding: EdgeInsets.only(top: 15, left: 15, bottom: 10, right: 10),
        //margin: EdgeInsets.only(right: 15),
        child: Row(
          children: [
            Expanded(
                flex: 8,
                child: Container(
                  // color: Colors.black,

                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        amount,
                        style: myStyle(
                            22, Colors.white.withOpacity(0.7), FontWeight.w800),
                      ),

                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            title,
                            style: myStyle(17, textColor, FontWeight.w800),maxLines: 1,overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            subtitle,
                            style: myStyle(17, textColor, FontWeight.w800),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          )
                        ],
                      )
                    ],
                  ),
                )),
            Expanded(
                flex: 3,
                child: Align(
                    alignment: Alignment.bottomRight,
                    child: Icon(
                      Icons.assignment_returned_outlined,
                      size: 25,
                      color: textColor.withOpacity(0.5),
                    )))
          ],
        ),
      ),
    );
  }
}*/

