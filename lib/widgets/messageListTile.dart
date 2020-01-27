import 'package:flutter/material.dart';
import 'package:turbo_ui/turbo_extension.dart';

class MessageListTile extends StatelessWidget{
  MessageListTile(
    {
      @required this.leading,
      this.leadingWidth,
      this.content,
      this.trailing,
      this.trailingWidth,
      this.nickName,
      this.messageDigest,
      this.transmissionTime,
      this.heigth = 60.0,
      this.padding = const EdgeInsets.all(0.0),
      this.onTap,
      this.onDoubleTap,
      this.onLongPress,
      this.borderRadius,
      this.backgroundColor = Colors.transparent,
      this.highlightColor = Colors.transparent,
      this.splashColor = null,
      this.radius = null,
    }
  ):assert(!(leading != null && leadingWidth == null),'[leadingWidth] cannot be null when [leading] is not null'),
  assert(!(trailing != null && trailingWidth == null),'[trailingWidth] cannot be null when [trailing] is not null');
  
  /// 显示左边的部件
  final Widget leading;
  /// 左边部件的宽度
  final double leadingWidth;
  /// 右边部件
  final Widget trailing;
  /// 右边部件的宽度
  final double trailingWidth;
  /// 中间内容部件
  final Widget content;
  /// 昵称
  final Widget nickName;
  ///消息摘要
  final Widget messageDigest;
  /// 消息发送时间
  final DateTime transmissionTime;
  /// 最大高度
  final double heigth;
  /// 单击事件
  final VoidCallback onTap;
  /// 双击事件
  final VoidCallback onDoubleTap;
  /// 长按事件
  final VoidCallback onLongPress;
  /// 控件圆角
  final BorderRadiusGeometry borderRadius;
  /// 背景色(为 null 时为透明色)
  final Color backgroundColor;
  /// toch时的高亮色(为 null 时为默认色)
  final Color highlightColor;
  /// 水波颜色(为 null 时为默认色)
  final Color splashColor;
  ///水波半径(为null 时自动设置)
  final double radius;
  /// padding
  final EdgeInsetsGeometry padding;

  /// ontap事件必须指定方法，否则当外部不指定ontap事件时不会有水波
  void _onTap(){
    if(this.onTap != null){
      this.onTap();
    }
  }

  /// 构造默认的中间内容部件
  Widget _buildDefContent(){
    
    return Padding(
      padding: EdgeInsets.only(left: 5.0,right: 5.0),
      child: Align(alignment: Alignment.centerLeft,
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          this.nickName,
          this.messageDigest,
        ],
      )
      ) 
    );
  }

  /// 格式化显示发送时间
  String _changeShowTime(DateTime time){
    var _newDate = DateTime.now();
    // 如果不同年，则显示【年-月】
    if(!time.isSameValue(_newDate.year,DateTimeUnits.Y))
      return time.format(fm:'yyyy-MM');
    // 如果不同月，则显示【月-日期】
    if(!time.isSameValue(_newDate.month,DateTimeUnits.M))
      return time.format(fm:'MM-dd');  
    // 如果不是当天，则显示【月-日期】  
    if(!time.isSameDate(_newDate))
      return time.format(fm:'MM-dd'); 
    // 如果不是当前小时，则显示【小时-分钟】   
    if(!time.isSameValue(_newDate.hour,DateTimeUnits.H))
      return time.format(fm:'HH:ss');   
    // 如果不是当前分钟
    if(!time.isSameValue(_newDate.minute,DateTimeUnits.MIN))
    {
      //如果时差小于2分钟就显示【刚刚】,否则显示【小时-分钟】
      if(_newDate.minute - time.minute < 2)  
        return '刚刚';
      else
        return time.format(fm:'HH:ss');
    }
    else 
      return('刚刚');
  }

  /// 构建默认右边部件
  Widget _buildDefTrailing()
  {
    return Align(
      alignment:Alignment.centerRight,
      child: Padding(padding:EdgeInsets.only(right: 18.0),
        child: LimitedBox(
          maxWidth: 140.0,
            child: Text(
              _changeShowTime(transmissionTime) ,
              softWrap: false,
              style: TextStyle(fontSize: 15.0, color: Colors.grey),
          )
        )
      )
    );
  }

  /// 构建左边部件
  Widget _buildLeadingWidget(){
    return SizedBox(
      child: this.leading,
      height: this.heigth,
      width: this.leadingWidth,
      );
  }

  /// 构建中间内容部件
  Widget _buildContentWidget(){
    return SizedBox(
      child: this.content == null ? _buildDefContent() : this.content,
      height: this.heigth,
      );
  }

  /// 构建右边部件
  Widget _buildTrailingWidget(){
    return SizedBox(
      child: this.trailing == null ? _buildDefTrailing() : this.trailing,
      height: this.heigth,
      width: this.trailingWidth,
      );
  }

  /// 构建Ink装饰容器
  Decoration _buildInkBoxDecoration(){
    if(this.borderRadius == null)
      return null;
    return BoxDecoration(
      color: this.backgroundColor,
      borderRadius: this.borderRadius,
    );  
  }

  /// 构建部件
  @override
  Widget build(BuildContext context) {
    final _realLeadingWidth = this.leading != null ? this.leadingWidth : 0.0;
    final _realTrailingWidth = this.trailing != null ? this.trailingWidth : 140.0;

    List<Widget> widgets = new List();
    widgets.add(_buildLeadingWidget());
    widgets.add(_buildContentWidget());
    widgets.add(_buildTrailingWidget());
    
    return Ink(
      color: this.borderRadius != null ? null : this.backgroundColor,
      decoration: _buildInkBoxDecoration(),
      child:InkWell(
        borderRadius: this.borderRadius,
        splashColor: this.splashColor,
        highlightColor: this.highlightColor,
        radius: this.radius,
        onTap: (){
          _onTap();
        },
        onDoubleTap: this.onDoubleTap,
        onLongPress: this.onLongPress,
        child: Padding(
          padding: this.padding,
          child: Container(
            alignment: Alignment.centerLeft,
            height: this.heigth,
            child: Container(
              child: Table(
                defaultVerticalAlignment: TableCellVerticalAlignment.middle,
                children: [
                  TableRow(children:widgets),
                ],
                columnWidths:{
                  0: FixedColumnWidth(_realLeadingWidth),
                  2: FixedColumnWidth(_realTrailingWidth)
                },
              )
            )
          )
        )
      )
    );
  }
}