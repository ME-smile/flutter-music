import 'package:dio/dio.dart';
import 'dart:async';
import 'url.dart';
Future getSingerData(String path) async{
  try{
    Dio dio = new Dio();
    Response response = await dio.get(routers[path]);
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('Failed to get data ...');
    }
  }catch(e){
    print(e);
  }
}
