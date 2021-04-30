// To parse this JSON data, do
//
//     final startingPayableModel = startingPayableModelFromJson(jsonString);

import 'dart:convert';

StartingPayableModel startingPayableModelFromJson(String str) => StartingPayableModel.fromJson(json.decode(str));

String startingPayableModelToJson(StartingPayableModel data) => json.encode(data.toJson());

class StartingPayableModel {
  StartingPayableModel({
    this.total,
    this.payableDetails,
  });

  dynamic total;
  List<PayableDetail> payableDetails;

  factory StartingPayableModel.fromJson(Map<String, dynamic> json) => StartingPayableModel(
    total: json["total"] == null ? null : json["total"],
    payableDetails: json["payable_details"] == null ? null : List<PayableDetail>.from(json["payable_details"].map((x) => PayableDetail.fromJson(x))),
  );

  Map<String, dynamic> toJson() => {
    "total": total == null ? null : total,
    "payable_details": payableDetails == null ? null : List<dynamic>.from(payableDetails.map((x) => x.toJson())),
  };
}

class PayableDetail {
  PayableDetail({
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
    this.date2,
  });

  String date2;
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
  dynamic details;

  factory PayableDetail.fromJson(Map<String, dynamic> json) => PayableDetail(
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
    details: json["details"],
    date2: json["formated_date"],
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
    "details": details,
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
