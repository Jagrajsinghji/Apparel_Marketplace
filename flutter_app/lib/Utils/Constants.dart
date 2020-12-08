import 'package:dio/dio.dart';

class Constants {
  static const BASE_URL = "http://dev.wowfas.com/old/api";

  static BaseOptions baseOptions = BaseOptions(
      baseUrl: BASE_URL, connectTimeout: 5000, receiveTimeout: 3000);
}
