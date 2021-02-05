import 'dart:async';

import 'package:dio/dio.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';
import 'package:flutter_app/UI/SignInUp/SignUp.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:sms_autofill/sms_autofill.dart';

class MobileLogin extends StatefulWidget {
  const MobileLogin({
    Key key,
  }) : super(key: key);

  @override
  _MobileLoginState createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLogin> {
  GlobalKey<FormFieldState> _mobileKey = GlobalKey();

  String mobileNo;
  bool otpSent = false;
  String otp;

  String _fieldOTP;
  SmsAutoFill _smsAutoFill = SmsAutoFill();
  StreamController<String> _statusController = StreamController();

  void getOtp() async {
    if(!_statusController.isClosed)
    _statusController.add("Sending OTP");
    _smsAutoFill.unregisterListener();
    Response response = await Provider.of<AuthBloc>(context, listen: false)
        .sendOTP(mobileNo, await _smsAutoFill.getAppSignature);
    if (kDebugMode) print(response.data);
    if (response.data is Map &&
        response.data['message'].toString().contains("An Error Occurred")) {
      if(!_statusController.isClosed)
      _statusController.add("Error!\nTry Again.");

      Fluttertoast.showToast(msg: "An Error Occurred!");
    } else if (response.data is Map) {
      Map data = response.data ?? {};
      otp = data['otp'].toString();
      if(!_statusController.isClosed)
      _statusController.add("OTP Sent!");
    }
    await _smsAutoFill.listenForCode;
    Timer(
        Duration(
          seconds: 1,
        ), () {
      if(!_statusController.isClosed)
      _statusController.add("Fetching OTP!");
    });
  }

  double startV = 0, updateV = 0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(onTap: (){
      Navigator.pop(context);
    },
      child: Dismissible(
        direction: DismissDirection.down,
        onDismissed: (c) {
          Navigator.pop(context);
        },
        key: UniqueKey(),
        child: Scaffold(
          backgroundColor: Colors.transparent,
          body: Align(
            alignment: Alignment.bottomCenter,
            child: AnimatedContainer(
                duration: Duration(milliseconds: 900),
                curve: Curves.fastLinearToSlowEaseIn,
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20)),
                child: otpSent ? otpField() : mobileField()),
          ),
        ),
      ),
    );
  }

  Widget otpField() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              "ENTER OTP",
              style: TextStyle(
                color: Color(0xffdc0f21),
                fontSize: 26,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),
        Center(
          child: Container(
            width: 60,
            height: 4,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(600),
              color: Color(0xffdc0f21),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "We have sent a one time verification code\non ${mobileNo ?? "Your Number"}",
                style: TextStyle(
                  color: Color(0xff9d9d9d),
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
        ),
        Expanded(
            flex: 0,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 5),
              child: PinFieldAutoFill(
                onCodeChanged: (c) {
                  _fieldOTP = c;
                  if (c.length == 6)if(!_statusController.isClosed) _statusController.add("Click To Login");
                },
              ),
            )),
        Expanded(
          flex: 0,
          child: Center(
            child: Container(
                height: 150,
                width: 150,
                child: Stack(
                  children: [
                    Container(
                      height: 150,
                      width: 150,
                      child: CircularProgressIndicator(
                        valueColor:
                            AlwaysStoppedAnimation<Color>(Color(0xff5B5B5B)),
                        strokeWidth: 7,
                      ),
                    ),
                    Center(
                      child: StreamBuilder<String>(
                          stream: _statusController.stream,
                          builder: (context, snapshot) {
                            return Text("${snapshot.data ?? ""}");
                          }),
                    )
                  ],
                )),
          ),
        ),
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.only(top: 30.0),
            child: InkWell(
              onTap: getOtp,
              child: Center(
                child: Text(
                  "Did’nt get the OTP?",
                  style: TextStyle(
                    color: Color(0xff5b5b5b),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
        Expanded(
          flex: 0,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
            child: InkWell(
              onTap: () async {
                if (_fieldOTP == null)
                  Fluttertoast.showToast(msg: "Please Enter OTP.");
                else if (_fieldOTP.length != 6)
                  Fluttertoast.showToast(msg: "Invalid OTP.");
                else if (otp != null && _fieldOTP == otp) {
                  if(!_statusController.isClosed)
                  _statusController.add("Logging In...");
                  await Provider.of<AuthBloc>(context, listen: false)
                      .loginWithNumber(mobileNo, _fieldOTP);
                  refreshBlocs(context, logInOutRefresh: true);
                  Navigator.pop(context);
                } else
                  Fluttertoast.showToast(msg: "An Error occurred!");
              },
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 50,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: Color(0xffdc0f21),
                ),
                child: Center(
                  child: Text(
                    "Login",
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
        ),
      ],
    );
  }

  Widget mobileField() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Center(
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.grey.shade400,
                  borderRadius: BorderRadius.circular(20)),
              height: 4,
              width: 30,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30.0, top: 20),
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
          padding: const EdgeInsets.only(left: 12.0, top: 10, bottom: 5),
          child: Text(
            "Enter your mobile number",
            style: TextStyle(
              color: Color(0xff2c393f),
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(
            left: 10.0,
            right: 10.0,
          ),
          child: TextFormField(
            keyboardType: TextInputType.number,
            key: _mobileKey,
            validator: (c) {
              if (c.trim().length < 10||c.trim().length>10) return "Invalid Mobile Number";
              return null;
            },
            onChanged: (c) => mobileNo = c,
            decoration: InputDecoration(
              isDense: true,
              contentPadding: EdgeInsets.all(16),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Color(0xffA8A8A8))),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(40),
                  borderSide: BorderSide(color: Color(0xffA8A8A8))),
              errorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(40),
              ),
              focusedErrorBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.red),
                borderRadius: BorderRadius.circular(40),
              ),
              hintText: "Mobile No.*",
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
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 20),
          child: InkWell(
            onTap: () async {
              if (_mobileKey.currentState.validate()) {
                if (mounted)
                  setState(() {
                    otpSent = true;
                  });
                getOtp();
              }
            },
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(100),
                color: Color(0xffdc0f21),
              ),
              child: Center(
                child: Text(
                  "Send OTP",
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
        Center(
          child: Padding(
            padding: const EdgeInsets.only( bottom: 5),
            child: Text(
              "Or",textAlign: TextAlign.center,
              style: TextStyle(
                color: Colors.black,
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ),Center(
          child: Padding(
            padding: const EdgeInsets.only( bottom: 20),
            child: InkWell(onTap: ()async{
            var res  =  await Navigator.push(context,
                  PageRouteBuilder(opaque: false,barrierColor: Colors.black54,reverseTransitionDuration: Duration(milliseconds: 100),transitionDuration: Duration(milliseconds: 500),transitionsBuilder: (c,a,b,w){
                    return SlideTransition(position: Tween(begin: Offset(0,1),end: Offset.zero).animate(CurvedAnimation(curve: Curves.fastLinearToSlowEaseIn,parent: a)),child: w,);
                  },pageBuilder:  (c,a,b) => SignIn()));
            if (res != null && res == "LoggedIn") {
              Navigator.pop(context);
            }
            },
              child: Container(height: 20,
                child: Text(
                  "Use Email to Sign In or Sign Up",textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Color(0xffDC0f21),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  @override
  void dispose() {
    _smsAutoFill.unregisterListener();
    _statusController.close();
    super.dispose();
  }
}
