import 'dart:convert';

import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/reportCategory_model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportCategory extends StatefulWidget {
  @override
  _ReportCategoryState createState() => _ReportCategoryState();
}

class _ReportCategoryState extends State<ReportCategory> {
  List<ReportCategoryModel> allData = [];
  ReportCategoryModel model;

  loadReportCategory() async {
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/chart/category",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("report category data are   :  ${response.body}");
    for (var category in jsonResponce) {
      model = ReportCategoryModel(
        eventCategoryName: category["event_category_name"],
        expenseAmount: category["expense_amount"],
        percent: category["percent"],
        totalDataCount: category["total_data_count"],
        size: category["size"],
      );
      try {
        allData.firstWhere((element) => element.eventCategoryName == category["event_category_name"]);
      } catch (e) {
        allData.add(model);
      }
    }
    print("${allData[0].eventCategoryName}");
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // height: 500,
        backgroundColor: BrandColors.colorPrimaryDark,
        body:Container(
          height: 600,
          child: Column(
            children: [
              Container(

                height: 300,
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: FutureBuilder(
                      future: loadReportCategory(),
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.connectionState == ConnectionState.done)
                          return SfCircularChart(
                              title: ChartTitle(
                                  text: 'Categories',
                                  textStyle: TextStyle(color: Colors.white)),
                              legend: Legend(
                                isVisible: true,
                                isResponsive: true,
                                textStyle: TextStyle(color: Colors.white),
                              ),
                              tooltipBehavior: TooltipBehavior(enable: true),
                              series: <CircularSeries>[
                                DoughnutSeries<ReportCategoryModel, String>(
                                  dataSource: allData,
                                  pointRadiusMapper: (ReportCategoryModel data, _) => "${data.size}.0",
                                  xValueMapper: (ReportCategoryModel data, _) => data.eventCategoryName,
                                  yValueMapper: (ReportCategoryModel data, _) => data.percent,
                                  pointColorMapper: (ReportCategoryModel data, _) =>double.parse(data.size) == 95? Color(0xFFffffff) : double.parse(data.size) == 90?Colors.green:
                                  double.parse(data.size) == 85? Colors.grey:Colors.blue,
                                  explode: true,
                                  //explodeAll: true,
                                  strokeWidth: 2,
                                  innerRadius: '50%',
                                  dataLabelSettings: DataLabelSettings(
                                    color: Colors.white,
                                    isVisible: true,
                                  ),
                                )
                              ]);
                        else
                          return Center(child: Spin());
                      }),
                ),
              ),


                 Container(
                   height: 200,
                  color: Colors.red,

              )

            ],
          ),
        )

    );
  }


  Color clr=Color(0xFFfffff);
}

