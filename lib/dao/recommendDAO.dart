import 'package:dio/dio.dart';
import 'dart:async';
import 'url.dart';
Future getData(String path) async{
  try{
    Response response = await  Dio().get(routers[path]);
    if(response.statusCode==200){
      return response.data;
    }else{
      throw Exception('Failed to get data ...');
    }
  }catch(e){
    print(e);
  }
}

