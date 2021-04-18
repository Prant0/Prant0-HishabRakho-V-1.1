import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/screen/reports/report_category.dart';
import 'package:anthishabrakho/screen/reports/report_subCategory.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/drawer.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';


class MyReports extends StatefulWidget {
  @override
  _MyReportsState createState() => _MyReportsState();
}

class _MyReportsState extends State<MyReports>with SingleTickerProviderStateMixin {


  DateTime _currentDate = DateTime.now();
  TabController controller;
  @override
  void initState() {

    //myEntriesDetails();
    // myReceiveableEntries();
    // myPayableEntries();
    // myEarningEntries();
    // myExpenditureEntries();
    controller = TabController(length: 2, vsync: this, initialIndex: 0);
    super.initState();
  }
  Future<Null> seleceDate(BuildContext context) async {
    final DateTime _seldate = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(DateTime.now().year - 5),
        lastDate: DateTime.now().subtract(Duration(days: 0)),
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
  void dispose() {
    controller.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    String formattedDate = new DateFormat.yMMM().format(_currentDate);
    return Scaffold(

      backgroundColor: BrandColors.colorPrimaryDark,
      body: Container(

        padding: EdgeInsets.symmetric(horizontal: 20),
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
           children: [
             Container(
             //  height: 70,
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
               height: 150,
             ),
             Padding(
               padding: EdgeInsets.symmetric(vertical: 20),
               child: Text("Expenses Overview",style: myStyle(18,Colors.white,FontWeight.w500),),
             ),
             Container(
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: [
                   TabBar(
                     physics: BouncingScrollPhysics(),
                     labelColor: Colors.green,
                     indicatorColor: Colors.grey,
                     unselectedLabelColor:
                     Colors.blueGrey,
                     controller: controller,
                     isScrollable: true,
                     tabs: [
                       Tab(
                         child:Text(
                           "Categories",
                           style: myStyle(
                               14,
                               BrandColors.colorDimText),
                         ),
                       ),
                       Tab(
                         child:Text(
                           "Sub-Categories",
                           style: myStyle(
                               14,
                               BrandColors.colorDimText),
                         ),
                       ),
                     ],
                   ),
                   Divider(
                     color: Colors.white70,
                     height: 0,
                   )
                 ],
               ),
             ),
             Container(
               height: MediaQuery.of(context).size.height,
               padding: EdgeInsets.only(
                   bottom: 6, left: 6, right: 6),
               child: TabBarView(
                 controller: controller,
                 physics: BouncingScrollPhysics(),
                 children: <Widget>[
                   ReportCategory(),
                   ReportSubCategory()

                 ],
               ),
             )
           ],
          ),
        ),
      ),
    );
  }
}
