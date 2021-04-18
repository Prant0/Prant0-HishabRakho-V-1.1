import 'dart:convert';
import 'package:anthishabrakho/screen/registation_page.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/http/http_requests.dart';
import 'package:anthishabrakho/models/bankModel.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:modal_progress_hud/modal_progress_hud.dart';

class ChooseBank extends StatefulWidget {
  final String types;
  ChooseBank({this.types});
  @override
  _ChooseBankState createState() => _ChooseBankState();
}

class _ChooseBankState extends State<ChooseBank> {

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  bool onProgress =false;

  BankModel bankModel;

  Future<List<BankModel>> getUserBankData()async{
    if(widget.types=="single"){
      print("single");
      var data = await http.get("http://api.hishabrakho.com/api/user/personal/banks",headers: await CustomHttpRequests.getHeaderWithToken());
      var jsonData = json.decode(data.body);
      print(jsonData);
      for(var u in jsonData){
        bankModel = BankModel(
          id: u["id"],
          balance: u["balance"],
          storageHubName: u["storage_hub_name"],
          storageHubLogo: u["storage_hub_logo"],
          userStorageHubAccountNumber: u["user_storage_hub_account_number"],
        );
        try {
          bankList.firstWhere((element) => element.id == u["id"]);
        }
       catch(e){
         bankList.add(bankModel);
       }
      }
      print("${bankList.length}");
      return bankList;
    }else{
      var data = await http.get("http://api.hishabrakho.com/api/bank/details",headers: await CustomHttpRequests.getHeaderWithToken());
      var jsonData = json.decode(data.body);
      print(jsonData);
      for(var u in jsonData){
        bankModel = BankModel(
          id: u["id"],
          balance: u["balance"],
          storageHubName: u["storage_hub_name"],
          storageHubLogo: u["storage_hub_logo"],
          userStorageHubAccountNumber: u["user_storage_hub_account_number"],
        );
        try {
          bankList.firstWhere((element) => element.id == u["id"]);
        }
        catch(e){
          bankList.add(bankModel);
        }
      }
      print("${bankList.length}");
      return bankList;
    }
  }


  @override
  void initState() {
    getUserBankData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text(widget.types=="single"? "My Bank" : "Bank Storage",style: myStyle(20,Colors.white,FontWeight.w600),),
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
                    future: getUserBankData(),
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                     if(snapshot.data==null){
                       return Container(
                         child: Center(
                           child: Text("Loading",style: myStyle(17,Colors.white),),
                         ),
                       );
                     }else
                      {
                        return GridView.builder(
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
                                list.add(bankList[index].id.toString());
                                list.add(bankList[index].storageHubName.toString());
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
                                    padding: EdgeInsets.all(10),

                                   // width: 100,height: 100,
                                    child: Image.network("http://hishabrakho.com/admin/storage/hub/${snapshot.data[index].storageHubLogo}",fit: BoxFit.cover,height: 80,width: 80,),
                                  ),
                                  SizedBox(height:12 ,),
                                  Text(snapshot.data[index].storageHubName.toString() ?? '',style: myStyle(14,BrandColors.colorText,FontWeight.w600),overflow: TextOverflow.ellipsis,),



                                  widget.types=="single" ? Text("A / C : ${snapshot.data[index].userStorageHubAccountNumber.toString() ?? ''}",style: myStyle(12,BrandColors.colorDimText.withOpacity(0.6),FontWeight.w400),overflow: TextOverflow.ellipsis,) :SizedBox(height: 2,)

                                ],
                              ),
                            );
                          },
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

  List<BankModel> bankList = [];
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
              bankList=bankList.where((post) {
                var postTitle = post.storageHubName.toLowerCase();
                return postTitle.contains(text);
              }).toList();
            });
          },
        ),

    );
  }
  /* _searchBar(){
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30),
      child: TextField(
        style:myStyle(16,Colors.white,FontWeight.w600),
        decoration: InputDecoration(
          hintStyle: myStyle(16,Colors.white,FontWeight.w600),
          hintText: "Search"
        ),
        onChanged: (text){
          text=text.toLowerCase();
          setState(() {
            bankList=bankList.where((post) {
              var postTitle = post.storageHubName.toLowerCase();
              return postTitle.contains(text);
            }).toList();
          });
        },
      ),
    );
  }*/
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(
      new SnackBar(
        content: Text(
          value,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800),
        ),
        backgroundColor: Colors.indigo,
      ),
    );
  }

}
