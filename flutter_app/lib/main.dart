import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/UI/Dashboard/Profile/HelpCenter.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'Bloc/AuthBloc.dart';
import 'Bloc/CartBloc.dart';
import 'Bloc/CategoryBloc.dart';
import 'Bloc/ItemBloc.dart';
import 'Bloc/ScreenBloc.dart';
import 'UI/Dashboard/Brands/BrandProductsPage.dart';
import 'UI/Dashboard/Cart/ShoppingBag.dart';
import 'UI/Dashboard/Dashboard.dart';
import 'UI/Dashboard/Profile/Orders/Orders.dart';
import "UI/SplashScreen.dart";

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // await Firebase.initializeApp();
  runApp(MultiProvider(
    providers: [
      ChangeNotifierProvider<ProductsBloc>.value(value: ProductsBloc()),
      ChangeNotifierProvider<CategoryBloc>.value(value: CategoryBloc()),
      ChangeNotifierProvider<CartBloc>.value(value: CartBloc()),
      ChangeNotifierProvider<ItemBloc>.value(value: ItemBloc()),
      ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
      ChangeNotifierProvider<ScreenBloc>.value(value: ScreenBloc()),
      ChangeNotifierProvider<OrdersBloc>.value(value: OrdersBloc()),
    ],
    child: MaterialApp(
      navigatorKey: Session.navigatorKey,
      debugShowCheckedModeBanner: false,
      theme: ThemeData(textTheme: GoogleFonts.poppinsTextTheme()),
      routes: {
        "Splash": (c) => SplashScreen(),
        Session.BASE_URL: (c) => Dashboard(),
        "ShoppingBag": (c) => ShoppingBag(),
        "Orders": (c) => Orders(),
        "HelpCenter": (c) => HelpCenter(),
      },
      initialRoute: "Splash",
      onUnknownRoute: (r) {
        String route = r.name.replaceAll("https://wowfas.com/", "");
        if (route.startsWith("category")) {
          route = route.replaceAll("category/", "");
          List parts = route.split("/");
          String cat, subCat, childCat;
          if (parts.length > 0) cat = parts[0];
          if (parts.length > 1) subCat = parts[1];
          if (parts.length > 2) childCat = parts[2];
          return MaterialPageRoute(
              builder: (c) => CategoriesPage(
                    childCatName: childCat,
                    subCatName: subCat,
                    categoryName: cat,
                  ));
        }
        else if(route.startsWith("brand")){
          route = route.replaceAll("brand/", "");
          return MaterialPageRoute(builder: (c)=>BrandProductsPage(brandName: route,));
        }
        return MaterialPageRoute(builder: (c) => Dashboard());
      },
    ),
  ));
}
