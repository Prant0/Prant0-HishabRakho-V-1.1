

import 'package:flutter/cupertino.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/bankModel.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';

class StorageHubProvider with ChangeNotifier{
  List<MyTransectionModel> _bankList = [];
  List<MyTransectionModel> get bankList {
    return _bankList;
  }

  List<MyTransectionModel> _mfsList = [];
  List<MyTransectionModel> get mfsList {
    return _mfsList;
  }
  List<MyTransectionModel> _cashList = [];
  List<MyTransectionModel> get cashList {
    return _cashList;
  }

  List<BankModel> _userBank = [];
  List<BankModel> get userBank {
    return _userBank;
  }




  MyTransectionModel model;
  void editBankData(int id,String accountName,String accountNumber,double balance,String storageHubName){
    final package = _bankList.firstWhere((element) => element.id==id);
    package.userStorageHubAccountName=accountName;
    package.userStorageHubAccountNumber=accountNumber;
    package.balance=balance;
    package.storageHubName=storageHubName;
    _bankList.insert(0, package);
    _bankList.removeAt(0);
    print("new value Delivered are : $_bankList");
    notifyListeners();
  }

  void clearAllStorage(){
    bankList.clear();
    mfsList.clear();
    cashList.clear();
    notifyListeners();
  }


  void clearBank(){
    bankList.clear();
    notifyListeners();
  }

  void clearMfs(){
    mfsList.clear();
    notifyListeners();
  }

  void clearCash(){
    cashList.clear();
    notifyListeners();
  }

  void editMfsData(int id,String accountNumber,double balance,String storageHubName){
    final package = mfsList.firstWhere((element) => element.id==id);
    package.userStorageHubAccountNumber=accountNumber;
    package.balance=balance;
    package.storageHubName=storageHubName;
    mfsList.insert(0, package);
    mfsList.removeAt(0);
    print("new value Delivered are : $mfsList");
    notifyListeners();
  }

  void editCashData(int id,double balance,){
    final package = cashList.firstWhere((element) => element.id==id);
    package.balance=balance;
    cashList.insert(0, package);
    cashList.removeAt(0);
    print("new value Delivered are : $mfsList");
    notifyListeners();
  }


  Future<dynamic> mybankDetails() async {
    final data = await CustomHttpRequests.userBankDetails();
    print("Bank Details are $data");
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        storageHubCategoryId: entries["storage_hub_category_id"],
        storageHubId: entries["storage_hub_id"],
        userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
        userStorageHubAccountName: entries["user_storage_hub_account_name"],
        balance: entries["single_bank_balance"],
        date: entries["date"],
        storageHubName: entries["storage_hub_name"],
        hubCategoryName: entries["storage_hub_category_name"],
        totalBalance: entries["balance"],
        photo:entries["storage_hub_logo"],

      );
      try {
        _bankList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        bankList.add(model);

      }
    }
    notifyListeners();
  }



  Future<dynamic> myMfsDetails() async {
    final data = await CustomHttpRequests.userMfsDetails();
    print("MFS Details are $data");
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        storageHubCategoryId: entries["storage_hub_category_id"],
        storageHubId: entries["storage_hub_id"],
        userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
        userStorageHubAccountName: entries["user_storage_hub_account_name"],
        balance: entries["single_mfs_balance"],
        date: entries["date"],
        storageHubName: entries["storage_hub_name"],
        hubCategoryName: entries["storage_hub_category_name"],
        totalBalance: entries["balance"],
        photo:entries["storage_hub_logo"],
      );
      try {
        _mfsList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _mfsList.add(model);
      }
    }
    notifyListeners();
  }

  Future<dynamic> myCashDetails() async {
    final data = await CustomHttpRequests.userCashDetails();
    print("Cash Details are $data");
    for (var entries in data) {
      MyTransectionModel model = MyTransectionModel(
        id: entries["id"],
        storageHubCategoryId: entries["storage_hub_category_id"],
        storageHubId: entries["storage_hub_id"],
        balance: entries["total_balance"],
        hubCategoryName: entries["storage_hub_category_name"],
        date: entries["date"],
      );
      try {
        _cashList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _cashList.add(model);
      }
    }
  }




}



