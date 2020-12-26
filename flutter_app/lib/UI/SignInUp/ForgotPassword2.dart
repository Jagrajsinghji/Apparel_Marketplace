import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class ForgotPassword2 extends StatefulWidget {
  @override
  _ForgotPassword2State createState() => _ForgotPassword2State();
}

class _ForgotPassword2State extends State<ForgotPassword2> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        title: Text(
          "OTP Verification",
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
      body: ListView(
        children: [
          Center(
            child: Text(
              "ENTER OTP",
              style: TextStyle(
                color: Color(0xffdc0f21),
                fontSize: 26,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 5.54),
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
          SizedBox(height: 5.54),
          Center(
            child: Text(
              "We have sent a one time verification code\nto your registered email",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 150),
          Container(
            height: 150,
            color: Color(0xffDC0F21),
            child: PinCodeTextField(
              appContext: context,
              cursorColor: Colors.black,
              pinTheme: PinTheme(
                  shape: PinCodeFieldShape.box,
                  activeColor: Colors.black,
                  inactiveColor: Colors.black,
                  selectedColor: Color(0xffDC0F21)),
              onChanged: (s) {},
              length: 4,
            ),
          ),
          Center(
              child: Container(
                  height: 185,
                  width: 185,
                  child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xff5B5B5B)),
                    strokeWidth: 7,
                  ))),
          SizedBox(height: 10),
          Center(
            child: Text(
              "Did’nt get the OTP?",
              style: TextStyle(
                color: Color(0xff5b5b5b),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27, vertical: 10),
            child: InkWell(
              onTap: () {},
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
}
