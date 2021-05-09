import 'package:anthishabrakho/globals.dart';
import 'package:anthishabrakho/widget/brand_colors.dart';
import 'package:flutter/material.dart';

class SenderTextEdit extends StatelessWidget {
  SenderTextEdit({
    this.icon,
    this.keytype,
    this.lebelText,
    this.keyy,
    this.maxNumber,
    this.name,
    this.function,
    this.data,
    this.hintText,
    this.initialText,
    this.suffixIcon,
    this.formatter,
    this.onChangeFunction,
    this.suffixText,
  });

  final TextEditingController name;
  final Function onChangeFunction;
  final dynamic data;
  final dynamic icon;
  final dynamic suffixIcon;
  final String initialText;
  final Function function;
  final String hintText;
  final int maxNumber;
  final String lebelText;
  final dynamic formatter;
  final dynamic keytype;
  final String suffixText;

  final String keyy;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.symmetric( vertical: 8),
      child: TextFormField(

        minLines: 1,
        maxLines: maxNumber ?? 1,
        initialValue: initialText,
        keyboardType: keytype,
        controller: name,
        inputFormatters: formatter,
        validator: function,
        onSaved: (String value) => data[keyy] = value,
        onChanged: onChangeFunction,
        autofocus: false,
        style: myStyle( 14.0,  BrandColors.colorDimText),
        decoration: InputDecoration(hoverColor: Colors.black,
          filled: true,
          suffixText: suffixText,
          errorStyle: myStyle(12,Colors.redAccent.withOpacity(0.9),FontWeight.w500),
          contentPadding: EdgeInsets.symmetric(vertical: 20,horizontal: 20),
          fillColor: BrandColors.colorPrimary,
          focusedBorder:OutlineInputBorder(
            borderSide: const BorderSide(color: Colors.transparent, width: 1.0),
            borderRadius: BorderRadius.circular(12.0),
          ),

          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12.0),
            borderSide: BorderSide(
              color: Colors.transparent,
              width: 2.0,
            ),
          ),

          labelText: hintText,
          hintStyle: myStyle(12, BrandColors.colorDimText),

          suffixIcon: suffixIcon,
          prefixIcon: icon,
          labelStyle: myStyle(12,BrandColors.colorDimText),
          hintText: lebelText,
        ),
      ),
    );
  }
}