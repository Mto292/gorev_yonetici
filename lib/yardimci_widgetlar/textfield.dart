import 'package:flutter/material.dart';
import 'package:gorevyonetici/responsive/responsive.dart';

//ekranlara kullanılacak text field
class MyTextField extends StatelessWidget {
  TextEditingController controller;
  FocusNode focusNode;
  TextInputAction textInputAction;
  TextInputType keyboardType;
  TextStyle textStyle;
  bool autofocus;
  int maxLines;
  int maxLength;
  Function onTap;
  Icon icon;
  Icon prefixIcon;
  Icon suffixIcon;
  String label;

  MyTextField({
    Key key,
    this.controller,
    this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.textStyle,
    this.autofocus,
    this.maxLines,
    this.maxLength,
    this.onTap,
    this.icon,
    this.prefixIcon,
    this.suffixIcon,
    this.label,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: this.controller,
      focusNode: this.focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      style: textStyle,
      autofocus: this.autofocus ?? true,
      maxLength: maxLength,
      maxLines: maxLines,
      onTap: this.onTap,
      decoration: InputDecoration(
        icon: icon,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        border: OutlineInputBorder(
          borderSide: BorderSide(width: SizeConfig.screenWidth * 0.001),
        ),
      ),
    );
  }
}
