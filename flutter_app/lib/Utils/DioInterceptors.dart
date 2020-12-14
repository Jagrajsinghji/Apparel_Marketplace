import 'package:dio/dio.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';

class DioInterceptor extends Interceptor{

  final AppErrorBloc _appErrorBloc;

  DioInterceptor(this._appErrorBloc);

  @override
  Future onRequest(RequestOptions options) async{
    return options ;
  }

  @override
  Future onError(DioError err) async{
    // _appErrorBloc.updateError(err.message);
    return true;
  }

  @override
  Future onResponse(Response response)async {
    return response;
  }
}