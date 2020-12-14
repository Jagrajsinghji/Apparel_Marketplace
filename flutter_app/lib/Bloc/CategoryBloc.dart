import 'package:dio/dio.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';

class CategoryBloc {
  static Future<Response> getAllCategories(AppErrorBloc errorBloc) async {
    Dio dio = Dio(Constants.baseOptions);
    dio.interceptors.add(DioInterceptor(errorBloc));
    Response response = await dio.get("/api/categories/list");
    return response;
  }
}
