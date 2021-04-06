import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:anthishabrakho/widget/customKeyboard/keyboardKey.dart';
import 'package:intl/intl.dart';

class CustomKeyboardScreen extends StatefulWidget {
  static const String id = 'customKeyboard';
  @override
  _CustomKeyboardScreenState createState() => _CustomKeyboardScreenState();
}

class _CustomKeyboardScreenState extends State<CustomKeyboardScreen> {
  List<List<dynamic>> keys ;


  dynamic amount;


  bool x=true;
  @override
  void initState() {
    keys=[
      ['1', '2', '3'],
      ['4', '5', '6'],
      ['7', '8', '9'],
      [".", '0', Icon(Icons.backspace_outlined,color: BrandColors.colorText,)],
    ];
    amount="";
    super.initState();
  }

  onKeyClick(val){
    if(val=="0"  && amount.length ==0 || val=="."  && amount.length ==0){
      return;
    }
    setState(() {
      amount=amount+val;
    });
  }

  onBackSpacePress(){
    if(amount.length ==0){
      return;
    }
    setState(() {
      amount=amount.substring(0,amount.length-1);
    });
  }
  renderKeyboard() {
    return keys
        .map(
          (x) => Row(
        children: x.map((y) {
          return Expanded(
            child: KeyboardKey(
              label: y,
              onTap: (val) {
                if(val is Widget){
                  onBackSpacePress();
                }
                else{
                  onKeyClick(val);
                }
              },
              value: y,
            ),
          );
        }).toList(),
      ),
    )
        .toList();
  }

  renderConfirmButton() {
    return Row(
      children: [
        Expanded(
          child:GestureDetector(
            onTap:amount.length>0? (){}:null,
            child: Container(
              alignment: Alignment.center,
              margin: EdgeInsets.all(12.0),
              decoration: BoxDecoration(
                color:amount.length >0?  BrandColors.colorPurple:Colors.grey,
                borderRadius: BorderRadius.circular(12.0),
              ),
              child: Padding(
                padding: EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  'Confirm',
                  style: TextStyle(
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  renderAmount(){
    String display ="Tk";
    TextStyle style=myStyle(20,Colors.grey,FontWeight.w500);
    if(this.amount.length >0){
      NumberFormat f = NumberFormat.currency(
          decimalDigits: (amount)
          is int
              ? 0
              : 2,
          symbol: '',
          locale: "en-in");
     //display= Double.parseDouble(amount.getText().toString().replace(",", ""));
     //
      //display=f.format(double.parse(amount.toString().replaceAll(".","")))+"Tk";
      /*display.toString().contains(".")? setState((){
        x=false;
        print("wwwwwwwwwwwwww");
      }):setState((){
        x=true;
        print("eeeeee");
      });*/


      display= f.format(double.parse(amount))+"Tk";
      if(amount.length-1 =="."){
        setState(() {
          x=true;
          print("Pppppppp");

        });
      }else {
        setState(() {
          x=false;
          print("wwwww");
        });
      }
      style=style.copyWith(color: Colors.red);
    }
    return Expanded(
      child: Center(child: Text(display,style: myStyle(30,Colors.grey,FontWeight.w500),)),
    );
  }

  bool xx=false;
  @override
  Widget build(BuildContext context) {

    return SafeArea(
        child: Scaffold(
      backgroundColor: BrandColors.colorPrimaryDark,
      body: Container(

        child: Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children:[
              renderAmount(),
              ...renderKeyboard(),
              //SizedBox(height: 8,),
              renderConfirmButton(),
              //SizedBox(height: 15,),

            ]
        ),
      ),
    )
    );
  }
}