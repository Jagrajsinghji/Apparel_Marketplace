import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';

class ProductsBloc {

static Future<Response> getHomePage()async{
  Dio dio = Dio(Constants.baseOptions);
  Response response = await dio.get("");
  return response;
}
static Future<Response> getHomePageExtras()async{
  Dio dio = Dio(Constants.baseOptions);
  Response response = await dio.get("/extras");
  return response;
}



}