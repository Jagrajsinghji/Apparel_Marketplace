import 'package:flutter/material.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        width: 414,
        color: Colors.white,
        padding: const EdgeInsets.only(
          bottom: 15,
        ),
        child: ListView(children: [
          Container(
              width: double.infinity,
              height: 120,
              color: Color(0xff303847),
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Container(
                          width: 60,
                          height: 60,
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15)),
                          child: Transform.scale(
                            scale: .5,
                            child: Image.asset(
                              "assets/user.png",
                              height: 30,
                              width: 30,
                            ),
                          )),
                    ),
                    Text(
                      "Hello, Rahul",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ],
                ),
              )),
          SizedBox(height: 40.23),
          ListTile(
            title: Text(
              "Orders",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Check your order status",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Orders",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Check your order status",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Help Center",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Help regarding your recent purchases",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Wishlist",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Your most loved style",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Saved Cards",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Save your card for faster checkout",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
          ListTile(
            title: Text(
              "Coupons",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
            subtitle: Text(
              "Manage Coupons for additional discounts",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 10,
                fontFamily: "Poppins",
                fontWeight: FontWeight.w400,
              ),
            ),
          ),

        ]),
      ),
    );
  }
}
