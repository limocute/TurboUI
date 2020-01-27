import 'package:flutter/material.dart';

class IndexBarHintChangeNotifier with ChangeNotifier {
  BuildContext context;
  String curHintTag = '';
  bool isTouch = false;
  double position=0;

  /// 是否显示IndexBar触摸提示
  bool showHintTag()=> curHintTag == '' ? false : true;

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("IndexBarHintChangeNotifier => dispose");
  }

  /// 通知订阅部件，indexbar被触摸
  void notify(String newHintTag,bool touchStatus,double newPosition) {
    curHintTag = newHintTag;
    isTouch = touchStatus;
    position=newPosition;
    notifyListeners();
  }  
  /// 通知订阅部件，indexbar被触摸
  void notifyOnlyTag(String newHintTag) {
    curHintTag = newHintTag;
    notifyListeners();
  }    
}

class HangTagTopChangeNotifier with ChangeNotifier {
  BuildContext context;
  double curTop = 0.0;
  String curTag='';

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("HangTagTopChangeNotifier => dispose");
  }

  /// 通知订阅部件
  void notify(double newTop,String newTag) {
    curTop = newTop;
    curTag=newTag;
    notifyListeners();
  }    
  void notifyOnlyTag(String newTag) {
    curTag=newTag;
    notifyListeners();
  }    
}

class IndexBarSelectionChangeNotifier with ChangeNotifier {
  BuildContext context;
  String selectTag='';

  void setContext(BuildContext context) {
    if (this.context == null) {
      this.context = context;
    }
  }

  @override
  void dispose() {
    super.dispose();
    debugPrint("HangTagTopChangeNotifier => dispose");
  }

  /// 通知订阅部件
  void notify(String newSelectTag) {
    selectTag = newSelectTag;
    notifyListeners();
  }    
}