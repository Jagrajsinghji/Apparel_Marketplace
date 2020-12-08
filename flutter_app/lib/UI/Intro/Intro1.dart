import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'Intro2.dart';

class Intro1 extends StatefulWidget {
  @override
  _Intro1State createState() => _Intro1State();
}

class _Intro1State extends State<Intro1> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:   Color(0xffe0dace),
      body: Column(
        children: [
          Expanded(flex: 1,
            child: ListView(shrinkWrap: true,
              children: [
                Image.asset("assets/intro1.png"),
                Padding(
                  padding: const EdgeInsets.only(top:27.0,left: 27),
                  child: Text(
                    "Exceptional\nModern Clothing",
                    style: TextStyle(
                      color: Color(0xff2c393f),
                      fontSize: 27,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:27.0,left: 27.0),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Container(
                      width: 85,
                      height: 2,
                      color: Color(0xff2c393f),
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:27.0,left: 27.0),
                  child: Text(
                    "Shop for everyday modern clothing for your\neveryday life",
                    style: TextStyle(
                      color: Color(0xff2c393f),
                      fontSize: 14,
                      fontFamily: "Poppins",
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ),

                Padding(
                  padding: const EdgeInsets.only(top:27.0,left: 27.0),
                  child: Align(alignment: Alignment.centerLeft,
                    child: Container(
                      width: 169,
                      height: 44.74,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(600),
                        color: Color(0xffdc0f21),
                      ),
                      child: InkWell( borderRadius: BorderRadius.circular(600),onTap: (){
                        Navigator.push(context, MaterialPageRoute(builder: (c)=>Intro2()));
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
                Padding(
                  padding: const EdgeInsets.only(top:27.0,left: 27.0),
                  child: Row(
                    children: [
                      Stack(alignment: Alignment.center,
                        children: [
                          Container(
                            width: 10,
                            height: 10,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: Colors.black,
                                width: 0.50,
                              ),
                              color: Color(0xffe0dace),
                            ),
                          ),

                          Container(
                            width: 6,
                            height: 6,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: Color(0xff2c393f),
                            ),
                          ),
                        ],
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff2c393f),
                          ),
                        ),
                      ),

                      Padding(
                        padding: const EdgeInsets.only(left:5.0),
                        child: Container(
                          width: 6,
                          height: 6,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Color(0xff2c393f),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

              ],
            ),
          ),
          Container(
            width: 414,
            height: 7,
            color: Color(0xfffaae00),
          ),
        ],
      ),
    );
  }
}
