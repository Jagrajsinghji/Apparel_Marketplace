import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/DashDrawer.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Profile.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: AppBar(
        leading: IconButton(icon: Icon(Icons.menu),onPressed: (){
          _scaffoldKey.currentState.openDrawer();
        },),
        backgroundColor: Colors.white,
        title: Image.asset(
          "assets/logo.png",
          width: 160,
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/search.png",
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/notification.png",
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/favourite.png",
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(5.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/cart.png",
                width: 20,
                height: 20,
              ),
              onTap: () {},
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: DashDrawer(),
      bottomNavigationBar: bottomNav(),
    );
  }

  bottomNav() {
    return Container(
      height: 60,
      color: Colors.white,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Container(
            width: 60,
            child: Column(
              children: [
                Image.asset("assets/wowIcon.png", height: 30, width: 30),
                Text("Home")
              ],
            ),
          ),
          Container(
            width: 60,
            child: Column(
              children: [
                Image.asset(
                  "assets/shirtIcon.png",
                  height: 30,
                  width: 30,
                ),
                Text("Fashion")
              ],
            ),
          ),
          Container(
            width: 60,
            child: Column(
              children: [
                Image.asset("assets/chairIcon.png", height: 30, width: 30),
                Text("Decor")
              ],
            ),
          ),
          Container(
            width: 60,
            child: Column(
              children: [
                Image.asset("assets/explore.png", height: 30, width: 30),
                Text("Explore")
              ],
            ),
          ),
          Container(
            width: 60,
            child: Column(
              children: [
                Image.asset(
                  "assets/user.png",
                  height: 30,
                  width: 30,
                ),
                Text("Profile")
              ],
            ),
          ),
        ],
      ),
    );
  }
}
