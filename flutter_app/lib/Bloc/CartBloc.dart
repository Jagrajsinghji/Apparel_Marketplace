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
    await Session.instance.updateCookie(response);
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
    await Session.instance.updateCookie(response);

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
    await Session.instance.updateCookie(response);
    await getCartItems();
    if (response.data != null && response.data['data'] is String) {
      Fluttertoast.showToast(msg: "An Error occurred!");
    }
    if (((response.data['data'] ?? {})['item'] ?? {})['id'] == itemId) {
      Fluttertoast.showToast(msg: "Item Added To Cart");
    }
    notifyListeners();
    return response;
  }

  Future<Response> removeItemFromCart(
    String key,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("${Session.BASE_URL}/api/removecart/$key");
    await Session.instance.updateCookie(response);

    await getCartItems();
    return response;
  }

  Future<Response> addByOne(int id, String itemId,
      {sizeQty = "", sizePrice = "", bool getCartItem = true}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
        "${Session.BASE_URL}/api/add/byone?id=$id&itemid=$itemId&size_qty=$sizeQty&size_price=$sizePrice");

    await Session.instance.updateCookie(response);

    if (getCartItem) {
      await getCartItems();
    } else
      getCartItems();

    if (response.data['data'] is String) {
      if (response.data['data'].toString().contains("Out of stock"))
        Fluttertoast.showToast(msg: "Item out of stock.");
    } else if (response.data['data'] is Map) {
      Fluttertoast.showToast(msg: "Item added successfully.");
    }

    notifyListeners();

    return response;
  }

  Future<Response> reduceByOne(int id, String itemId,
      {sizeQty = "", sizePrice = "",}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
        "${Session.BASE_URL}/api/reduce/byone?id=$id&itemid=$itemId&size_qty=$sizeQty&size_price=$sizePrice");
    await Session.instance.updateCookie(response);
    await getCartItems();
    if (response.data['data'] is String) {
      if (response.data['data'].toString().contains("greater than size qty"))
        Fluttertoast.showToast(msg: "Can not remove item.");
    } else if (response.data['data'] is Map) {
      Fluttertoast.showToast(msg: "Item removed successfully.");
    }notifyListeners();
    return response;
  }

  Future<Response> getCheckOutItems() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get("/api/checkout/view",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> getCouponDetails(String coupon, String total) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.get("/api/carts/coupon?code=$coupon&total=$total");
    await Session.instance.updateCookie(response);

    if (response?.data is Map) {
      couponData = response.data;
    } else
      couponData = {};
    notifyListeners();
    return response;
  }

  Future<Response> placeCashOnDeliveryOrder(
      {String personalEmail,
      String personalName,
      String personalPass,
      String userId,
      String totalQty,
      String shipping,
      String pickupLocation,
      String email,
      String name,
      String tax,
      String phone,
      String total,
      String method,
      String personalConfirm,
      String shippingCost,
      String packingCost,
      String customerCountry,
      String address,
      String city,
      String zip,
      String vendorShippingId,
      String vendorPackingId,
      String dp,
      String couponCode,
      String couponDiscount,
      String couponId}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.post(
        "/api/cashon/delivery?personal_email=$personalEmail&personal_name=$personalName&personal_pass=$personalPass&user_id=$userId&totalQty=$totalQty&shipping=$shipping&pickup_location=$pickupLocation&email=$email&name=$name&tax=$tax&phone=$phone&total=$total&method=$method&personal_confirm=$personalConfirm&shipping_cost=$shippingCost&packing_cost=$packingCost&customer_country=$customerCountry&address=$address&city=$city&zip=$zip&vendor_shipping_id=$vendorShippingId&vendor_packing_id=$vendorPackingId&dp=$dp&coupon_code=$couponCode&coupon_discount=$couponDiscount&coupon_id=$couponId",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);

    await getCartItems();
    notifyListeners();
    return response;
  }
}
