import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class CategoryBloc with ChangeNotifier {
  Map categoryData = {};

  CategoryBloc() {
    getAllCategories();
  }

  Future<Response> getAllCategories({bool forceRefresh = false}) async {
    String _url = "/api/categories/list";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(DioInterceptor.getInstance());
    DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig(
      baseUrl: Session.BASE_URL,
    ));

    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 3),
            maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    if (response?.data is Map)
      categoryData = response?.data ?? {};
    else
      categoryData = {};
    notifyListeners();
    return response;
  }
}
