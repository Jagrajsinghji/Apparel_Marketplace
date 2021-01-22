import 'package:dio/dio.dart';
import 'package:dio_http_cache/dio_http_cache.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ItemBloc with ChangeNotifier {
  Map wishListData = {};

  ItemBloc() {
    getWishList();
  }

  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();

  Future<Response> getItemBySlug(
    String slug,{bool forceRefresh=false}
  ) async {
    String _url = "/api/item/$slug";
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    DioCacheManager _dioCacheManager = DioCacheManager(CacheConfig(
      baseUrl: Session.BASE_URL,defaultRequestMethod: "GET"
    ));
    dio.interceptors.add(_dioCacheManager.interceptor);
    Response response = await dio.get(_url, options: buildCacheOptions(Duration(days: 3),
        maxStale: Duration(days: 7), forceRefresh: forceRefresh));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getWishList() async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("/api/user/wishlists",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);
      if (response.data is Map)
        wishListData = {}..addAll(response.data);
      else
        wishListData = {};
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      wishListData = {};
      notifyListeners();
      return null;
    }
  }

  Future<Response> addItemToWishlist(int itemId) async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("/api/user/wishlist/add/$itemId",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      print(response.data);
      await Session.instance.updateCookie(response);
      await getWishList();
      if (response.data != null) {
        Fluttertoast.showToast(msg: "Item Added To Wishlist");
      }
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Response> removeItemFromWishlist(int itemId) async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("/api/user/wishlist/remove/$itemId",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      print(response.data);
      await Session.instance.updateCookie(response);
      await getWishList();
      if (response.data != null) {
        Fluttertoast.showToast(msg: "Item Removed From Wishlist");
      }
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      return null;
    }
  }
}
