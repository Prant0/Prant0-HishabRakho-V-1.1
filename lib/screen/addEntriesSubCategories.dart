import 'package:anthishabrakho/screen/form_screen/fundTransfer_form.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/entries_Home_Model.dart';
import 'package:anthishabrakho/screen/form_screen/earning_form.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';

class AddEntriesSubCategories extends StatefulWidget {
  int id;
  String namee;

  AddEntriesSubCategories({this.namee, this.id});

  @override
  _AddEntriesSubCategoriesState createState() =>
      _AddEntriesSubCategoriesState();
}

class _AddEntriesSubCategoriesState extends State<AddEntriesSubCategories> {
  List<EntriesHomeModel> list = [];

  @override
  void initState() {
    addEntryesCategories();
    super.initState();
  }
  Future<dynamic> addEntryesCategories() async {
    final data = await CustomHttpRequests.addEntriesSubcategories(widget.id);
    print("SubCategories are are $data");
    for (var entries in data) {
      EntriesHomeModel model = EntriesHomeModel(
          id: entries["id"],
          position: entries["position"],
          classIcon: entries["subcategory_icon"],
          eventClassName: entries["event_sub_category_name"],
          eventCategoryId: entries["event_category_id"]);
      try {
        list.firstWhere((element) => element.id == entries['id']);
      } catch (e) {
        setState(() {
          list.add(model);
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor:BrandColors.colorPrimaryDark,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 8,),
          height: double.infinity,
          width: double.infinity,
          child: ListView(
            children: [

              Container(
                  margin: EdgeInsets.only(bottom: 40,top: 10,left: 10,right: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("What kinds of ${widget.namee}",style: myStyle(20,Colors.white,FontWeight.w500),),
                      Text("would you like to add",style: myStyle(18,Colors.white,FontWeight.w500),),
                    ],
                  )

              ),
            list.isNotEmpty?  GridView.builder(
              gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 2,
                  mainAxisSpacing: 2
              ),
                physics: BouncingScrollPhysics(),
                shrinkWrap: true,
                scrollDirection: Axis.vertical,
                itemCount: list.length,
                itemBuilder: (context, index) {
                  return GestureDetector(
                    onTap: () {
                      print("widget name is ${widget.namee}");
                      widget.namee == "Fund Transfer"
                          ? Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => FundTransferForm(
                                      id: list[index].id,
                                      title: list[index].eventClassName,
                                      name: widget.namee)))
                          : Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => EarningForm(
                                        id: list[index].id,
                                        title: list[index].eventClassName,
                                        name: widget.namee,
                                      )));
                    },
                    child: Card(
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(13.0)),
                      elevation: 10,
                      color:BrandColors.colorPrimary,
                      //width: MediaQuery.of(context).size.width / 1,
                      child: Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                         // crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            CachedNetworkImage(
                              imageUrl:
                                  "http://api.hishabrakho.com/admin/${list[index].classIcon}",
                              width: 60,
                              height: 50,
                              fit: BoxFit.cover,
                              placeholder: (context, url) =>
                                  Spin(),
                              errorWidget: (context, url, error) =>
                                  Icon(Icons.error),
                            ),
                            SizedBox(height: 5,),
                            Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Center(
                                child: Text(
                                  list[index].eventClassName.toString(),
                                  style: myStyle(16, Colors.white),
                                ),
                              ),
                            ),

                          ],
                        ),
                      ),
                      margin: EdgeInsets.symmetric(vertical: 7,horizontal: 7),
                    ),
                  );
                },
              ) : Spin(),

            ],
          )),
    );
  }
}
