import 'dart:convert';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/reportCategory_model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/extra.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
class ReportCategory extends StatefulWidget {
  @override
  _ReportCategoryState createState() => _ReportCategoryState();
}

class _ReportCategoryState extends State<ReportCategory> {
  List<ReportCategoryModel> allData = [];
  ReportCategoryModel model;

  void loadDashBoardData() async {
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/chart/category",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("report category data are   :  ${response.body}");
    for (var category in jsonResponce){
     model=ReportCategoryModel(
        eventCategoryName: category["event_category_name"],
        expenseAmount: category["expense_amount"],
        percent: category["percent"],
        totalDataCount: category["total_data_count"],
      );
      allData.add(model);
    }
    print("${allData[0].eventCategoryName}");
  }

  @override
  void initState() {
    loadDashBoardData();
    super.initState();
  }

  int touchedIndex;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
     // height: 500,

      //backgroundColor: Colors.blueAccent,
      body:AspectRatio(
        aspectRatio: 1.3,
        child: Card(
          color: Colors.white,
          child: Column(
            children: [
              SizedBox(
                height: 130,
              ),
              PieChart(

                  PieChartData(
                    sections: getSections(),
                    pieTouchData: PieTouchData(touchCallback: (pieTouchResponse) {
                      setState(() {
                        final desiredTouch = pieTouchResponse.touchInput is! PointerExitEvent &&
                            pieTouchResponse.touchInput is! PointerUpEvent;
                        if (desiredTouch && pieTouchResponse.touchedSection != null) {
                         // touchedIndex = pieTouchResponse.touchedSection.touchedSectionIndex;
                        } else {
                          touchedIndex = -1;
                        }

                      });
                    }),
                    startDegreeOffset: 180,
                    borderData: FlBorderData(
                      show: false,
                    ),
                    sectionsSpace: 10,
                    centerSpaceRadius: 40,


                  )
              ),
            ],
          )
        ),
      )
    );
  }

 // [{"expense_amount":3433,"total_data_count":1,"event_category_name":"Food","percent":70.8},{"expense_amount":1083,"total_data_count":2,"event_category_name":"Health","percent":22.33},{"expense_amount":333,"total_data_count":1,"event_category_name":"Tax","percent":6.87}]


  List<PieChartSectionData> getSections() => PieDataa.data.asMap().map<int,PieChartSectionData>((index,data){

    final value=PieChartSectionData(
        color:Color(0xff13d38e).withOpacity(0.5),
        showTitle:true,

        value: data.percent,
        title: "${data.name}%",
        titleStyle: myStyle(16,Colors.red,FontWeight.w500),
        radius: 100,



    );
    return MapEntry(index, value);
  }).values.toList();


}



