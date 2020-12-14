import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Dashboard/DashDrawer.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Profile.dart';

import 'Home/Home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  int page=0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(key: _scaffoldKey,
      appBar: AppBar(elevation: 0,
        leading: IconButton(icon: Icon(Icons.menu),onPressed: (){
          _scaffoldKey.currentState.openDrawer();
        },),
        backgroundColor: Colors.white,
        title: Transform.translate(offset: Offset(-25,0),
          child: Image.asset(
            "assets/logo.png",
            width: 160,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
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
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/notification.png",
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.pushNamed(context,  "Notifications");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/favourite.png",
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.pushNamed(context,  "WishList");
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/cart.png",
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.pushNamed(context,  "ShoppingBag");
              },
            ),
          ),
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      drawer: DashDrawer(),
      body: page==0?Home():Profile(),
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
          InkWell(onTap: (){
setState(() {
  page=0;
});
          },
            child: Container(
              width: 60,
              child: Column(
                children: [
                  Image.asset("assets/wowIcon.png", height: 30, width: 30),
                  Text("Home")
                ],
              ),
            ),
          ),
          InkWell(onTap: (){
            setState(() {
              page=1;
            });
          },
            child: Container(
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
          ),
          InkWell(onTap: (){
            setState(() {
              page=2;
            });
          },
            child: Container(
              width: 60,
              child: Column(
                children: [
                  Image.asset("assets/chairIcon.png", height: 30, width: 30),
                  Text("Decor")
                ],
              ),
            ),
          ),
          InkWell(onTap: (){
            setState(() {
              page=3;
            });
          },
            child: Container(
              width: 60,
              child: Column(
                children: [
                  Image.asset("assets/explore.png", height: 30, width: 30),
                  Text("Explore")
                ],
              ),
            ),
          ),
          InkWell(onTap: (){
            setState(() {
              page=4;
            });
          },
            child: Container(
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
          ),
        ],
      ),
    );
  }
}
