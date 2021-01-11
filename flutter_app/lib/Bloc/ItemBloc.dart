import 'package:dio/dio.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';

class ItemBloc {
  Future<Response> getItemBySlug(
    String slug,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(DioInterceptor.getInstance());
    Response response = await dio.get("/api/item/$slug");
    await Session.instance.updateCookie(response);

    return response;
  }
}
