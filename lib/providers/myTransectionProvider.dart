import 'package:flutter/cupertino.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/entries_Home_Model.dart';
import 'package:anthishabrakho/models/my_transection_model.dart';


class MyTransectionprovider with ChangeNotifier {
  List<MyTransectionModel> _myEntriesList = [];

  List<MyTransectionModel> get myEntriesList {
    return _myEntriesList;
  }

  List<MyTransectionModel> _myReceivableEntriesList = [];
  List<MyTransectionModel> get myReceivableEntriesList{
    return _myReceivableEntriesList;
  }

  List<MyTransectionModel> _myPayableEntriesList = [];
  List<MyTransectionModel> get myPayableEntriesList{
    return _myPayableEntriesList;
  }

  List<MyTransectionModel> _myEarningEntriesList=[];
  List<MyTransectionModel> get myEarningEntriesList {
    return _myEarningEntriesList;
  }
  List<MyTransectionModel> _myExpenditureEntriesList=[];

  List<MyTransectionModel> get myExpenditureEntriesList{
    return _myExpenditureEntriesList;
  }

  List<MyTransectionModel> _viewEntries=[];
  List<MyTransectionModel> get viewEntries{
    return _viewEntries;
  }

  List<MyTransectionModel> _viewreceivables=[];
  List<MyTransectionModel> get viewreceivables{
    return _viewreceivables;
  }

  List<MyTransectionModel> _viewEarning=[];
  List<MyTransectionModel> get viewEarning{
    return _viewEarning;
  }

  List<MyTransectionModel> _details=[];
  List<MyTransectionModel> get details{
    return _details;
  }


  List<EntriesHomeModel> _data=[];
  List<EntriesHomeModel> get data{
    return _data;
  }


  MyTransectionModel model;

  void deleteTransaction(){
    print("deleting transection");
    myEntriesList.clear();
    myReceivableEntriesList.clear();
    myPayableEntriesList.clear();
    myEarningEntriesList.clear();
    myExpenditureEntriesList.clear();
    notifyListeners();
  }

  void deleteEarning(){
    _myEarningEntriesList.clear();
  }
  void deleteExpenditure(){
    _myExpenditureEntriesList.clear();
  }
  void deletePayable(){
    _myPayableEntriesList.clear();
  }
  void deleteReceivable(){
    _myReceivableEntriesList.clear();
  }
  void deleteMyEntries(){
    _myEntriesList.clear();
  }
  void d(int id){
    _myEarningEntriesList.removeWhere((element) => element.id==id);
  }

  Future<dynamic> addEntryesHome() async {
    final data = await CustomHttpRequests.addEntriesHome();
    print("Entries home value are $data");
    for (var entries in data) {
      EntriesHomeModel model = EntriesHomeModel(
          id: entries["id"],
          position: entries["position"],
          classIcon: entries["class_icon"],
          eventClassName: entries["event_class_name"]);
      try {
        print(" view my entries are ${entries['position']}");
        _data.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _data.add(model);
      }
    }
    notifyListeners();
  }

  Future<dynamic> getMyEntriesDetails() async {
    final data = await CustomHttpRequests.myEntriesData();
    print("my Entries data areeee $data");
    for (var entries in data) {
      model = MyTransectionModel(
        amount: entries["amount"],
        id: entries["id"],
        formatedDate: entries["formated_date"],
        eventType: entries["event_type"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        balance: entries["balance"],
        eventId: entries["event_id"],
      );
      try {
        print(" my entries data are *-*-*-*${entries['amount']}");
        _myEntriesList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _myEntriesList.add(model);
      }
    }
    notifyListeners();
  }

  Future<dynamic> getMyRecievableEntries() async {
    final data = await CustomHttpRequests.myReceiveableEntriesData();
    print("my Recievable Entries data areeee $data");
    for (var entries in data) {
      model = MyTransectionModel(
        id: entries["id"],
        amount: entries["amount"],
        eventId: entries["event_id"],
        formatedDate: entries["formated_date"],
        eventType: entries["event_type"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        balance: entries["balance"],
        transactionTypeId: entries["transaction_type_id"],
        eventSubCategoryId: entries["event_sub_category_id"]
      );
      try {
        print(" my Recievable entries data are ${entries['id']}");
        _myReceivableEntriesList.firstWhere((element) =>element.balance==entries["balance"]);
      } catch (e) {
        _myReceivableEntriesList.add(model);
      }
    }
    notifyListeners();
  }


  Future<dynamic> getMyPayableEntries() async {
    final data = await CustomHttpRequests.myPayableEntriesData();
    print("my Payable Entries data areeee $data");
    for (var entries in data) {
      model = MyTransectionModel(
        id: entries["id"],
        amount: entries["amount"],
        formatedDate: entries["formated_date"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        eventId: entries["event_id"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        transactionTypeId: entries["transaction_type_id"],


      );
      try {
        print(" Payable entries ${entries['id']}");
        _myPayableEntriesList.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _myPayableEntriesList.add(model);
      }
    }
    notifyListeners();
  }

  Future<dynamic> getMyEarningEntries() async {
    final data = await CustomHttpRequests.myEarningEntriesData();
    print("my Earning data are the $data");
    for (var entries in data) {
      model = MyTransectionModel(
        id: entries["id"],
        amount: entries["amount"],
        formatedDate: entries["formated_date"],
        date: entries["date"],
        eventId: entries["event_id"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        eventSubCategoryId: entries["event_sub_category_id"],
        transactionTypeId: entries["transaction_type_id"],
      );
      try {
        print(" my earning entries ${entries['friend_name']}");
        _myEarningEntriesList
            .firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _myEarningEntriesList.add(model);
      }
    }
    notifyListeners();
  }


  void deleteEarningEntries(int id){
    final package= _myEarningEntriesList.firstWhere((element) => element.eventId==id);
        print("deleting id is  :${package.id}");
        _myEarningEntriesList.removeWhere((element) => element.eventId==id);
        notifyListeners();
  }

  Future<dynamic> getMyExpenditureEntries() async {
    final data = await CustomHttpRequests.myExpendituresEntriesData();
    print("my Expenditure data are theee $data");
    for (var entries in data) {
      model = MyTransectionModel(
        id: entries["id"],
        amount: entries["amount"],
        eventId: entries["event_id"],
        formatedDate: entries["formated_date"],
        eventSubCategoryName: entries["event_sub_category_name"],
        friendName: entries["friend_name"],
        balance: entries["balance"],
        eventType: entries["event_type"],
        eventSubCategoryId: entries["event_sub_category_id"],
        transactionTypeId: entries["transaction_type_id"],
      );
      try {
        print(" Expenditure entries ${entries['friend_name']}");
        _myExpenditureEntriesList
            .firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _myExpenditureEntriesList.add(model);
      }
    }
    notifyListeners();
  }


  Future<dynamic> viewMyEntries(int eventId) async {
    _details.clear();
    final data = await CustomHttpRequests.myEntriesView(eventId);
    print("view entries are $data");
    for (var entries in data) {
      model = MyTransectionModel(
          id: entries["id"],
          amount: entries["amount"],
          eventSubCategoryName: entries["event_sub_category_name"],
          friendName: entries["friend_name"],
          storageHubName: entries["storage_hub_name"],
          transactionTypeName: entries["transaction_type_name"],
          eventType: entries["event_type"],
          details: entries["details"],
          date: entries["date"],
          storageHubCategoryId: entries["storage_hub_category_id"],
          formatedDate: entries["formated_date"],
          userStorageHubAccountNumber: entries["user_storage_hub_account_number"]
      );
      try {
        _details.firstWhere((element) => element.id == entries['id']);

      } catch (e) {
        //
        _details.add(model);
      }
    }
  }


  Future<dynamic> viewReceivablesEntries(int eventId) async {
    _details.clear();
    final data = await CustomHttpRequests.myReceivableView(eventId);
    print("view entries are $data");
    for (var entries in data) {
      model = MyTransectionModel(
          id: entries["id"],
          amount: entries["amount"],
          eventSubCategoryName: entries["event_sub_category_name"],
          friendName: entries["friend_name"],
          storageHubName: entries["storage_hub_name"],
          transactionTypeName: entries["transaction_type_name"],
          eventType: entries["event_type"],
          details: entries["details"],
          userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
          date: entries["date"],
        formatedDate: entries["formated_date"],
      );
      try {
        _details.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _details.add(model);
      }
    }
    //notifyListeners();
  }

  Future<dynamic> viewPayableEntries(int eventId) async {
    _details.clear();
    final data = await CustomHttpRequests.myPayableView(eventId);
    print("view Payabale are $data");
    for (var entries in data) {
      model = MyTransectionModel(
          id: entries["id"],
          amount: entries["amount"],
          eventSubCategoryName: entries["event_sub_category_name"],
          friendName: entries["friend_name"],
          storageHubName: entries["storage_hub_name"],
          transactionTypeName: entries["transaction_type_name"],
          formatedDate: entries["formated_date"],
          eventType: entries["event_type"],
          details: entries["details"],
          userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
          date: entries["date"]
      );
      try {
        _details.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _details.add(model);
      }
    }

  }

  Future<dynamic> viewEarningEntries(int eventId) async {
    _details.clear();
    final data = await CustomHttpRequests.myEarningView(eventId);
    print("earning entries are $data");
    for (var entries in data) {
      model = MyTransectionModel(
          id: entries["id"],
          amount: entries["amount"],
          eventSubCategoryName: entries["event_sub_category_name"],
          friendName: entries["friend_name"],
          storageHubName: entries["storage_hub_name"],
          transactionTypeName: entries["transaction_type_name"],
          eventType: entries["event_type"],
          details: entries["details"],
          userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
          date: entries["date"],formatedDate: entries["formated_date"],
      );
      try {

        _details.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _details.add(model);
      }
    }
    //notifyListeners();
  }

  Future<dynamic> viewExpenditureEntries(int eventId) async {
    _details.clear();
    final data = await CustomHttpRequests.myExpenditureView(eventId);
    print("view Expenditure are $data");
    for (var entries in data) {
      model = MyTransectionModel(
          id: entries["id"],
          amount: entries["amount"],
          eventSubCategoryName: entries["event_sub_category_name"],
          friendName: entries["friend_name"],
          storageHubName: entries["storage_hub_name"],
          transactionTypeName: entries["transaction_type_name"],
          eventType: entries["event_type"],
          details: entries["details"],
          userStorageHubAccountNumber: entries["user_storage_hub_account_number"],
          date: entries["date"],formatedDate: entries["formated_date"],
      );
      try {

        _details.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        _details.add(model);
      }
    }
    //notifyListeners();
  }
}

