// To parse this JSON data, do
//
//     final reportCategoryModel = reportCategoryModelFromJson(jsonString);

import 'dart:convert';

List<ReportCategoryModel> reportCategoryModelFromJson(String str) => List<ReportCategoryModel>.from(json.decode(str).map((x) => ReportCategoryModel.fromJson(x)));

String reportCategoryModelToJson(List<ReportCategoryModel> data) => json.encode(List<dynamic>.from(data.map((x) => x.toJson())));

class ReportCategoryModel {
  ReportCategoryModel({
    this.expenseAmount,
    this.totalDataCount,
    this.eventCategoryName,
    this.percent,
  });

  dynamic expenseAmount;
  int totalDataCount;
  String eventCategoryName;
  dynamic percent;

  factory ReportCategoryModel.fromJson(Map<String, dynamic> json) => ReportCategoryModel(
    expenseAmount: json["expense_amount"] == null ? null : json["expense_amount"],
    totalDataCount: json["total_data_count"] == null ? null : json["total_data_count"],
    eventCategoryName: json["event_category_name"] == null ? null : json["event_category_name"],
    percent: json["percent"] == null ? null : json["percent"].toDouble(),
  );

  Map<String, dynamic> toJson() => {
    "expense_amount": expenseAmount == null ? null : expenseAmount,
    "total_data_count": totalDataCount == null ? null : totalDataCount,
    "event_category_name": eventCategoryName == null ? null : eventCategoryName,
    "percent": percent == null ? null : percent,
  };
}
