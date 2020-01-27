import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_ui/common/turbo_common.dart';
import 'package:turbo_ui/common/changeNotifiers.dart';

class HangTagFrameWidget extends StatelessWidget{
  /// 分组悬浮标签框架
  /// 
  /// `childBuilder` 悬浮标签构造器
  HangTagFrameWidget({
    @required this.childBuilder,
  }):assert(childBuilder != null,'HangTagFrameWidget.childBuilder is null');

  final HangTagBuilder childBuilder;

  ///是否隐藏控件
  bool _hideWidget(HangTagTopChangeNotifier notifierModel){
    if(notifierModel.curTag == null || notifierModel.curTag == '↑' || notifierModel.curTag == '')
      return true;
    return false;
  }

  @override
  Widget build(BuildContext context) {
    final notifierModel = Provider.of<HangTagTopChangeNotifier>(context);
    return Positioned(
          ///-0.1修复部分手机丢失精度问题
          top: notifierModel.curTop,
          left: 0.0,
          right: 0.0,
          child: Offstage(
            offstage: _hideWidget(notifierModel),
            child:childBuilder(context,notifierModel.curTag),
          )
        );
  }
}