import 'package:lpinyin/lpinyin.dart';
class SingerModel{
  final String name;
  final int id;
  final String avatar;
  String title='';
  SingerModel({
    this.name,
    this.id,
    this.avatar,
  });
  static RegExp reg = RegExp('[a-zA-Z]');
  static normalizeSinger(List list){
    const String HOT_NAME='🔥';
    const int HOT_SINGER_LEN=10;
    final int len = list.length;
    Map<String,dynamic> data={
      'hot': {
        'title': HOT_NAME,
        'items': <SingerModel>[]
      }
    };
    //  遍历list,取出前十条，添加到items,
    for(int i=0;i<len;i++){
      var item = list[i];
      SingerModel singerModel=SingerModel(name:item['name'],id:item['id'],avatar:item['picUrl']);
      if(i<HOT_SINGER_LEN){
        data['hot']['items'].add(
          singerModel
        );
      }
      // 重新设置singer.title
      if(reg.hasMatch(item['name'][0])){
        singerModel.title = item['name'][0].toUpperCase();
      }else{
        singerModel.title = PinyinHelper.getFirstWordPinyin(item['name'])[0].toUpperCase();
      }
      // 字母对象，以字母为键
      String key = singerModel.title;
      if(!data.containsKey(key)){
        data[key]={
          'title':key,
          'items':[]
        };
      }
      data[key]['items'].add(
        singerModel
      );
    }
    List hot=[];
    List ret=[];
    data.forEach((key,val){
      if(reg.hasMatch(val['title'])){
        ret.add(val);
      }else if(val['title'] == HOT_NAME){
        hot.add(val);
      }
    });
    ret.sort((a,b){
      return a['title'].codeUnitAt(0)-b['title'].codeUnitAt(0);
    });
       return hot+ret;
  }
}
class SingerDetailModel{
  final int id;
  final String name;
  final String avatar;
  // final List<SongModel> songs;
  const SingerDetailModel({
    this.id,
    this.name,
    this.avatar
  });

  factory SingerDetailModel.fromJson(Map<String,dynamic> json){
    return SingerDetailModel(
      id:json['id'],
      name:json['name'],
      avatar: json['picUrl']
    );
  }
}