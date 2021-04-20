// To parse this JSON data, do
//
//     final reportCategoryModel = reportCategoryModelFromJson(jsonString);

import 'dart:convert';

import 'package:flutter/material.dart';


class ReportCategoryModel {




  ReportCategoryModel({
    this.expenseAmount,
    this.totalDataCount,
    this.eventCategoryName,
    this.percent,
     this.colorr,
    this.size,

  });

  dynamic expenseAmount;
  int totalDataCount;
  String eventCategoryName;
  dynamic percent;
    final Color colorr;
  final dynamic size;




}



class ReportModel {

  final String name;
  final int amount;
  ReportModel({this.name,this.amount});
}
