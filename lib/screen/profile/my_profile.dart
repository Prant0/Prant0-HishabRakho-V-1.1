import 'dart:convert';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:anthishabrakho/providers/myTransectionProvider.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/profile/edit_profile_info.dart';
import 'package:anthishabrakho/screen/profile/reset_password.dart';
import 'package:anthishabrakho/screen/stapper/addBank.dart';
import 'package:flutter/material.dart';
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
  TextEditingController _textFieldController=TextEditingController();
  Drawer drawer = Drawer();
  bool isLoading =false;
  final _formKey = GlobalKey<FormState>();
  bool onProgress = false;
  Map<String, dynamic> _data = Map<String, dynamic>();


  @override
  void initState() {
    loadUserData();
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
      backgroundColor: Colors.black12,
      appBar: AppBar(
        title: Text(
          "My Profile",
          style: myStyle(18, Colors.white, FontWeight.w700),
        ),
        centerTitle: true,
        backgroundColor: Colors.black,
      ),
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 8, ),
        child: ModalProgressHUD(
          inAsyncCall:isLoading ,
          child: Column(
            children: [
              Expanded(
                flex: 5,
                child: ListView.builder(
                  physics: NeverScrollableScrollPhysics(),
                  scrollDirection: Axis.vertical,
                  shrinkWrap: true,
                  itemCount: user.length,
                  itemBuilder: (context, index) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Stack(
                          children: [
                            CircleAvatar(
                              backgroundImage: NetworkImage("http://hishabrakho.com/admin/user/${user[index].photo}",
                              ),
                              radius: 70,
                            ),
                            Positioned(
                              bottom: 0,left:2,right:2,
                              child: InkWell(
                                child: Container(
                                  child: Center(child: Icon(Icons.edit,color: Colors.white,)),
                                color: Colors.black54,
                                ),
                                onTap: (){
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> EditInfo(
                                    model: user[index],
                                  )));
                                },
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${user[index].username}",
                          style: myStyle(22, Colors.white70, FontWeight.w800),
                        ),
                        SizedBox(
                          height: 8,
                        ),
                        Text(
                          "${user[index].email}",
                          style: myStyle(14, Colors.white70, FontWeight.w600),
                        ),
                        SizedBox(
                          height: 12,
                        ),

                        // ignore: deprecated_member_use
                        RaisedButton(
                          onPressed: () {
                            displayTextInputDialog(context);
                          },
                          color: Colors.purple,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(8.0)),
                          padding: EdgeInsets.symmetric(
                            horizontal: 25,
                          ),
                          child: Text(
                            "Logout",
                            style: myStyle(18, Colors.white),
                          ),

                        ),

                      ],
                    );
                  },
                ),
              ),
              Expanded(
                flex: 6,
                child: Container(
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
                ),
              )
            ],
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
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
            title: Text('Do you want to Reset all data?'),
            content: Form(
              key: _formKey,
              child:Container(
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
                        setState(() {

                        });
                      },
                      child: Icon(
                        _obscureText
                            ? Icons.visibility
                            : Icons.visibility_off,
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
                    hintText:"Password",
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
        isLoading=true;
      });
      final result = await CustomHttpRequests.resetAllData(
          _textFieldController.text.toString());
      final data = jsonDecode(result);
      setState(() {
        isLoading=false;
      });
      if (data != null) {
        Provider.of<MyTransectionprovider>(context,listen: false).deleteTransaction();
        Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=> AddBankStapper(
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
        isLoading=false;
      });
      showInSnackBar("The current Password Is not Matched");

      print("something wrong pranto $e");
    }


  }

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(value,style: TextStyle(color: Colors.white),),
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
                onPressed: () async{
                  SharedPreferences preferences = await SharedPreferences.getInstance();
                  await preferences.remove('token');
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
