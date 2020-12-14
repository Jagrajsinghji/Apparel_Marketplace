import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';

class ProductsBloc {

static Future<Response> getHomePage(AppErrorBloc errorBloc)async{
  Dio dio = Dio(Constants.baseOptions);
  dio.interceptors.add(DioInterceptor(errorBloc));
  Response response = await dio.get("/api");
  return response;
}
static Future<Response> getHomePageExtras(AppErrorBloc errorBloc)async{
  Dio dio = Dio(Constants.baseOptions);
  dio.interceptors.add(DioInterceptor(errorBloc));
  Response response = await dio.get("/api/extras");
  return response;
}

static Future<Response> getProductsByCategoryName(String name,AppErrorBloc errorBloc)async {
  Dio dio = Dio(Constants.baseOptions);
  dio.interceptors.add(DioInterceptor(errorBloc));
  Response response = await dio.get("/api/category/$name/null/null");
  return response;
}

static Future<Response> getProductsBySubCategoryName(String categoryName,String subcategoryName,AppErrorBloc errorBloc)async {
  Dio dio = Dio(Constants.baseOptions);
  dio.interceptors.add(DioInterceptor(errorBloc));
  Response response = await dio.get("/api/category/$categoryName/$subcategoryName/null");
  return response;
}

static Future<Response> getProductsByChildCategoryName(String categoryName,String subcategoryName,String childCategoryName,AppErrorBloc errorBloc)async {
  Dio dio = Dio(Constants.baseOptions);
  dio.interceptors.add(DioInterceptor(errorBloc));
  Response response = await dio.get("/api/category/$categoryName/$subcategoryName/$childCategoryName");
  return response;
}


}