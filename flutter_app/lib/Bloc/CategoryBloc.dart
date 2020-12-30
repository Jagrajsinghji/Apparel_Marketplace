import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class CategoryBloc with ChangeNotifier {
  Map categoryData = {};

  CategoryBloc() {
    getAllCategories();
  }

  Future<Response> getAllCategories() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(DioInterceptor.getInstance());
    Response response = await dio.get("/api/categories/list");
    Session.instance.updateCookie(response);
    if (response?.data is Map)
      categoryData = response?.data ?? {};
    else
      categoryData = {};
    notifyListeners();
    return response;
  }
}
