import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/UI/SignInUp/SignUp.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

import 'ForgotPassword1.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPassword = true;
  GlobalKey<FormFieldState> _emailKey = GlobalKey();
  GlobalKey<FormFieldState> _passKey = GlobalKey();
  String email, pass;

  bool showError = false, loading = false;
  String errorMessage = "";

  @override
  Widget build(BuildContext context) {
    AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
      body: ListView(
        shrinkWrap: true,
        children: [
          Image.asset(
            "assets/logo.png",
            height: 70,
            width: 225,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 36.0, top: 17),
            child: Text(
              "Sign In",
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
              "Sign in to continue",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
                key: _emailKey,
                onChanged: (c) {
                  email = c.trim();
                },
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
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
                key: _passKey,
                onChanged: (c) {
                  pass = c;
                },
                validator: (c) {
                  if (c.length < 6)
                    return "Pasword must be greater than 6 letters";
                  return null;
                },
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
                        highlightColor: Colors.transparent,
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
          if (showError) ...[
            SizedBox(height: 17),
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
          SizedBox(height: 17),
          Align(
            alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right: 27.0),
              child: InkWell(
                onTap: () {
                  Navigator.push(context,
                      MaterialPageRoute(builder: (c) => ForgotPassword1()));
                },
                child: Text(
                  "Forgot Password?",
                  style: TextStyle(
                    color: Color(0xff729aff),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InkWell(
              onTap: () => signIn(_authBloc),
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
          SizedBox(height: 17),
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(
                onTap: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (c) => SignUp()));
                },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 14,
                    color: Color(0xff1382B6),
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ],
          ),
          SizedBox(height: 17),
          Center(
            child: Text(
              "or",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 17),
          Center(
            child: Text(
              "Sign In using",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 17),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              InkWell(
                onTap: () {
                  // _authBloc.googleSignIn(() => Navigator.pop(context), (error) {
                  //   print(error);
                  // });
                },
                child: Container(
                  height: 58,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Color(0xff7b8387),
                  ),
                  child: Center(
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Transform.scale(
                            scale: .5,
                            child: Image.asset(
                              "assets/google.png",
                            )),
                        Padding(
                          padding: const EdgeInsets.only(right: 25.0),
                          child: Text(
                            "Google",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Color(0xff7b8387),
                ),
                child: Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(10.0),
                        child: Transform.scale(
                            scale: .5,
                            child: Image.asset(
                              "assets/facebook.png",
                            )),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right: 25.0),
                        child: Text(
                          "Facebook",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  void signIn(AuthBloc authBloc) async {
    if (_emailKey.currentState.validate() && _passKey.currentState.validate()) {
      if (mounted)
        setState(() {
          showError = false;
          loading = true;
        });

      // FirebaseAuth.instance
      //     .signInWithEmailAndPassword(email: email.trim(), password: pass)
      //     .then((userCreds) async {
      //   if (userCreds?.user != null) {
      //     Navigator.pop(context);
      //   }
      // }).catchError((err) {
      //   errorMessage = err.message.toString();
      //   showError = true;
      //   loading = false;
      //   if (mounted) setState(() {});
      // });

      try {
        Response resp = await Provider.of<AuthBloc>(context, listen: false)
            .login(email, pass);

        if (resp.data is Map && resp.data.length > 0) {
          refreshBlocs(context, loginRefresh: true);
          Navigator.pop(context);
        } else
          throw DioError(
              type: DioErrorType.RESPONSE,
              response: Response(data: {"error": "", "code": 102}));
      } on DioError catch (error) {
        var data = error.response.data;
        print(data);
        if (data is Map) {
          var msg = data['error'];
          var code = data['code'] ?? "";
          if (msg.toString().contains("Unauthorised"))
            errorMessage = "Invalid Credentials.";
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
}
