import 'package:flutter/cupertino.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/my_situation%20model.dart';

class MySituationProvider with ChangeNotifier{

  List<MySituationModel> _payableData=[];

  List<MySituationModel> get payableData{
    return _payableData;
  }
  List<MySituationModel> _receiveableData=[];

  List<MySituationModel> get receiveableData{
    return _receiveableData;
  }
  MySituationModel model;


  void clearReceivable(){

  }

  Future<dynamic> getPayableDetails()async{
    final data = await CustomHttpRequests.myPayableData();
    for (var payable in data){
      model =MySituationModel(
        amount: payable["amount"],
        id: payable["id"],
        name: payable["friend_name"],
      );
      try{
        _payableData.firstWhere((element) => element.id==payable['id']);
      }catch(e){
        _payableData.add(model);
      }
    }
    notifyListeners();
  }

  void deletePayableEntries(){
    _payableData.clear();
    payableData.clear();
    notifyListeners();
  }


  void deleteReceivableEntrie(){
    _receiveableData.clear();
    notifyListeners();
  }

  Future<dynamic> getreceiveableDetails()async{
    final data = await CustomHttpRequests.myreceiveableData();
    for (var payable in data){
      model =MySituationModel(
        amount: payable["amount"],
        id: payable["id"],
        name: payable["friend_name"],
      );
      try{
        _receiveableData.firstWhere((element) => element.id==payable['id']);
      }catch(e){
        _receiveableData.add(model);
      }
    }
    notifyListeners();


  }

}