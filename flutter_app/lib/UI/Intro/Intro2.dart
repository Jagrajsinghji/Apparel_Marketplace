import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/UI/Intro/Intro3.dart';

class Intro2 extends StatefulWidget {
  @override
  _Intro2State createState() => _Intro2State();
}

class _Intro2State extends State<Intro2> {

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor:Color(0xff005294), ));
  }
  @override
  void dispose() {
    print("dfjsdfd");
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor:Color(0xfffaae00), ));
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var width = MediaQuery.of(context).size.width;
    var height = MediaQuery.of(context).size.height;

    return SafeArea(
      child: Scaffold(backgroundColor:   Color(0xffe0dace),
        body: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(flex: 0,
              child: Text(
                "Shop Your\nFavourite Brands",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff2c393f),
                  fontSize: 27,
                  fontFamily: "Poppins",
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            Image.asset("assets/intro2.png", height: height / 2,
              width: double.infinity,
              fit: BoxFit.fill,),

            Expanded(flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 27),
                child: Align(alignment: Alignment.centerLeft,
                  child: Container(
                    width: 85,
                    height: 2,
                    color: Color(0xff2c393f),
                  ),
                ),
              ),
            ),

            Expanded(flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 27),
                child: Text(
                  "Browse and search your new style from all\nthe brands list",
                  style: TextStyle(
                    color: Color(0xff2c393f),
                    fontSize: 14,
                    fontFamily: "Poppins",
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ),
            ),
            Expanded(flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 27.0),
                child: Align(alignment: Alignment.centerLeft,
                  child: Container(
                    width: 169,
                    height: 44.74,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(600),
                      color: Color(0xffdc0f21),
                    ),
                    child: InkWell( borderRadius: BorderRadius.circular(600),onTap: (){
                      Navigator.push(
                          context, PageRouteBuilder(pageBuilder:  (c,a,b) => Intro3(),transitionsBuilder: (c,a,b,w){
                        return SlideTransition(position: Tween(begin: Offset(2.0, 0),end:Offset.zero).animate(a),child: w,);
                      }));
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
            ),
            Expanded(flex: 0,
              child: Padding(
                padding: const EdgeInsets.only(left: 27.0),
                child: Row(
                  children: [

                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Color(0xff2c393f),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left:5.0),
                      child: Stack(alignment: Alignment.center,
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
            ),
            Container(
              width: 414,
              height: 7,
              color: Color(0xff005294),
            ),

          ],
        ),
      ),
    );
  }
}
