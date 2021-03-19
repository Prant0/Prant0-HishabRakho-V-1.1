import 'dart:async';
import 'package:connectivity/connectivity.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/entries_Home_Model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/screen/addEntriesCategories.dart';
import 'package:anthishabrakho/screen/addEntriesSubCategories.dart';
import 'package:anthishabrakho/screen/tabs/myStorageHubs.dart';
import 'package:anthishabrakho/screen/tabs/my_situation.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/screen/home_page.dart';
import 'package:anthishabrakho/screen/tabs/add__Entries.dart';
import 'package:anthishabrakho/screen/tabs/myTransection.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:provider/provider.dart';

class MainPage extends StatefulWidget {
  static const String id = 'mainpage';
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> with SingleTickerProviderStateMixin {
  @override
  void initState() {
    tabController=TabController(length:5,vsync: this );
    check().then((intenet) {
      if (intenet != null && intenet) {
        if (mounted) {
          addEntryesHomee();
        }
      } else
        showInSnackBar("No Internet Connection");
    });

    super.initState();
  }

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }

  Future<dynamic> addEntryesHomee() async {
    final data = await CustomHttpRequests.addEntriesHome();
    print("Entries home value are $data");
    for (var entries in data) {
      EntriesHomeModel model = EntriesHomeModel(
          id: entries["id"],
          position: entries["position"],
          classIcon: entries["class_icon"],
          eventClassName: entries["event_class_name"]);
      try {
        print(" view my entries are ${entries['position']}");
        dataa.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        if (mounted) {
          setState(() {
            dataa.add(model);
          });
        }
      }
    }
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }
  TabController tabController;
  int selectedIndex = 0;

  List<EntriesHomeModel> dataa = [];

  Future<bool> onBackPressed(){
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context){
          
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(13.0)
            ),
            title: Text("Are You Sure ?",style: myStyle(16,Colors.black54,FontWeight.w800),),
            content: Text("You are going to exit the app !"),
            actions:<Widget> [
              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop(false);
                  },
                  child: Text("No")
              ),

              FlatButton(
                  onPressed: (){
                    Navigator.of(context).pop(true);
                  },
                  child: Text("Yes")
              )
            ],
          );
    }
    );
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    //dataa = Provider.of<MyTransectionprovider>(context).data;
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      key: _scaffoldKey,
      drawer: Drawerr(_scaffoldKey),
      body: WillPopScope(
        onWillPop: onBackPressed,
        child: Stack(

          children: [
            TabBarView(
              controller: tabController,
              physics: ScrollPhysics(),
              children: [
                HomePage(),
                MyStorageHubs(),
                AddEntriesScreen(),

                MySituationPage(),
                MyTransection(),
              ],
            ),
            Positioned(
              bottom: 9,
              right: 15,
              child: FloatingActionButton(

                elevation: 8,
                onPressed: () {
                 
                  showModalBottomSheet(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.only(topLeft: Radius.circular(13.0),topRight: Radius.circular(13.0))),
                    backgroundColor: BrandColors.colorPrimary,
                      context: context,
                      isScrollControlled: true,
                      builder: (context,) {
                        return FractionallySizedBox(
                          heightFactor: 0.4,
                          child: GridView.builder(
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 3,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2
                            ),
                            itemCount: dataa.length,
                            itemBuilder: (context,index){
                              return GestureDetector(
                                onTap: (){
                                  print("event class name : ${dataa[index].eventClassName}");
                                  dataa[index].eventClassName=="Fund Transfer"? Navigator.push(context, MaterialPageRoute(builder: (context)=>AddEntriesSubCategories(
                                    id: 28,namee: dataa[index].eventClassName,
                                  ))): Navigator.push(context, MaterialPageRoute(builder: (context)=> AddEntriesCategories(
                                    id: dataa[index].id,name: dataa[index].eventClassName,
                                  )));
                                },
                                child: Container(
                                  padding: EdgeInsets.only(top: 12,left: 8),
                                  child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [

                                      Container(
                                        decoration: BoxDecoration(
                                            color: Color(0xFF33324e),
                                            // borderRadius: BorderRadiusDirectional.circular(15),
                                            border: Border.all(color: Colors.grey,width: 1),
                                            borderRadius: BorderRadius.circular(15.0)
                                        ),

                                        child: Image.network(
                                          "http://api.hishabrakho.com/admin/${dataa[index].classIcon}",
                                          width: 60,
                                          height: 50,
                                          fit: BoxFit.fill,
                                        ),
                                        padding: EdgeInsets.symmetric(horizontal: 13,vertical: 13),
                                      ),
                                      SizedBox(height: 6,),
                                      Text(
                                        dataa[index].eventClassName.toString(),
                                        style: myStyle(16, Colors.white),
                                      ),

                                    ],
                                  ),
                                ),
                              );
                            },
                          )
                        );
                      });
                },




                splashColor: Colors.teal,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
                backgroundColor: Colors.deepPurpleAccent,
                child: Icon(
                  Icons.add,
                  color: Colors.white,
                ),
              ),
            )
          ],
        ),
      ),




      bottomNavigationBar: Container(
        margin: EdgeInsets.only(left: 10,right: 10,bottom: 14),
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(12.0),
          color: BrandColors.colorPrimary,),

        child: TabBar(
          labelPadding: EdgeInsets.symmetric(vertical: 0),
          labelColor: Colors.white,
          unselectedLabelColor: BrandColors.colorDimText,
          labelStyle: myStyle(14),
          indicator: UnderlineTabIndicator(borderSide: BorderSide(color: BrandColors.colorDimText,width: 1 ),
            //insets: EdgeInsets.fromLTRB(50, 0.0, 50.0, 40.0)
          ),
          tabs:<Widget> [
            Tab(text: "Home",icon: Icon(Icons.home,size: 21,),),
            Tab(text: "Storage",icon: Icon(Icons.account_tree_outlined,size: 21,),),
            Tab(text: "Budget",icon: Icon(Icons.add_business_sharp,size: 21,),),
            Tab(text: "Reports",icon: Icon(Icons.pages,size: 21,),),
            Tab(text: "Entries",icon: Icon(Icons.anchor_outlined,size: 21,),),
          ],
          controller: tabController,
        ),
      )
    );
  }


  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: myStyle(15, Colors.white),
      ),
      backgroundColor: Colors.purple,
    ));
  }
}
