import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/my_friends.dart';
import 'package:anthishabrakho/screen/profile/my_profile.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
class Drawerr extends StatefulWidget {
  final GlobalKey<ScaffoldState> sKey;
  Drawerr(this.sKey);
  @override
  _DrawerrState createState() => _DrawerrState();
}

class _DrawerrState extends State<Drawerr> {
  List<UserModel> user = [];


  @override
  void initState() {
    loadUserData();
    super.initState();
  }





  loadUserData() async {
    print("expenditure entries are");
    final data = await Provider.of<UserDetailsProvider>(context, listen: false)
        .getUserDetails();
    print("aaaaaaaaaaaaaaaa${data}");
  }
  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserDetailsProvider>(context).userData;
    return SizedBox(
      width: MediaQuery.of(context).size.width-120,
      child: Drawer(

        child: Container(
          color: BrandColors.colorPrimaryDark,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [

              Container(

                //height: 200,
                padding: EdgeInsets.only(top: 50,left: 25,bottom: 25),
                child:  ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        GestureDetector(

                          child: Image.network(
                              "http://hishabrakho.com/admin/user/${user[index].photo}",height: 100,width: 85,fit: BoxFit.cover,
                          ),

                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                          },
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "${user[index].username}",
                          style: myStyle(20, Colors.white, FontWeight.w800),
                        ),

                        Text(
                          "${user[index].email}",
                          style: myStyle(14, BrandColors.colorDimText, FontWeight.w600),
                        ),



                      ],
                    );
                  },
                ),
              ),
              Divider(

                thickness: 0.5,color:  BrandColors.colorDimText,
              ),
              Container(
               // color: Colors.black,
                padding: EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  children: [

                    SizedBox(height: 15,),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        //Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                      },
                      child: Container(

                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.home_outlined,size: 25,color: BrandColors.colorDimText,),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Home",style: myStyle(16,Colors.white70),),

                            ],
                          )
                      ),
                    ),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                      },
                      child: Container(

                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.person,size: 25,color: BrandColors.colorDimText,),
                              SizedBox(
                                width: 16,
                              ),
                              Text("My Profile",style: myStyle(16, BrandColors.colorDimText,),),

                            ],
                          )
                      ),
                    ),

                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFriends()));
                      },
                      child: Container(

                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.people_alt_outlined,size: 25,color:  BrandColors.colorDimText,),
                              SizedBox(
                                width: 16,
                              ),
                              Text("My Friends",style: myStyle(16, BrandColors.colorDimText,),),

                            ],
                          )
                      ),
                    ),



                    InkWell(onTap: (){
                      displayTextInputDialog(context);

                    },
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.assignment_returned_outlined,size: 25,color: BrandColors.colorDimText,),
                              SizedBox(
                                width: 16,
                              ),
                              Text("Log Out",style: myStyle(16, BrandColors.colorDimText,),),
                            ],
                          )
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Image(
                        image: AssetImage('assets/lgo.png'),
                        //height: 130.0,
                        //width: 130.0,
                      ),
                    ),
                    ],
                ),
              )

            ],
          ),
        ),
        elevation: 10,
      ),
    );
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Are you sure want to Logout ?'),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),

              FlatButton(
                color: Colors.purple,
                textColor: Colors.white,
                child: Text('OK'),
                onPressed: () async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('token');
                  await preferences.remove('userName');
                  Provider.of<UserDetailsProvider>(context,listen: false).deletedetails();
                  Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  //Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage()));
                  Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>LoginScreen()));
                },
              ),
            ],
          );
        });
  }
}
