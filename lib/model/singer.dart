import 'package:lpinyin/lpinyin.dart';
class SingerModel{
  final String name;
  final int id;
  final String avatar;
  String title='';
  SingerModel(
    this.name,
    this.id,
    this.avatar,
  );
  static RegExp reg = RegExp('[a-zA-Z]');
  static normalizeSinger(List list){
    // for(int i=0;i<list.length;i++){
    //   var item = list[i];
    //   print(item['name']);
    //   print(reg.hasMatch(list[i]['name']));
    // }
    const String HOT_NAME='热门';
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
      SingerModel singerModel=SingerModel(item['name'],item['id'],item['picUrl']);
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