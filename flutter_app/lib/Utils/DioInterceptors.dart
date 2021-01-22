import 'package:dio/dio.dart';
import 'package:flutter_app/Utils/Session.dart';

class DioInterceptor extends Interceptor {

  DioInterceptor._private();

  factory DioInterceptor.getInstance() => DioInterceptor._private();

  @override
  Future onRequest(RequestOptions options) async {
    options.headers.addAll((await Session.instance.getHeaders()));
    // print(options.headers);
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
