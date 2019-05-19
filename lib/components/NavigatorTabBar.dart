import 'package:flutter/material.dart';

buildAppBar(){
  const List<Widget> _tabs = [
    Tab(child: Text('推荐'),),
    Tab(child: Text('歌手'),),
    Tab(child: Text('排行'),),
  ];
  return AppBar(
    title: TabBar(
      tabs: _tabs,
      indicatorSize: TabBarIndicatorSize.label,
    ),
    actions: <Widget>[
      IconButton(icon: Icon(Icons.search),onPressed: (){},),
    ],
  );
}

