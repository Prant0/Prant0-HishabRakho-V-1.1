// To parse this JSON data, do
//
//     final startingReceivableModel = startingReceivableModelFromJson(jsonString);

import 'dart:convert';

StartingReceivableModel startingReceivableModelFromJson(String str) => StartingReceivableModel.fromJson(json.decode(str));

String startingReceivableModelToJson(StartingReceivableModel data) => json.encode(data.toJson());

class StartingReceivableModel {
  StartingReceivableModel({
    this.total,
    this.receivableDetails,
  });

  dynamic total;
  List<ReceivableDetail> receivableDetails;

  factory StartingReceivableModel.fromJson(Map<String, dynamic> json) => StartingReceivableModel(
    total: json["total"] == null ? null : json["total"],
    receivableDetails: json["receivable_details"] == null ? null : List<ReceivableDetail>.from(json["receivable_details"].map((x) => ReceivableDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total == null ? null : total,
    "receivable_details": receivableDetails == null ? null : List<dynamic>.from(receivableDetails.map((x) => x.toJson())),
  };
}

class ReceivableDetail {
  ReceivableDetail({
    this.id,
    this.eventId,
    this.transactionTypeId,
    this.userPersonalStorageHubId,
    this.amount,
    this.eventType,
    this.date,
    this.friendName,
    this.eventSubCategoryName,
    this.subcategoryIcon,
    this.details,
  });

  int id;
  int eventId;
  int transactionTypeId;
  dynamic userPersonalStorageHubId;
  dynamic amount;
  dynamic eventType;
  dynamic date;
  String friendName;
  String eventSubCategoryName;
  String subcategoryIcon;
  String details;

  factory ReceivableDetail.fromJson(Map<String, dynamic> json) => ReceivableDetail(
    id: json["id"] == null ? null : json["id"],
    eventId: json["event_id"] == null ? null : json["event_id"],
    transactionTypeId: json["transaction_type_id"] == null ? null : json["transaction_type_id"],
    userPersonalStorageHubId: json["user_personal_storage_hub_id"],
    amount: json["amount"] == null ? null : json["amount"],
    eventType: json["event_type"],
    date: json["date"] == null ? null : DateTime.parse(json["date"]),
    friendName: json["friend_name"] == null ? null : json["friend_name"],
    eventSubCategoryName: json["event_sub_category_name"] == null ? null : json["event_sub_category_name"],
    subcategoryIcon: json["subcategory_icon"] == null ? null : json["subcategory_icon"],
    details: json["details"] == null ? null : json["details"],
  );

  Map<String, dynamic> toJson() => {
    "id": id == null ? null : id,
    "event_id": eventId == null ? null : eventId,
    "transaction_type_id": transactionTypeId == null ? null : transactionTypeId,
    "user_personal_storage_hub_id": userPersonalStorageHubId,
    "amount": amount == null ? null : amount,
    "event_type": eventType,
    "date": date == null ? null : "${date.year.toString().padLeft(4, '0')}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}",
    "friend_name": friendName == null ? null : friendName,
    "event_sub_category_name": eventSubCategoryName == null ? null : eventSubCategoryName,
    "subcategory_icon": subcategoryIcon == null ? null : subcategoryIcon,
    "details": details == null ? null : details,
  };

  Map<String ,dynamic>toJsonn() {
    return {
      'date' : date,
      'amount' : amount,
      "friend_name":friendName,
      'details' : details,
    };
  }
}
