import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_ui/common/changeNotifiers.dart';
import 'package:turbo_ui/component/listview/hangTagFrameWidget.dart';
import 'package:turbo_ui/common/turbo_common.dart';

class SuspensionFrame extends StatefulWidget{
  /// ListView 悬浮分组提示器框架
  /// 
  /// `child` 被包裹的listview小部件 (不能为 null)
  /// 
  /// `controller` listviw的控制器 (不能为 null)
  /// 
  /// `hangTagBuilder` 悬浮标签小部件构造器 (不能为 null)
  /// 
  /// `hangTagWidgetHeight` 悬浮标签高度 (不能为 null)
  /// 
  /// `groupTagLoaclMap` 分组标签位置数据 Map<String, double> (不能为 null)
  /// 
  /// `indexBarHintChangeNotifier` IndexBar触摸提示 通知器 (不能为 null)
  /// 
  /// `indexBarSelectNotifier` IndexBar选中项改变 通知器 (不能为 null)
  SuspensionFrame({
    Key key,
    @required this.child,
    @required this.controller,
    @required this.hangTagBuilder,
    @required this.hangTagWidgetHeight,
    @required this.groupTagLoaclMap,
    @required this.indexBarHintChangeNotifier,
    @required this.indexBarSelectNotifier,
  }) : assert(child != null),
      assert(controller != null),
      assert(hangTagBuilder != null),
      assert(hangTagWidgetHeight != null),
      assert(groupTagLoaclMap != null),
      assert(indexBarHintChangeNotifier != null),
      assert(indexBarSelectNotifier!=null),
      super(key: key);

  /// 被包裹的listview小部件
  final Widget child;
  /// listviw的控制器
  final ScrollController controller;
  /// 悬浮标签小部件
  final HangTagBuilder hangTagBuilder;
  /// 悬浮标签高度
  final double hangTagWidgetHeight;
  /// 分组标签位置
  final Map<String, double> groupTagLoaclMap;
  /// IndexBar触摸提示 通知器
  final IndexBarHintChangeNotifier indexBarHintChangeNotifier;
   /// IndexBar选中项改变 通知器
  final IndexBarSelectionChangeNotifier indexBarSelectNotifier;
  /// 悬浮分组标签位置及标签名改变 通知器
  final HangTagTopChangeNotifier _hangTagTopChangeNotifier = HangTagTopChangeNotifier();
 

  @override
  _SuspensionFrameState createState() => new _SuspensionFrameState();
}

class _SuspensionFrameState extends State<SuspensionFrame> {
  List<double>groupTagLoaclMapList=new List();
  /// 上一个索引
  int _lastIndex;
  /// 悬浮标签当前Top值
  double _suspensionTop = 0.0;
  /// 悬浮标签当前显示的Tag
  String _suspensionTag='';
  /// 根据构造器构造的悬浮标签小部件实例
  Widget _hangTagWidget;

  @override
  void initState(){
    super.initState();

    /// listview滑动监听器
    widget.controller.addListener(() {
      double offset = widget.controller.offset;
      int _index = _getIndex(offset);
      if (_index != -1 && _lastIndex != _index) {
        _lastIndex = _index;
        _suspensionTag = widget.groupTagLoaclMap.keys.toList()[_index];

        widget.indexBarHintChangeNotifier.notifyOnlyTag(_suspensionTag);
        widget._hangTagTopChangeNotifier.notify(_suspensionTop,_suspensionTag);//通知更新部件
        widget.indexBarSelectNotifier.notify(_suspensionTag);
      }
    });
  }
  
  /// 获取当前Tag的索引
  int _getIndex(double offset) {
    //算剩余空间
    for (int i = 0; i < groupTagLoaclMapList.length - 1; i++) {
      double space = groupTagLoaclMapList[i + 1] - offset;
      // 如果当前剩余空间大于0且小于空间高度
      if (space > 0 && space < widget.hangTagWidgetHeight) {
        // 则赋值为差值
        space = space - widget.hangTagWidgetHeight;
      } else {
        // 否则为0
        space = 0;
      }
      if (_suspensionTop != space && widget.hangTagWidgetHeight != null) {
        _suspensionTop = space;
        widget._hangTagTopChangeNotifier.notify(_suspensionTop,_suspensionTag);//通知更新部件
      }
      double a = groupTagLoaclMapList[i];
      double b = groupTagLoaclMapList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
      if (offset >= groupTagLoaclMapList[groupTagLoaclMapList.length - 1]) {
        return groupTagLoaclMapList.length - 1;
      }
    }
    return -1;
  }

  /// 初始化
  void _init()
  {
    /// 保存分组标签数据
    groupTagLoaclMapList..clear()..addAll(widget.groupTagLoaclMap.values);
    /// 设置默认选中的Tag
    if(widget._hangTagTopChangeNotifier.curTag == null || widget._hangTagTopChangeNotifier.curTag == ""){
      if(widget.groupTagLoaclMap != null && widget.groupTagLoaclMap.length != 0){
        widget._hangTagTopChangeNotifier.notifyOnlyTag(widget.groupTagLoaclMap.keys.toList()[0]);
      }
    }
  }

  /// 构造悬浮标签小部件
  Widget _buildHangTagWidget()
  {
    _hangTagWidget = ChangeNotifierProvider.value(
        value: widget._hangTagTopChangeNotifier,
        child: HangTagFrameWidget(childBuilder: widget.hangTagBuilder)
      );
    return _hangTagWidget;
  }

  @override
  Widget build(BuildContext context) {
    _init();

    _buildHangTagWidget();
    var children = <Widget>[
      widget.child,
    ];
    if (widget.hangTagBuilder != null) {
      children.add(_hangTagWidget);
    }
    return Stack(children: children);
  }


}