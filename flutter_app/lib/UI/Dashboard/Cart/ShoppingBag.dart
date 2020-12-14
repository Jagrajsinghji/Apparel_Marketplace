import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';

class ShoppingBag extends StatefulWidget {
  @override
  _ShoppingBagState createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
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
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                  height: 35, width: 35, child: Image.asset("assets/wind.png")),
              Container(
                  height: 100,
                  width: 100,
                  child: Image.asset("assets/shopingBag.png")),
            ],
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Hey, it feels so empty",
            style: TextStyle(
              color: Color(0xff5b5b5b),
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "Save items that you like in your wihlist.\nReview them anytime and easily move\nthem to bag",
            style: TextStyle(
              color: Color(0xff5b5b5b),
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(600),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Constants.BASE_URL, (route) => false);
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
