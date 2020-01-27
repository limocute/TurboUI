import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:turbo_ui/common/changeNotifiers.dart';

/// IndexBart提示带通知器的有状态部件
abstract class IndexBarHintNotifierStatefulWidget extends StatefulWidget{

  final IndexBarHintChangeNotifier hintChangeNotifier = IndexBarHintChangeNotifier();

  @override
  State<StatefulWidget> createState() {
    return new IndexBarHintNotifierState();
  }
 
}

class IndexBarHintNotifierState extends State<IndexBarHintNotifierStatefulWidget>{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.hintChangeNotifier,
      child:null,
    );
  }
}

/// IndexBart提示带通知器的无状态部件
abstract class IndexBarHintNotifierStatelessWidget extends StatelessWidget{

  final IndexBarHintChangeNotifier hintChangeNotifier = IndexBarHintChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: hintChangeNotifier,
      child:null,
    );
  }
}

/// TurboListView悬浮框架带通知器的有状态部件
abstract class SuspensionChangeNotifierStatefulWidget extends StatefulWidget{

  final HangTagTopChangeNotifier hangTagChangeNotifier = HangTagTopChangeNotifier();

  @override
  State<StatefulWidget> createState() {
    return new SuspensionChangeNotifierState();
  }
 
}

class SuspensionChangeNotifierState extends State<SuspensionChangeNotifierStatefulWidget>{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.hangTagChangeNotifier,
      child:null,
    );
  }
}

/// TurboListView悬浮框架带通知器的无状态部件
abstract class SuspensionChangeNotifierStatelessWidget extends StatelessWidget{

  final HangTagTopChangeNotifier hangTagChangeNotifier = HangTagTopChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: hangTagChangeNotifier,
      child:null,
    );
  }
}


/// IndexBar架带通知器的有状态部件
abstract class IndexBarNotifierStatefulWidget extends StatefulWidget{

  final IndexBarSelectionChangeNotifier indexBarSelectionNotifier = IndexBarSelectionChangeNotifier();

  @override
  State<StatefulWidget> createState() {
    return new IndexBarNotifierState();
  }
 
}

class IndexBarNotifierState extends State<IndexBarNotifierStatefulWidget>{

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: widget.indexBarSelectionNotifier,
      child:null,
    );
  }
}
/// IndexBar架带通知器的无状态部件
abstract class IndexBarNotifierStatelessWidget extends StatelessWidget{

  final IndexBarSelectionChangeNotifier indexBarSelectionNotifier = IndexBarSelectionChangeNotifier();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider.value(
      value: indexBarSelectionNotifier,
      child:null,
    );
  }
}