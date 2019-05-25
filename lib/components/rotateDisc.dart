import 'package:flutter/material.dart';
import 'package:music/model/song.dart';
class RotateDisc extends AnimatedWidget {
  RotateDisc({Key key, Animation<double> animation, this.songModel})
      : super(key: key, listenable: animation);
  final SongModel songModel;
  Widget build(BuildContext context) {
    final Animation<double> animation = listenable;
    return new Container(
      margin: new EdgeInsets.symmetric(vertical: 10.0,horizontal: 50.0),
      height: 250.0,
      width: 250.0,
      child: new RotationTransition(
          turns: animation,
          child: new Container(
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              image: DecorationImage(
                image: NetworkImage(songModel.imgUrl),
              ),
            ),
          )),
    );
  }
}
