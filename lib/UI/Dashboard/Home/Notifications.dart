import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Dashboard/Cart/ShoppingBag.dart';
import 'package:flutter_app/Utils/Extensions.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          key: _scaffoldKey,
          appBar: AppBar(
            elevation: 0,
            title: Text(
              "Notification",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 18,fontFamily: goggleFont
              ),
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
            actions: [
              CartIcon(
                globalKey: _scaffoldKey,
              )
            ],
          ),
          endDrawer: ShoppingBag(),
          backgroundColor: Colors.transparent,
          body: InkWell(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              decoration: BoxDecoration(color: Colors.white),
              child: Center(
                child: Text(
                  "No New Notification",
                  style: TextStyle(
                    color: Color(0xff5b5b5b),
                    fontSize: 20,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
