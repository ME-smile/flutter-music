import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:music/components/loading.dart';
import 'package:music/dao/SingerDAO.dart';
import 'package:music/model/singer.dart';
import 'package:music/model/song.dart';
import 'package:music/store/store.dart';
import 'package:provide/provide.dart';

import 'player.dart';

class SingerDetail extends StatefulWidget {
  final int id;
  const SingerDetail({this.id, Key key}) : super(key: key);

  _SingerDetailState createState() => _SingerDetailState();
}

class _SingerDetailState extends State<SingerDetail> {
  SingerDetailModel artist;
  Map<String, dynamic> singerInfo;
  List songList;
  Widget contentAreaBuilder(context, snapshot) {
    if (snapshot.hasData) {
      singerInfo = snapshot.data['artist'];
      artist = SingerDetailModel.fromJson(singerInfo);
      songList = snapshot.data['hotSongs']
          .map((item) => SongModel.fromJson(item))
          .toList();
      AudioModel audioModel = Provide.value<AudioModel>(context);
      return Scaffold(
          body: CustomScrollView(
        slivers: <Widget>[
          SliverAppBar(
            pinned: true,
            title: Container(
              alignment: Alignment.center,
              child: Text('${artist.name}', textAlign: TextAlign.center),
            ),
            expandedHeight: 263.0,
            flexibleSpace: FlexibleSpaceBar(
              background: Image.network(
                artist.avatar,
                fit: BoxFit.cover,
              ),
            ),
          ),
          SliverList(
            delegate:
                SliverChildBuilderDelegate((BuildContext context, int index) {
              return ListTile(
                leading: Text('${index + 1}'),
                title: Text(songList[index].title),
                subtitle: Text(songList[index].subTitle),
                onTap: () {
                  audioModel
                    ..setPlayList(songList)
                    ..setSequenceList(songList)
                    ..selectPlay(index);
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) =>
                            Player(songList: songList, index: index),
                      ));
                },
              );
            }, childCount: songList.length),
          ),
        ],
      ));
    } else {
      return Loading(
        isFull: true,
        isLoading: true,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: getSingerAndSongData('singerDetail', widget.id),
      builder: contentAreaBuilder,
    );
  }
}
