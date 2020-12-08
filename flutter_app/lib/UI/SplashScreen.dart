import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Intro/Intro1.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=>Intro1()));
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:   Color(0xffe0dace),
      body: Center(child: Image.asset("assets/logo.png"),),
    );
  }
}
