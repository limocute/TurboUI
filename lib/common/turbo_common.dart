import 'package:flutter/widgets.dart';

///Default IndexBar data.
const List<String> INDEX_BAR_DATA_DEF = const [
  "A",
  "B",
  "C",
  "D",
  "E",
  "F",
  "G",
  "H",
  "I",
  "J",
  "K",
  "L",
  "M",
  "N",
  "O",
  "P",
  "Q",
  "R",
  "S",
  "T",
  "U",
  "V",
  "W",
  "X",
  "Y",
  "Z",
  "#"
];

/// Called to build children for the listview(调用它来为listview构建子对象).
typedef Widget ItemWidgetBuilder(BuildContext context, IGroupTag model);

/// Called to build IndexBar.(调用它来构建索引栏)
typedef Widget IndexBarBuilder(BuildContext context, List<String> tags, IndexBarTouchCallback onTouch);

/// Called to build index hint.(调用它来构建索引提示)
typedef Widget IndexHintBuilder(BuildContext context, String hint);

/// Called to build listview group tag.(调用它来构建列表的分组item)
typedef Widget ListGroupTagHintBuilder(BuildContext context, String groupTag);

/// Called to build hang tag.(调用它来构建悬浮标签)
typedef Widget HangTagBuilder(BuildContext context, String tag);

/// Called to build index bar items.(调用它来构建索引栏item)
typedef Widget IndexBarItemBuilder(BuildContext context,String curTag, String selectionTag);

/// IndexBar touch callback IndexModel.(索引栏触摸回调)
typedef void IndexBarTouchCallback(IndexBarDetails model);

/// Index bar hint display mode.(IndexBar提示显示模式 居中/跟随)
enum  IndexHintDisplayMode{
  /// center 居中
   center,
  /// Follow Option 跟随IndexBar选中项
   followOption,
}

/// IHang Tag(悬停的分组标签，listview item的对象model需要extends或with此类).
/// [hangTag] 悬停标签的值
/// [showHangTag] 此Item是否显示悬停标签
abstract class IGroupTag {
  String groupTag;
  ///Whether this item displays Hang Tag(此项目是否显示悬停标签)
  bool showGroupTag;

  /// get Hang Tag(获取悬停标签值)
  String getGroupTag() => groupTag; 
}

/// _HeaderWidget Model.(列表头部widget的model)
class HeaderWidgetTag extends IGroupTag {
  HeaderWidgetTag(){
    super.groupTag='↑';
  }
  @override
  bool get showGroupTag => false;
}

/// TurboListView Header Widget(ListView头部小部件)
class TurboListViewHeader {
  TurboListViewHeader({
    @required this.height,
    @required this.builder,
    this.tag = "↑",
  });

  final double height;
  final String tag;
  final WidgetBuilder builder;
}

/// TurboListView Util(TurboListViewUtil工具类)
class TurboListViewUtil{
  /// sort list  by group tag.
  /// (根据GroupTag属性进行[A-Z-#]排序)
  static void sortListByGroupTag(List<IGroupTag> list) {
    if (list == null || list.isEmpty) return;
    list.sort((a, b) {
      if (a.getGroupTag() == "@" || b.getGroupTag() == "#") {
        return -1;
      } else if (a.getGroupTag() == "#" || b.getGroupTag() == "@") {
        return 1;
      } else {
        return a.getGroupTag().compareTo(b.getGroupTag());
      }
    });
  }

  /// get index bar data list by group tag.
  /// (获取索引列表)
  static List<String> getIndexBarTags(List<IGroupTag> list) {
    List<String> indexBarData = new List();
    if (list != null && list.isNotEmpty) {
      String tempTag = '';
      for (int i = 0, length = list.length; i < length; i++) {
        String tag = list[i].getGroupTag();
        if (tag.length > 2) tag = tag.substring(0, 2);
        if (tempTag != tag) {
          indexBarData.add(tag);
          tempTag = tag;
        }
      }
    }
    return indexBarData;
  }

  /// set show group tag status.
  /// 设置显示GroupTag状态。
  static void setShowGroupTagStatus(
    List<IGroupTag> list,
    Map<String, double> groupTagLoaclMap,
    TurboListViewHeader header,
    double groupTagHeight,
    double itemExtent,
    bool showGroupTag) {
    if (list == null || list.isEmpty) return;
    groupTagLoaclMap.clear();
    double groupTagOffset = 0.0;
    if (header != null) {
      groupTagLoaclMap[header.tag] = 0.0;
      groupTagOffset += header.height;
    }

    String tempTag = '';
    for (int i = 0, length = list.length; i < length; i++) {
      String tag = list[i].getGroupTag();
      if(i!=0){
        groupTagOffset +=  itemExtent;
      }
      if (tempTag != tag) {
        tempTag = tag;
        list[i].showGroupTag = true;
        groupTagLoaclMap.putIfAbsent(tempTag, () => groupTagOffset);
        if(showGroupTag)
          groupTagOffset +=  groupTagHeight;
      } else {
        list[i].showGroupTag = false;
      }
    }
  }
}

/// IndexModel.
class IndexBarDetails {
  /// current touch tag.(当前触摸标签)
  String tag; 
  /// current touch position.(当前触摸位置，此坐标相对于整个屏幕)
  int position; 
  /// is touch.(是否被触摸)
  bool isTouch; 

  IndexBarDetails({this.tag, this.position, this.isTouch});
}
