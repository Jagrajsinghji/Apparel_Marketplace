
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Dashboard/Profile/HelpCenter.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Bloc/AuthBloc.dart';
import 'Bloc/CartBloc.dart';
import 'Bloc/CategoryBloc.dart';
import 'Bloc/ScreenBloc.dart';
import 'UI/Dashboard/Cart/ShoppingBag.dart';
import 'UI/Dashboard/Dashboard.dart';
import 'UI/Dashboard/Profile/Orders.dart';
import "UI/SplashScreen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductsBloc>.value(value: ProductsBloc()),
      ChangeNotifierProvider<CategoryBloc>.value(value: CategoryBloc()),
      ChangeNotifierProvider<CartBloc>.value(value: CartBloc()),
      ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
      ChangeNotifierProvider<ScreenBloc>.value(value: ScreenBloc()),
    ],
    child: MaterialApp(
      navigatorKey: Session.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {
        "Splash":(c)=>SplashScreen(),
        Session.BASE_URL: (c) => Dashboard(),
        "ShoppingBag": (c) => ShoppingBag(),
        "Orders": (c) => Orders(),
        "HelpCenter": (c) => HelpCenter(),
      },
      initialRoute: "Splash",
      onUnknownRoute: (r) {
        return MaterialPageRoute(builder: (c) => Dashboard());
      },
    ),
  ));
}
