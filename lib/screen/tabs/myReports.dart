import 'dart:convert';

import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/reportCategory_model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class MyReports extends StatefulWidget {
  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports> with SingleTickerProviderStateMixin {
  DateTime _currentDate = DateTime.now();


  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMM().format(_currentDate);


    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      body: Container(
        padding: EdgeInsets.symmetric(horizontal: 20),
        child: ListView(
          children: [
            Container(
              margin: EdgeInsets.symmetric(vertical: 20),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "$formattedDate",
                    style: myStyle(16, BrandColors.colorText, FontWeight.w400),
                  ),

                  GestureDetector(
                    onTap: () {
                      showCupertinoModalPopup(
                        context: context,
                        builder: (_) => Container(
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                                topRight: Radius.circular(10.0),
                                topLeft: Radius.circular(10.0)),
                            color: Colors.white,
                          ),
                          height: 200,
                          child: CupertinoDatePicker(
                              initialDateTime: DateTime.now(),
                              maximumYear: 2022,
                              minimumYear: 2019,
                              mode: CupertinoDatePickerMode.date,
                              use24hFormat: false,
                              onDateTimeChanged: (val) {
                                setState(() {
                                  _currentDate = val;

                                });
                              }),
                        ),
                      );
                    },
                    child: Container(
                      decoration: BoxDecoration(
                          color: BrandColors.colorPrimary,
                          borderRadius: BorderRadius.circular(10.0)),
                      padding:
                      EdgeInsets.symmetric(horizontal: 20, vertical: 13),
                      child: Row(
                        children: [


                          Text(
                            "Select Month",
                            style: myStyle(
                                14, BrandColors.colorText.withOpacity(0.6)),
                          ),
                          SizedBox(
                            width: 5,
                          ),

                          Icon(
                            Icons.filter_list_sharp,
                            size: 20,
                            color: BrandColors.colorText,
                          ),
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
            Container(
              padding: EdgeInsets.only(right:10),
              height: 200,
              child: FutureBuilder(
                  future: loadReportData(formattedDate),
                  builder: (BuildContext context, AsyncSnapshot snapshot) {
                    if (snapshot.connectionState == ConnectionState.done)
                      return SfCartesianChart(
                          tooltipBehavior: TooltipBehavior(
                              enable: true, shouldAlwaysShow: true),
                          primaryXAxis: CategoryAxis(),
                          series: <ChartSeries>[
                            StackedBarSeries<ReportModel, String>(
                              name: "",
                              dataSource: allReportData,
                              xValueMapper: (ReportModel sales, _) =>
                              allReportData.isNotEmpty
                                  ? sales.name
                                  : "Expense",
                              yValueMapper: (ReportModel sales, _) =>
                              allReportData.isNotEmpty ? sales.amount : 00,
                              enableTooltip: true,
                              width: 0.4,
                              spacing: 0.3,
                              opacity: 0.8 ,
                              dataLabelSettings: DataLabelSettings(
                                  isVisible: true,

                                  opacity: 0.6,
                                  textStyle: myStyle(
                                      12, BrandColors.colorWhite)),
                              color: BrandColors.colorPurple,
                            ),
                          ]);
                    else
                      return Center(
                          child: Text(
                            "Loading...",
                            style:
                            myStyle(16, BrandColors.colorText, FontWeight.w500),
                          ));
                  }),
            ),



            Padding(
              padding: EdgeInsets.symmetric(vertical: 40),
              child: Text(
                "Expenses Overview  ",
                style: myStyle(16, BrandColors.colorText, FontWeight.w400),
              ),
            ),
            Row(
              children: [
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isCategory == true
                          ? BrandColors.colorPrimary
                          : BrandColors.colorPrimaryDark,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Text(
                      "Categories",
                      style:
                          myStyle(14, isCategory ? Colors.white : Colors.grey),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isCategory = true;
                      isSubCategory = false;
                    });
                  },
                ),
                SizedBox(
                  width: 15,
                ),
                GestureDetector(
                  child: Container(
                    decoration: BoxDecoration(
                      color: isSubCategory == true
                          ? BrandColors.colorPrimary
                          : BrandColors.colorPrimaryDark,
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 16, horizontal: 20),
                    child: Text(
                      "Sub-Categories",
                      style: myStyle(
                          14, isSubCategory ? Colors.white : Colors.grey),
                    ),
                  ),
                  onTap: () {
                    setState(() {
                      isCategory = false;
                      isSubCategory = true;
                    });
                  },
                )
              ],
            ),
            Divider(
              thickness: 1,
              height: 50,
              color: BrandColors.colorText,
            ),
            Container(
              child: Column(
                children: [
                  Visibility(
                    visible: isCategory,
                    child: Container(
                      // height: 300,
                      child: FutureBuilder(
                          future: loadReportCategory(formattedDate),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done)
                              return allData.isNotEmpty
                                  ? Column(
                                      children: [
                                        SfCircularChart(
                                            tooltipBehavior:
                                                TooltipBehavior(enable: true),
                                            series: <CircularSeries>[
                                              DoughnutSeries<ReportCategoryModel, String>(
                                                dataSource: allData,
                                                // pointRadiusMapper: (ReportCategoryModel data, _) => "${data.size}.0",
                                                xValueMapper:
                                                    (ReportCategoryModel data,
                                                            _) =>
                                                        data.eventCategoryName,
                                                yValueMapper:
                                                    (ReportCategoryModel data,
                                                            _) =>
                                                        data.percent,
                                                pointColorMapper: (ReportCategoryModel
                                                            data,
                                                        _) =>
                                                    data.size == 1
                                                        ? Color(0xFF8F73F8)
                                                        : data.size == 2
                                                            ? Color(0xFFFF8E54)
                                                            : data.size == 3
                                                                ? Color(
                                                                    0xFF1FB9FC)
                                                                : data.size == 4
                                                                    ? Color(
                                                                        0xFF34BCA3)
                                                                    : data.size ==
                                                                            5
                                                                        ? Colors
                                                                            .yellow
                                                                        : Colors
                                                                            .black54,
                                                explode: true,
                                                strokeWidth: 2,
                                                innerRadius: '35%',
                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                  color: Colors.white,
                                                  //isVisible: true,
                                                ),
                                              ),

                                            ]


                                        ),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: allData.length,
                                          gridDelegate:
                                              new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2.7),
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return bottomChart(
                                              allData: allData,
                                              size: allData[index].size,
                                              name: allData[index]
                                                  .eventCategoryName,
                                              percent: allData[index].percent,
                                              total:
                                                  allData[index].totalDataCount,
                                            );
                                          },
                                        )
                                      ],
                                    )
                                  : Text(
                                      "No Information Found",
                                      style: myStyle(16, BrandColors.colorText,
                                          FontWeight.w500),
                                    );
                            else
                              return Center(
                                  child: Text(
                                "",
                                style: myStyle(
                                    16, BrandColors.colorText, FontWeight.w500),
                              ));
                          }),
                    ),
                  ),
                  Visibility(
                    visible: isSubCategory == true,
                    child: Container(
                      child: FutureBuilder(
                          future: loadReportSubCategory(formattedDate),
                          builder:
                              (BuildContext context, AsyncSnapshot snapshot) {
                            if (snapshot.connectionState ==
                                ConnectionState.done)
                              return allSubData.isNotEmpty
                                  ? Column(
                                      children: [
                                        SfCircularChart(
                                            /*title: ChartTitle(
                                         text: 'Sub-Categories',
                                         textStyle: TextStyle(color: Colors.white)),*/

                                            tooltipBehavior:
                                                TooltipBehavior(enable: true),
                                            series: <CircularSeries>[
                                              // Renders doughnut chart
                                              DoughnutSeries<
                                                  ReportCategoryModel, String>(
                                                dataSource: allSubData,
                                                // pointColorMapper: (ReportCategoryModel data, _) =>Color(0xFF24204b),
                                                xValueMapper:
                                                    (ReportCategoryModel data,
                                                            _) =>
                                                        data.eventCategoryName,
                                                yValueMapper:
                                                    (ReportCategoryModel data,
                                                            _) =>
                                                        data.percent,
                                                pointColorMapper: (ReportCategoryModel
                                                            data,
                                                        _) =>
                                                    data.size == 1
                                                        ? Color(0xFF8F73F8)
                                                        : data.size == 2
                                                            ? Color(0xFFFF8E54)
                                                            : data.size == 3
                                                                ? Color(
                                                                    0xFF1FB9FC)
                                                                : data.size == 4
                                                                    ? Color(
                                                                        0xFF34BCA3)
                                                                    : data.size ==
                                                                            5
                                                                        ? Colors
                                                                            .yellow
                                                                        : Colors
                                                                            .black54,
                                                /*pointColorMapper: (ReportCategoryModel data, _) =>data.size[0]?  Color(0xFF8F73F8) : data.size[1]?Color(0xFFFF8E54): data.size[2]?Color(0xFF1FB9FC):
                                   data.size[3]?Color(0xFF34BCA3): Colors.black54,*/
                                                explode: true,
                                                //explodeAll: true,
                                                // pointRadiusMapper: (ReportCategoryModel data, _) => "80",
                                                strokeWidth: 5,
                                                innerRadius: '90%',

                                                dataLabelSettings:
                                                    DataLabelSettings(
                                                  color: Colors.white,
                                                  isVisible: true,
                                                ),
                                              )
                                            ]),
                                        GridView.builder(
                                          shrinkWrap: true,
                                          scrollDirection: Axis.vertical,
                                          physics:
                                              NeverScrollableScrollPhysics(),
                                          itemCount: allSubData.length,
                                          gridDelegate:
                                              new SliverGridDelegateWithFixedCrossAxisCount(
                                            crossAxisCount: 2,
                                            crossAxisSpacing: 8,
                                            mainAxisSpacing: 8,
                                            childAspectRatio:
                                                MediaQuery.of(context)
                                                        .size
                                                        .width /
                                                    (MediaQuery.of(context)
                                                            .size
                                                            .height /
                                                        2.7),
                                          ),
                                          itemBuilder: (BuildContext context,
                                              int index) {
                                            return bottomChart(
                                              allData: allSubData,
                                              size: allSubData[index].size,
                                              name: allSubData[index]
                                                  .eventCategoryName,
                                              percent:
                                                  allSubData[index].percent,
                                              total: allSubData[index]
                                                  .totalDataCount,
                                            );
                                          },
                                        ),
                                        SizedBox(
                                          height: 20,
                                        ),
                                      ],
                                    )
                                  : Text(
                                      "No Information Found",
                                      style: myStyle(16, BrandColors.colorText,
                                          FontWeight.w500),
                                    );
                            else
                              return Center(child: Spin());
                          }),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  ReportModel rModel;
  List<ReportModel> allReportData = [];

  loadReportData(String date) async {
    allReportData.clear();
    print("date is $date");
    var map = Map<String, dynamic>();
    map['month_year'] = date;
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/report",
      headers: await CustomHttpRequests.getHeaderWithToken(),
      body: map,
    );
    final jsonResponce = json.decode(response.body);
    print("report data are   :  ${response.body}");
    for (var category in jsonResponce) {
      rModel = ReportModel(
        amount: category["amount"],
        name: category["name"],
      );
      try{
        allReportData.firstWhere((element) => element.amount == category["amount"]);
      }catch(e){
        allReportData.add(rModel);
      }
    }
    print("${allReportData[0].name}");
  }

  List<ReportCategoryModel> allData = [];

  ReportCategoryModel model;

  loadReportCategory(String date) async {
    allData.clear();
    print("date is $date");
    var map = Map<String, dynamic>();
    map['month_year'] = date;
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/chart/category",
      headers: await CustomHttpRequests.getHeaderWithToken(),
      body: map,
    );
    final jsonResponce = json.decode(response.body);
    print("report category data are   :  ${response.body}");
    for (var category in jsonResponce) {
      model = ReportCategoryModel(
        eventCategoryName: category["event_category_name"],
        expenseAmount: category["expense_amount"],
        percent: category["percent"],
        totalDataCount: category["total_data_count"],
        size: category["color_value"],
      );
      try {
        allData.firstWhere((element) =>
            element.eventCategoryName == category["event_category_name"]);
      } catch (e) {
        allData.add(model);
      }
    }
    print("${allData[0].eventCategoryName}");
  }

  List<ReportCategoryModel> allSubData = [];

  loadReportSubCategory(String date) async {
    print("date is $date");
    allSubData.clear();
    var map = Map<String, dynamic>();
    map['month_year'] = date;
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/chart/subcategory",
      headers: await CustomHttpRequests.getHeaderWithToken(),
      body: map,
    );
    final jsonResponce = json.decode(response.body);
    print("Subreport category data are   :  ${response.body}");
    for (var category in jsonResponce) {
      model = ReportCategoryModel(
        eventCategoryName: category["event_sub_category_name"],
        expenseAmount: category["expense_amount"],
        percent: category["percent"],
        totalDataCount: category["total_data_count"],
        size: category["color_value"],
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

  bool isCategory = true;
  bool isSubCategory = false;
}

class bottomChart extends StatelessWidget {
  bottomChart({this.percent, this.allData, this.size, this.name, this.total});

  final List<ReportCategoryModel> allData;

  final dynamic size;
  dynamic percent;
  String name;
  int total;

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
      ),
      color: BrandColors.colorPrimary,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            // margin: EdgeInsets.only(bottom: 6),
            padding: const EdgeInsets.all(6.0),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(
                  color: size == 1
                      ? Color(0xFF8F73F8)
                      : size == 2
                          ? Color(0xFFFF8E54)
                          : size == 3
                              ? Color(0xFF1FB9FC)
                              : size == 4
                                  ? Color(0xFF34BCA3)
                                  : size == 5
                                      ? Colors.yellow
                                      : Colors.black54,
                  width: 1.0),
            ),
            child: CircleAvatar(
              maxRadius: 20,
              backgroundColor: size == 1
                  ? Color(0xFF8F73F8)
                  : size == 2
                      ? Color(0xFFFF8E54)
                      : size == 3
                          ? Color(0xFF1FB9FC)
                          : size == 4
                              ? Color(0xFF34BCA3)
                              : size == 5
                                  ? Colors.yellow
                                  : Colors.black54,
              child: Text(
                "${percent}%",
                style: myStyle(14, Colors.white, FontWeight.w600),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Center(
                child: Text(
                  "${name}",
                  style: myStyle(14, BrandColors.colorText),
                  overflow: TextOverflow.ellipsis,
                  softWrap: false,
                  maxLines: 1,
                ),
              ),
              Text(
                "${total} Transactions",
                style: myStyle(12, BrandColors.colorText.withOpacity(0.6)),
              ),
            ],
          )
        ],
      ),
    );
  }


}
