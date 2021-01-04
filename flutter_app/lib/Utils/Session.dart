import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Session {
  static const BASE_URL = "https://wowfas.com";
  static const IMAGE_BASE_URL = "https://marketplace.wowfas.com";
  static GlobalKey<NavigatorState> navigatorKey = GlobalKey();
  static Session _constant = Session();

  static Session get instance => _constant;

  Map<String, String> _headers = {};
  SharedPreferences _pref;

  get baseOptions => BaseOptions(
        baseUrl: BASE_URL,
      );

  Future<Map<String, String>> getHeaders() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    String _savedCookie = _pref.get("cookie_");
    if (_savedCookie != null) _headers['cookie'] = _savedCookie;
    return _headers;
  }

  Future<void> updateCookie(Response response) async {
    if (response == null) return;
    String rawCookie = response.headers['set-cookie'].toString();
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    String _savedCookie = _pref.get("cookie_");
    if (rawCookie != null) {
      _headers['cookie'] = rawCookie.split(";").first.replaceAll("[", "");
      if (_savedCookie != _headers['cookie'])
        _pref.setString("cookie_", _headers['cookie']);
    }
  }

  void setToken(String value) async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    _pref.setString("api_token_", value);
  }

  Future<String> getToken() async {
    if (_pref == null) _pref = await SharedPreferences.getInstance();
    return _pref.getString("api_token_");
  }
}
