
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter/cupertino.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/dashBoard_Model.dart';

class DashBoardProviders with ChangeNotifier{

  List<DashBoardModel> _dashBoardList = [];
  List<DashBoardModel>get dashBoardList{
    return _dashBoardList.toList();
  }

  DashBoardModel dashBoardModel;

  /*Future<dynamic> loadDashBoardData() async {
    var response = await http.get(
      "http://api.hishabrakho.com/api/user/summary",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print(response.body);
    dashBoardModel = DashBoardModel.fromJson(jsonResponce);
        dashBoardList.add(dashBoardModel);

    notifyListeners();
    print("totalBankAmount is :${dashBoardModel.bankDetails}");
  }*/

  Future<dynamic> fetchDashBoardData()async{
    DashBoardModel dashBoardModel;
    var response = await http.get("http://api.hishabrakho.com/api/user/summary",
      headers: await CustomHttpRequests.getHeaderWithToken(),);
    final jsonResponce = json.decode(response.body);
    print("data are ${response.body}");
    dashBoardModel=DashBoardModel.fromJson(jsonResponce);
    print("skljfbgjbfgj");
    try{
      _dashBoardList.firstWhere((element) => element.mfsDetails==dashBoardModel.mfsDetails);
      print("skljfbgjbfgj");
    }catch(e){
      dashBoardList.add(dashBoardModel);
    }notifyListeners();
  }

}