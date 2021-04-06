import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/mfsModel.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChooseMfs extends StatefulWidget {
  final String types;
  ChooseMfs({this.types});
  @override
  _ChooseMfsState createState() => _ChooseMfsState();
}

class _ChooseMfsState extends State<ChooseMfs> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onProgress =false;
  List<MfsModel> mfsList = [];
  MfsModel bankModel;

  Future<List<MfsModel>> getUserMfsData()async{
    if(widget.types=="single"){
      print("lllllllllll");
      var data = await http.get("http://api.hishabrakho.com/api/user/personal/mfs",headers: await CustomHttpRequests.getHeaderWithToken());
      var jsonData = json.decode(data.body);
      print(jsonData);
      for(var u in jsonData){
        bankModel = MfsModel(
          id: u["id"],
          balance: u["balance"],
          storageHubName: u["storage_hub_name"],
          storageHubLogo: u["storage_hub_logo"],
          userStorageHubAccountNumber: u["user_storage_hub_account_number"],
        );
        try {
          mfsList.firstWhere((element) => element.balance == u["balance"]);
        }
        catch(e){
          mfsList.add(bankModel);
        }
      }
      print("${mfsList.length}");
      return mfsList;
    }else{
      var data = await http.get("http://api.hishabrakho.com/api/mfs/details",headers: await CustomHttpRequests.getHeaderWithToken());
      var jsonData = json.decode(data.body);
      print(jsonData);
      for(var u in jsonData){
        bankModel = MfsModel(
          id: u["id"],
          balance: u["balance"],
          storageHubName: u["storage_hub_name"],
          storageHubLogo: u["storage_hub_logo"],
          userStorageHubAccountNumber: u["user_storage_hub_account_number"],
        );
        try {
          mfsList.firstWhere((element) => element.id == u["id"]);
        }
        catch(e){
          mfsList.add(bankModel);
        }
      }
      print("${mfsList.length}");
      return mfsList;
    }
  }
  @override
  void initState() {
    print("llll");
    getUserMfsData();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text("Your MFS",style: myStyle(20,Colors.white,FontWeight.w600),),
      ),

      body: ModalProgressHUD(
        inAsyncCall: onProgress == true,
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 1,
                child: Container(
                  child: _searchBar(),
                ),
              ),
              Expanded(
                  flex: 8,
                  child: FutureBuilder(
                    future: getUserMfsData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(snapshot.data==null){
                        return Container(
                          child: Center(
                            child: Text("Loading",style: myStyle(17,Colors.white),),
                          ),
                        );
                      }else
                      {
                        return Container(
                          margin: EdgeInsets.only(top: 10),
                          child: GridView.builder(
                            gridDelegate:  SliverGridDelegateWithFixedCrossAxisCount(
                                crossAxisCount: 2,
                                crossAxisSpacing: 2,
                                mainAxisSpacing: 2
                            ),

                            itemCount: snapshot.data.length,
                            itemBuilder: (BuildContext context,int index){
                              return GestureDetector(
                                onTap: (){
                                  List list =[];
                                  list.add(mfsList[index].id.toString());
                                  list.add(mfsList[index].storageHubName.toString());
                                  Navigator.of(context).pop(list);
                                },
                                child: Flex(
                                  mainAxisAlignment:MainAxisAlignment.center,
                                  direction: Axis.vertical,
                                  // mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Container(
                                      //
                                      decoration: BoxDecoration(
                                          borderRadius: BorderRadius.circular(10.0),
                                          color: BrandColors.colorPrimary
                                      ),
                                      // padding: EdgeInsets.all(18),

                                      // width: 100,height: 100,
                                      child: Image.network("http://hishabrakho.com/admin/storage/hub/${snapshot.data[index].storageHubLogo}",fit: BoxFit.fill,height: 80,width: 80,),
                                    ),
                                    SizedBox(height:12 ,),
                                    Text(snapshot.data[index].storageHubName.toString() ?? '',style: myStyle(14,BrandColors.colorText,FontWeight.w600),overflow: TextOverflow.ellipsis,),
                                    widget.types=="single" ? Text("A / C : ${snapshot.data[index].userStorageHubAccountNumber.toString() ?? ''}",style: myStyle(12,BrandColors.colorDimText,FontWeight.w400),) :SizedBox()

                                  ],
                                ),
                              );
                            },
                          ),
                        );
                      }
                    },
                  )
              ),
            ],
          ),
        ),
      ),
    );
  }

  _searchBar(){
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24,),
      decoration: BoxDecoration(borderRadius: BorderRadius.circular(18.0)),
      child: TextField(
        style:myStyle(16,Colors.white,FontWeight.w600),
        decoration: InputDecoration(
          hintStyle: myStyle(16,Colors.white,FontWeight.w600),
          hintText: "Search",
          filled: true,
          focusedBorder: InputBorder.none,
          suffixIcon: Icon(Icons.search,color: BrandColors.colorDimText,),
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 15),
          fillColor: BrandColors.colorPrimary,
        ),
        onChanged: (text){
          text=text.toLowerCase();
          setState(() {
            mfsList=mfsList.where((post) {
              var postTitle = post.storageHubName.toLowerCase();
              return postTitle.contains(text);
            }).toList();
          });
        },
      ),

    );
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.purple,
      ),
    );
  }

}
