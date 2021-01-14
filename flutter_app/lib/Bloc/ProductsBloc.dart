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
    await Session.instance.updateCookie(response);

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
    await Session.instance.updateCookie(response);

    if (response?.data is Map)
      homePageExtras = response?.data ?? {};
    else
      homePageExtras = {};
    notifyListeners();
    return response;
  }

  Future<Response> getProductsByCategoryName(String name, {int page}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("/api/category/$name/null/null?page=$page");
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getProductsBySubCategoryName(
      String categoryName, String subcategoryName,
      {int page}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio
        .get("/api/category/$categoryName/$subcategoryName/null?page=$page");
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getProductsByChildCategoryName(
      String categoryName, String subcategoryName, String childCategoryName,
      {int page}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
        "/api/category/$categoryName/$subcategoryName/$childCategoryName?page=$page");
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getSearchedProducts(String keyword, int page) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("/api/category/null/null/null?search=$keyword&page=$page");
    await Session.instance.updateCookie(response);
    return response;
  }
}
