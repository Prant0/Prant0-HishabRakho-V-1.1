import 'dart:convert';
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
  List<BankModel> bankList = [];
  BankModel bankModel;

  Future<List<BankModel>> getUserBankData()async{
    if(widget.types=="single"){
      print("llllllllll");
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


  /* Future<List<BankModel>> fetchUserBankList()async{
    try{
      final responce = await http.get("http://api.hishabrakho.com/api/user/personal/banks",headers:await CustomHttpRequests.getHeaderWithToken());
      if(20==responce.statusCode){
        final List<BankModel> bankModels = bankModelFromJson(responce.body);
        print("ffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffffff");
        return bankModels;
      }else{
        // ignore: deprecated_member_use
        return List<BankModel>();
      }
    }
    catch(e){
      // ignore: deprecated_member_use
      return List<BankModel>();
    }
  }*/

  @override
  void initState() {
    print("llll");
    getUserBankData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: BrandColors.colorPrimaryDark,
      appBar: AppBar(
        backgroundColor: BrandColors.colorPrimaryDark,
        title: Text("Your Bank",style: myStyle(20,Colors.white,FontWeight.w600),),
      ),

      body: ModalProgressHUD(
        inAsyncCall: onProgress == true,
        child: Container(
          child: Column(
            children: [
              Expanded(
                flex: 2,
                child: Container(

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
                              child: Column(
                                children: [
                                  Container(

                                    decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10.0),
                                      color: BrandColors.colorPrimary
                                    ),
                                    padding: EdgeInsets.all(18),
                                    width: 100,height: 100,
                                    child: Image.network("http://hishabrakho.com/admin/storage/hub/${snapshot.data[index].storageHubLogo}"),
                                  ),
                                  SizedBox(height:15 ,),
                                  Text(snapshot.data[index].storageHubName.toString() ?? '',style: myStyle(16,Colors.white),)
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
