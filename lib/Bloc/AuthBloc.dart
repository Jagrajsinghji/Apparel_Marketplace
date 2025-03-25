import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:http_parser/http_parser.dart';

class AuthBloc with ChangeNotifier {
  Map userData = {};

  // final _googleSigIn = GoogleSignIn(
  //   scopes: <String>[
  //     'email',
  //   ],
  // );
  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();

  AuthBloc() {
    getUserProfile();
  }

  // void googleSignIn(handler, errorHandler(error)) {
  //   _googleSigIn.signIn().then((acc) {
  //     if (acc?.email != null) {
  //       acc.authentication.then((value) {
  //         if (value != null) {
  //           final credential = GoogleAuthProvider.credential(
  //               idToken: value.idToken, accessToken: value.accessToken);
  //           FirebaseAuth.instance
  //               .signInWithCredential(credential)
  //               .then((authRes) async {
  //             if (authRes != null) {
  //               notifyListeners();
  //               handler();
  //             }
  //           });
  //         }
  //       });
  //     }
  //   }).catchError((err) {
  //     errorHandler(err);
  //   });
  // }

  Future<Response> getUserProfile() async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("${Session.BASE_URL}/api/user/profile",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);
      if (response.data is Map)
        userData = response?.data ?? {};
      else
        userData = {};
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      userData = {};
      notifyListeners();
      return null;
    }
  }

  Future<Response> editProfile(
      {String name,
      String email,
      String mobileNumber,
      String city,
      String state,
      String country,
      String zip,
      String address,
      File photo}) async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();


      Map<String, dynamic> data = {
        "name": name,
        "email": email,
        "mobile_number": mobileNumber,
        "city": city,
        "address": address,
        "zip": zip,
        "country":country,
        "state": state
      };
      if (photo != null) {
        String fileName = photo?.path?.split('/')?.last;
        MultipartFile mFile = await MultipartFile.fromFile(
          photo?.path,
          filename: fileName,
          contentType: MediaType("image", fileName.split(".").last),
        );
      data.addAll({"photo": mFile});
    }
    FormData fData = FormData.fromMap(data);
      Response response = await dio.post("${Session.BASE_URL}/api/user/profile",
          data: fData,
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);
      await getUserProfile();
      print(response.data);
      return response;
    } catch (err) {
      print(err);
      notifyListeners();
      return null;
    }
  }

  Future<Response> refreshCode() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.get(
      "${Session.BASE_URL}/api/contact/refresh_code",
    );
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> login(
    String email,
    String password,
  ) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.options.headers.addAll({"Accept": "application/json"});
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.post("${Session.BASE_URL}/api/user/login",
        data: {"email": email, "password": password});
    await Session.instance.updateCookie(response);

    if (response.data is Map && response.data.length > 0) {
      String apiToken = response.data['success']['token'];
      if (apiToken != null) Session.instance.setToken(apiToken);
    }
    await getUserProfile();
    return response;
  }

  Future<Response> logOut() async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get("${Session.BASE_URL}/api/user/logout",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);
    Session.instance.setToken(null);
    userData = {};
    return response;
  }

  Future<Response> register(Map data) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.post("${Session.BASE_URL}/api/user/register", data: {
      "name": data['name'],
      "email": data['email'],
      "mobile_number": data['number'],
      "password": data['password'],
      "password_confirmation": data['password'],
      "codes": data['code']
    });
    await Session.instance.updateCookie(response);

    await login(data['email'], data['password']);
    return response;
  }

  Future<Response> resetPassword(String email) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    Response response =
        await dio.post("${Session.BASE_URL}/api/user/forgot?email=$email");
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> loginWithNumber(String number, String otp) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.options.headers.addAll({"Accept": "application/json"});
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.post(
        "${Session.BASE_URL}/api/user/login-register-otp",
        data: {"mobile_number": number, "otp": otp});
    await Session.instance.updateCookie(response);
    if (response.data is Map && response.data.length > 0) {
      String apiToken = response.data['success']['token'];
      if (apiToken != null) Session.instance.setToken(apiToken);
    }
    await getUserProfile();
    return response;
  }

  Future<Response> sendOTP(String number, String signature) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.options.headers.addAll({"Accept": "application/json"});
    dio.interceptors.add(_dioInterceptor);
    Response response = await dio.post("${Session.BASE_URL}/api/user/send-otp",
        data: {"mobile_number": number, "signature": signature});
    await Session.instance.updateCookie(response);
    return response;
  }
}
