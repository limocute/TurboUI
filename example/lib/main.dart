import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import 'package:lpinyin/lpinyin.dart';
import 'package:example/contact_model.dart';
import 'package:turbo_ui/turbo_ui.dart';


void main() => runApp(MyApp());

class MyApp extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Turbo UI Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: 'Turbo UI Demo'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<ContactInfo> _contacts = List();
  double _groupItemHeight=40.0;
  ScrollController _scrollController;

  /// 加载测试数据
  void loadData() async {
    //加载联系人列表
    rootBundle.loadString('assets/data/contacts.json').then((value) {
      List list = json.decode(value);
      list.forEach((value) {
        _contacts.add(ContactInfo(name: value['name']));
      });
      _buildListHangTag(_contacts);
      setState(() {});
    });
  }

  /// 构建list每个itsm的HangTag属性
  void _buildListHangTag(List<ContactInfo> list) {
    if (list == null || list.isEmpty) return;
    for (int i = 0, length = list.length; i < length; i++) {
      String pinyin = PinyinHelper.getPinyinE(list[i].name);
      String tag = pinyin.substring(0, 1).toUpperCase();
      if (RegExp("[A-Z]").hasMatch(tag)) {
        list[i].groupTag = tag;
      } else {
        list[i].groupTag = "#";
      }
    }
  }

  @override
  void initState() {
    super.initState();
    _scrollController=ScrollController(); 
    loadData();
  }

  /// 构建分组标签
  Widget _buildGroupTagItem(String tag)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: _groupItemHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      child: Row(
        children: <Widget>[
          Text(
            '$tag',
            textScaleFactor: 1.2,
          ),
          Expanded(
              child: Divider(
            height: .0,
            indent: 10.0,
          ))
        ],
      ),
    );
  }

  /// 构建分组标签
  Widget _buildHangTagItem(String tag)
  {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 15.0),
      height: _groupItemHeight,
      width: double.infinity,
      alignment: Alignment.centerLeft,
      color: Colors.white,
      child: Row(
        children: <Widget>[
          Text(
            '$tag',
            textScaleFactor: 1.2,
          ),
          Expanded(
              child: Divider(
            height: .0,
            indent: 10.0,
          ))
        ],
      ),
    );
  }

  /// 构建Item
  Widget _buildListItem(BuildContext context,ContactInfo model){
    if(model==null) return null;
    return MessageListTile(
      leading:Center(
        child: TurboBlur(
          child:CircleAvatar(
            child: Text(model.name[0]),
          ),
          borderRadius:BorderRadius.circular(20),
        )
      ),
      leadingWidth: 60.0,
      //paddingLeft: 50.0,
      nickName: Text(model.name),
      messageDigest: Text('消息'),
      transmissionTime: DateTime.parse('2020-01-12'),
      splashColor: Colors.red[100],
      highlightColor:Colors.transparent,// Colors.red[200],
    );
    
  }

   /// 构建自定义风格的 提示 部件
  Widget _bulidCustomHint(String hint){
    return Container(
            alignment: Alignment.center,
            width: 40.0,
            height: 40.0,
            decoration: BoxDecoration(
              color:Colors.black54,
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

  Widget _buildListView(){
    TurboListViewHeader head=TurboListViewHeader(
      height: 150.0,
      builder: (context){
        return Center(
          child: TurboShadow(
            child:TurboBlur(
              child: TurboImage(
              borderRadius: BorderRadius.circular(25),
              splashColor: Colors.blue[200],
              onPressed: (){

              },
              width: 50.0,
              height: 50.0,
              image:NetworkImage('https://wx.qlogo.cn/mmopen/vi_32/DYAIOgq83eqE2ib7iaGACNGgtqdFB0sAR33YWzlQO89xXoq0zichJxst9j7Rp8TtRKzgtdLtd1EotzXYibp7tagruQ/132'),
            ),
            borderRadius:BorderRadius.circular(25),
            ), 
            shandowShape: BoxShape.circle,
            blurRadius: 1.0, 
            spreadRadius: 0.0,
            shadowOpacity: 250,
            shanowColor: Colors.red,
            shadowType: ShadowType.shine,
          )
        ); 
      }
    );
    return TurboListView(
      data: _contacts,
      sortDataByGroupTag: false,
      header: head,
      controller: _scrollController,
      showGroupTag: false,
      useRealIndex: true,
      showIndexBar: true,
      itemExtent: 56.0,
      itemBuilder:(context, model)=> _buildListItem(context, model),
      showHangTag: false,
      hangTagItemBuilder: (BuildContext context, String tag)=>_buildHangTagItem(tag),
      indexHintDisplayMode: IndexHintDisplayMode.center,
      indexHintBuilder: (BuildContext context, String hint)=>_bulidCustomHint(hint),
    );
  }

  @override
  Widget build(BuildContext context) {
   
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: _buildListView(),
     
      floatingActionButton: TurboShadow(
        child: FloatingActionButton(
          child: Icon(Icons.add)
        ),
        shandowShape: BoxShape.circle,
        shadowType: ShadowType.shine,
        shanowColor: Colors.red,
      )
    );
  }
}
