import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Bloc/ScreenBloc.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/GlobalWidget.dart';
import 'package:flutter_app/UI/Dashboard/DashDrawer.dart';
import 'package:flutter_app/UI/Dashboard/Explore/Explore.dart';
import 'package:flutter_app/UI/Dashboard/Fashion/Fashion.dart';
import 'package:flutter_app/UI/Dashboard/Home/Notifications.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Profile.dart';
import 'package:flutter_app/UI/Dashboard/Search/SearchProds.dart';
import 'package:provider/provider.dart';

import 'Cart/WishList.dart';
import 'Deals/DealsPage.dart';
import 'Home/Home.dart';

class Dashboard extends StatefulWidget {
  @override
  _DashboardState createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffdc0f21),
    ));
  }

  @override
  Widget build(BuildContext context) {
    ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
    int page = screenBloc.page;
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        key: _scaffoldKey,
        appBar: page == 4
            ? null
            : AppBar(
                elevation: 0,
                leading: IconButton(
                  icon: Icon(Icons.menu),
                  onPressed: () async {
                    _scaffoldKey.currentState.openDrawer();
                  },
                ),
                backgroundColor: Colors.white,
                title: page == 0
                    ? Transform.translate(
                        offset: Offset(-25, 0),
                        child: Image.asset(
                          "assets/logo.png",
                          width: 160,
                        ),
                      )
                    : Text(
                        page == 1
                            ? "Fashion"
                            : page == 2
                                ? "Deals & Offers"
                                : "Explore",
                        style: TextStyle(
                          color: Color(0xff2c393f),
                          fontSize: 18,
                        ),
                      ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Hero(tag: "SearchTag",
                        child: Image.asset(
                          "assets/search.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(seconds: 1),
                                reverseTransitionDuration:
                                    Duration(milliseconds: 800),
                                pageBuilder: (c, a, b) => SearchProds()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Hero(
                        tag: "Notifications",
                        child: Image.asset(
                          "assets/notification.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(seconds: 1),
                                reverseTransitionDuration:
                                    Duration(milliseconds: 800),
                                pageBuilder: (c, a, b) => Notifications()));
                      },
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: InkWell(
                      focusColor: Colors.transparent,
                      splashColor: Colors.transparent,
                      child: Hero(
                        tag: "WishList",
                        child: Image.asset(
                          "assets/favourite.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      onTap: () {
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                transitionDuration: Duration(seconds: 1),
                                reverseTransitionDuration:
                                    Duration(milliseconds: 800),
                                pageBuilder: (c, a, b) => WishList()));
                      },
                    ),
                  ),
                  CartIcon()
                ],
                iconTheme: IconThemeData(color: Colors.black),
              ),
        drawer: page == 0 ? DashDrawer() : null,
        body: page == 0
            ? Home()
            : page == 1
                ? Fashion()
                : page == 2
                    ? DealsPage()
                    : page == 3
                        ? Explore()
                        : Profile(),
        bottomNavigationBar: bottomNavigation(context, voidCallback: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            floatingActionButton(context, voidCallback: () {}));
  }
}
