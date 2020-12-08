import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: FutureBuilder<List<Response>>(
        future: Future.wait([ProductsBloc.getHomePage(),ProductsBloc.getHomePageExtras()]),
        builder: (c, s) {
          var response1 =s?.data?.first;
          var response2= s?.data?.last;
          return Center(child: Text(response2?.data?.toString()??"Loading"));
        },
      ),
    );
  }
}
