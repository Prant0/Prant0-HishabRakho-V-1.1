import 'dart:convert';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/entries_Home_Model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/storageHubProvider.dart';

import 'package:anthishabrakho/screen/addEntriesCategories.dart';
import 'package:anthishabrakho/screen/addEntriesSubCategories.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:provider/provider.dart';

class AddEntriesScreen extends StatefulWidget {
  @override
  _AddEntriesScreenState createState() => _AddEntriesScreenState();
}

class _AddEntriesScreenState extends State<AddEntriesScreen> {
  List<EntriesHomeModel> dataa = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() {

    check().then((intenet) {
      if (intenet != null && intenet) {
        if (mounted) {
          addEntryesHome();
        }
      }
      else showInSnackBar("No Internet Connection");
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

  addEntryesHome()async{
    await Provider.of<MyTransectionprovider>(context,listen: false).addEntryesHome();
  }

  @override
  Widget build(BuildContext context) {
    dataa = Provider.of<MyTransectionprovider>(context).data;
    return Scaffold(
      drawer: Drawerr(),
      key: _scaffoldKey,
      backgroundColor: Colors.black,
      appBar: AppBar(
        leadingWidth: 70,
        leading: InkWell(
            onTap: (){
              print("tap");
              _scaffoldKey.currentState.openDrawer();
            },
            child: Icon(Icons.menu,size: 30,color: Colors.purple,)),
        backgroundColor: Colors.black,
        title: Text(
          "Add Entries",
          style: myStyle(18, Colors.white70),textAlign: TextAlign.center,
        ),
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 15,vertical: 20),
          height: double.infinity,
          width: double.infinity,
          child:dataa.isNotEmpty? GridView.builder(
            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 20,
                mainAxisSpacing: 10
            ),
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            scrollDirection: Axis.vertical,
            itemCount: dataa.length,
            itemBuilder: (context, index) {
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
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadiusDirectional.circular(15),
                      border: Border.all(color: Colors.grey,width: 1),
                      borderRadius: BorderRadius.circular(15.0)
                  ),
                  width: MediaQuery.of(context).size.width / 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [

                      Image.network(
                        "http://api.hishabrakho.com/admin/${dataa[index].classIcon}",
                        width: 60,
                        height: 50,
                        fit: BoxFit.fill,
                      ),
                      SizedBox(height: 5,),
                      Text(
                        dataa[index].eventClassName.toString(),
                        style: myStyle(18, Colors.white),
                      ),

                    ],
                  ),
                  margin: EdgeInsets.symmetric(vertical: 20),
                ),
              );
            },
          ) :Center(child: SpinKitFadingCircle(
            itemBuilder:
                (BuildContext context, int index) {
              return DecoratedBox(
                decoration: BoxDecoration(
                  color: index.isEven
                      ? Colors.purpleAccent
                      : Colors.purple,
                ),
              );
            },
          ),)

      ),
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

