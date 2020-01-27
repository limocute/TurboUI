import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_ui/common/turbo_common.dart';
import 'package:turbo_ui/common/changeNotifiers.dart';

/// 默认风格的 IndexBar提示 小部件
class IndexBarHintFrameWidget extends StatelessWidget{
  /// IndexBar提示器
  /// 
  /// `indexHintDisplayMode` 提示器显示方式(居中/跟随) 不能为 null
  /// 
  /// `builder` 提示组件构造器(如果为null，则使用默认样式构造提示器)
  IndexBarHintFrameWidget(
    {
      @required this.indexHintDisplayMode,
      @required this.builder,
    }
  ):assert(indexHintDisplayMode != null,'IndexBarHintFrameWidget.indexHintDisplayMode is null');
  
  /// Display Mode(显示方式 )
  final IndexHintDisplayMode indexHintDisplayMode;
  /// ListView Index Bar Hint Widget Builder(listview 的索引栏提示构造器)
  final IndexHintBuilder builder;

  /// 构建默认风格的 提示 部件
  Widget _bulidHint(String hint){
    return Container(
            alignment: Alignment.center,
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color:Colors.blue,//Colors.black54,
              borderRadius:BorderRadius.circular(20) ,
              ),
            child: Text(
              hint,
              style: TextStyle(
                fontSize: 22.0,
                color: Colors.white,
              ),
            ),
          );
  }


  ///构建 跟随提示
  Widget _buildWidgetByFollowOption(BuildContext context,IndexBarHintChangeNotifier notifierModel)
  {
    return Positioned(
          right:  20.0,
          top:  notifierModel.position ,
          child:Offstage(
            offstage: !notifierModel.isTouch,
            child:builder == null ?_bulidHint(notifierModel.curHintTag) : builder(context,notifierModel.curHintTag),
          )
        );
  }

  ///构建 居中提示
  Widget _buildWidgetByCenter(BuildContext context,IndexBarHintChangeNotifier notifierModel)
  {
    return Offstage(
          offstage: !notifierModel.isTouch,
          child:Center(
            child:  builder == null ?_bulidHint(notifierModel.curHintTag) : builder(context,notifierModel.curHintTag),
            )
          );
  }


  @override
  Widget build(BuildContext context) {
    final notifierModel = Provider.of<IndexBarHintChangeNotifier>(context);
    return indexHintDisplayMode == IndexHintDisplayMode.center ? _buildWidgetByCenter(context,notifierModel) : _buildWidgetByFollowOption(context,notifierModel);
  
  }

}