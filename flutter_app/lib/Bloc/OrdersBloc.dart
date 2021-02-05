import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class OrdersBloc with ChangeNotifier {
  List myOrders = [];
  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();

  OrdersBloc() {
    getMyOrders();
  }

  Future<Response> getMyOrders() async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("/api/user/orders",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);

      if (response?.data is List)
        myOrders = response?.data ?? [];
      else
        myOrders = [];
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      myOrders = [];
      notifyListeners();
      return null;
    }
  }

  Future<Response> getOrderDetails(int id) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get("/api/user/order/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> cancelOrder(String id) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get("/api/user/cancel-this-order/$id/1",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);
    notifyListeners();
    return response;
  }
}
