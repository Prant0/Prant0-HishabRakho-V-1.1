import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:anthishabrakho/widget/custom_TextField.dart';
import 'dart:convert';
import 'dart:io';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:connectivity/connectivity.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/providers/user_dertails_provider.dart';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:anthishabrakho/widget/extra%20widget.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class EditInfo extends StatefulWidget {
  final UserModel model;
  EditInfo({this.model});
  @override
  _EditInfoState createState() => _EditInfoState();
}

class _EditInfoState extends State<EditInfo> {


  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  Map<String, dynamic> _data = Map<String, dynamic>();
  File _image;
  final picker = ImagePicker();
  TextEditingController nameController = TextEditingController();
  GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool onProgress = false;


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
    // ignore: deprecated_member_use
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
    }
    Navigator.pop(context);
  }


  @override
  void initState() {
    nameController.text="${widget.model.username}";
    super.initState();
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
                child: Text("Image with Gallery"),
                onPressed: () {
                  print("Gallery");
                  chooseGallery();
                },
              ),
              SimpleDialogOption(
                child: Text("Image with Camera"),
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
  Widget build(BuildContext context) {
    return Scaffold(
      key:_scaffoldKey ,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        title: Text(getTranslated(context,'t117'),  ),            //"Edit Info"),
        backgroundColor: BrandColors.colorPrimaryDark,
        centerTitle: true,
      ),
      body: Form(
        key: _formKey,
        child: ModalProgressHUD(
          progressIndicator: Spin(),
          inAsyncCall: onProgress,
          child: SingleChildScrollView(
            child: Container(
              width: MediaQuery.of(context).size.width,
              child: Column(
                children: [
                  InkWell(
                    onTap: (){
                      selectImage(context);
                    },
                    child: _image != null ? Image.file(_image): Image(image: AssetImage('assets/ph.png'),fit: BoxFit.cover,width: double.infinity,),
                  ),
                  SizedBox(
                    height: 20.0,
                  ),
                  Text(getTranslated(context,'t116'),              //"Click on image to update your photo",
                    style: TextStyle(fontSize: 18,color: Colors.white),),
                  SizedBox(
                    height: 16.0,
                  ),

                  Container(
                    decoration: BoxDecoration(

                      borderRadius: BorderRadius.circular(18),

                    ),
                    margin: EdgeInsets.only(left: 20,right: 25),
                    child:  SenderTextEdit(
                      keyy: "Name",
                      data: _data,
                      name: nameController,
                      lebelText:getTranslated(context,'t118'),              // "User Name",
                      //hintText: " ${widget.model.username}",
                      icon: Padding(
                        padding: const EdgeInsets.all(14.0),
                        child: SvgPicture.asset("assets/user1.svg",
                          alignment: Alignment.bottomCenter,
                          fit: BoxFit.contain,
                          color: BrandColors.colorText,
                        ),
                      ),
                      function: (String value) {
                        if (value.isEmpty) {
                          return getTranslated(context,'t84');              //"Name required";
                        }
                        if (value.length < 3) {
                          return getTranslated(context,'t85');              // "Name Too Short ( Min 3 character)";
                        }if (value.length > 30) {
                          return getTranslated(context,'t86');              // "Name Too long (Max 30 character)";
                        }
                      },
                    ),
                  ),

                  SizedBox(height: 30.0,),
                  RaisedButton(
                    onPressed: (){
                      if (!_formKey.currentState.validate()) return;
                      _formKey.currentState.save();
                      updateProfile(context);
                      print("tap");
                    },
                    child: Text(getTranslated(context,'t119'), ),             //"Update Info"),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
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
  SharedPreferences sharedPreferences;
  String img;
  Future updateProfile(BuildContext context) async {
    sharedPreferences = await SharedPreferences.getInstance();
    try {
      check().then((intenet)async {
        if (intenet != null && intenet) {
          if (mounted) {
            setState(() {
              onProgress = true;
            });
            final uri = Uri.parse("http://api.hishabrakho.com/api/user/profile/update");
            var request = http.MultipartRequest("POST", uri);
            request.headers.addAll(await CustomHttpRequests.getHeaderWithToken());
        if(_image==null){
          request.fields['name'] = nameController.text.toString();
          request.fields['email'] = widget.model.email.toString();
        }else{
          request.fields['name'] = nameController.text.toString();
          request.fields['email'] = widget.model.email.toString();
          var photo = await http.MultipartFile.fromPath("image", _image.path);
          request.files.add(photo);

        }
        var response = await request.send();
        var responseData = await response.stream.toBytes();
        var responseString = String.fromCharCodes(responseData);
        if (response.statusCode == 201) {
        print("responseBody1 " + responseString);
        var data = jsonDecode(responseString);
        await sharedPreferences.remove('userName');
        if(_image !=null){
          await sharedPreferences.remove('image');
          setState(()  {
            sharedPreferences.setString("image", data['image']);
            sharedPreferences.setString("userName", data['name']);
            onProgress = false;
          });
        }else{
          setState(()  {
            sharedPreferences.setString("userName", data['name']);
            onProgress = false;
          });
        }

        showInSnackBar(getTranslated(context,'t90'));              //"update successful");
        Provider.of<UserDetailsProvider>(context,listen: false).deletedetails();
        Navigator.pop(context);
        Navigator.pop(context);
        }
        else {
        showInSnackBar(getTranslated(context,'t79'),);              //"update Failed, Try again please");
        print("update failed " + responseString);
        setState(() {
        onProgress = false;
        });
        }
          }
        }
        else showInSnackBar(getTranslated(context,'t90'),);              //"No Internet Connection");
      });
    } catch (e) {
      print("something went wrong $e");
    }
  }



  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
      content: Text(
        value,
        style: TextStyle(
          color: Colors.white,
        ),
      ),
      backgroundColor: Colors.indigo,
    ));
  }


}
