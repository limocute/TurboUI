import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_ui/common/turbo_common.dart';
import 'package:turbo_ui/common/changeNotifiers.dart';

/// 默认风格的 分组标签 小部件
class DefaultGroupTagWidget extends StatelessWidget{
  /// 默认风格的 分组标签
  /// 
  /// `curTag` 当前分组的Tag
  /// 
  /// `maxHeight` 分组标签的最大高度
  DefaultGroupTagWidget(
  {
    @required this.curTag,
    @required this.maxHeight,
  }):assert(curTag != null)
    ,assert(maxHeight != null);

  final String curTag;
  final double maxHeight;

  Widget _buildWidget(String curGroupTag)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 30.0),
      height: maxHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            curGroupTag,
            textScaleFactor: 1.0,
          ),
          Expanded(
            child: Divider(
              height: .0,
              indent: 10.0,
            )
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return _buildWidget(curTag);
  }

}

/// 默认风格的 IndexBar 小部件
class DefaultIndexBarWidget extends StatefulWidget{
  /// 默认风格的 IndexBar 小部件
  /// 
  /// `data` IndexBar 索引列表数据 List<String> 不能为null
  /// 
  /// `itemBuilder` 字母索引小部件构造器 如果为 null 则使用默认风格构造字母索引部件
  /// 
  /// `onTouch` IndexBar 触摸事件回调
  DefaultIndexBarWidget({
    @required this.data,
    this.itemBuilder,
    this.onTouch,
  }):assert(data != null);
  /// IndexBar 触摸事件回调
  final IndexBarTouchCallback onTouch;
  /// IndexBar 索引列表数据 List<String> 不能为null
  final List<String> data;
  /// 字母索引小部件构造器 如果为 null 则使用默认风格构造字母索引部件
  final IndexBarItemBuilder itemBuilder;

  @override
  State<StatefulWidget> createState() {
    return new DefaultIndexBarState();
  }

}

class DefaultIndexBarState extends State<DefaultIndexBarWidget>{

  List<Widget> _children = new List();
  int _widgetTop = -1;
  int _lastIndex = 0;
  bool _widgetTopChange = false;
  List<int> _indexSectionList = new List();
  IndexBarDetails _indexModel = new IndexBarDetails();

  /// 初始化
  void _init() {
    _widgetTopChange = true;
    _indexSectionList.clear();
    _indexSectionList.add(0);
    int tempHeight = 0;
    widget.data?.forEach((value) {
      tempHeight = tempHeight + 14;
      _indexSectionList.add(tempHeight);
    });
  }

  /// 获取指定坐标的字母索引.
  int _getIndex(int offset) {
    for (int i = 0, length = _indexSectionList.length; i < length - 1; i++) {
      int a = _indexSectionList[i];
      int b = _indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return i;
      }
    }
    return -1;
  }

  /// 获取指定坐标字母索引的Top值
  int _getIndexTop(int offset) {
    for (int i = 0, length = _indexSectionList.length; i < length - 1; i++) {
      int a = _indexSectionList[i];
      int b = _indexSectionList[i + 1];
      if (offset >= a && offset < b) {
        return _indexSectionList[i];
      }
    }
    return -1;
  }

  /// 触摸事件
  _onTouchEvent() {
    if (widget.onTouch != null) {
      widget.onTouch(_indexModel);
    }
  }

  /// 构建indexbar的item
  Widget _buildItem(String tag,String selectionTag){
    return Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: tag== selectionTag ? Colors.blue : Colors.transparent,
          borderRadius: BorderRadius.circular(14 * 0.5),
        ),
        child: Text(
                  tag,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                        fontSize: 10.0,
                        color: tag== selectionTag ? Colors.white : Color(0xFF555555),
                        fontWeight: FontWeight.w500,
                      ),  
                ),
        width: 14.0,
        height: 14.0,
      );
  }

  /// 构建 字母索引 小部件
  void _buildWidgets(BuildContext context,String selectionTag){
    _children.clear();
    widget.data.forEach((tag) {
      Widget tagWidget;
      if(widget.itemBuilder != null){
        tagWidget = widget.itemBuilder(context,tag,selectionTag);
      }
      else{
        tagWidget = _buildItem(tag,selectionTag);
      }
      
      _children.add(tagWidget);
    });
  }


  @override
  Widget build(BuildContext context) {
    final notifierModel = Provider.of<IndexBarSelectionChangeNotifier>(context);
    _init();
    _buildWidgets(context,notifierModel.selectTag);

    return GestureDetector(
      behavior: HitTestBehavior.opaque,//解决使用GestureDetector包裹Container在Container内容为空的区域点击时，捕捉不到onTap点击事件
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: _children,
        ),
      onVerticalDragDown: (DragDownDetails details) {
        //手指按下并在垂直方向上移动时触发
        if (_widgetTop == -1 || _widgetTopChange) {
          _widgetTopChange = false;
          RenderBox box = context.findRenderObject();
          Offset topLeftPosition = box.localToGlobal(Offset.zero);
          _widgetTop = topLeftPosition.dy.toInt();
        }
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);

        if (index != -1) {
          _lastIndex = index;
          _indexModel.position = _getIndexTop(offset)+_widgetTop;//当前项目top+indexbar控件top为实际相对屏幕的top
          _indexModel.tag = widget.data[index];
          _indexModel.isTouch = true;
          //触发事件
          _onTouchEvent();
        }
      } , 
      onVerticalDragUpdate: (DragUpdateDetails details){
        //与屏幕接触并垂直移动的指针沿垂直方向移动
        int offset = details.globalPosition.dy.toInt() - _widgetTop;
        int index = _getIndex(offset);

        if (index != -1 && _lastIndex != index) {
          _lastIndex = index;
          _indexModel.position = _getIndexTop(offset)+_widgetTop;
          _indexModel.tag = widget.data[index];
          _indexModel.isTouch = true;
          //触发事件
          _onTouchEvent();
        }
      },
      onVerticalDragEnd: (DragEndDetails details){
        //以前与屏幕接触并垂直移动的指针不再与屏幕接触，并且当其停止接触屏幕时以特定速度移动。
         _indexModel.isTouch = false;
         //触发事件
         _onTouchEvent();
      },
      onTapUp:(TapUpDetails details){
        //触发点的指针已停止在特定位置与屏幕联系
         _indexModel.isTouch = false;
         //触发事件
         _onTouchEvent();
      }  

    );
  }

}