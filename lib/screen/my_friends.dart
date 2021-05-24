import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/user_model.dart';


class MyFriends extends StatefulWidget {
  @override
  _MyFriendsState createState() => _MyFriendsState();
}

class _MyFriendsState extends State<MyFriends> {

  List<UserModel> friends=[];


  @override
  void initState() {
    getMyFriends();
    super.initState();

  }

  Future<dynamic> getMyFriends() async {
    final data = await CustomHttpRequests.myAllFriends();
    print("My Friends are $data");
    for (var entries in data) {
      UserModel model = UserModel(
          id: entries["id"],
          username: entries["friend_name"],
      );
      try {
        // print(" sub are ${entries['position']}");
        friends.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          friends.add(model);
        });
      }
    }
  }

  Color boxColor = Color(0xFF021A2C);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor:BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor:BrandColors.colorPrimaryDark,
        title: Text(getTranslated(context,'t140'), ),//"My Friends"),
        centerTitle: true,
        elevation: 0,
      ),

      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.only(top: 25),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                  margin: EdgeInsets.symmetric(horizontal:25),
                  child: Text("${getTranslated(context,'t1')}  ${friends.length}" ?? "0",  //total friends
                    style: myStyle(18,Colors.white70),)),

              SizedBox(height: 20,),
              friends.isEmpty ? Center(child: Text('',style: TextStyle(fontSize: 18,color: Colors.white),)) : ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                itemCount: friends.length,
                itemBuilder: (context, index) {
                  return Card(
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
                    elevation: 8,
                    shadowColor: boxColor,
                    margin: EdgeInsets.symmetric(horizontal:25,vertical: 5),
                    color: BrandColors.colorPrimary,
                    child: ListTile(
                      leading:  FaIcon(FontAwesomeIcons.user,size: 20,color: Colors.white70.withOpacity(0.7),),
                      title: Text(
                        friends[index].username ?? "",
                        style: myStyle(16, Colors.white),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      trailing: InkWell(
                        onTap: (){
                          showDialog(
                              context: context,
                              barrierDismissible: false,
                              builder: (BuildContext context){
                                return AlertDialog(
                                  titlePadding: EdgeInsets.only(top: 30,bottom: 12,right: 30,left: 30),
                                  contentPadding: EdgeInsets.only(left: 30,right: 30,),
                                  backgroundColor: BrandColors.colorPrimary,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(13.0)
                                  ),
                                  title: Text("Are You Sure ?",style: myStyle(16,Colors.white,FontWeight.w800),),
                                  content: Text("You want to delete !",style: myStyle(14,Colors.white70,) ,),
                                  actions:<Widget> [
                                    FlatButton(
                                        onPressed: (){
                                          Navigator.of(context).pop(false);
                                        },
                                        child: Text("No",style: myStyle(14,Colors.white),)
                                    ),

                                    RaisedButton(
                                      padding: EdgeInsets.symmetric(vertical: 10,horizontal: 10),
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                                      color: BrandColors.colorPurple,
                                      child: Text('Yes',style: myStyle(14,Colors.white,FontWeight.w500),),
                                      onPressed: (){
                                        print("tap");
                                        CustomHttpRequests.deleteFriends(friends[index].id)
                                            .then((value) => value);
                                        setState(() {
                                          friends.removeAt(index);
                                        });
                                        showInSnackBar(getTranslated(context,'t65'),); //"1 Item Delete",);
                                        Navigator.pop(context);
                                      },
                                    ),


                                  ],
                                );
                              }
                          );
                        },
                        child:  FaIcon(FontAwesomeIcons.trashAlt,size: 20,color: Colors.redAccent,),
                      ),
                    ),
                  );
                },
              )
            ],
          )
        ),
      ),
    );
  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(duration: Duration(seconds: 1),
      content: Text(value,style: myStyle(15,Colors.white,),),
      backgroundColor: Colors.indigo,
    ));
  }
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
}

