import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Dashboard.dart';
import 'package:flutter_app/UI/SignInUp/SignUp.dart';

class SignIn extends StatefulWidget {
  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {
  bool showPassword =false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor: Colors.white,
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
                fontFamily: "Poppins",
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
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
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
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: Container(
              decoration: BoxDecoration(
                color: Color(0xfff6f6f6),
                borderRadius: BorderRadius.circular(100),
              ),
              height: 58,
              child: TextFormField(
                decoration: InputDecoration(
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.transparent)),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(100),
                        borderSide: BorderSide(color: Colors.transparent)),
                    errorBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    hintText: "Password",
                    hintStyle: TextStyle(
                      color: Color(0xff9d9d9d),
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),suffixIcon: FlatButton(splashColor: Colors.transparent,
                  focusColor: Colors.transparent,
                  onPressed: (){
                    setState(() {
                      showPassword = !showPassword;
                    });
                  },child:showPassword?Transform.translate(offset: Offset(18,0),child: Transform.scale(scale: .3,child: Image.asset("assets/hidePass.png"))):Transform.scale(scale: .5,child: Image.asset("assets/seePass1.png")) ,)
                ),
                obscureText: showPassword,
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 17),
          Align(alignment: Alignment.centerRight,
            child: Padding(
              padding: const EdgeInsets.only(right:27.0),
              child: Text(
                "Forgot Password?",
                style: TextStyle(
                  color: Color(0xff729aff),
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
          ),
          SizedBox(height: 17),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 27),
            child: InkWell(onTap: (){
              Navigator.of(context).push(MaterialPageRoute(builder: (c)=>Dashboard()));
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
                    "Go Shopping",
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
          SizedBox(height: 17),
          Row(crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Don’t have an account? ",
                style: TextStyle(
                  fontSize: 14,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w400,
                ),
              ),
              InkWell(onTap: (){
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=>SignUp()));
              },
                child: Text(
                  "Sign Up",
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: "Poppins",color: Color(0xff1382B6),
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
                fontFamily: "Poppins",
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
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          SizedBox(height: 17),
          Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
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
                      Transform.scale(scale: .5,child: Image.asset("assets/google.png",)),
                      Padding(
                        padding: const EdgeInsets.only(right:25.0),
                        child: Text(
                          "Google",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Poppins",
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ],
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
                        child: Transform.scale(scale: .5,child: Image.asset("assets/facebook.png",)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(right:25.0),
                        child: Text(
                          "Facebook",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 14,
                            fontFamily: "Poppins",
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
}
