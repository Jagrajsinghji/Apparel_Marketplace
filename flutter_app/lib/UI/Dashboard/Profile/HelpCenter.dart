import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';

class HelpCenter extends StatefulWidget {
  @override
  _HelpCenterState createState() => _HelpCenterState();
}

class _HelpCenterState extends State<HelpCenter> {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
                  Text(
            "Help Center",
            style: TextStyle(
              color: Color(0xff5b5b5b),
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Please get in touch and we will\nbe happy to help you",
            style: TextStyle(
              color: Color(0xff5b5b5b),
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell( borderRadius: BorderRadius.circular(600),
              onTap: (){
                Navigator.pushNamedAndRemoveUntil(context, Constants.BASE_URL, (route) => false);
              },
              child: Container(
                width: 186,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(600),
                  border: Border.all(
                    color: Color(0xffdc0f21),
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    "Shop Now",
                    style: TextStyle(
                      color: Color(0xffdc0f21),
                      fontSize: 14,
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
