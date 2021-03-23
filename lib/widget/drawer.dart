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
          color: Colors.black,
          child: ListView(
            padding: EdgeInsets.all(0),
            children: [

              Container(
                color: Colors.black,
                //height: 200,
                padding: EdgeInsets.symmetric(vertical: 50),
                child:  ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        GestureDetector(

                          child: CircleAvatar(
                            backgroundImage: NetworkImage("http://hishabrakho.com/admin/user/${user[index].photo}",
                            ),

                            maxRadius: 50,
                          ),

                        /*ClipRRect(
                            borderRadius: BorderRadius.circular(100.0),
                            child: CachedNetworkImage(
                              imageUrl:
                              'http://hishabrakho.com/admin/user/${user[index].photo}',height: 80.0,
                              fit: BoxFit.cover,
                              placeholder: (context, url) => Padding(
                                child: CircularProgressIndicator(
                                  value: 5.0,
                                  backgroundColor: Colors.purple,
                                ),
                                padding: EdgeInsets.all(20.0),
                              ),
                              errorWidget: (context, url, error) => Icon(Icons.error),
                            ),
                          ),*/
                          onTap: (){
                            Navigator.pop(context);
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                          },
                        ),
                        SizedBox(height: 8,),
                        Text(
                          "${user[index].username}",
                          style: myStyle(20, Colors.white, FontWeight.w800),
                        ),
                        SizedBox(height: 8,),
                        Text(
                          "${user[index].email}",
                          style: myStyle(14, Colors.white, FontWeight.w600),
                        ),


                      ],
                    );
                  },
                ),
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
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                      },
                      child: Container(

                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.person,size: 35,color: Colors.purple.shade300,),
                              SizedBox(
                                width: 15,
                              ),
                              Text("My Profile",style: myStyle(15,Colors.white70),),

                            ],
                          )
                      ),
                    ),
                    Divider(color: Colors.purpleAccent.withOpacity(0.5),height: 1,thickness: 1,),

                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                        Navigator.push(context, MaterialPageRoute(builder: (context)=>MyFriends()));
                      },
                      child: Container(

                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.people_alt_outlined,size: 35,color: Colors.purple.shade300,),
                              SizedBox(
                                width: 15,
                              ),
                              Text("My Friends",style: myStyle(15,Colors.white70),),

                            ],
                          )
                      ),
                    ),


                    Divider(color: Colors.purpleAccent.withOpacity(0.5),height: 1,thickness: 1,),

                    InkWell(onTap: (){
                      displayTextInputDialog(context);

                    },
                      child: Container(
                          margin: EdgeInsets.symmetric(vertical: 10),
                          height: 50,
                          child: Row(
                            children: [
                              Icon(Icons.assignment_returned_outlined,size: 35,color: Colors.purple.shade300,),
                              SizedBox(
                                width: 15,
                              ),
                              Text("Log Out",style: myStyle(15,Colors.white70),),
                            ],
                          )
                      ),
                    ),
                    Divider(color: Colors.purpleAccent.withOpacity(0.5),height: 1,thickness: 1,),
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
