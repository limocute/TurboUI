import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_ui/common/changeNotifiers.dart';
import 'package:turbo_ui/common/turbo_common.dart';
import 'package:turbo_ui/component/listview/defaultWidgets.dart';
import 'package:turbo_ui/component/listview/indexBarHintFrameWidget.dart';
import 'package:turbo_ui/component/listview/suspensionFrameWidget.dart';

class TurboListView extends StatefulWidget {
  /// TurboListView
  ///
  /// `data` with IHangTag Data(extends或with 类IHangTag的列表数据model)
  ///
  /// `sortDataByGroupTag`  是否根据groupTag对data排序(默认 true,如果此值为false，则传入的data需要事先排序，否则indexbar索引位置会不对)
  ///
  /// `scrollDirection` scroll Direction(默认：垂直,滚动方向)
  ///
  /// `header` TurboListView Header Widget(ListView头部小部件)
  ///
  /// `itemBuilder` ListView Item Widget Builder(listview 的item构造器)
  ///
  /// `indexBarBuilder` ListView Index Bar Widget Builder(listview 的索引栏构造器)
  ///
  /// `indexHintBuilder` ListView Index Bar Hint Widget Builder(listview 的索引栏提示构造器)
  ///
  /// `groupTagItemBuilder` ListView Group Tag Item Widget Builder(listview 的分组标签Item构造器)
  ///
  /// `hangTagItemBuilder` ListView Hang Tag Item Widget Builder(listview 的悬浮分组标签Item构造器)
  ///
  /// `controller` Scroll Controller(listview 滚动控制器)
  ///
  /// `physics`
  ///
  ///   - Scroll Physics(滚动物理效果)
  ///
  ///   - AlwaysScrollableScrollPhysics(总是可以滑动)
  ///
  ///   - NeverScrollableScrollPhysics(禁止滚动)
  ///
  ///   - BouncingScrollPhysics(内容超过一屏 上拉有回弹效果)
  ///
  ///   - ClampingScrollPhysics(包裹内容 不会有回弹)
  ///
  /// `shrinkWrap` shrink Wrap(默认 false,内容适配)
  ///
  /// `padding` padding(内间距)
  ///
  /// `cacheExtent` cache Extent(预加载的区域条目个数)
  ///
  /// `primary` If the [primary] argument is true, the [controller] must be null.(默认 false,如果内容不足，则用户无法滚动.而如果[primary]为true，它们总是可以尝试滚动;primary为true时,controller滑动监听就不能使用了)
  ///
  /// `itemExtent` itemExtent(指定每一个item的高度 会让item加载更加高效)
  ///
  /// `groupTagHeight` Group Tag Height(默认 40.0,分组标签的高度)
  ///
  /// `showGroupTag` Displays the group tag in the list(默认 false,在列表中显示分组标签)
  ///
  /// `showHangTag` Displays the hang tag in the list(默认 false,在列表中显示悬浮分组标签)
  ///
  /// `hangTagWidgetHeight` Hang Tag Height(默认 40.0,分组标签的高度)
  ///
  /// `showIndexBar` Show Index Bar(默认 true,是否显示索引栏)
  ///
  /// `showIndexBarHint` Show Index Bar Hint(默认 true,是否显示索引栏触摸提示)
  ///
  /// `indexHintDisplayMode` ListView Index Bar Hint Widget Display Mode(默认 IndexHintDisplayMode.followOption,listview索引栏提示的显示方式 )
  ///
  /// `useRealIndex` Build the index bar with real index data(默认 true,使用真实的索引数据构建IndexBar)
  ///
  /// `onHangTagChanged` on Hang tag change callback.(当前的悬停分组标签改变时，回调方法)
  TurboListView({
    Key key,
    this.data,
    this.sortDataByGroupTag = true,
    this.scrollDirection = Axis.vertical,
    this.header,
    @required this.itemBuilder,
    this.indexBarBuilder,
    this.indexHintBuilder,
    this.groupTagItemBuilder,
    this.hangTagItemBuilder,
    this.controller,
    this.physics,
    this.shrinkWrap = false,
    this.padding = EdgeInsets.zero,
    this.cacheExtent,
    this.primary = false,
    this.itemExtent,
    this.groupTagHeight = 40.0,
    this.showGroupTag = false,
    this.showHangTag = false,
    this.hangTagWidgetHeight = 40.0,
    this.showIndexBar = true,
    this.showIndexBarHint = true,
    this.indexHintDisplayMode = IndexHintDisplayMode.followOption,
    this.useRealIndex = true,
    this.onHangTagChanged,
  })  : assert(itemBuilder != null), //item构建器不能为空
        assert(
            !(showGroupTag != null &&
                showGroupTag == true &&
                (groupTagHeight == null || groupTagHeight <= 0.0)),
            '当显示组标签时groupTagHeight必填且值>0.0'), //当显示组标签时groupTagHeight必填且值>0.0
        assert(
            !(showGroupTag != null &&
                showGroupTag == true &&
                (itemExtent == null || itemExtent <= 0.0)),
            '当显示组标签时itemExtent必填且值>0.0'), //当显示组标签时itemExtent必填且值>0.0
        assert(
            !(showIndexBar != null &&
                showIndexBar == true &&
                (itemExtent == null || itemExtent <= 0.0)),
            '当显示IndexBar时itemExtent必填且值>0.0'),
        super(key: key);

  ///with IHangTag Data(extends或with 类IHangTag的列表数据model)
  final List<IGroupTag> data;
  // 是否根据groupTag对data排序(默认true 如果此值为false，则传入的data需要事先排序，否则indexbar索引未知会不对)
  final bool sortDataByGroupTag;

  /// scroll Direction(滚动方向,默认垂直)
  final Axis scrollDirection;

  /// TurboListView Header Widget(ListView头部小部件)
  final TurboListViewHeader header;

  /// ListView Item Widget Builder(listview 的item构造器)
  final ItemWidgetBuilder itemBuilder;

  /// ListView Index Bar Widget Builder(listview 的索引栏构造器)
  final IndexBarBuilder indexBarBuilder;

  /// ListView Index Bar Hint Widget Builder(listview 的索引栏提示构造器)
  final IndexHintBuilder indexHintBuilder;

  /// ListView Group Tag Item Widget Builder(listview 的分组标签Item构造器)
  final ListGroupTagHintBuilder groupTagItemBuilder;

  /// ListView Hang Tag Item Widget Builder(listview 的悬浮分组标签Item构造器)
  final HangTagBuilder hangTagItemBuilder;

  /// Scroll Controller(listview 滚动控制器)
  final ScrollController controller;

  /// Scroll Physics(滚动物理效果)
  /// AlwaysScrollableScrollPhysics() 总是可以滑动
  /// NeverScrollableScrollPhysics禁止滚动
  /// BouncingScrollPhysics 内容超过一屏 上拉有回弹效果
  /// ClampingScrollPhysics 包裹内容 不会有回弹
  final ScrollPhysics physics;

  /// shrink Wrap(默认 false,内容适配)
  final bool shrinkWrap;

  /// padding(内间距)
  final EdgeInsetsGeometry padding;

  /// cache Extent(预加载的区域条目个数)
  final double cacheExtent;

  /// If the [primary] argument is true, the [controller] must be null.
  /// (默认 false,如果内容不足，则用户无法滚动 而如果[primary]为true，它们总是可以尝试滚动;primary为true时,controller滑动监听就不能使用了)
  final bool primary;

  /// itemExtent(指定每一个item的高度 会让item加载更加高效)
  final double itemExtent;

  /// Group Tag Height(默认 40.0,分组标签的高度)
  final double groupTagHeight;

  /// Displays the group tag in the list(默认 false,在列表中显示分组标签)
  final bool showGroupTag;

  /// Displays the hang tag in the list(默认 false,在列表中显示悬浮分组标签)
  final bool showHangTag;

  /// Hang Tag Height(默认 40.0,分组标签的高度)
  final double hangTagWidgetHeight;

  /// Show Index Bar(默认 true,是否显示索引栏)
  final bool showIndexBar;

  /// Show Index Bar Hint(默认 true,是否显示索引栏触摸提示)
  final bool showIndexBarHint;

  /// ListView Index Bar Hint Widget Display Mode(默认 IndexHintDisplayMode.followOption,listview索引栏提示的显示方式 )
  final IndexHintDisplayMode indexHintDisplayMode;

  /// Build the index bar with real index data(默认 true,使用真实的索引数据构建IndexBar)
  final bool useRealIndex;

  ///on Hang tag change callback.(当前的悬停分组标签改变时，回调方法)
  final ValueChanged<String> onHangTagChanged;

  /// indexbar提示 通知器
  final IndexBarHintChangeNotifier _indexBarHintChangeNotifier =
      IndexBarHintChangeNotifier();

  /// indexbar选中项 通知器
  final IndexBarSelectionChangeNotifier _indexBarSelectNotifier =
      IndexBarSelectionChangeNotifier();

  @override
  State<StatefulWidget> createState() {
    return new _TurboListViewState();
  }
}

class _TurboListViewState extends State<TurboListView> {
  /// Index Bar Tag Data(索引栏标签数据)
  List<String> _indexBarTagList = List();

  /// ListView Data(列表数据)
  List<IGroupTag> _dataList = List();

  /// Controls a scrollable widget(滑动控制器)
  ScrollController _scrollController;

  /// 分组标签位置
  Map<String, double> _groupTagLoaclMap = Map();

  /// IndexBar实例
  Widget _indexBar;

  /// IndexBar提示器实例
  Widget _indexBarHint;

  /// 分组标签实例
  Widget _groupTagItem;

  /// 分组标签位置信息数据表
  List<double> groupTagLoaclMapList = new List();
  // 上一个索引
  int _lastIndex;

  @override
  void initState() {
    super.initState();
    //设置滑动控制器
    _scrollController = widget.controller ?? ScrollController();

    if (widget.showHangTag == false) {
      // 如果不显示悬浮分组标签就处理滑动监听
      _scrollController.addListener(() {
        // 获取当前滑动位置
        double offset = _scrollController.offset;
        // 根据滑动位置获取所在的分组Tag索引
        int _index = _getIndex(offset);
        if (_index != -1 && _lastIndex != _index) {
          _lastIndex = _index;
          // 通知IndexBar当前所在分组
          widget._indexBarSelectNotifier
              .notify(_groupTagLoaclMap.keys.toList()[_index]);
        }
      });
    }
  }

  /// 获取指定位置是在哪个分组下
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

  @override
  void dispose() {
    _scrollController?.dispose();
    _dataList?.clear();
    _indexBarTagList?.clear();
    super.dispose();
  }

  /// initialization data 初始化数据
  void _initData() {
    _dataList.clear();
    // Sort Data List 对数据排序
    List<IGroupTag> list = widget.data;
    if (list != null && list.isNotEmpty) {
      if (widget.sortDataByGroupTag) TurboListViewUtil.sortListByGroupTag(list);
      _dataList.addAll(list);
    }

    // Set List Item ShowGroupTag Status 设置每个item是否显示分组标签,并获取所有组标签在list中的位置
    if (widget.showIndexBar == true) {
      TurboListViewUtil.setShowGroupTagStatus(
          _dataList,
          _groupTagLoaclMap,
          widget.header,
          widget.groupTagHeight,
          widget.itemExtent,
          widget.showGroupTag);
      groupTagLoaclMapList
        ..clear()
        ..addAll(_groupTagLoaclMap.values);
    }
    // Insert Header Data 插入头部数据并设置hangtag属性
    if (widget.header != null) {
      _dataList.insert(0, HeaderWidgetTag()..groupTag = widget.header.tag);
    }

    // Add Index Bar Data 构造IndexBar数据
    _indexBarTagList.clear();
    if (widget.useRealIndex) {
      _indexBarTagList.addAll(TurboListViewUtil.getIndexBarTags(_dataList));
    } else {
      _indexBarTagList.addAll(INDEX_BAR_DATA_DEF);
    }
    //IndexBar给默认选中第一个
    if (widget._indexBarSelectNotifier.selectTag == null ||
        widget._indexBarSelectNotifier.selectTag == "") {
      if (_groupTagLoaclMap != null && _groupTagLoaclMap.length != 0) {
        widget._indexBarSelectNotifier
            .notify(_groupTagLoaclMap.keys.toList()[0]);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    _initData();
    // Widgets 子部件
    var childrenWidget = <Widget>[];

    //  有悬浮标签的
    if (widget.showHangTag) {
      childrenWidget.add(_buildSuspensionFrameListView());
    } else {
      // 没有悬浮标签的
      childrenWidget.add(_buildListView());
    }

    // Check to see if the index bar is displayed 检查是否显示IndexBar
    if (widget.showIndexBar) {
      childrenWidget.add(Align(
        alignment: Alignment.centerRight,
        child: _buildIndexBar(),
      ));
      // Check to see if the index bar hint is displayed 检查是否显示IndexBar的提示组件
      if (widget.showIndexBarHint) {
        childrenWidget.add(Stack(
          overflow: Overflow.visible,
          children: <Widget>[_buildIndexBarHint()],
        ));
      }
    }
    return Stack(children: childrenWidget);
  }

  /// 构建分组悬浮标签
  Widget _buildHangTagItem(String tag) {
    return Container(
        padding: EdgeInsets.symmetric(horizontal: 15.0),
        height: widget.hangTagWidgetHeight,
        width: double.infinity,
        alignment: Alignment.centerLeft,
        color: Colors.white,
        child:SizedBox(
                height: widget.hangTagWidgetHeight,
                child: DefaultGroupTagWidget(
                        curTag: tag,
                        maxHeight: widget.hangTagWidgetHeight)
        )
    );
  }

  /// 构建带悬浮框架的ListView
  Widget _buildSuspensionFrameListView() {
    if( widget.hangTagItemBuilder!= null) {
      return SuspensionFrame(
        child: _buildListView(),
        controller: _scrollController,
        indexBarHintChangeNotifier: widget._indexBarHintChangeNotifier,
        indexBarSelectNotifier: widget._indexBarSelectNotifier,
        hangTagBuilder: widget.hangTagItemBuilder,
        hangTagWidgetHeight: widget.hangTagWidgetHeight,
        groupTagLoaclMap: _groupTagLoaclMap,
      );
    }
    else
    {
      return SuspensionFrame(
        child: _buildListView(),
        controller: _scrollController,
        indexBarHintChangeNotifier: widget._indexBarHintChangeNotifier,
        indexBarSelectNotifier: widget._indexBarSelectNotifier,
        hangTagBuilder: (BuildContext context, String tag)=> _buildHangTagItem(tag),
        hangTagWidgetHeight: widget.hangTagWidgetHeight,
        groupTagLoaclMap: _groupTagLoaclMap,
      );
    }
  }

  /// Build ListView 构建lietview
  Widget _buildListView() {
    return ListView.builder(
        controller: _scrollController,
        physics: widget.physics,
        shrinkWrap: widget.shrinkWrap,
        padding: widget.padding,
        itemExtent: widget.itemExtent != null &&
                !widget.showGroupTag &&
                widget.header == null
            ? widget.itemExtent
            : null,
        itemCount: _dataList.length,
        itemBuilder: (BuildContext context, int index) {
          if (index == 0 && _dataList[index] is HeaderWidgetTag) {
            return SizedBox(
                height: widget.header.height,
                child: Align(
                    alignment: Alignment.topLeft,
                    child: widget.header.builder(context)));
          }
          if (widget.showGroupTag && _dataList[index].showGroupTag) {
            return Column(
              children: <Widget>[
                _buildGroupTagItem(_dataList[index].getGroupTag()),
                SizedBox(
                  height: widget.itemExtent,
                  child: widget.itemBuilder(context, _dataList[index]),
                )
              ],
            );
          }
          if (widget.itemExtent != null) {
            return SizedBox(
                height: widget.itemExtent,
                child: widget.itemBuilder(context, _dataList[index]));
          }
          return widget.itemBuilder(context, _dataList[index]);
        });
  }

  /// 构建分组标签Item
  Widget _buildGroupTagItem(String currentGroupTag) {
    if (widget.groupTagItemBuilder != null) {
      _groupTagItem = widget.groupTagItemBuilder(context, '$currentGroupTag');
    } else {
      _groupTagItem = DefaultGroupTagWidget(
          curTag: '$currentGroupTag', maxHeight: widget.groupTagHeight);
    }
    return SizedBox(height: widget.groupTagHeight, child: _groupTagItem);
  }

  /// Build Index Bar 构建索引栏
  Widget _buildIndexBar() {
    if (widget.indexBarBuilder == null) {
      _indexBar = ChangeNotifierProvider.value(
          value: widget._indexBarSelectNotifier,
          child: DefaultIndexBarWidget(
              data: _indexBarTagList, onTouch: _onIndexBarTouch));
    } else {
      _indexBar = widget.indexBarBuilder(
        context,
        _indexBarTagList,
        _onIndexBarTouch,
      );
    }
    return _indexBar;
  }

  /// Build Index Bar Hint 构建索引栏提示
  Widget _buildIndexBarHint() {
    _indexBarHint = ChangeNotifierProvider.value(
        value: widget._indexBarHintChangeNotifier,
        child: IndexBarHintFrameWidget(
          indexHintDisplayMode: widget.indexHintDisplayMode,
          builder: widget.indexHintBuilder,
        ));
    return _indexBarHint;
  }

  /// on index bar touch event 索引栏被触摸事件
  void _onIndexBarTouch(IndexBarDetails model) {
    //计算控件的top值
    RenderBox box = context.findRenderObject();
    Offset topLeftPosition = box.localToGlobal(Offset.zero);
    //model.position-topLeftPosition.dy 这里得到实际的Hint控件显示坐标
    widget._indexBarHintChangeNotifier.notify(
        model.tag, model.isTouch, model.position - topLeftPosition.dy - 15.0);
    widget._indexBarSelectNotifier.notify(model.tag);
    double offset = _groupTagLoaclMap[model.tag];
    if (offset != null) {
      _scrollController
          .jumpTo(offset.clamp(.0, _scrollController.position.maxScrollExtent));
    }
  }
}
