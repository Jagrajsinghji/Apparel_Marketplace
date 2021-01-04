import 'package:dio/dio.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter/material.dart';
class OrdersBloc with ChangeNotifier{
  List myOrders=[];
  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();

  OrdersBloc(){
    getMyOrders();
  }
  Future<Response> getMyOrders() async {
    print('dfgjkjl;kjhgfvdxvfghjk');
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token =await Session.instance.getToken();
    Response response = await dio.get("/api/user/orders",options: Options(headers: {"Authorization":"Bearer $token"}));
    Session.instance.updateCookie(response);
    if (response?.data is Map)
      myOrders = response?.data ?? [];
    else
      myOrders = [];
    print(myOrders);
    notifyListeners();
    return response;
  }
}