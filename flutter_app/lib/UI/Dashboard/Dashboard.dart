import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Bloc/ScreenBloc.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/GlobalWidget.dart';
import 'package:flutter_app/UI/Components/SearchIcon.dart';
import 'package:flutter_app/UI/Components/WishListIcon.dart';
import 'package:flutter_app/UI/Dashboard/Home/Notifications.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Profile.dart';
import 'package:provider/provider.dart';

import 'file:///D:/WeExpan/WOW-APP/flutter_app/lib/UI/Dashboard/Drawer/DashDrawer.dart';

import 'Cart/ShoppingBag.dart';
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
      statusBarColor: Color(0xff005294),
    ));
    alertForLogin();
  }

  @override
  Widget build(BuildContext context) {
    ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
    int page = screenBloc.page;
    return Scaffold(
        backgroundColor: Colors.white,
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
                  SearchIcon(),
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
                        Navigator.push(
                            context,
                            PageRouteBuilder(
                                opaque: false,
                                barrierColor: Colors.black.withOpacity(.8),
                                transitionDuration: Duration(
                                  milliseconds: 500,
                                ),
                                reverseTransitionDuration:
                                    Duration(milliseconds: 500),
                                transitionsBuilder: (c, a, b, w) {
                                  return SlideTransition(
                                    position: Tween(
                                            end: Offset.zero,
                                            begin: Offset(0, -1))
                                        .animate(CurvedAnimation(
                                            parent: a,
                                            curve: Curves.decelerate)),
                                    child: w,
                                  );
                                },
                                pageBuilder: (c, a, b) => Notifications()));
                      },
                    ),
                  ),
                  WishListIcon(),
                  CartIcon(
                    globalKey: _scaffoldKey,
                  )
                ],
                iconTheme: IconThemeData(color: Colors.black),
              ),
        drawer: page != 4 ? DashDrawer() : null,
        endDrawer: ShoppingBag(),
        body: page == 0
            ? Home()
            // : page == 1
            //     ? Fashion()
            : page == 2
                ? DealsPage()
                // : page == 3
                //     ? Explore()
                : Profile(),
        bottomNavigationBar: bottomNavigation(context, voidCallback: () {}),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton:
            floatingActionButton(context, voidCallback: () {}));
  }

  void alertForLogin() {
    // AuthBloc authBloc = Provider.of<AuthBloc>(context,listen: false);
    // if (authBloc.userData.length == 0)
    //   Timer(Duration(seconds: 5), () {
    //     if (mounted) {
    //       Navigator.push(context, MaterialPageRoute(builder: (c) => SignIn()));
    //     }
    //   });
  }
}
