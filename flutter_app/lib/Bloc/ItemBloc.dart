import 'package:dio/dio.dart';
import 'package:flutter_app/Utils/Constants.dart';

import 'AppErrorBloc.dart';

class ItemBloc {

  static Future<Response> getItemBySlug(String slug,
      AppErrorBloc errorBloc) async {
    Dio dio = Dio(Constants.baseOptions);
    Response response = await dio.get(
        "/api/category/item/$slug");
    return response;
  }
}