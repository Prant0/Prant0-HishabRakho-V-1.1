import 'package:anthishabrakho/screen/localization/localization_Constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/entries_Home_Model.dart';
import 'package:anthishabrakho/screen/addEntriesSubCategories.dart';
import 'package:anthishabrakho/widget/Circular_progress.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AddEntriesCategories extends StatefulWidget {
  int id;
  String name;

  AddEntriesCategories({this.name, this.id});

  @override
  _AddEntriesCategoriesState createState() => _AddEntriesCategoriesState();
}

class _AddEntriesCategoriesState extends State<AddEntriesCategories> {
  List<EntriesHomeModel> list = [];

  @override
  void initState() {
    addEntryesCategories();
    super.initState();
  }

  void nextPage() {
    if (widget.id == 8) {}
  }

  Future<dynamic> addEntryesCategories() async {
    final data = await CustomHttpRequests.addEntriesCategories(widget.id);
    print("SubCategories are are $data");
    for (var entries in data) {
      EntriesHomeModel model = EntriesHomeModel(
          id: entries["id"],
          position: entries["position"],
          classIcon: entries["category_icon"],
          eventClassName: entries["event_category_name"]);
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
        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        centerTitle: true,
      ),
      body: Container(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          child: SingleChildScrollView(
            child:Column(
              children: [

                Container(
                  margin: EdgeInsets.only(bottom: 50),
                  //padding: EdgeInsets.symmetric(horizontal: 15,vertical: 15),
                 // height: 100,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text("${getTranslated(context,'t91')} ${widget.name}",style: myStyle(20,Colors.white,FontWeight.w500),),   //what kind of
                      Text(getTranslated(context,'t92')                //"would you like to add ?"
                        ,style: myStyle(20,Colors.white,FontWeight.w500),),
                    ],
                  )

                ),

                list.isNotEmpty? ListView.builder(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  scrollDirection: Axis.vertical,
                  itemCount: list.length,
                  itemBuilder: (context, index) {
                    return GestureDetector(
                      onTap: () {
                        print("widget name is ${widget.name}");
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => AddEntriesSubCategories(
                                  id: list[index].id,
                                  namee: widget.name,
                                )));
                      },
                      child: Container(
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(8.0),
                          color: BrandColors.colorPrimary,
                        ),
                        padding: EdgeInsets.symmetric(vertical: 20),
                        margin: EdgeInsets.symmetric(vertical: 5),
                        child:Row(
                          children: [
                            Expanded(
                              flex: 3,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 8,),
                                child: CachedNetworkImage(
                                  imageUrl:
                                  "http://hishabrakho.com/admin/${list[index].classIcon}",
                                  height: 27,width: 23,
                                  fit: BoxFit.cover,
                                  placeholder: (context, url) => Padding(
                                      padding: const EdgeInsets.all(0.0),
                                      child: Spin()
                                  ),
                                  errorWidget: (context, url, error) =>
                                      Icon(Icons.error),
                                ),
                              ),
                            ),

                            Expanded(
                              flex: 7,
                              child: Text(list[index].eventClassName,style: myStyle(14,Colors.white,FontWeight.w500),),
                            ),

                            Expanded(
                              flex: 2,
                              child:Container(
                                padding: const EdgeInsets.all(0.0),
                                child: SvgPicture.asset("assets/arrow1.svg",
                                  alignment: Alignment.center,
                                  fit: BoxFit.contain,
                                ),
                              ),
                            ),

                          ],
                        )
                      ),

                    );
                  },
                ) :Spin(),
              ],
            )
          )),
    );
  }
}
