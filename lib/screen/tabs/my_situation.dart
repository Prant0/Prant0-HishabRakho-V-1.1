import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';
import 'package:anthishabrakho/models/my_situation%20model.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/viewMySituation.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';
class MySituationPage extends StatefulWidget {
  static const String id = 'mysituation';

  @override
  _MySituationPageState createState() => _MySituationPageState();
}

class _MySituationPageState extends State<MySituationPage> {
  Color textColor = Colors.white.withOpacity(0.7);
  List<MySituationModel> payablee = [];
  List<MySituationModel> receiveable = [];
  List<UserModel> user = [];

  UserModel userModel;

  @override
  void initState() {
    getreceiveableDetails();
    getPayableDetails();
    loadUserDetails();
    super.initState();
  }
  MySituationModel model;


  loadUserDetails()async{
    await Provider.of<UserDetailsProvider>(context,listen: false).getUserDetails();
  }

  SharedPreferences sharedPreferences;
  List<DashBoardModel> allData = [];
  DashBoardModel dashBoardModel;



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  Widget build(BuildContext context) {
    user=Provider.of<UserDetailsProvider>(context).userData;
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      drawer: Drawerr(_scaffoldKey),
      body: Container(
        padding: EdgeInsets.only(top: 26, left: 15, right: 15),
        height: double.infinity,
        width: double.infinity,
        decoration: BoxDecoration(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              flex: 2,
              child: ListView.builder(
                physics: NeverScrollableScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: user.length,
                itemBuilder: (context, index) {
                  return ListTile(
                    leading: CircleAvatar(
                      radius: 30,
                      backgroundImage: NetworkImage(
                          'http://hishabrakho.com/admin/user/${user[index].photo}'),
                    ),
                    title: Text(
                      "${user[index].username}" ?? "name",
                      style: myStyle(16, Colors.white, FontWeight.w800),
                    ),
                    subtitle: Text(
                      "${user[index].email}" ?? "email",
                      style: myStyle(14, textColor, FontWeight.w600),
                    ),
                    trailing: InkWell(
                      onTap: () {
                        _scaffoldKey.currentState.openDrawer();
                      },
                      child: Icon(
                        Icons.menu,
                        size: 40,
                        color: textColor,
                      ),
                    ),
                  );
                },
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  String title = "My Payable";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewMySituation(
                                payable: payablee,
                                title: title,
                              )));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0)),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  shadowColor: Colors.deepOrange,
                  elevation: 10,
                  child: Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(16.0),
                          gradient: LinearGradient(
                              begin: Alignment.bottomRight,
                              end: Alignment.topLeft,
                              colors: [
                                Color(0xFFff8a65),
                                Color(0xFFff5722),
                                Color(0xFFdd2c00),
                                Color(0xFFbf360c),
                              ])),
                      height: double.infinity,
                      width: double.infinity,
                      child: Row(
                        children: [
                          Expanded(
                            flex: 1,
                            child: CircleAvatar(
                              maxRadius: 0,
                              backgroundColor: Colors.white,
                            ),
                          ),
                          Expanded(
                            flex: 6,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "My Payable   ",
                                  style: myStyle(30, textColor),
                                  textAlign: TextAlign.center,
                                ),
                                SizedBox(
                                  height: 1,
                                ),
                                ListView.builder(
                                  shrinkWrap: true,
                                  scrollDirection: Axis.vertical,
                                  itemCount: allData.length,
                                  itemBuilder: (context, index) {
                                    return Text(
                                      NumberFormat.currency(
                                              symbol: ' ৳ ',
                                              decimalDigits: 0,
                                              locale: "en-in")
                                          .format(dashBoardModel.totalPayable),
                                      style: myStyle(
                                          22, Colors.white, FontWeight.w800),
                                      textAlign: TextAlign.center,
                                    );
                                  },
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                              flex: 2,
                              child: Container(
                                padding: EdgeInsets.only(bottom: 15, top: 15),
                                child: Column(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      payablee.length.toString() ?? "0",
                                      style: myStyle(30, Colors.white),
                                    ),
                                    Icon(
                                      Icons.ac_unit,
                                      color: Colors.white,
                                    ),
                                  ],
                                ),
                              )),
                        ],
                      )),
                ),
              ),
            ),
            Expanded(
              flex: 5,
              child: GestureDetector(
                onTap: () {
                  String title = "My Receivable";
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ViewMySituation(
                                payable: receiveable,
                                title: title,
                              )));
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(17.0)),
                  margin: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                  shadowColor: Colors.teal,
                  elevation: 8,
                  child: Container(
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(16.0),
                        gradient: LinearGradient(
                            begin: Alignment.bottomRight,
                            end: Alignment.topLeft,
                            colors: [
                              Color(0xFF4db6ac),
                              Color(0xFF00796b),
                              Color(0xFF006064),
                              Color(0xFF004d40),
                            ])),

                    height: double.infinity,
                    width: double.infinity,
                    child: Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: CircleAvatar(
                            maxRadius: 0,
                            backgroundColor: Colors.white,
                          ),
                        ),
                        Expanded(
                          flex: 6,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                "My Receivable   ",
                                style: myStyle(30, textColor),
                                textAlign: TextAlign.center,
                              ),
                              SizedBox(
                                height: 1,
                              ),
                              ListView.builder(
                                shrinkWrap: true,
                                scrollDirection: Axis.vertical,
                                itemCount: allData.length,
                                itemBuilder: (context, index) {
                                  return Text(
                                    NumberFormat.currency(
                                            symbol: ' ৳ ',
                                            decimalDigits: 0,
                                            locale: "en-in")
                                        .format(dashBoardModel.totalReceivable ?? ""),
                                    style: myStyle(
                                        22, Colors.white, FontWeight.w800),
                                    textAlign: TextAlign.center,
                                  );
                                },
                              ),
                            ],
                          ),
                        ),
                        Expanded(
                            flex: 2,
                            child: Container(
                              padding: EdgeInsets.only(bottom: 15, top: 15),
                              child: Column(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    receiveable.length.toString() ?? "0",
                                    style: myStyle(30, Colors.white),
                                  ),
                                  Icon(
                                    Icons.ac_unit,
                                    color: Colors.white,
                                  ),
                                ],
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
  Future<dynamic> getPayableDetails()async{
    final data = await CustomHttpRequests.myPayableData();
    for (var payable in data){
      MySituationModel model =MySituationModel(
        amount: payable["amount"],
        id: payable["id"],
        name: payable["friend_name"],
      );
      try{
        payablee.firstWhere((element) => element.id==payable['id']);
      }catch(e){
        if(mounted){
          setState(() {
            payablee.add(model);
          });
        }
      }
    }
  }


  Future<dynamic> getreceiveableDetails()async{
    final data = await CustomHttpRequests.myreceiveableData();
    for (var payable in data){
      model =MySituationModel(
        amount: payable["amount"],
        id: payable["id"],
        name: payable["friend_name"],
      );
      try{
        receiveable.firstWhere((element) => element.id==payable['id']);
      }catch(e){
        if(mounted){
          setState(() {
            receiveable.add(model);
          });
        }
      }
    }
  }
}
