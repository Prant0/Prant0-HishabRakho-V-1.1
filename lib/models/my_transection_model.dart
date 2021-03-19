import 'package:flutter/cupertino.dart';

class MyTransectionModel {
  int id;
  int eventId;
  int transactionTypeId;
  int userPersonalStorageHubId;
  dynamic amount;
  String eventType;
  String date;
  String friendName;
  String details;
  String eventSubCategoryName;
  dynamic balance;
  String formatedDate;
  String recievableFrom;
  String PayableTo;
  String transactionTypeName;
  String storageHubName;
  String userStorageHubAccountNumber;
  String userStorageHubAccountName;
  int storageHubId;
  String hubCategoryName;
  dynamic totalBalance;
  int eventSubCategoryId;
  int storageHubCategoryId;
  int  currentBalance;
  TextEditingController controller;
  String photo;


  String xp;





  MyTransectionModel(
      {
        this.controller,
        this.photo,
        this.storageHubCategoryId,
        this.xp,
        this.eventSubCategoryId,
        this.totalBalance,
        this.hubCategoryName,
        this.storageHubId,
        this.currentBalance,
        this.userStorageHubAccountName,
        this.id,
        this.eventId,
        this.transactionTypeId,
        this.userPersonalStorageHubId,
        this.amount,
        this.eventType,
        this.date,
        this.friendName,
        this.details,
        this.eventSubCategoryName,
        this.balance,
        this.formatedDate,
        this.transactionTypeName,
        this.PayableTo,
        this.recievableFrom,
        this.storageHubName,
        this.userStorageHubAccountNumber,

      });

  get nameController => null;

  Map<String ,dynamic>toJson() {
    return {
      'amount' : amount,
      'details' : details,
      'date' : date,
      'event_id' : eventId,
      'transaction_type' :transactionTypeId,
      'event_type' : eventType,

    };
  }

  Map<String ,dynamic>toPayable() {
    return {
      'amount' : amount,
      'details' : details,
      'date' : date,
      'event_id' : eventId,
      'transaction_type' : transactionTypeId,
      'event_type' : eventType,
      'payable_from':friendName,
    };
  }


  Map<String ,dynamic>toReceivable() {
    return {
      'amount' : amount,
      'details' : details,
      'date' : date,
      'event_id' : eventId,
      'transaction_type' : transactionTypeId,
      'event_type' : eventType,
      'receivable_from':friendName,
    };
  }


  Map<String ,dynamic>toBank() {
    return {
      'storage_hub_category_id' : storageHubCategoryId,
      'storage_hub_id' : storageHubId,
      'user_storage_hub_account_number_bank' : userStorageHubAccountNumber,
      'user_storage_hub_account_name' : userStorageHubAccountName,
      'balance' : balance,
      'date' : date,
    };
  }


  Map<String ,dynamic>toMfs() {
    return {
      'storage_hub_category_id' : storageHubCategoryId,
      'storage_hub_id' : storageHubId,
      'user_storage_hub_account_number_mfs' :userStorageHubAccountNumber,
      'user_storage_hub_account_name' : userStorageHubAccountName,
      'balance' : balance,
      'date' : date,
    };
  }


  Map<String ,dynamic>toCash() {
    return {
      'storage_hub_category_id' : storageHubCategoryId,
      'balance' : balance,
      'date' : date,
    };
  }
}
