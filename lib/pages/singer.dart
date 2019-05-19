import 'package:flutter/material.dart';
import 'package:music/dao/SingerDAO.dart';
import 'package:music/model/singer.dart';
// tabbar点击会发生样式变化，所以使用StatefulWidget
class SingerPage extends StatefulWidget{
  // 创建状态管理对象
  @override
  _SingerPageState createState() => _SingerPageState();
}
class _SingerPageState extends State<SingerPage>{

  Widget _buildListTiles(context,snapshot){
    List result;
    if(snapshot.hasData){
      result = snapshot.data['list']['artists'];
      List singGroups=SingerModel.normalizeSinger(result);
      print(singGroups);
      return Text(SingerModel.normalizeSinger(result).length.toString());
    }else{
      return Text('Loading...........');
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      child: FutureBuilder(
        future: getSingerData('hotSinger'),
        builder: _buildListTiles,
      ),
    );
  }
}