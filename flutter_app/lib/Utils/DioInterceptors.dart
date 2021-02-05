import 'package:dio/dio.dart';
import 'package:flutter_app/Utils/Session.dart';

class DioInterceptor extends Interceptor {

  DioInterceptor._private();

  static DioInterceptor _instance;

  factory DioInterceptor.getInstance() {
    _instance ??= DioInterceptor._private();
    return _instance;
  }

  @override
  Future onRequest(RequestOptions options) async {
    var cookies = (await Session.instance.getHeaders());
    options.headers.addAll(cookies);
    print(options.uri);
    // print(options.headers);
    return options;
  }

  @override
  Future onError(DioError err) async {
    print("****************************************************");
    print(err.message);
    print(err.request.uri);
    print("****************************************************");
    // _appErrorBloc.updateError(err.message);
    return err;
  }

  @override
  Future onResponse(Response response) async {
    return response;
  }
}
