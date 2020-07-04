import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:gorevyonetici/responsive/responsive.dart';

//Ekranlarda text göstermek için oluşturuldu
class Label extends StatelessWidget {
  String text;
  Color color;
  double size;

  Label({
    Key key,
    this.text,
    this.color,
    this.size,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Container(
      child: Text(
        this.text,
        style: TextStyle(
          color: color != null ? color : Colors.black,
          fontSize: size != null ? size : SizeConfig.safeBlockHorizontal * 7,
          fontWeight: FontWeight.w400,
        ),
      ),
    );
  }
}
