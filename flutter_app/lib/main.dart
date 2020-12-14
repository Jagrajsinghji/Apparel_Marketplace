import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/UI/Dashboard/Profile/HelpCenter.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:provider/provider.dart';

import 'UI/Dashboard/Cart/CheckOut.dart';
import 'UI/Dashboard/Cart/ShoppingBag.dart';
import 'UI/Dashboard/Cart/WishList.dart';
import 'UI/Dashboard/Dashboard.dart';
import 'UI/Dashboard/Home/Notifications.dart';
import 'UI/Dashboard/Profile/Orders.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider.value(value: AppErrorBloc()),
    ],
    child: MaterialApp(
      navigatorKey: Constants.navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        Constants.BASE_URL: (c) => Dashboard(),
        "WishList": (c) => WishList(),
        "Notifications": (c) => Notifications(),
        "ShoppingBag": (c) => CheckOut(),
        "Orders": (c) => Orders(),
        "HelpCenter": (c) => HelpCenter(),
      },
      initialRoute: Constants.BASE_URL,
      onUnknownRoute: (r) {
        return MaterialPageRoute(builder: (c) => Dashboard());
      },
    ),
  ));
}
