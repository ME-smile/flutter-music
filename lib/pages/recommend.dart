import 'package:flutter/material.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:music/dao/recommendDAO.dart';
import 'package:music/components/NavigatorTabBar.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:music/model/hot_song.dart';

import 'singer.dart';
class RecommendPage extends StatefulWidget{
  @override
  _RecommendPageState createState () => _RecommendPageState();
}
class _RecommendPageState extends State<RecommendPage>{
  List imageUrls;
  List hotSongModels;
  Widget _buildSwiper(){
    return FutureBuilder(
      future: getData('banner'),
      builder: (context,snapshot){
        if(snapshot.hasData){
          imageUrls = snapshot.data['banners'].map((item) => item['pic']).toList();
          return Swiper(
              itemCount: imageUrls.length,
              autoplay: true,
              duration: 500,
              itemBuilder: (context, index){
                return Image.network(imageUrls[index]);
                },
              );
        }else{
          return Text('正在加载数据....');
        }
      },
    );
  }
    Widget _buildGridTiles(BuildContext context,int index){
      return Container(
        child: Column(
          children: <Widget>[
            Container(
              width: ScreenUtil().setWidth(180),
              height: ScreenUtil().setHeight(180),
              child: Stack(
              overflow: Overflow.visible,
              children: <Widget>[
                ClipRRect(
                  child: Image.network(hotSongModels[index].picUrl,fit: BoxFit.fill,),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                Positioned(
                  right: 0.0,
                  child: Row(children: <Widget>[
                    Icon(IconData(0xe66b,fontFamily: 'Ali',),size: 16.0),
                    Text(hotSongModels[index].playCount.toString(),style:TextStyle(fontSize: 12.0))
                ],),
                ),
              ],
              ),
            ),
            Container(
              width: ScreenUtil().setWidth(180),
              child: Text(
                hotSongModels[index].name,
                overflow: TextOverflow.ellipsis,
                maxLines:2,
                softWrap: true,
                style: TextStyle(fontSize: 12.0),),
            )
          ],
        ),
      );
  }
  Widget _buildRcommendTabView(){
    return Column(
      children: <Widget>[
              Container(
                width: ScreenUtil().setWidth(750.0),
                height: ScreenUtil().setHeight(260.0),
                margin: const EdgeInsets.only(top: 5.0),
                child: _buildSwiper(),
              ),
              Text('推荐歌单',style: TextStyle(fontWeight: FontWeight.w300,fontSize: 24.0),),
              FutureBuilder(
                future: getData('hotSong'),
                builder: (context,snapshot){
                  if(snapshot.hasData){
                    hotSongModels = snapshot.data['result'].map((json) => HotSongModel.fromJson(json)).toList();
                    return Expanded(
                      child: GridView.builder(
                        itemCount: hotSongModels.length,
                        itemBuilder: _buildGridTiles,
                        gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                          mainAxisSpacing: 1.0,
                          maxCrossAxisExtent: ScreenUtil().setWidth(360)
                        ),
                      ),
                    );

                  }else{
                    return Text('Loading....');
                  }
                },
               
              ),
            ],);
    }
  @override
  Widget build(BuildContext context){
    ScreenUtil.instance = ScreenUtil(width: 750, height: 1334)..init(context);
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: buildAppBar(),
        drawer: Drawer(
          child: Text('我是抽屉'),
        ),
        body: TabBarView(
          children: <Widget>[
            _buildRcommendTabView(),
            SingerPage(),
            _buildRcommendTabView(),
          ],
        ),
      ),
    );
  }
}