import 'package:flutter/material.dart';

enum PlayMode { SEQUENCE, LOOP, RANDOM }

class AudioModel with ChangeNotifier {
  bool playing;
  bool fullScreen;
  int currentIndex;
  List playList;
  List sequenceList;
  PlayMode playMode;
  get currentSong => playList[currentIndex];

  setPlaying(bool isPlaying) {
    playing = isPlaying;
    notifyListeners();
  }

  setFullScreen(bool isFullScreen) {
    fullScreen = isFullScreen;
    notifyListeners();
  }

  setCurrentIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  setPlayList(List list) {
    playList = list;
    sequenceList = list;
    notifyListeners();
  }

  setSequenceList(List list) {
    sequenceList = list;
    notifyListeners();
  }

  setPlayMode(PlayMode mode) {
    playMode = mode;
    notifyListeners();
  }

  // 封装actions
  selectPlay(index) {
    setCurrentIndex(index);
    setPlaying(true);
    setFullScreen(true);
  }
}
