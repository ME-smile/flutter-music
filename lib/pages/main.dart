import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/utils/config.dart';

import 'recommend.dart';
import 'singer.dart';

class MainPage extends StatelessWidget {
  const MainPage({Key key}) : super(key: key);
  Widget _buildAppBar() {
    const List<Widget> _tabs = [
      Tab(
        child: Text(
          '推荐',
          style: AppTextStyle.NavigationTitle,
        ),
      ),
      Tab(
        child: Text(
          '歌手',
          style: AppTextStyle.NavigationTitle,
        ),
      ),
      Tab(
        child: Text(
          '排行',
          style: AppTextStyle.NavigationTitle,
        ),
      ),
    ];
    return AppBar(
      title: TabBar(
        tabs: _tabs,
        indicatorSize: TabBarIndicatorSize.label,
      ),
      actions: <Widget>[
        IconButton(
          icon: Icon(Icons.search),
          onPressed: () {},
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: _buildAppBar(),
        drawer: Drawer(
          child: Text('我是抽屉'),
        ),
        body: TabBarView(
          children: <Widget>[
            RecommendTabView(),
            SingerTabView(),
            RecommendTabView(),
          ],
        ),
      ),
    );
  }
}
