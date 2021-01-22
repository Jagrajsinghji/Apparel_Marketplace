import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class ProductsBloc with ChangeNotifier {
  Map homePageData = {}, homePageExtras = {};

  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();
  DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig(
    baseUrl: Session.BASE_URL,
  ));

  ProductsBloc() {
    getHomePage(forceRefresh: true);
    getHomePageExtras(forceRefresh: true);
  }

  Future<Response> getHomePage({bool forceRefresh = false}) async {
    String _url = "/api";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    if (forceRefresh) _dioCacheManager.delete(_url);
    dio.interceptors.add(_dioCacheManager.interceptor);

    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 1),
            maxStale: Duration(days: 3), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    if (response?.data is Map)
      homePageData = response?.data ?? {};
    else
      homePageData = {};
    notifyListeners();
    return response;
  }

  Future<Response> getHomePageExtras({bool forceRefresh = false}) async {
    String _url = "/api/extras";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    dio.interceptors.add(_dioCacheManager.interceptor);

    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 1),
            maxStale: Duration(days: 3), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    if (response?.data is Map)
      homePageExtras = response?.data ?? {};
    else
      homePageExtras = {};
    notifyListeners();
    return response;
  }

  Future<Response> getProductsByCategoryName(String name,
      {int page, bool forceRefresh = false}) async {
    String _url = "/api/category/$name/null/null?page=$page";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 3),
            maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getProductsBySubCategoryName(
      String categoryName, String subcategoryName,
      {int page, bool forceRefresh = false}) async {
    String _url =
        "/api/category/$categoryName/$subcategoryName/null?page=$page";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 3),
            maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getProductsByChildCategoryName(
      String categoryName, String subcategoryName, String childCategoryName,
      {int page, bool forceRefresh = false}) async {
    String _url =
        "/api/category/$categoryName/$subcategoryName/$childCategoryName?page=$page";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 3),
            maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getSearchedProducts(
    String keyword,
    int page,
  ) async {
    String _url = "/api/category/null/null/null?search=$keyword&page=$page";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 1),
            maxStale: Duration(days: 3), forceRefresh: false));
    await Session.instance.updateCookie(response);
    return response;
  }

  Future<Response> getViewMoreProducts(String filter,
      {int page, bool forceRefresh = false}) async {
    String _url = "/api/view-all-products/$filter?page=$page";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 3),
            maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getBrandProducts(String brandName,
      {int page, bool forceRefresh = false}) async {
    String _url = "/api/brand/$brandName?page=$page";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 3),
            maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    return response;
  }
}
