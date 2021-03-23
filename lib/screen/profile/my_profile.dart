import 'dart:convert';
import 'package:anthishabrakho/models/Starting_receivable_model.dart';
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

  bool onProgress=false;
  Future<dynamic> fetchStartingPayableData() async {
    payableData.clear();
    setState(() {
      onProgress=true;
    });
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/personal/starting/payable/balance/view",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Starting payable details are   ::  ${response.body}");
    if (this.mounted) {
      setState(() {
        totalPayable=jsonResponce["total"];
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
        totalReceivable=jsonResponce["total"];
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
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(
          "My Profile",
          style: myStyle(18, Colors.white, FontWeight.w700),
        ),
        centerTitle: true,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
        child: ModalProgressHUD(
          inAsyncCall: isLoading,
          child: ListView.builder(

            itemCount: user.length,
            itemBuilder: (context,index){
              return  Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ListTile(
                    leading: CircleAvatar(
                        radius: 30,
                        backgroundImage: NetworkImage(
                          "http://hishabrakho.com/admin/user/${user[index].photo}",
                        )),
                    title: Text(
                      "${user[index].username}",
                      style: myStyle(18, Colors.white, FontWeight.w600),
                    ),
                    subtitle: Text(
                      "${user[index].email}",
                      style: myStyle(18, Colors.white, FontWeight.w600),
                    ),
                  ),
                  Card(
                      color: BrandColors.colorPrimary,
                      //height: 60,
                      elevation: 10,
                      margin: EdgeInsets.symmetric(vertical: 20, horizontal: 8),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(13.0)),
                      child: Padding(
                        padding: EdgeInsets.symmetric(vertical: 25, horizontal: 25),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "My Payables",
                                    style: myStyle(14, BrandColors.colorDimText),
                                  ),
                                  Text(
                                    NumberFormat
                                        .compactCurrency(
                                      symbol: ' ৳ ',
                                    ).format(totalPayable ?? 0),
                                    style: myStyle(14, BrandColors.colorWhite),
                                  ),


                                ],
                              ),
                              Column(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    "My Receivables",
                                    style: myStyle(14, BrandColors.colorDimText),
                                  ),
                                  SizedBox(
                                    height: 4,
                                  ),
                                  Text(NumberFormat
                                      .compactCurrency(
                                    symbol: ' ৳ ',
                                  ).format(totalReceivable?? 0), style: myStyle(14, Colors.white),)
                                ],
                              ),
                              GestureDetector(
                                onTap:(){
                                  String type="payable";
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>AddStartingBalance(
                                    title:type,
                                  ))).then((value) => setState(() {
                                    fetchStartingPayableData();
                                    fetchStartingReceivableData();
                                  }));
                                },

              /* (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=>MyStartingBalance()));
                                },*/
                                child: Container(
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 10),
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(5),
                                      border: Border.all(
                                          color: Colors.deepPurpleAccent)),
                                  child: Icon(
                                    Icons.edit,
                                    size: 20,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      )),
                  ProfileButton(
                    title: "Edit Profile",
                    icon: Icons.person,
                     onPress:(){
                       Navigator.push(context, MaterialPageRoute(builder: (context)=> EditInfo(
                         model: user[index],
                       )));
                     },
                  ),
                  ProfileButton(
                    title: "Notification",
                    icon: Icons.notification_important,
                    onPress: () {

                    },
                  ),
                  ProfileButton(
                    title: "Password Security",
                    icon: Icons.lock,
                    onPress: () {},
                  ),
                  ProfileButton(
                    title: "Help Center",
                    icon: Icons.help_rounded,
                    onPress: () {},
                  ),
                  ProfileButton(
                    title: "Invite A Friend",
                    icon: Icons.share,
                    onPress: () {},
                  ),
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
                      padding: const EdgeInsets.symmetric(vertical: 8),
                      child: Text(
                        "Reset All Data",
                        style: myStyle(16, BrandColors.colorPurple),
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      displayTextInputDialog(context);
                    },
                    child: Text(
                      "Logout",
                      style: myStyle(16, BrandColors.colorPurple),
                    ),
                  )

                  /*Container(
                  padding: EdgeInsets.only(
                    top: 15,
                  ),
                  child: Column(
                    children: [
                      Divider(
                          color: Colors.purpleAccent.withOpacity(0.5),
                          height: 0.5,
                          thickness: 1.0),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => ResetPassword()));
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reset Password",
                                style: myStyle(16, Colors.white70, FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                          color: Colors.purpleAccent.withOpacity(0.5),
                          height: 0.5,
                          thickness: 1.0),
                      SizedBox(
                        height: 15,
                      ),
                      InkWell(
                        onTap: () {
                          _displayTextInputDialog(context);
                        },
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 12),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                "Reset All Data",
                                style: myStyle(16, Colors.white70, FontWeight.w700),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 8, horizontal: 15),
                                child: Icon(
                                  Icons.arrow_forward_outlined,
                                  size: 20,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      Divider(
                        color: Colors.purpleAccent.withOpacity(0.5),
                        height: 0.5,
                        thickness: 1.5,
                      ),
                    ],
                  ),
                )*/
                ],
              );
            },
          ),
        ),
      ),
    );
  }



  String y;
  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        barrierDismissible: false,
        context: context,
        builder: (context) {
          return AlertDialog(
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(13.0)),
            title: Text('Do you want to Reset all data?'),
            content: Form(
              key: _formKey,
              child: Container(
                padding: EdgeInsets.all(20.0),
                child: TextFormField(
                  // onSaved: (val) => y = val,
                  controller: _textFieldController,
                  validator: (String value) {
                    if (value.isEmpty) {
                      return "Password required";
                    }
                    if (value.length < 6) {
                      return "Password Too Short ( 6 - 15 character )";
                    }
                    if (value.length > 15) {
                      return "Password Too Long ( 6 - 15 character )";
                    }
                  },
                  decoration: InputDecoration(
                    suffixIcon: GestureDetector(
                      onTap: () {
                        print("Tap");
                        _obscureText = !_obscureText;
                        setState(() {});
                      },
                      child: Icon(
                        _obscureText ? Icons.visibility : Icons.visibility_off,
                        color: Theme.of(context).iconTheme.color,
                      ),
                    ),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(15.0),
                      gapPadding: 5.0,
                    ),
                    labelText: "Password",
                    labelStyle: myStyle(16, Colors.purple),
                    prefixIcon: const Icon(
                      Icons.lock,
                      color: Colors.purple,
                    ),
                    hintText: "Password",
                  ),
                  obscureText: _obscureText,
                ),
              ),

              /*SenderTextEdit(

                keyy: "name",
                data: _data,
                name: _textFieldController,
                lebelText: "Enter Password",
                hintText: "Enter Password",

                icon: Icons.drive_file_rename_outline,
                function: (String value) {
                  if (value.isEmpty) {
                    return "required";
                  }
                  if (value.length < 6) {
                    return "Name is Too Short";
                  }if (value.length > 20) {
                    return "Name is Too Long";
                  }
                },
              ),*/
            ),
            actions: <Widget>[
              FlatButton(
                color: Colors.black,
                textColor: Colors.white,
                child: Text('CANCEL'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              FlatButton(
                color: Colors.purple,
                textColor: Colors.white,
                child: Text('OK'),
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
      showInSnackBar("The current Password Is not Matched");

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
          return AlertDialog(
            title: Text('Are you sure want to LogOut ?'),
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
                onPressed: () async {
                  SharedPreferences preferences =
                      await SharedPreferences.getInstance();
                  await preferences.remove('token');
                  await preferences.remove('userName');
                  Provider.of<UserDetailsProvider>(context,listen: false).deletedetails();
                  Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
                  Navigator.pop(context);
                  Navigator.pop(context);
                  Navigator.of(context).pushReplacementNamed(LoginScreen.id);
                  /*Navigator.pop(context);
                  Navigator.pop(context, MaterialPageRoute(builder: (context)=>LoginScreen()));*/
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
              title, style: myStyle(16, BrandColors.colorWhite),),
          ],
        ),
      ),
    );
  }
}


