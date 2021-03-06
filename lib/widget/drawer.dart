import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/select_language.dart';
import 'package:flutter_svg/flutter_svg.dart';
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
 // final GlobalKey<ScaffoldState> sKey;
//  Drawerr(this.sKey);
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
          child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        ClipRRect(
                          
                          child: GestureDetector(

                            child: Image.network(
                                "http://hishabrakho.com/admin/user/${user[index].photo}",height: 90,width: 75,fit: BoxFit.cover,
                            ),

                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>MyProfile()));
                            },
                          ),
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        SizedBox(height: 10,),
                        Text(
                          "${user[index].username}",
                          style: myStyle(20, Colors.white, FontWeight.w500),
                        ),

                        Text(
                          "${user[index].email}",
                          style: myStyle(14, BrandColors.colorDimText, FontWeight.w500),
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
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    Container(

                      height: MediaQuery.of(context).size.height / 2,
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
                                    SvgPicture.asset("assets/home.svg",
                                      alignment: Alignment.center,
                                      fit: BoxFit.contain,

                                    ),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text( getTranslated(context,'t12'),  // home
                                      style: myStyle(16,BrandColors.colorText),),

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
                                    Icon(Icons.person,size: 25,color:  BrandColors.colorText,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text( getTranslated(context,'t27'),  //my profile
                                      style: myStyle(16, BrandColors.colorDimText,),),

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
                                    Icon(Icons.people_outline,size: 25,color:  BrandColors.colorText,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text( getTranslated(context,'t28'), //my friends
                                       style: myStyle(16, BrandColors.colorDimText,),),

                                  ],
                                )
                            ),
                          ),
                          InkWell(
                            onTap: (){
                              Navigator.pop(context);
                              Navigator.push(context, MaterialPageRoute(builder: (context)=>SelectLanguage()));

                          },
                            child: Container(
                              //  margin: EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(Icons.translate,size: 25,color:   BrandColors.colorText,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text( getTranslated(context,'t29'),  //choose language
                                      style: myStyle(16, BrandColors.colorDimText,),),
                                  ],
                                )
                            ),
                          ),

                          InkWell(
                            onTap: (){
                              displayTextInputDialog(context);

                            },
                            child: Container(
                              //  margin: EdgeInsets.symmetric(vertical: 10),
                                height: 50,
                                child: Row(
                                  children: [
                                    Icon(Icons.assignment_returned_outlined,size: 25,color:   BrandColors.colorText,),
                                    SizedBox(
                                      width: 15,
                                    ),
                                    Text( getTranslated(context,'t30'), //logout

                                      style: myStyle(16, BrandColors.colorDimText,),),
                                  ],
                                )
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      child: Image(
                        image: AssetImage('assets/lgo.png'),
                        width: 200,height: 45,
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
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            titlePadding: EdgeInsets.only(top: 30,bottom: 12,right: 20,left: 30),
            contentPadding: EdgeInsets.only(left: 30,right: 20,),
            backgroundColor:  BrandColors.colorPrimaryDark,
            title: Text('Log out from the app?'),
            actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
            content: Text("Make sure you have checked everything you wanted to.",),
            contentTextStyle: myStyle(14,BrandColors.colorText.withOpacity(0.7),FontWeight.w400),
            titleTextStyle: myStyle(18,Colors.white,FontWeight.w500),
            actions: <Widget>[
              FlatButton(
                color: Colors.transparent,
                textColor: Colors.white,
                child: Text('Cancel',style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  Navigator.pop(context);
                },
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text('Logout',style: myStyle(14,Colors.white,FontWeight.w500),),
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
