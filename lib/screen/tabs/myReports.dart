import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/screen/reports/report_category.dart';
import 'package:anthishabrakho/screen/reports/report_subCategory.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:intl/intl.dart';
import 'dart:convert';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/reportCategory_model.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:syncfusion_flutter_charts/charts.dart';

class MyReports extends StatefulWidget {
  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports>with SingleTickerProviderStateMixin {

  DateTime _currentDate = DateTime.now();

  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now().subtract(Duration(days: 0)
        ),
        //initialDatePickerMode: DatePickerMode.day,
        builder: (context, child) {
          return SingleChildScrollView(
            child: child,
          );
        });
    if (_seldate != null) {
      setState(() {
        _currentDate = _seldate;
      });
    }
  }

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
                   "$formattedDate",style: myStyle(16,BrandColors.colorText,FontWeight.w400),
                 ),
                 Container(
                   decoration: BoxDecoration(
                     color: BrandColors.colorPrimary,
                     borderRadius: BorderRadius.circular(10.0)
                   ),
                   padding: EdgeInsets.symmetric(horizontal: 20,vertical: 13),
                   child: Row(
                     children: [
                       Icon(Icons.filter_list_sharp,size: 20,color: BrandColors.colorText,),
                        SizedBox(width: 5,),
                       Text("Select Month",style: myStyle(14,BrandColors.colorText.withOpacity(0.6)),)
                     ],
                   ),
                 )
               ],
             ),
           ),
           Container(
             //color: Colors.red,
             height: 250,
             child: FutureBuilder(
                 future: loadReportData(),
                 builder: (BuildContext context, AsyncSnapshot snapshot) {
                   if (snapshot.connectionState == ConnectionState.done)
                     return SfCartesianChart(
                         tooltipBehavior: TooltipBehavior(enable: true,shouldAlwaysShow: true),
                         primaryXAxis: CategoryAxis(),
                         series: <ChartSeries>[
                           StackedBarSeries<ReportModel, String>(
                             groupName: "Text",
                               name: "Sheehan Bhai",
                               dataSource: allReportData,

                               xValueMapper: (ReportModel sales, _) =>allReportData.isNotEmpty? sales.name : "Expence",
                               yValueMapper: (ReportModel sales, _) =>allReportData.isNotEmpty? sales.amount:00,
                             enableTooltip: true,
                         width: 0.6, // Width of the bars
                         spacing: 0.3,
                             dataLabelSettings: DataLabelSettings(isVisible:true, textStyle: myStyle(12,BrandColors.colorPrimaryDark)),
                         borderRadius: BorderRadius.only(topRight: Radius.circular(8.0),bottomRight: Radius.circular(8.0),),



                             gradient: LinearGradient(
                                 begin: Alignment.centerLeft,
                                 end: Alignment.centerRight,
                                 colors: [Colors.redAccent,
                                   Colors.blueAccent,
                                   Colors.greenAccent,
                                 ]),
                            // isTrackVisible: true,trackColor: BrandColors.colorPrimary,isVisibleInLegend: true
                           ),

                           /*StackedBarSeries<ReportModel, String>(
                             dataSource: allReportData,
                             xValueMapper: (ReportModel sales, _) => sales.name,
                             yValueMapper: (ReportModel sales, _) => sales.amount,
                             color: Colors.red,
                             enableTooltip: true,
                             isVisibleInLegend: false,isTrackVisible: false,isVisible: false,xAxisName: "Name",yAxisName: "pranto",
                             dataLabelSettings: DataLabelSettings(isVisible:true, ),
                           ),*/
                         ]
                     );
                   else
                     return Center(child: Text("Loading...",style: myStyle(16,BrandColors.colorText,FontWeight.w500),));
                 }),
           ),
           Padding(
             padding: EdgeInsets.symmetric(vertical: 40),
             child: Text("Expenses Overview  ",style: myStyle(16,BrandColors.colorText,FontWeight.w400),),
           ),

           
           Row(
             children: [
               GestureDetector(

                 child: Container(
                   decoration: BoxDecoration(
                     color:isCategory==true? BrandColors.colorPrimary :BrandColors.colorPrimaryDark,
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                   child: Text("Categories",style: myStyle(14, isCategory?Colors.white :Colors.grey),),
                 ),
                 onTap: (){

                  setState(() {
                    isCategory=true;
                    isSubCategory=false;
                  });
                 },
               ),
               SizedBox(
                 width: 15,
               ),
               GestureDetector(

                 child: Container(
                   decoration: BoxDecoration(
                     color:isSubCategory==true? BrandColors.colorPrimary :BrandColors.colorPrimaryDark,
                     borderRadius: BorderRadius.circular(10.0),
                   ),
                   padding: EdgeInsets.symmetric(vertical: 16,horizontal: 20),
                   child: Text("Sub-Categories",style: myStyle(14, isSubCategory?Colors.white :Colors.grey),),
                 ),
                 onTap: (){
                   setState(() {
                     isCategory=false;
                     isSubCategory=true;
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
           Visibility(
             visible: isCategory,
             
             child: Container(
              // height: 300,
               child: FutureBuilder(
                   future: loadReportCategory(),
                   builder: (BuildContext context, AsyncSnapshot snapshot) {
                     if (snapshot.connectionState == ConnectionState.done)
                       return Column(
                         children: [
                           SfCircularChart(
                               title: ChartTitle(
                                   text: 'Categories',
                                   textStyle: TextStyle(color: Colors.white)),
                               tooltipBehavior: TooltipBehavior(enable: true),
                               series: <CircularSeries>[
                                 DoughnutSeries<ReportCategoryModel, String>(
                                   dataSource: allData,
                                   pointRadiusMapper: (ReportCategoryModel data, _) => "${data.size}.0",
                                   xValueMapper: (ReportCategoryModel data, _) => data.eventCategoryName,
                                   yValueMapper: (ReportCategoryModel data, _) => data.percent,
                                   pointColorMapper: (ReportCategoryModel data, _) =>double.parse(data.size) == 95? Color(0xFF8F73F8) : double.parse(data.size) == 90?Color(0xFFFF8E54):
                                   double.parse(data.size) == 85? Color(0xFF1FB9FC):  double.parse(data.size) == 80? Color(0xFF34BCA3): Colors.black54,
                                   explode: true,
                                   //explodeAll: true,
                                   strokeWidth: 2,
                                   innerRadius: '35%',
                                   dataLabelSettings: DataLabelSettings(
                                     color: Colors.white,
                                     //isVisible: true,
                                   ),
                                 )
                               ]),
                           GridView.builder(
                             shrinkWrap: true,scrollDirection: Axis.vertical,
                             physics: NeverScrollableScrollPhysics(),
                             itemCount: allData.length,
                             gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 2,
                               crossAxisSpacing: 15,
                               mainAxisSpacing: 5,
                               childAspectRatio: MediaQuery.of(context).size.width /
                                   (MediaQuery.of(context).size.height /4),

                             ),
                             itemBuilder: (BuildContext context, int index) {
                               return bottomChart(
                                 allData: allData,
                                 size: allData[index].size,
                                 name: allData[index].eventCategoryName,
                                 percent: allData[index].percent,
                                 total: allData[index].totalDataCount,
                               );
                             },
                           )
                         ],
                       );
                     else
                       return Center(child: Text("Loading...",style: myStyle(16,BrandColors.colorText,FontWeight.w500),));
                   }),
             ),
           ),




           Visibility(
             visible: isSubCategory==true,
             child: Container(
               height: 600,
               child: FutureBuilder(

                   future: loadReportSubCategory(),
                   builder: (BuildContext context, AsyncSnapshot snapshot) {
                     if (snapshot.connectionState == ConnectionState.done)
                       return Column(
                         children: [
                           SfCircularChart(
                             //color=_colorItem[index % _colorItem.length];
                               title: ChartTitle(
                                   text: 'Sub-Categories',
                                   textStyle: TextStyle(color: Colors.white)),

                               tooltipBehavior: TooltipBehavior(enable: true),
                               series: <CircularSeries>[
                                 // Renders doughnut chart
                                 DoughnutSeries<ReportCategoryModel, String>(
                                   dataSource: allSubData,
                                   // pointColorMapper: (ReportCategoryModel data, _) =>Color(0xFF24204b),
                                   xValueMapper: (ReportCategoryModel data, _) => data.eventCategoryName,
                                   yValueMapper: (ReportCategoryModel data, _) => data.percent,
                                   pointColorMapper: (ReportCategoryModel data, _) =>double.parse(data.size) == 95? Color(0xFF8F73F8) : double.parse(data.size) == 90?Color(0xFFFF8E54):
                                   double.parse(data.size) == 85? Color(0xFF1FB9FC):  double.parse(data.size) == 80? Color(0xFF34BCA3): Colors.black54,
                                   /*pointColorMapper: (ReportCategoryModel data, _) =>data.size[0]?  Color(0xFF8F73F8) : data.size[1]?Color(0xFFFF8E54): data.size[2]?Color(0xFF1FB9FC):
                                   data.size[3]?Color(0xFF34BCA3): Colors.black54,*/
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
                               ]),
                           GridView.builder(
                             shrinkWrap: true,scrollDirection: Axis.vertical,
                             physics: NeverScrollableScrollPhysics(),
                             itemCount: allSubData.length,
                             gridDelegate: new SliverGridDelegateWithFixedCrossAxisCount(
                               crossAxisCount: 2,
                               crossAxisSpacing: 15,
                               mainAxisSpacing: 5,
                               childAspectRatio: MediaQuery.of(context).size.width /
                                   (MediaQuery.of(context).size.height /4),

                             ),
                             itemBuilder: (BuildContext context, int index) {
                               return bottomChart(
                                 allData: allSubData,
                                 size: allSubData[index].size,
                                 name: allSubData[index].eventCategoryName,
                                 percent: allSubData[index].percent,
                                 total: allSubData[index].totalDataCount,
                               );
                             },
                           )
                         ],
                       );
                     else
                       return Center(child: Spin());
                   }),
             ),
           )

         ],
        ),
      ),
    );
  }
  ReportModel rModel;
  List<ReportModel> allReportData = [];
  loadReportData() async {
    print("start");
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/report",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("report data are   :  ${response.body}");
    for (var category in jsonResponce){
      rModel=ReportModel(
        amount: category["amount"],
        name: category["name"],
      );
      allReportData.add(rModel);
    }
    print("${allReportData[0].name}");
  }

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


  List<ReportCategoryModel> allSubData = [];
  loadReportSubCategory() async {
    var response = await http.post(
      "http://api.hishabrakho.com/api/user/personal/chart/subcategory",
      headers: await CustomHttpRequests.getHeaderWithToken(),
    );
    final jsonResponce = json.decode(response.body);
    print("Subreport category data are   :  ${response.body}");
    for (var category in jsonResponce) {
      model = ReportCategoryModel(
        eventCategoryName: category["event_sub_category_name"],
        expenseAmount: category["expense_amount"],
        percent: category["percent"],
        totalDataCount: category["total_data_count"],
        size: category["size"],
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






  bool isCategory=true;
  bool isSubCategory=false;

}

class bottomChart extends StatelessWidget {

  bottomChart({this.percent,this.allData,this.size,this.name,this.total});
  final List<ReportCategoryModel> allData ;

  final dynamic size;
  dynamic percent;
  String name;
  int total;

  @override
  Widget build(BuildContext context) {
    return Container(
      child: Row(
          //mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children:[
            Container(
              margin: EdgeInsets.only( right: 10,),
              padding: const EdgeInsets.all(6.0),
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(color:size== "95"? Color(0xFF8F73F8):size== "90"?Color(0xFFFF8E54):
                size== "85"? Color(0xFF1FB9FC):size== "80"? Color(0xFF34BCA3):Colors.black54, width: 1.0),
              ),
              child: CircleAvatar(
                maxRadius: 20,
                backgroundColor:size== "95"? Color(0xFF8F73F8):size== "90"?Color(0xFFFF8E54):
                size== "85"? Color(0xFF1FB9FC):size== "80"? Color(0xFF34BCA3):Colors.black54,
                child: Text("${percent}%",style: myStyle(14,Colors.white),),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 15),
              child: Column(
               // mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text("${name}",style: myStyle(12,BrandColors.colorText),overflow: TextOverflow.visible,textAlign: TextAlign.justify,softWrap: true,
                  maxLines: 2,),
                  Text("${total} Transactions",style: myStyle(12,BrandColors.colorText.withOpacity(0.6)),),
                ],
              ),
            )
          ]
      ),
    );
  }
}



