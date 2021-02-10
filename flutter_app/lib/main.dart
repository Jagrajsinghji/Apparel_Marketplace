import 'dart:async';
import 'dart:isolate';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_crashlytics/firebase_crashlytics.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/Bloc/RecentProdsBloc.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/UI/Dashboard/Profile/HelpCenter.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:package_info/package_info.dart';
import 'package:provider/provider.dart';

import 'Bloc/AuthBloc.dart';
import 'Bloc/CartBloc.dart';
import 'Bloc/CategoryBloc.dart';
import 'Bloc/CountryStateBloc.dart';
import 'Bloc/ItemBloc.dart';
import 'Bloc/ScreenBloc.dart';
import 'UI/Dashboard/Brands/BrandProductsPage.dart';
import 'UI/Dashboard/Cart/ShoppingBag.dart';
import 'UI/Dashboard/Dashboard.dart';
import 'UI/Dashboard/Profile/Orders/Orders.dart';
import 'UI/SignInUp/MobileLogin.dart';
import "UI/SplashScreen.dart";
import 'UI/Dashboard/Profile/ReturnItems/ReturnItems.dart';
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
  versionName = packageInfo.version;
  await FirebaseCrashlytics.instance
      .setCrashlyticsCollectionEnabled(kReleaseMode);
  FlutterError.onError = FirebaseCrashlytics.instance.recordFlutterError;
  Isolate.current.addErrorListener(RawReceivePort((pair) async {
    final List<dynamic> errorAndStacktrace = pair;
    await FirebaseCrashlytics.instance.recordError(
      errorAndStacktrace.first,
      errorAndStacktrace.last,
    );
  }).sendPort);


  runZonedGuarded<Future<void>>(() async {
    runApp(MultiProvider(
      providers: [
        Provider<RecentProdsBloc>.value(value: RecentProdsBloc.instance()),
        ChangeNotifierProvider<ProductsBloc>.value(value: ProductsBloc()),
        ChangeNotifierProvider<CategoryBloc>.value(value: CategoryBloc()),
        ChangeNotifierProvider<CartBloc>.value(value: CartBloc()),
        ChangeNotifierProvider<ItemBloc>.value(value: ItemBloc()),
        ChangeNotifierProvider<AuthBloc>.value(value: AuthBloc()),
        ChangeNotifierProvider<ScreenBloc>.value(value: ScreenBloc()),
        ChangeNotifierProvider<OrdersBloc>.value(value: OrdersBloc()),
        ChangeNotifierProvider<CountryStateBloc>.value(
            value: CountryStateBloc()),
      ],
      child: MaterialApp(
        navigatorKey: Session.navigatorKey,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(textTheme: GoogleFonts.crimsonProTextTheme(),),
        routes: {
          "Splash": (c) => SplashScreen(),
          Session.BASE_URL: (c) => Dashboard(),
          "ShoppingBag": (c) => ShoppingBag(),
          "Orders": (c) => Orders(),
          "Returns": (c)=>ReturnItems(),
          "HelpCenter": (c) => HelpCenter(),
          "dev": (x) => MobileLogin(),
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
          } else if (route.startsWith("brand")) {
            route = route.replaceAll("brand/", "");
            return MaterialPageRoute(
                builder: (c) => BrandProductsPage(
                      brandName: route,
                    ));
          }
          return MaterialPageRoute(builder: (c) => Dashboard());
        },
      ),
    ));
  }, FirebaseCrashlytics.instance.recordError);

}
