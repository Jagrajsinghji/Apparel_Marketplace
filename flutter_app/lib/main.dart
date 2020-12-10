import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/UI/SplashScreen.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:provider/provider.dart';

import 'UI/Dashboard/Dashboard.dart';
import 'UI/Dashboard/Home/Home.dart';

void main() {
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider.value(value: AppErrorBloc()),
  ], child: MaterialApp(navigatorKey: Constants.navigatorKey,
    debugShowCheckedModeBanner: false,routes: {
    Constants.BASE_URL: (c)=>Dashboard(),


  },initialRoute: Constants.BASE_URL,
    onUnknownRoute: (r){
      return MaterialPageRoute(builder: (c)=>Dashboard());
    },
  ),));
}
