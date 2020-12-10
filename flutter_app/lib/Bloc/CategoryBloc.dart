import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/Utils/Constants.dart';

class CategoryBloc {

static Future<Response> getAllCategories(AppErrorBloc errorBloc)async{
  Dio dio = Dio(Constants.baseOptions);
  Response response = await dio.get("/api/categories/list");
  return response;
}
}