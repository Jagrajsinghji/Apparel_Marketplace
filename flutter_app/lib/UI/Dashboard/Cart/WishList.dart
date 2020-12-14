import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(appBar: AppBar(
      elevation: 0,
      leading: FlatButton(
        child: Image.asset("assets/backArrow.png"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),backgroundColor: Colors.white,
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: Text(
              "Your Wishlist is empty",
              style: TextStyle(
                color: Color(0xff5b5b5b),
                fontSize: 20,
              ),
            ),
          ),
          SizedBox(height: 20),
          Center(
            child: Text(
              "Save items that you like in your wihlist.\nReview them anytime and easily move\nthem to bag",
              style: TextStyle(
                color: Color(0xff5b5b5b),
                fontSize: 14,
              ),
            ),
          ),
          SizedBox(height: 20),
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
