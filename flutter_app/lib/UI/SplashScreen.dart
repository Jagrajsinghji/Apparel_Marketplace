import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Intro/Intro1.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with TickerProviderStateMixin{

  AnimationController _animCont;
  Animation<double> _size;
  @override
  void initState() {
    super.initState();
    Timer(Duration(seconds: 3), (){
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (c)=>Intro1()));
    });
    _animCont = AnimationController(duration: Duration(seconds: 2,),vsync: this);
    _size = Tween(begin: .3,end: 1.0).animate(CurvedAnimation(curve: Curves.elasticInOut,parent: _animCont));
    _animCont.addListener(() =>setState((){}));
    _animCont.forward();
  }

  @override
  void dispose() {
    _animCont?.dispose();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(backgroundColor:  Colors.white,
      body: Stack(
        children: [
          Center(child: Transform.scale(scale: _size.value,child: Image.asset("assets/logo.png")),),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Align(alignment: Alignment.bottomCenter,child: Text("Version 0.0.1")),
          )
        ],
      ),
    );
  }
}
