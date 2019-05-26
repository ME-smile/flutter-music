import 'package:dio/dio.dart';
import 'dart:async';
import 'url.dart';


Future getSingerData(String path) async {
  try {
    Response response = await Dio().get(routers[path]);
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to get data ...');
    }
  } catch (e) {
    print(e);
  }
}

Future getSingerAndSongData(String path, int id) async {
  try {
    Response response = await Dio().get(routers[path] + '$id');
    if (response.statusCode == 200) {
      return response.data;
    } else {
      throw Exception('Failed to get data ...');
    }
  } catch (e) {
    print(e);
  }
}

getAudioUrl(songList, index) async {
  print('===================================++++++++++++++++++++++=');
  return getSingerAndSongData('audioUrl', songList[index].id);
}
