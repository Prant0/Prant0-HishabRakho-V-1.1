import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/screen/login_page.dart';
import 'package:anthishabrakho/screen/stapper/addBank.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:moneytextformfield/moneytextformfield.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistationPage extends StatefulWidget {
  static const String id = 'registationpage';

  @override
  _RegistationPageState createState() => _RegistationPageState();
}

class _RegistationPageState extends State<RegistationPage> {
  final photoPicker = ImagePicker();
  bool onProgress = false;
  Map<String, dynamic> _data = Map<String, dynamic>();

  final _formKey = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _name = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _cashBalance = TextEditingController();
  final TextEditingController _confirmPassword = TextEditingController();
  File _image;
  final picker = ImagePicker();
  var imagesList;
  bool _obscureText = true;



  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.red,
    ));
  }
  _cropImage(File pickedImage)async{
    File cropped = await ImageCropper.cropImage(
        androidUiSettings:AndroidUiSettings(
            lockAspectRatio: false,
            statusBarColor: Colors.purpleAccent,
            toolbarColor: Colors.purple,
            toolbarTitle: "Crop Image",
            toolbarWidgetColor: Colors.white
        ) ,
        sourcePath: pickedImage.path,
        aspectRatioPresets: [
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio16x9,
          CropAspectRatioPreset.ratio4x3,
        ]
    );
    if(cropped != null){
      setState(() {
        _image = cropped;
      });
    }
  }

  Future chooseGallery() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.gallery);
    if(pickedImage !=null){
      _cropImage(pickedImage);
    }
    Navigator.pop(context);
  }

  Future chooseCamera() async {
    File pickedImage = await ImagePicker.pickImage(source: ImageSource.camera);
    if(pickedImage !=null){
      _cropImage(pickedImage);
      Navigator.pop(context);
    }

  }

  selectImage(parentContext) {
    return showDialog(
        context: parentContext,
        builder: (context) {
          return SimpleDialog(
            title: Text(
              "Upload Image",
              style: TextStyle(),
            ),
            children: [
              SimpleDialogOption(
                child: Text("Image from Gallery"),
                onPressed: () {
                  print("Gallery");
                  chooseGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Image from Camera"),
                onPressed: () {
                  print("open camera");
                  chooseCamera();
                },
              ),
              SimpleDialogOption(
                child: Text("cancel"),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              )
            ],
          );
        });
  }
  @override
  void didChangeDependencies() {
    Future.delayed(const Duration(milliseconds: 100), () {
      setState(() {
        _cashBalance.clear();
      });
    });
    super.didChangeDependencies();
  }

  TextStyle _ts = TextStyle(fontSize: 18.0);

  Future<bool> check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      return true;
    } else if (connectivityResult == ConnectivityResult.wifi) {
      return true;
    }
    return false;
  }
  SharedPreferences sharedPreferences;
  String token;

  Future getRegister(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      check().then((intenet) async {
        if (intenet != null && intenet) {
          if (mounted) {
            setState(() {
              onProgress = true;
            });
            final uri =
                Uri.parse("http://api.hishabrakho.com/api/user/register");
            var request = http.MultipartRequest("POST", uri);
            request.headers.addAll(await CustomHttpRequests.defaultHeader);
            request.fields['email'] = _emailController.text.toString();
            request.fields['name'] = _name.text.toString();
            request.fields['password'] = _passwordController.text.toString();
            request.fields['password_confirmation'] =
                _confirmPassword.text.toString();
            request.fields['balance'] = _cashBalance.text.toString();
            var photo = await http.MultipartFile.fromPath("image", _image.path);
            print("processing");
            request.files.add(photo);
            var response = await request.send();
            var responseData = await response.stream.toBytes();
            var responseString = String.fromCharCodes(responseData);
            print("responseBody " + responseString);

            if (response.statusCode == 201) {
              print("responseBody1 " + responseString);
              var data = jsonDecode(responseString);
              if (data["token"] != null) {
                setState(() {
                  sharedPreferences.setString("token", data['token']);
                });
                print("save token");
                token = sharedPreferences.getString("token");
                print('token is $token');
                showInSnackBar(responseString);
                setState(() {
                  onProgress = false;
                });
              }
              Navigator.pushReplacement(context,
                  MaterialPageRoute(builder: (context) => AddBankStapper()));
            } else {
              setState(() {
                onProgress = false;
              });
              var errorr = jsonDecode(responseString.trim().toString());
              showInSnackBar("Registered Failed, ${errorr}");
              print("Registered failed " + responseString);

              //return false;
            }
          }
        } else
          showInSnackBar("No Internet Connection");
      });
    } catch (e) {
      print("something went wrong $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
          resizeToAvoidBottomPadding: true,
          key: _scaffoldKey,
          backgroundColor: BrandColors.colorPrimaryDark,
          body: ModalProgressHUD(
            inAsyncCall: onProgress,
            child: Container(
              padding: EdgeInsets.symmetric(vertical: 10),
              child: Column(
                children: [
                  Expanded(
                    flex: 10,
                  child: SingleChildScrollView(
                    child: Form(
                      key: _formKey,
                      child: Container(

                        width: MediaQuery.of(context).size.width,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [

                            SizedBox(
                              height: 8,
                            ),
                            Container(

                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: Text(
                                "Create Your Account",
                                style: myStyle(22, Colors.white, FontWeight.w500),
                              ),
                            ),
                            SizedBox(
                              height: 25,
                            ),
                            Center(
                              child: Column(
                                children: [
                                  Stack(children: [
                                    Container(
                                      height: 80,
                                      width: 80,
                                      decoration: BoxDecoration(
                                        borderRadius:
                                        BorderRadius.all(Radius.circular(50)),
                                        border: Border.all(
                                            color:Colors.grey, width: 1.0),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(5.0),
                                        child: Container(
                                            decoration: BoxDecoration(
                                              color: BrandColors.colorPrimary,
                                              borderRadius: BorderRadius.all(
                                                Radius.circular(50),
                                              ),
                                            ),
                                            child: _image == null
                                                ? IconButton(
                                              onPressed: () {
                                                // selectImage(context);
                                                selectImage(context);
                                              },
                                              icon: Icon(
                                                Icons.camera_alt,
                                                color: Colors.white,
                                                size: 25,
                                              ),
                                            )
                                                : CircleAvatar(
                                              backgroundImage: FileImage(_image),
                                            )
                                          // : Image.file(
                                          //     image,
                                          //     fit: BoxFit.cover,
                                          //   ),
                                        ),
                                      ),
                                    ),
                                    Positioned(
                                      right: -15,
                                      top: -15,
                                      child: IconButton(
                                        onPressed: () {
                                          setState(() {
                                            _image = null;
                                          });
                                        },
                                        icon: _image != null
                                            ? Icon(Icons.clear,color: Colors.white,)
                                            : Icon(
                                          Icons.clear,
                                          color: Colors.white,
                                        ),
                                      ),
                                    ),
                                  ]),
                                  SizedBox(
                                    height: 10,
                                  ),
                                  Text(
                                    'Add your profile photo',
                                    style: myStyle(14,BrandColors.colorText),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15,),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SenderTextEdit(
                                keyy: "name",
                                data: _data,
                                name: _name,
                                lebelText: "Your name",
                                icon: Padding(
                                  padding: const EdgeInsets.all(15.0),
                                  child: SvgPicture.asset("assets/user1.svg",
                                    alignment: Alignment.center,
                                    height: 21,width: 21,
                                    fit: BoxFit.contain,
                                  ),
                                ),
                                function: (String value) {
                                  if (value.isEmpty) {
                                    return "Name required";
                                  }
                                  if (value.length < 3) {
                                    return "Name Too Short";
                                  }
                                  if (value.length > 30) {
                                    return "Name Too long (Max 30 character)";
                                  }
                                },
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(horizontal: 20),
                              child: SenderTextEdit(
                                keyy: "email",
                                data: _data,
                                name: _emailController,
                                lebelText: "Your email address",
                                icon:Padding(
                                  padding:EdgeInsets.all(15),
                                  child: SvgPicture.asset("assets/email.svg",
                                    alignment: Alignment.bottomCenter,
                                    fit: BoxFit.contain,
                                    color: BrandColors.colorText.withOpacity(0.4),
                                  ),
                                ),
                                function: (String value) {
                                  if (value.isEmpty) {
                                    return "Email required";
                                  }
                                  if (!value.contains('@')) {
                                    return "Invalid Email";
                                  }
                                  if (!value.contains('.')) {
                                    return "Invalid Email";
                                  }
                                },
                              ),
                            ),

                            /*SenderTextEdit(
                          keytype: TextInputType.number,
                          formatter:  <TextInputFormatter>[
                            FilteringTextInputFormatter.allow(RegExp(r'[0-9]')),
                            CurrencyInputFormatter(),
                          ],
                          keyy: "balance",
                          data: _data,
                          name: _cashBalance,
                          lebelText: "Enter your initial balance",
                          hintText: "Initial Cash Balance",
                          icon: Icons.monetization_on_outlined,
                          function: (String value) {
                            if (value.isEmpty) {
                              return "Cash Balance required";
                            }
                            if (value.length > 17) {
                              return "Amount is Too Long.(Max 10 digits)";
                            }
                          },
                        ),*/
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                              child: TextFormField(
                                // onSaved: (val) => y = val,
                                style: TextStyle(fontSize: 14.0, color:BrandColors.colorDimText),

                                controller: _passwordController,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "Password required.( 6 - 15 character/letter/digit/symbol ) ";
                                  }
                                  if (value.length < 6) {
                                    return "Password Too Short.( 6 - 15 character )";
                                  }
                                  if (value.length > 15) {
                                    return "Password Too long.( 6 - 15 character/letter/digit/symbol )";
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
                                        color:BrandColors.colorText,
                                        size: 18,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      gapPadding: 5.0,
                                    ),

                                    contentPadding: EdgeInsets.symmetric(vertical: 20),
                                    filled: true,
                                    fillColor: BrandColors.colorPrimary,
                                    focusedBorder: InputBorder.none,
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SvgPicture.asset("assets/password.svg",
                                        alignment: Alignment.bottomCenter,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    hintText: 'Your password',
                                    hintStyle: myStyle(14,BrandColors.colorDimText)
                                ),
                                obscureText: _obscureText,
                              ),
                            ),
                            Container(
                              padding: EdgeInsets.symmetric(vertical: 8,horizontal: 20),
                              child: TextFormField(
                                style: TextStyle(fontSize: 14.0, color:BrandColors.colorDimText),

                                // onSaved: (val) => y = val,
                                controller: _confirmPassword,
                                validator: (String value) {
                                  if (value.isEmpty) {
                                    return "Confirm Password required ";
                                  }
                                  if (value.length < 6) {
                                    return "Password Too Short";
                                  }
                                  if (value.length > 15) {
                                    return "Password Too long ( 6 - 15 character )";
                                  }
                                  if (_passwordController.text !=
                                      _confirmPassword.text) {
                                    return "Password do not match";
                                  }
                                },
                                decoration: InputDecoration(
                                    filled: true,
                                    fillColor: BrandColors.colorPrimary,
                                    focusedBorder: InputBorder.none,
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
                                        color: BrandColors.colorText,
                                        size: 18,
                                      ),
                                    ),
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(15.0),
                                      gapPadding: 5.0,
                                    ),
                                    prefixIcon: Padding(
                                      padding: const EdgeInsets.all(15.0),
                                      child: SvgPicture.asset("assets/password.svg",
                                        alignment: Alignment.bottomCenter,
                                        fit: BoxFit.contain,
                                      ),
                                    ),
                                    hintText: "Confirm your password",
                                    hintStyle: myStyle(14,BrandColors.colorDimText,)
                                ),
                                obscureText: _obscureText,

                              ),
                            ),

                            Padding(
                              padding: EdgeInsets.symmetric(horizontal: 12),
                              child: MoneyTextFormField(
                                settings: MoneyTextFormFieldSettings(
                                  controller: _cashBalance,
                                  moneyFormatSettings: MoneyFormatSettings(
                                    // amount: double.tryParse(widget.model.balance.toString()),
                                      currencySymbol: ' ৳ ',
                                      displayFormat: MoneyDisplayFormat.symbolOnLeft),
                                  appearanceSettings: AppearanceSettings(
                                      padding: EdgeInsets.all(15.0),
                                      labelText: 'Your initial balance* ',
                                      labelStyle:
                                      myStyle(16, BrandColors.colorDimText, FontWeight.w600),
                                      inputStyle: _ts.copyWith(color:BrandColors.colorDimText),
                                      formattedStyle:
                                      _ts.copyWith(color:BrandColors.colorDimText)),
                                ),
                              ),
                            ),


                            InkWell(
                              onTap: () async {
                                if (_image == null) {
                                  showInSnackBar("Image Required");
                                } else {
                                  if (!_formKey.currentState.validate()) return;
                                  _formKey.currentState.save();
                                  getRegister(context);
                                  print("tap");
                                }
                              },
                              child: Container(
                                  decoration: BoxDecoration(
                                    color: BrandColors.colorPurple,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  padding: EdgeInsets.symmetric(
                                      horizontal: 30.0, vertical: 20.0),
                                  margin: EdgeInsets.symmetric(
                                      horizontal: 20.0, vertical: 5.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        'Register',
                                        style: myStyle(16, Colors.white, FontWeight.w600),
                                      ),
                                      SvgPicture.asset("assets/arrow1.svg",
                                        alignment: Alignment.center,
                                        fit: BoxFit.contain,
                                      ),
                                    ],
                                  )
                              ),
                            ),

                            SizedBox(
                              height: 150,
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),),

                  Expanded(
                    flex: 1,
                    child: Container(

                      // height: 65,
                       padding: EdgeInsets.symmetric(horizontal: 3,vertical: 4),
                      width: MediaQuery.of(context).size.width,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FittedBox(child: Text("Already have  a account?",style: myStyle(14,Colors.white,FontWeight.w400),)),

                          InkWell(
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => LoginScreen()));
                            },
                            child: FittedBox(
                              child: Container(
                                padding: EdgeInsets.symmetric(horizontal: 60,vertical: 20),
                                // margin: EdgeInsets.only(right: 12,bottom: 12),
                                //height: double.infinity,
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                                ),
                                child: Center(child: Text("Login ",style: myStyle(14,Colors.white,FontWeight.w500),)),
                              ),
                            ),
                          )
                        ],
                      ),
                    ),

                    /*Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Center(child: FittedBox(child: Text("Already have an account?",style: myStyle(16,Colors.white),))),

                        InkWell(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => LoginScreen()));
                          },
                          child: Container(
                            padding: EdgeInsets.symmetric(horizontal: 35,vertical: 10),
                            margin: EdgeInsets.only(right: 12,),
                            //height: double.infinity,
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12.0),border: Border.all(color: BrandColors.colorPurple,width: 2)
                            ),
                            child: Center(child: Text("Log in",style: myStyle(16,Colors.white,FontWeight.w500),)),
                          ),
                        )
                      ],
                    ),*/
                  )
                ],
              ),
            )
          )),
    );
  }
}

class SenderTextEdit extends StatelessWidget {
  SenderTextEdit({
    this.icon,
    this.keytype,
    this.lebelText,
    this.keyy,
    this.maxNumber,
    this.name,
    this.function,
    this.data,
    this.hintText,
    this.initialText,
    this.suffixIcon,
    this.formatter,
    this.onChangeFunction,
    this.suffixText,
  });

  final TextEditingController name;
  final Function onChangeFunction;
  final dynamic data;
  final dynamic icon;
  final dynamic suffixIcon;
  final String initialText;
  final Function function;
  final String hintText;
  final int maxNumber;
  final String lebelText;
  final dynamic formatter;
  final dynamic keytype;
  final String suffixText;

  final String keyy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric( vertical: 8),
      child: TextFormField(

        minLines: 1,
        maxLines: maxNumber ?? 1,
        initialValue: initialText,
        keyboardType: keytype,
        controller: name,
        inputFormatters: formatter,
        validator: function,
        onSaved: (String value) => data[keyy] = value,
        onChanged: onChangeFunction,
        autofocus: false,
        style: myStyle( 14.0,  BrandColors.colorDimText),
        decoration: InputDecoration(hoverColor: Colors.black,
          filled: true,
          suffixText: suffixText,
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 40),
          fillColor: BrandColors.colorPrimary,
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

          labelText: hintText,
          hintStyle: myStyle(14, BrandColors.colorDimText),

          suffixIcon: suffixIcon,
          prefixIcon: icon,
          labelStyle: myStyle(14,BrandColors.colorDimText),
          hintText: lebelText,
        ),
      ),
    );
  }
}
