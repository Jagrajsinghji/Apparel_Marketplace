import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class ProductsBloc with ChangeNotifier {
  Map homePageData = {}, homePageExtras = {};

  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();

  ProductsBloc() {
    getHomePage();
    getHomePageExtras();
  }

  Future<Response> getHomePage() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get("/api");
    Session.instance.updateCookie(response);
    if (response?.data is Map)
      homePageData = response?.data ?? {};
    else
      homePageData = {};
    notifyListeners();
    return response;
  }

  Future<Response> getHomePageExtras() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get("/api/extras");
    Session.instance.updateCookie(response);
    if (response?.data is Map)
      homePageExtras = response?.data ?? {};
    else
      homePageExtras = {};
    notifyListeners();
    return response;
  }

  Future<Response> getProductsByCategoryName(
    String name,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get("/api/category/$name/null/null");
    Session.instance.updateCookie(response);
    return response;
  }

  Future<Response> getProductsBySubCategoryName(
    String categoryName,
    String subcategoryName,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("/api/category/$categoryName/$subcategoryName/null");
    Session.instance.updateCookie(response);
    return response;
  }

  Future<Response> getProductsByChildCategoryName(
    String categoryName,
    String subcategoryName,
    String childCategoryName,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio
        .get("/api/category/$categoryName/$subcategoryName/$childCategoryName");
    Session.instance.updateCookie(response);
    return response;
  }
}
