import 'package:flutter/material.dart';
import 'package:turbo_ui/methods_extension/color_extension.dart';

const Color _defaultShanowColor = const Color(0XFF9E9E9E);//Colors.grey;

/// TurboShadow Shadow Show mode.(TurboShadow显示类型 边界/投影)
enum  ShadowType{
  /// 无阴影
  none,
  /// shine 边界发光
   shine,
  /// shadow 投影(与系统默认的阴影一样，为:右下仿投影)
   shadow,
   /// 自定义阴影位置
   custom,
}

/// 为任何部件添加阴影
class TurboShadow extends StatelessWidget{
  ///阴影部件
  ///
  ///`child` 要实现阴影的部件
  ///
  ///`shandowShape` 阴影形状,默认 BoxShape.rectangle (矩形/圆形)
  ///
  ///`shandowBorderRadius` 阴影圆角角度(当shandowShape = BoxShape.rectangle 时此值有效)
  ///
  ///`shadowType` 显示类型,默认 ShadowType.shadow (边界/投影)
  ///
  ///`customShadowOffset` 自定义阴影位置(当shadowType = ShadowType.custom 时此值有效)
  ///
  ///`blurRadius` 阴影模糊程度,默认 1.0
  ///
  ///`spreadRadius` 阴影扩散程度,默认 0.0
  ///
  ///`shadowOpacity` 阴影透明度,默认 255
  ///
  ///`shanowColor` 阴影颜色,默认 Colors.grey => Color(0XFF9E9E9E)
  TurboShadow({
    @required this.child,
    this.shandowShape = BoxShape.rectangle,
    this.shandowBorderRadius,
    this.shadowType = ShadowType.shadow,
    this.customShadowOffset,
    this.blurRadius = 1.0,
    this.spreadRadius = 0.0,
    this.shadowOpacity = 255,
    this.shanowColor = _defaultShanowColor
  }):assert(child != null,'TurboShadow.[child] is null')
  ,assert(shandowShape != null || shandowBorderRadius != null,'TurboShadow.[shandowShape] and TurboShadow.[shandowBorderRadius] cannot both be null')
  ,assert(!(shadowType == ShadowType.custom && customShadowOffset == null ),'When TurboShadow.[shadowType] = shadowtype.custom, the TurboShadow.[customShadowOffset] cannot be null');
  
  final Widget child;
  final BoxShape shandowShape;
  final BorderRadiusGeometry shandowBorderRadius;
  final ShadowType shadowType;
  final double blurRadius;
  final double spreadRadius;
  final int shadowOpacity;
  final Color shanowColor;
  final Offset customShadowOffset;

  /// 钩爪阴影数据
  List<BoxShadow>_buildShadows(){
    // offset 阴影位置 (1,1)右下，(-1,-1)左上,(1,-1)右上,(-1,1)左下
    // blurRadius 阴影模糊程度
    // spreadRadius 阴影扩散程度
    switch(shadowType)
    {
      case ShadowType.shadow:
        return [
                BoxShadow(color: this.shanowColor, offset: Offset(1, 1), blurRadius: this.blurRadius, spreadRadius: this.spreadRadius)
              ];
        break;
      case ShadowType.shine:
        return [
          BoxShadow(color: this.shanowColor.toARGBColor(alpha:this.shadowOpacity), offset: Offset(1, 1), blurRadius: this.blurRadius, spreadRadius: this.spreadRadius),
          BoxShadow(color: this.shanowColor.toARGBColor(alpha:this.shadowOpacity), offset: Offset(-1, -1), blurRadius: this.blurRadius, spreadRadius: this.spreadRadius),
          BoxShadow(color: this.shanowColor.toARGBColor(alpha:this.shadowOpacity), offset: Offset(1, -1), blurRadius: this.blurRadius, spreadRadius: this.spreadRadius),
          BoxShadow(color: this.shanowColor.toARGBColor(alpha:this.shadowOpacity), offset: Offset(-1, 1), blurRadius: this.blurRadius, spreadRadius: this.spreadRadius),
        ];  
        break;
      case ShadowType.custom:
        return [
          BoxShadow(color: this.shanowColor, offset: this.customShadowOffset, blurRadius: this.blurRadius, spreadRadius: this.spreadRadius)
        ];
        break;
      case ShadowType.none:
        return null;
        break;
      default:
        throw 'An unsupported value is passed in for TurboShadow.[shadowType] (不支持的阴影类型)';
    }
     

    
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: this.child,
      decoration: BoxDecoration(
        shape: this.shandowShape,
        borderRadius: this.shandowShape == BoxShape.circle ? null : this.shandowBorderRadius,
        boxShadow: _buildShadows(),
      ),
    );
  }

}