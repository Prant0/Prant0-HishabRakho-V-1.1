
import 'package:flutter/cupertino.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/user_model.dart';
import 'package:shared_preferences/shared_preferences.dart';
class UserDetailsProvider with ChangeNotifier{
  List<UserModel> _userData=[];
  String _namee;
  SharedPreferences sharedPreferences;
  String   get name {
    return _namee;
  }
  List<UserModel> get userData {
    return _userData;
  }

  UserModel userModel;
  Future<dynamic> getUserDetails() async {
    final data = await CustomHttpRequests.userDetails();
    print("User data areeee $data");
    userModel = UserModel.fromJson(data);
    try{
      _userData.firstWhere((element) => element.photo==userModel.photo);
    }catch(e){
      _userData.add(userModel);

    }
    notifyListeners();
  }

  void deletedetails(){
    userData.clear();
    notifyListeners();
  }


}