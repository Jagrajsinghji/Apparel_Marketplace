import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'SignIn.dart';

class SignUp extends StatefulWidget {
  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  bool showPassword = true;
  GlobalKey<FormFieldState> _nameKey = GlobalKey();

  GlobalKey<FormFieldState> _mobileKey = GlobalKey();
  GlobalKey<FormFieldState> _emailKey = GlobalKey();
  GlobalKey<FormFieldState> _passKey = GlobalKey();
  GlobalKey<FormFieldState> _captchaKey = GlobalKey();
  String name, number, email, pass, captcha;

  bool showError = false, loading = false, captchaEnabled = false;
  String errorMessage = "";

  String _code, _time;

  @override
  void initState() {
    super.initState();
    refreshCaptcha();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        children: [
          Image.asset(
            "assets/logo.png",
            height: 70,
            width: 225,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 17),
            child: Text(
              "Sign Up",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 40,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 17),
            child: Text(
              "Create a new account to access thousands\nof products",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 18.11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
                key: _nameKey,
                validator: (c) {
                  if (c.trim().length < 3)
                    return "Name must be greater than 3 letters.";
                  return null;
                },
                onChanged: (c) => name = c.trim(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.black)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDC0F21)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDC0F21)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintText: "Name",
                  hintStyle: TextStyle(
                    color: Color(0xff9d9d9d),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                key: _mobileKey,
                validator: (c) {
                  if (c.trim().length < 10) return "Invalid Mobile Number";
                  return null;
                },
                onChanged: (c) => number = c.trim(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.black)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDC0F21)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDC0F21)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintText: "Mobile Number",
                  hintStyle: TextStyle(
                    color: Color(0xff9d9d9d),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(8),
              ),
              child: TextFormField(
                key: _emailKey,
                validator: (val) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (val.isEmpty ||
                      val == " " ||
                      val.length < 5 ||
                      !regex.hasMatch(val)) {
                    return "Enter Valid Email Address";
                  }
                  return null;
                },
                onChanged: (c) => email = c.trim(),
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.black)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.black)),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDC0F21)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Color(0xffDC0F21)),
                    borderRadius: BorderRadius.circular(100),
                  ),
                  hintText: "Email",
                  hintStyle: TextStyle(
                    color: Color(0xff9d9d9d),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 18.11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
                key: _passKey,
                validator: (c) {
                  if (c.length < 6)
                    return "Password must be greater than 6 letters";
                  return null;
                },
                onChanged: (c) => pass = c.trim(),
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.black)),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDC0F21)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDC0F21)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Color(0xff9d9d9d),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                    suffixIcon: Container(
                      height: 50,
                      child: FlatButton(
                        splashColor: Colors.transparent,
                        focusColor: Colors.transparent,
                        onPressed: () {
                          setState(() {
                            showPassword = !showPassword;
                          });
                        },
                        child: showPassword
                            ? Transform.translate(
                                offset: Offset(18, 0),
                                child: Transform.scale(
                                    scale: .3,
                                    child: Image.asset("assets/hidePass.png")))
                            : Transform.scale(
                                scale: .5,
                                child: Image.asset("assets/seePass1.png")),
                      ),
                    )),
                obscureText: showPassword,
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          if (captchaEnabled) ...[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                height: 60,
                child: Stack(
                  children: [
                    Center(
                      child: CachedNetworkImage(
                        progressIndicatorBuilder: (c, a, p) {
                          return Container(
                              width: 200,
                              child: LinearProgressIndicator(
                                value: p.progress,
                                valueColor:
                                    AlwaysStoppedAnimation(Color(0xffdc0f21)),
                              ));
                        },
                        imageUrl:
                            "${Session.BASE_URL}/public/assets/images/capcha_code.png${_time == null ? "" : "?time=$_time"}",
                      ),
                    ),
                    Align(
                      alignment: Alignment.centerRight,
                      child: IconButton(
                          onPressed: refreshCaptcha, icon: Icon(Icons.refresh)),
                    )
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 27),
              child: Container(
                decoration: BoxDecoration(
                  color: Color(0xfff6f6f6),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: TextFormField(
                  key: _captchaKey,
                  validator: (c) {
                    if (c.trim() != _code.toString().trim())
                      return "Please Enter valid captcha";
                    return null;
                  },
                  onChanged: (c) => captcha = c.trim(),
                  decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.black)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.black)),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDC0F21)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Color(0xffDC0F21)),
                      borderRadius: BorderRadius.circular(100),
                    ),
                    hintText: "Captcha Code",
                    hintStyle: TextStyle(
                      color: Color(0xff9d9d9d),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ],
          if (showError) ...[
            SizedBox(height: 18.11),
            Center(
              child: Text(
                "$errorMessage",
                style: TextStyle(
                  color: Color(0xffdc0f21),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          SizedBox(height: 18.11),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InkWell(
              onTap: signUp,
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xffdc0f21),
                ),
                child: Center(
                  child: loading
                      ? SpinKitFadingCircle(
                          color: Colors.white,
                        )
                      : Text(
                          "Go Shopping",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                ),
              ),
            ),
          ),
          SizedBox(height: 18.11),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Already have an account? ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (c) => SignIn()));
                },
                child: Text(
                  "Sign In",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1382B6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void signUp() async {
    if (_nameKey.currentState.validate() &&
        _mobileKey.currentState.validate() &&
        _emailKey.currentState.validate() &&
        _passKey.currentState.validate()) {
      if (captchaEnabled) if (!_captchaKey.currentState.validate()) return;
      if (mounted)
        setState(() {
          showError = false;
          loading = true;
        });
      // FirebaseAuth.instance
      //     .createUserWithEmailAndPassword(email: email.trim(), password: pass)
      //     .then((authRes) async {
      //   if (authRes?.user != null) {
      //     await authRes.user.updateProfile(displayName: name);
      //     Navigator.pop(context);
      //   }
      // }).catchError((err) {
      //   errorMessage = err.message.toString();
      //   showError = true;
      //   loading = false;
      //   if (mounted) setState(() {});
      // });
      if (mounted)
        setState(() {
          showError = false;
          loading = true;
        });
      try {
        Map data = {
          "name": name,
          "number": number,
          "email": email,
          "password": pass,
          "code": captcha
        };
        Response resp =
            await Provider.of<AuthBloc>(context, listen: false).register(data);
        var respData = resp.data;
        if (respData is Map) {
          if (respData.containsKey("errors"))
            throw DioError(
                response:
                    Response(data: {"message": respData['errors'].toString()}));
          else {
            String dataEmail = resp.data['user']['email'];
            if (dataEmail == email) {
              String value = resp.data['user']['api_token'] ?? "";
              if (value.length == 0)
                throw DioError(
                    type: DioErrorType.RESPONSE,
                    response: Response(data: {"message": "", "code": 101}));
              else {
                showDialog(
                    context: context,
                    builder: (c) => AlertDialog(
                          actions: [
                            FlatButton(
                                onPressed: () {
                                  Navigator.pop(c);
                                  Navigator.pop(context);
                                  refreshBlocs(context, loginRefresh: true);
                                },
                                child: Text(
                                  "Got It",
                                  style: TextStyle(),
                                ))
                          ],
                          title: Text(
                            "User Registered Successfully",
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          content: Text(
                            "A registration email has been sent to your email address.\nPlease verify your account for all benefits.",
                            textAlign: TextAlign.center,
                            style: TextStyle(),
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ));
                return;
              }
            } else
              throw DioError(
                  type: DioErrorType.RESPONSE,
                  response: Response(data: {"message": "", "code": 102}));
          }
        } else
          throw DioError(response: Response(data: {"code": 103}));
      } on DioError catch (error) {
        var data = error.response.data;
        if (data is Map) {
          var msg = data['message'];
          var code = data['code'] ?? "";
          if (msg.toString().toLowerCase().contains("email"))
            errorMessage = "Email has already been taken.";
          else if (msg.toString().toLowerCase().contains("mobile"))
            errorMessage = "Mobile Number has already been taken.";
          else
            errorMessage =
                "Something went wrong. Please try after some time.$code";
        } else
          errorMessage = "Something went wrong. Please try after some time.";
        showError = true;
        loading = false;
        if (mounted) setState(() {});
      }
    }
  }

  void refreshCaptcha() {
    Provider.of<AuthBloc>(context, listen: false).refreshCode().then((s) {
      captchaEnabled = s.data['capcha_status'] == 1;
      _code = s.data['capcha_code'];
      _time = Random().nextDouble().toString();
      if (mounted) setState(() {});
    });
  }
}
