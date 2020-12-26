import 'package:flutter/material.dart';

class Notifications extends StatefulWidget {
  @override
  _NotificationsState createState() => _NotificationsState();
}

class _NotificationsState extends State<Notifications> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("assets/cross.png"),
            height: 40,
            width: 40,
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: Text(
              "No New Notification",
              style: TextStyle(
                color: Color(0xff5b5b5b),
                fontSize: 20,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
