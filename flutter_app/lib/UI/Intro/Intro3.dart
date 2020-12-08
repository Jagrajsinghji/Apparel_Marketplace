import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';

class Intro3 extends StatefulWidget {
  @override
  _Intro3State createState() => _Intro3State();
}

class _Intro3State extends State<Intro3> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Image.asset("assets/intro3.png"),
          Positioned(
            bottom: 120,
            child: Container(
              height: 300,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(left: 27.0),
                    child: Text(
                      "Exceptional\nModern\nClothing",
                      style: TextStyle(
                        color: Color(0xff2c393f),
                        fontSize: 40,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 50.0, left: 27.0),
                    child: Align(
                      alignment: Alignment.centerLeft,
                      child: Container(
                        width: 169,
                        height: 44.74,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(600),
                          color: Color(0xffdc0f21),
                        ),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(600),
                          onTap: () {
                            Navigator.push(context,
                                MaterialPageRoute(builder: (c) => SignIn()));
                          },
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
                  ),
                ],
              ),
            ),
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              width: 414,
              height: 7,
              color: Color(0xffdc0f21),
            ),
          ),
        ],
      ),
    );
  }
}
