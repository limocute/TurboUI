import 'dart:ui';
import 'package:flutter/material.dart';

/// 高斯模糊部件
class TurboBlur extends StatefulWidget {

  final Widget child;
  /// 模糊值
  final double sigmaX;
  final double sigmaY;
  /// 透明度
  final double opacity;
  /// 外边距
  final double margin;
  final BoxShape shape;
  final BorderRadiusGeometry borderRadius;

  /// 高斯模糊部件
  /// 
  /// `child` 需要添加高斯模糊的部件
  /// 
  /// `sigmaX` X轴模糊值
  /// 
  /// `sigmaY` Y轴模糊值
  /// 
  /// `opacity` 透明度
  /// 
  /// `margin` 外边距
  const TurboBlur(
      {Key key,
      @required this.child,
      this.sigmaX,
      this.sigmaY,
      this.opacity = 0.0,
      this.margin,
      this.shape = BoxShape.rectangle,
      this.borderRadius,
      })
      : assert(child != null,'TurboBlur.[child] is null')
      , super(key: key);

  @override
  _TurboBlurState createState() => _TurboBlurState();
}

class _TurboBlurState extends State<TurboBlur> {

  Widget _buildBlurWidget(){
    return Container(
      margin: widget.margin ?? EdgeInsets.all(0.0),
      child: ClipRRect(
        borderRadius: widget.borderRadius ?? BorderRadius.circular(0.0),
        child: BackdropFilter(
          filter: ImageFilter.blur(
            sigmaX: this.widget.sigmaX ?? 20,
            sigmaY: this.widget.sigmaY ?? 20,
          ),
          child: Container(
            color: Colors.white10,
            child: this.widget.opacity != null
                ? Opacity(
                    opacity: widget.opacity,
                    child: this.widget.child,
                  )
                : this.widget.child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      overflow:Overflow.clip,
      children: <Widget>[
        widget.child,
        _buildBlurWidget()
      ],
    );_buildBlurWidget();
  }
}