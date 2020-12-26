import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:fluttertoast/fluttertoast.dart';

class CartBloc with ChangeNotifier {
  Map cartData = {};
  Map couponData = {};


  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();

  CartBloc() {
    getCartItems();
  }

  Future<Response> getCartItems() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get("/api/carts/view");
    Session.instance.updateCookie(response);
    if (response?.data is Map)
      cartData = response?.data ?? {};
    else
      cartData = {};
    notifyListeners();
    return response;
  }

  Future<Response> addItemByID(
    int itemID,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get("/api/addcart/$itemID");
    Session.instance.updateCookie(response);

    await getCartItems();
    return response;
  }

  /// Use this one on Item Page and checkout/shopping bag page
  Future<Response> addItemToCart(int itemId, int qty,
      {size = "",
      color = "",
      sizeQty = "",
      sizePrice = "",
      sizeKey = "",
      keys = "",
      values = "",
      prices = ""}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
        "${Session.BASE_URL}/api/numcart/add?id=$itemId&qty=$qty&size=$size&color=$color&size_qty=$sizeQty&size_price=$sizePrice&size_key=$sizeKey&keys=$keys&values=$values&prices=$prices");
    Session.instance.updateCookie(response);
    await getCartItems();

    if (response.data != null && response.data['data'] is String)
      return response;
    if (((response.data['data'] ?? {})['item'] ?? {})['id'] == itemId) {
      Fluttertoast.showToast(msg: "Item Added To Cart");
    }
    return response;
  }

  Future<Response> removeItemFromCart(
    String key,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("${Session.BASE_URL}/api/removecart/$key");
    Session.instance.updateCookie(response);

    await getCartItems();
    return response;
  }

  Future<Response> addByOne(
    int id,
    String itemId, {
    sizeQty = "",
    sizePrice = "",
  }) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
        "${Session.BASE_URL}/api/add/byone?id=$id&itemid=$itemId&size_qty=$sizeQty&size_price=$sizePrice");
    Session.instance.updateCookie(response);
    await getCartItems();
    if (response.data['data'] is String) {
      if (response.data['data'].toString().contains("greater than size qty"))
        Fluttertoast.showToast(msg: "Can not add more items.");
    } else if (response.data['data'] is Map) {
      Fluttertoast.showToast(msg: "Item added successfully.");
    }
    return response;
  }

  Future<Response> reduceByOne(
    int id,
    String itemId, {
    sizeQty = "",
    sizePrice = "",
  }) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
        "${Session.BASE_URL}/api/reduce/byone?id=$id&itemid=$itemId&size_qty=$sizeQty&size_price=$sizePrice");
    Session.instance.updateCookie(response);
    await getCartItems();
    if (response.data['data'] is String) {
      if (response.data['data'].toString().contains("greater than size qty"))
        Fluttertoast.showToast(msg: "Can not remove item.");
    } else if (response.data['data'] is Map) {
      Fluttertoast.showToast(msg: "Item removed successfully.");
    }
    return response;
  }

  Future<Response> getCheckOutItems() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get("/api/checkout/view");
    Session.instance.updateCookie(response);
    return response;
  }

  Future<Response> getCouponDetails(String coupon, String total) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("/api/carts/coupon?code=$coupon&total=$total");
    Session.instance.updateCookie(response);
    if (response?.data is Map) {
      couponData = response.data;
    } else
      couponData = {};
    notifyListeners();
    return response;
  }
}
