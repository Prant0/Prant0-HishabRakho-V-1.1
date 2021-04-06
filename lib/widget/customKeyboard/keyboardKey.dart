import 'package:flutter/material.dart';
import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';

class KeyboardKey extends StatefulWidget {
  final dynamic label;
  final dynamic value;
  final ValueSetter<dynamic> onTap;

  KeyboardKey({
    @required this.label,
    @required this.onTap,
    @required this.value,
  })  : assert(label != null),
        assert(onTap != null),
        assert(value != null);

  @override
  _KeyboardKeyState createState() => _KeyboardKeyState();
}

class _KeyboardKeyState extends State<KeyboardKey> {

  // 조건부 렌더링!
  renderLabel(){
    if(widget.label is String){
      return Text(
        widget.label,
        style: myStyle(
          20.0,BrandColors.colorText,
           FontWeight.bold,
        ),
      );
    }else{
      return widget.label;
    }
  }

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: (){
        widget.onTap(widget.value);
      },
      child: AspectRatio(
        aspectRatio: 2,
        child: Container(

          child: Center(
            child: renderLabel(),
          ),
        ),
      ),
    );
  }
}