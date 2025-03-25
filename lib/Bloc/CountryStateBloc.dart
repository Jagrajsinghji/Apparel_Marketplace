import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class CountryStateBloc with ChangeNotifier {
  List countries = [], states = [];
  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();
  DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig(
    baseUrl: Session.BASE_URL,
  ));

  CountryStateBloc(){
    getStatesCountries();
  }

  Future<Response> getStatesCountries({bool forceRefresh = false}) async {
    String _url = "/api/states-countries";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    dio.interceptors.add(_dioCacheManager.interceptor);

    Response response = await dio.get(_url,
        options: buildCacheOptions(Duration(days: 120),
            maxStale: Duration(days: 120), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    if (response?.data is Map) {
      countries = response.data['countries'] ?? [];
      states = response.data['states'] ?? [];
    } else {
      countries = [];
      states = [];
    }
    notifyListeners();
    return response;
  }
}
