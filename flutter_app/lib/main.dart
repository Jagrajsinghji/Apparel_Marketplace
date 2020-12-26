import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Dashboard/Profile/HelpCenter.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';
import 'package:flutter_app/UI/SignInUp/SignUp.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

import 'Bloc/AuthBloc.dart';
import 'Bloc/CartBloc.dart';
import 'Bloc/CategoryBloc.dart';
import 'UI/Dashboard/Cart/CheckOut.dart';
import 'UI/Dashboard/Cart/ShoppingBag.dart';
import 'UI/Dashboard/Cart/WishList.dart';
import 'UI/Dashboard/Dashboard.dart';
import 'UI/Dashboard/Home/Notifications.dart';
import 'UI/Dashboard/Profile/Orders.dart';
import 'UI/Dashboard/Search/SearchProds.dart';

void main() {
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductsBloc>.value(value: ProductsBloc()),
      ChangeNotifierProvider<CategoryBloc>.value(value: CategoryBloc()),
      ChangeNotifierProvider<CartBloc>.value(value: CartBloc()),
      ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
    ],
    child: MaterialApp(
      navigatorKey: Session.navigatorKey,
      debugShowCheckedModeBanner: false,
      routes: {
        Session.BASE_URL: (c) => Dashboard(),
        "WishList": (c) => WishList(),
        "Notifications": (c) => Notifications(),
        "ShoppingBag": (c) => ShoppingBag(),
        "Orders": (c) => Orders(),
        "HelpCenter": (c) => HelpCenter(),
        "Search": (c) => SearchProds(),
        "SignIn": (c) => SignIn(),
        "SignUp": (c) => SignUp(),
        "CheckOut": (c) => CheckOut(),
      },
      initialRoute: Session.BASE_URL,
      onUnknownRoute: (r) {
        return MaterialPageRoute(builder: (c) => Dashboard());
      },
    ),
  ));
}
