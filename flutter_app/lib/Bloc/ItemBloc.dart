import 'package:dio/dio.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';

import 'AppErrorBloc.dart';

class ItemBloc {

  static Future<Response> getItemBySlug(String slug,
      AppErrorBloc errorBloc) async {
    Dio dio = Dio(Constants.baseOptions);
    dio.interceptors.add(DioInterceptor(errorBloc));
    Response response = await dio.get(
        "/api/item/$slug");
    return response;
  }
}