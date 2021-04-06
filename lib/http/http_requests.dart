import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
class CustomHttpRequests {
  static const String uri =
      "http://api.hishabrakho.com/api"; // common part of our api
  static SharedPreferences sharedPreferences;
  static const Map<String, String> defaultHeader = {
    "Accept": "application/json",
  };
  static Future<Map<String, String>> getHeaderWithToken() async {
    sharedPreferences = await SharedPreferences.getInstance();
    var header = {
      "Accept": "application/json",
      "Authorization": "bearer ${sharedPreferences.getString("token")}",
    };
    print("user token is :${sharedPreferences.getString('token')}");
    return header;
  }

  Map<String, String> requestHeaders = {
    'Content-type': 'application/json',
    'Accept': 'application/json',
    'Authorization': '<Your token>'
  };

  static Future<String> login(String email, String password) async {
    try {
      String url = "$uri/login";
      var map = Map<String, dynamic>();
      map['email'] = email;
      map['password'] = password;
      final response = await http.post(url, body: map, headers: defaultHeader);
      print(response.body);
      if (response.statusCode == 200) {
        return response.body;
      }
      print(response.body);
      return "Something Wrong";
    } catch (e) {
      return e.toString();
    }
  }


  static Future<String> resetAllData(String password) async {
    try {
      String url = "$uri/user/personal/account/reset";
      var map = Map<String, dynamic>();
      map['your_password'] = password;
      print("password reseting");
      final response = await http.post(url, body: map, headers: await getHeaderWithToken(),);
      print(response.body);
      if (response.statusCode == 201) {
        return response.body;
      }
      print(response.body);
      return "Something Wrong";
    } catch (e) {
      return e.toString();
    }
  }

  static Future<dynamic> myPayableData() async {
    try {
      var response = await http.get(
        "${uri}/user/personal/payable/view",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> myreceiveableData() async {
    try {
      var response = await http.get(
        "$uri/user/personal/receivable/view",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> myEntriesData() async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/entries",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> myReceiveableEntriesData() async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/receivables",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> myPayableEntriesData() async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/payables",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      return data;
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> myEarningEntriesData() async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/earnings",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> myExpendituresEntriesData() async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/expenditures",
        headers: await getHeaderWithToken(),
        //body: meta,
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return {"error": "Something Wrong Exception"};
    }
  }

  static Future<dynamic> userDetails() async {
    try {
      var response = await http.get(
        "$uri/user/profile",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return "User details data not found";
    }
  }


  /*static Future<dynamic> dashBoardData() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/user/summary",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200)
        return data;
      else
        return "error";
    } catch (e) {
      print(e);
      return "User details data not found";
    }
  }*/

  static Future<dynamic> myEntriesView(int eventId) async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/entries/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> myReceivableView(int eventId) async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/receivables/entries/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> myEarningView(int eventId) async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/earnings/entries/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> myPayableView(int eventId) async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/payables/entries/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> myExpenditureView(int eventId) async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/expenditures/entries/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> addEntriesHome() async {
    try {
      var response = await http.get(
        "$uri/user/personal/event/class",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> addEntriesCategories(int id) async {
    try {
      var response = await http.get(
        "$uri/user/personal/event/categories/$id",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> addEntriesSubcategories(int id) async {
    try {
      var response = await http.get(
        "$uri/user/personal/event/subcategories/$id",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> bankDetails() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/user/personal/banks",
        headers: await getHeaderWithToken(),
      );
      if (response.statusCode == 200) {
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> mfsDetails() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/user/personal/mfs",
        headers: await getHeaderWithToken(),
      );
      //final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> cashDetails() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/user/personal/cash",
        headers: await getHeaderWithToken(),
      );
      if (response.statusCode == 200) {
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> userBankDetails() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/user/personal/storage/hub/bank/details",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> allBankDetails() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/bank/details",
      );
      //final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //print(data);
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> userMfsDetails() async {
    try {
      var response = await http.get(
        "$uri/user/personal/storage/hub/mfs/details",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> allMfsDetails() async {
    try {
      var response = await http.get(
        "http://api.hishabrakho.com/api/mfs/details",
      );
      //final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        //print(data);
        return response;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }




  static Future<dynamic> userCashDetails() async {
    try {
      var response = await http.get(
        "$uri/user/personal/storage/hub/cash/details",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }

  static Future<dynamic> myAllFriends() async {
    try {
      var response = await http.get(
        "$uri/user/personal/friends/view",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }


  static Future<dynamic> viewStorageEntries(int storageId) async {
    try {
      var response = await http.get(
        "$uri/user/personal/view/my/storage/hub/entries/$storageId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        print(data);
        return data;
      } else
        return "Error";
    } catch (e) {
      print(e);
      return "Something Wrong...!!!";
    }
  }


  static Future<dynamic> deleteList(int eventId)async{
    try{
      var response = await http.delete(
        "$uri/user/personal/delete/entries/$eventId",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);

      if(response.statusCode==200){

        print(data);
        print("delete sucessfully");
        return response;
      }
      else{
        throw Exception("Cant delete bro");
      }
    }catch(e){
      print(e);
    }
  }

  static Future<dynamic> deleteFriends(int id)async{
    try{
      var response = await http.delete(
        "$uri/user/personal/friends/delete/$id",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);

      if(response.statusCode==200){
        print(data);
        print("delete sucessfully");
        return response;
      }
      else{
        throw Exception("Cant delete bro");
      }
    }catch(e){
      print(e);
    }
  }

  static Future<dynamic> deleteStorageHub(int id)async{
    try{
      var response = await http.delete(
        "$uri/user/personal/storage/hub/delete/$id",
        headers: await getHeaderWithToken(),
      );
      final data = jsonDecode(response.body);
      if(response.statusCode==200){
        print(data);
        return response;
      }
      else{
        throw Exception("Cant delete bro");
      }
    }catch(e){
      print(e);
    }
  }




}

