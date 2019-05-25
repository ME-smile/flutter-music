import 'package:flutter/material.dart';

// enum不可以再类中声明
enum playMode { SEQUENCE, LOOP, RANDOM }

class SongStore with ChangeNotifier {
  bool playState;
  bool fullScreen;
  int currentIndex;
  List playList;
  List sequenceList;

  get currentSong => playList[currentIndex];

  setPlayList(list){
    playList = list;
    notifyListeners();
  }
}
