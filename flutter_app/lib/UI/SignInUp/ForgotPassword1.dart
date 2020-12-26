import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:provider/provider.dart';

class ForgotPassword1 extends StatefulWidget {
  @override
  _ForgotPassword1State createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPassword1> {
  GlobalKey<FormFieldState> _emailKey = GlobalKey();
  String email, errorMessage;
  bool showError = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "Forgot Password",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 14,
            fontFamily: "Poppins",
            fontWeight: FontWeight.w400,
          ),
        ),
        centerTitle: true,
        leading: Transform.scale(
            scale: .4, child: Image.asset("assets/backArrow.png")),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
              height: 60,
              child: Transform.scale(
                  scale: .8, child: Image.asset("assets/lock.png"))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "Please Enter your email id.\nWe will send a new password to reset your account.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff9d9d9d),
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(100),
              ),
              child: TextFormField(
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
                key: _emailKey,
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
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
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
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ],
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
            child: InkWell(
              onTap: reset,
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xffdc0f21),
                ),
                child: Center(
                  child: Text(
                    "Send",
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void reset() async {
    if (_emailKey.currentState.validate()) {
      if (mounted)
        setState(() {
          showError = false;
        });
      Response resp = await Provider.of<AuthBloc>(context, listen: false)
          .resetPassword(email);
      var respData = resp.data;
      if (respData is Map) {
        if (respData.containsKey("errors")) {
          if (respData['errors']
              .toString()
              .toLowerCase()
              .contains("no account"))
            errorMessage = "No account exist for particular email address.";
          else
            errorMessage = "Something went wrong. Please try after some time.";
        } else if (respData.containsKey("message")) {
          if (respData['message']
              .toString()
              .toLowerCase()
              .contains("reseted successfully"))
            showDialog(
                context: context,
                builder: (c) => AlertDialog(
                      actions: [
                        FlatButton(
                            onPressed: () {
                              Navigator.pop(c);
                              Navigator.pop(context);
                            },
                            child: Text(
                              "Got It",
                              style: TextStyle(
                                fontFamily: "Poppins",
                              ),
                            ))
                      ],
                      title: Text(
                        "Password Reset Successfully",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      content: Text(
                        "An email has been sent to your email address with new password.\nPlease login to your account with that password.",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontFamily: "Poppins",
                        ),
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                    ));

          return;
        } else
          errorMessage = "Something went wrong. Please try after some time.";
      } else
        errorMessage = "Something went wrong. Please try after some time.";
      if (mounted)
        setState(() {
          showError = true;
        });
    }
  }
}
