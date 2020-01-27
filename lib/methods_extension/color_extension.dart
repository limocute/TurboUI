import 'package:flutter/material.dart';

extension ColorExtension on Color{
  /// 将指定的颜色值转换为ARGB颜色
  Color toARGBColor({int alpha = 255}){
    if(this == null)
      return null;
    int red = this.red;
    int green = this.green;
    int blue = this.blue;
   
    // 通过fromARGB返回带透明度和RGB值的颜色
    return Color.fromARGB(alpha,red, green, blue);
  }
}