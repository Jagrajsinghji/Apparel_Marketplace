import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Constants {
  static const BASE_URL = "http://dev.wowfas.com/old";

  static BaseOptions baseOptions = BaseOptions(
      baseUrl: BASE_URL, connectTimeout: 5000, receiveTimeout: 5000,
  );

  static GlobalKey<NavigatorState> navigatorKey =GlobalKey();
}
