import 'package:flutter/material.dart';

class ForgotPassword1 extends StatefulWidget {
  @override
  _ForgotPassword1State createState() => _ForgotPassword1State();
}

class _ForgotPassword1State extends State<ForgotPassword1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
      appBar: AppBar(elevation: 0,backgroundColor: Colors.white,
      title: Text(
        "Forgot Password",
        style: TextStyle(
          color: Color(0xff2c393f),
          fontSize: 14,
          fontFamily: "Poppins",
          fontWeight: FontWeight.w400,
        ),
      ),centerTitle: true,
      leading: Transform.scale(
          scale: .4, child: Image.asset("assets/backArrow.png")),),
      body: Column(crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(height: 60,child: Transform.scale(scale: .8,child: Image.asset("assets/lock.png"))),
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: Center(
              child: Text(
                "We will send OTP to verify your identity",
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
            padding: const EdgeInsets.symmetric(horizontal: 27,vertical: 10),
            child: Container(decoration: BoxDecoration(color: Color(0xfff6f6f6),borderRadius:BorderRadius.circular(100), ),
              height: 58,
              child: TextFormField(
                decoration: InputDecoration(
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(100),
                      borderSide: BorderSide(color: Colors.transparent)
                  ),
                  errorBorder:
                  OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
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
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27,vertical: 10),
            child: InkWell(onTap: (){

            },
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
