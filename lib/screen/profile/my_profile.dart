import 'dart:convert';
import 'package:anthishabrakho/models/Starting_receivable_model.dart';
import 'package:anthishabrakho/localization/localization_Constants.dart';
import 'package:anthishabrakho/screen/profile/reset_password.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/select_language.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/starting_payable_Model.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/profile/edit_profile_info.dart';
import 'package:anthishabrakho/screen/stapper/addBank.dart';
import 'package:anthishabrakho/screen/starting_balance/Add_Starting_balance.dart';
import 'package:anthishabrakho/screen/starting_balance/my_Starting_Balance.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyProfile extends StatefulWidget {
  @override
  _MyProfileState createState() => _MyProfileState();
}

class _MyProfileState extends State<MyProfile> {
  List<UserModel> user = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool _obscureText = true;
  String valueText;
  TextEditingController _textFieldController = TextEditingController();

  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();

/*
  SharedPreferences sharedPreferences ;
  String userName;
  String image;
  loadUser()async{
    sharedPreferences = await SharedPreferences.getInstance();
    userName= sharedPreferences.getString("userName");
    print("user anme issssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssssss ${userName}");
    image= sharedPreferences.getString("image");print("image is $image");
  }
*/

  List<StartingPayableModel> payableData = [];
  StartingPayableModel model;

  bool onProgress = false;

  Future<dynamic> fetchStartingPayableData() async {
    payableData.clear();
    setState(() {
      onProgress = true;
    });
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/payable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting payable details are   ::  ${response.body}");
    if (this.mounted) {
      setState(() {
        totalPayable = jsonResponce["total"];

        print("tttttttttttttttttttttt $totalPayable");
      });
    }
  }

  List<StartingReceivableModel> receivableData = [];
  StartingReceivableModel modell;
  dynamic totalReceivable;
  dynamic totalPayable;

  void fetchStartingReceivableData() async {
    receivableData.clear();
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/receivable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting Receivable details are   ::  ${response.body}");
    if (this.mounted) {
      setState(() {
        totalReceivable = jsonResponce["total"];
        print("tttttttttttttttttttttt $totalReceivable");
      });
    }
  }

  @override
  void initState() {
    loadUserData();
    fetchStartingPayableData();
    fetchStartingReceivableData();
    // loadUser();
    super.initState();
  }

  loadUserData() async {
    print("User data  are");
    final data = await Provider.of<UserDetailsProvider>(context, listen: false)
        .getUserDetails();
    print("aaaaaaaaaaaaaaaa${data}");
  }

  @override
  Widget build(BuildContext context) {
    user = Provider.of<UserDetailsProvider>(context).userData;
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      progressIndicator: Spin(),
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: BrandColors.colorPrimaryDark,
        appBar: AppBar(
          elevation: 0,
          backgroundColor: BrandColors.colorPrimaryDark,
          title: Text(
            getTranslated(context,'t27'), //my profile
            style: myStyle(20, Colors.white, FontWeight.w500),
          ),
        ),
        body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              ListView.builder(
                shrinkWrap: true,
                itemCount: user.length,
                itemBuilder: (context,index){
                  return ListTile(
                    contentPadding: EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                    leading: ClipRRect(
                      child: Image.network(
                        "http://hishabrakho.com/admin/user/${user[index].photo}",
                        height: 70,
                        width: 70,
                        fit: BoxFit.cover,
                      ),
                      borderRadius: BorderRadius.circular(8.0),
                    ),




                    trailing: SvgPicture.asset(
                      "assets/barCode.svg",
                      alignment: Alignment.center,
                      height: 22,
                      width: 22,
                    ),
                    title: Text(
                      "${user[index].username}",
                      style: myStyle(22, Colors.white, FontWeight.w500),
                    ),
                    subtitle: Text(
                      "${user[index].email}",
                      style: myStyle(14, Colors.grey, FontWeight.w400),
                    ),
                  );
                },
              ),
              Padding(
                padding: EdgeInsets.all(12.0),
                child: Text(getTranslated(context,'t31') //my starting balance
                  ,style: myStyle(14,BrandColors.colorText,FontWeight.w400),),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => MyStartingBalance(


                          )));
                },
                child: Card(
                    color: BrandColors.colorPrimary,
                    //height: 60,

                    margin:
                    EdgeInsets.symmetric( horizontal: 8),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10.0)),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                          vertical: 25, horizontal: 25),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated(context,'t32'), //payables
                                style:
                                myStyle(12, Colors.redAccent,FontWeight.w400),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                NumberFormat.compactCurrency(
                                  symbol: ' ??? ',
                                ).format(totalPayable ?? 0),
                                style: myStyle(16, BrandColors.colorWhite,FontWeight.w700),
                              ),
                            ],
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                getTranslated(context,'t33'),  //receivables
                                style:
                                myStyle(12, BrandColors.colorGreen,FontWeight.w400),
                              ),
                              SizedBox(
                                height: 4,
                              ),
                              Text(
                                NumberFormat.compactCurrency(
                                  symbol: ' ??? ',
                                ).format(totalReceivable ?? 0),
                                style: myStyle(16, BrandColors.colorWhite,FontWeight.w700),
                              )
                            ],
                          ),
                          GestureDetector(
                            onTap: () {
                              String type = "payable";
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          AddStartingBalance(
                                            title: type,
                                          ))).then((value) => setState(() {
                                fetchStartingPayableData();
                                fetchStartingReceivableData();
                              }));
                            },


                            child: Container(
                              padding: EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 10),
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(
                                      color: Colors.deepPurpleAccent)),
                              child: Icon(
                                Icons.add,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ],
                      ),
                    )),
              ),
              SizedBox(height: 8,),
              ProfileButton(
                title: getTranslated(context,'t34'),  //edit profile
                icon: Icons.person,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => EditInfo(
                            model: user[0],
                          )));
                },
              ),
              ProfileButton(
                    title: getTranslated(context,'t29'), //notification
                    icon: Icons.language,
                    onPress: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => SelectLanguage())).then((value) => setState((){
                                loadUserData();
                      }));
                    },
                  ),
              ProfileButton(
                title: getTranslated(context,'t36'),                                //change password
                icon: Icons.lock,
                onPress: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ResetPassword()));
                },
              ),
              /*ProfileButton(
                    title: getTranslated(context,'t37'),                              //help center
                     icon: Icons.help_rounded,
                    onPress: () {},
                  ),
                  ProfileButton(
                    title: getTranslated(context,'t38'),                             // invite friends
                    icon: Icons.share,
                    onPress: () {},
                  ),*/
              Spacer(),
              Divider(
                color: Color(0xFF9fa8da),
                height: 15,
                thickness: .4,
              ),
              GestureDetector(
                onTap: () {
                  _displayTextInputDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8, horizontal: 25),
                  child: Text(
                    getTranslated(context,'t39'),                                       //reset all data
                    style: myStyle(16, BrandColors.colorPurple),
                  ),
                ),
              ),


              GestureDetector(
                onTap: () {
                  displayTextInputDialog(context);
                },
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 0, horizontal: 25),
                  child: Text(
                    getTranslated(context,'t30'),                                      //logout
                    style: myStyle(16, BrandColors.colorPurple),
                  ),
                ),
              ),
              SizedBox(
                height: 25,
              )

            ],
          )
        ),
      ),
    );
  }

  String y;

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
      
        context: context,
        builder: (context) {
          return AlertDialog(
            elevation: 1,
            actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
            titlePadding: EdgeInsets.only(top: 30,bottom: 8,right: 30,left: 30),
            contentPadding: EdgeInsets.only(left: 30,right: 30,),
            backgroundColor: BrandColors.colorPrimaryDark,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0)),
            title: Text( getTranslated(context,'t39'), //reset all data
           ),
            titleTextStyle: myStyle(18,Colors.white,FontWeight.w500),


            content: Form(
              key: _formKey,
              child: Container(
                height: 100,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                     Text(getTranslated(context,'t135')              //"Please enter your password"
                       ,style: myStyle(14,BrandColors.colorText.withOpacity(0.7),FontWeight.w400),),

                    TextFormField(
                      style: myStyle(14.0, BrandColors.colorDimText,FontWeight.w400),
                      // onSaved: (val) => y = val,
                      controller: _textFieldController,
                      validator: (String value) {
                        if (value.isEmpty) {
                          return  getTranslated(context,'t137'); // "Password required";
                        }
                        if (value.length < 6) {
                          return getTranslated(context,'t128'); // "Password Too Short ( 6 - 15 character )";
                        }
                        if (value.length > 15) {
                          return getTranslated(context,'t129'); // "Password Too Long ( 6 - 15 character )";
                        }
                      },
                      decoration: InputDecoration(
                        suffixIcon: GestureDetector(
                          onTap: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                          child: Icon(
                            _obscureText
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Color(0xFFD2DCF7).withOpacity(0.6),
                            size: 18,
                          ),
                        ),
                        contentPadding: EdgeInsets.symmetric(vertical: 20),
                        focusedBorder:OutlineInputBorder(
                          borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
                          borderRadius: BorderRadius.circular(12.0),
                        ),

                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12.0),
                          borderSide: BorderSide(
                            color: Colors.transparent,
                            width: 2.0,
                          ),
                        ),
                        filled: true,
                        hintStyle:  myStyle(14, BrandColors.colorDimText),
                        fillColor: BrandColors.colorPrimary,
                        prefixIcon:Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: SvgPicture.asset("assets/pass.svg",
                            alignment: Alignment.center,
                            height: 15,width: 15,
                          ),
                        ),
                        hintText:getTranslated(context,'t135'), // 'Enter your password',
                      ),
                      obscureText: _obscureText,
                      cursorColor: Colors.white70,
                    ),
                  ],
                ),
              ),

            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.transparent,
                textColor: Colors.white,
                child: Text(getTranslated(context,'t136'), // 'Cancel',
          style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),

              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,

                child: Text(getTranslated(context,'t39'), //   'Reset All Data',
                  style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  if (!_formKey.currentState.validate()) return;
                  _formKey.currentState.save();
                  setState(() {
                    //codeDialog = valueText;
                    resetPassword();
                    Navigator.pop(context);
                    _textFieldController.clear();
                  });
                },
              ),


            ],
          );
        });
  }

  resetPassword() async {
    try {
      setState(() {
        isLoading = true;
      });
      final result = await CustomHttpRequests.resetAllData(
          _textFieldController.text.toString());
      final data = jsonDecode(result);
      setState(() {
        isLoading = false;
      });
      if (data != null) {
        Provider.of<MyTransectionprovider>(context, listen: false)
            .deleteTransaction();
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => AddBankStapper(
                      types: "stapper",
                    )));
        print("Succesfull");
        return true;
      } else {
        showInSnackBar("Failed $data");
        return false;
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      showInSnackBar(getTranslated(context,'t134'),); // "The current Password Is not Matched");

      print("something wrong pranto $e");
    }
  }




  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(color: Colors.white),
      ),
      backgroundColor: Colors.purple,
    ));
  }

  Future<void> displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {



          return  AlertDialog(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
            titlePadding: EdgeInsets.only(top: 30,bottom: 12,right: 20,left: 30),
            contentPadding: EdgeInsets.only(left: 30,right: 20,),
            backgroundColor:  BrandColors.colorPrimaryDark,
            title: Text(getTranslated(context,'t138'),), // 'Log out from the app?'),
            actionsPadding: EdgeInsets.symmetric(horizontal: 10,vertical: 12),
            content: Text(getTranslated(context,'t139'),), // ("Make sure you have checked everything  you wanted to.",),
            contentTextStyle: myStyle(14,BrandColors.colorText.withOpacity(0.7),FontWeight.w400),
            titleTextStyle: myStyle(18,Colors.white,FontWeight.w500),
            actions: <Widget>[

              FlatButton(
                color: Colors.transparent,
                textColor: Colors.white,
                child: Text((getTranslated(context,'t136')) //'Cancel'
                  ,style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () {
                  Navigator.pop(context);

                },
              ),
              RaisedButton(
                padding: EdgeInsets.symmetric(vertical: 18,horizontal: 22),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0)),
                color: BrandColors.colorPurple,
                child: Text( getTranslated(context,'t30'), //logout,
               style: myStyle(14,Colors.white,FontWeight.w500),),
                onPressed: () async {
                  SharedPreferences preferences =
                  await SharedPreferences.getInstance();
                  await preferences.remove('token');
                  await preferences.remove('userName');
                  Provider.of<UserDetailsProvider>(context, listen: false)
                      .deletedetails();
                  Provider.of<MyTransectionprovider>(context, listen: false)
                      .deleteTransaction();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed(LoginScreen.id);

                },
              ),
            ],
          );

        });
  }
}
















class ProfileButton extends StatelessWidget {
  Function onPress;
  String title;
  IconData icon;

  ProfileButton({this.title, this.icon, this.onPress});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      child: FlatButton(
        onPressed: onPress,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(
              icon,
              color: Color(0xFF9fa8da),
            ),
            SizedBox(
              width: 10,
            ),
            Text(
              title,
              style: myStyle(16, BrandColors.colorWhite),
            ),
          ],
        ),
      ),
    );
  }
}
