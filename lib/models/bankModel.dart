// To parse this JSON data, do
//
//     final bankModel = bankModelFromJson(jsonString);

import 'dart:convert';


class BankModel {
  BankModel({
    this.id,
    this.storageHubName,
    this.storageHubLogo,
    this.storageHubCategoryId,
    this.storageHubId,
    this.userStorageHubAccountNumber,
    this.userStorageHubAccountName,
    this.balance,
    this.date,
  });

 final int id;
  final String storageHubName;
  final String storageHubLogo;
  final int storageHubCategoryId;
  final int storageHubId;
  final String userStorageHubAccountNumber;
  final String userStorageHubAccountName;
  final dynamic balance;
  final DateTime date;



  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "storage_hub_name": storageHubName == null ? null : storageHubName,
    "storage_hub_logo": storageHubLogo == null ? null : storageHubLogo,
    "storage_hub_category_id": storageHubCategoryId == null ? null : storageHubCategoryId,
    "storage_hub_id": storageHubId == null ? null : storageHubId,
    "user_storage_hub_account_number": userStorageHubAccountNumber == null ? null : userStorageHubAccountNumber,
    "user_storage_hub_account_name": userStorageHubAccountName == null ? null : userStorageHubAccountName,
    "balance": balance == null ? null : balance,
    "date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
  };
}
