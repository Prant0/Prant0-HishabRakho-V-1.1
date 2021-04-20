import 'dart:convert';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/reportCategory_model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class ReportSubCategory extends StatelessWidget {

  ReportCategoryModel model;
  List<ReportCategoryModel> allSubData = [];
  loadReportSubCategory() async {
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/chart/subcategory",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("report category data are   :  ${response.body}");
    for (var category in jsonResponce) {
      model = ReportCategoryModel(
        eventCategoryName: category["event_sub_category_name"],
        expenseAmount: category["expense_amount"],
        percent: category["percent"],
        totalDataCount: category["total_data_count"],
      );
      try {
        allSubData.firstWhere((element) =>
            element.eventCategoryName == category["event_sub_category_name"]);
      } catch (e) {
        allSubData.add(model);
      }
    }
    print("${allSubData[0].eventCategoryName}");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        // height: 500,

        backgroundColor: BrandColors.colorPrimaryDark,
        body: AspectRatio(
          aspectRatio: 1.3,
          child: Card(
            color: BrandColors.colorPrimaryDark,
            child: FutureBuilder(
                future: loadReportSubCategory(),
                builder: (BuildContext context, AsyncSnapshot snapshot) {
                  if (snapshot.connectionState == ConnectionState.done)
                    return SfCircularChart(
                        //color=_colorItem[index % _colorItem.length];

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
                          // Renders doughnut chart
                          DoughnutSeries<ReportCategoryModel, String>(
                            dataSource: allSubData,
                            // pointColorMapper: (ReportCategoryModel data, _) =>Color(0xFF24204b),
                            xValueMapper: (ReportCategoryModel data, _) =>
                                data.eventCategoryName,
                            yValueMapper: (ReportCategoryModel data, _) =>
                                data.percent,
                            explode: true,
                            //explodeAll: true,
                            // pointRadiusMapper: (ReportCategoryModel data, _) => "80",
                            strokeWidth: 5,
                            innerRadius: '90%',

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
        )

    );
  }
}
