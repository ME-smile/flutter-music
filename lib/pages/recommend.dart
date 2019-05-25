import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_swiper/flutter_swiper.dart';
import 'package:music/components/loading.dart';
import 'package:music/dao/recommendDAO.dart';
import 'package:music/model/hot_song.dart';
import 'package:music/utils/config.dart';

class RecommendTabView extends StatefulWidget {
  RecommendTabView({Key key}) : super(key: key);

  _RecommendTabViewState createState() => _RecommendTabViewState();
}

class _RecommendTabViewState extends State<RecommendTabView> {
  List imageUrls;
  List hotSongModels;

  // 轮播图
  Widget _buildSwiper() {
    return FutureBuilder(
      future: getData('banner'),
      builder: (context, snapshot) {
        if (snapshot.hasData) {
          imageUrls =
              snapshot.data['banners'].map((item) => item['pic']).toList();
          
          return Swiper(
            itemCount: imageUrls.length,
            autoplay: true,
            duration: 500,
            itemBuilder: (context, index) {
              return Image.network(imageUrls[index]);
            },
          );
        } else {
          return Loading(isLoading: true,isFull: true,);
        }
      },
    );
  }

  // 歌单项
  Widget _buildGridTiles(BuildContext context, int index) {

    var _number =  hotSongModels[index].playCount;
    var _playCount = _number >10000?'${_number ~/ 10000}万':'$_number';
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
                  child: Image.network(
                    hotSongModels[index].picUrl,
                    fit: BoxFit.fill,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                Positioned(
                  right: 0.0,
                  child: Row(
                    children: <Widget>[
                      Icon(
                          IconData(
                            0xe66b,
                            fontFamily: 'Ali',
                          ),
                          size: 16.0),
                      Text(_playCount,
                          style: AppTextStyle.BrifeDesc)
                    ],
                  ),
                ),
              ],
            ),
          ),
          Container(
            width: ScreenUtil().setWidth(180),
            child: Text(
              hotSongModels[index].name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              softWrap: true,
              style: TextStyle(fontSize: 12.0),
            ),
          )
        ],
      ),
    );
  }

  // 推荐歌单部分
  @override
  Widget build(BuildContext contedxt) {
    return Column(
      children: <Widget>[
        Container(
          width: ScreenUtil().setWidth(750.0),
          height: ScreenUtil().setHeight(260.0),
          margin: const EdgeInsets.only(top: 5.0),
          child: _buildSwiper(),
        ),
        Container(
          alignment: Alignment.centerLeft,
          padding: EdgeInsets.only(left: 16.0, top: 8.0, bottom: 8.0),
          child: Text(
            '推荐歌单',
            style: AppTextStyle.TTILE_3,
          ),
        ),
        FutureBuilder(
          future: getData('hotSong'),
          builder: (context, snapshot) {
            if (snapshot.hasData) {
              hotSongModels = snapshot.data['result']
                  .map((json) => HotSongModel.fromJson(json))
                  .toList();
              return Expanded(
                child: GridView.builder(
                  itemCount: hotSongModels.length,
                  itemBuilder: _buildGridTiles,
                  gridDelegate: SliverGridDelegateWithMaxCrossAxisExtent(
                      mainAxisSpacing: 1.0,
                      maxCrossAxisExtent: ScreenUtil().setWidth(360)),
                ),
              );
            } else {
              return Loading(isFull: true,isLoading: true,);
            }
          },
        ),
      ],
    );
  }
}
