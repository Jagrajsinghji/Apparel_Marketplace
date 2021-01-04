import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:dio/dio.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:provider/provider.dart';
class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  @override
  Widget build(BuildContext context) {
    OrdersBloc _orderBloc = Provider.of<OrdersBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: _orderBloc.myOrders.length==0?Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            child: Image.asset("assets/hanger.png"),
            height: 120,
            width: 120,
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "No active orders",
            style: TextStyle(
              color: Color(0xff5b5b5b),
              fontSize: 20,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Text(
            "There are no recent orders to show.",
            style: TextStyle(
              color: Color(0xff5b5b5b),
              fontSize: 14,
            ),
          ),
          SizedBox(
            height: 20,
          ),
          Center(
            child: InkWell(
              borderRadius: BorderRadius.circular(600),
              onTap: () {
                Navigator.pushNamedAndRemoveUntil(
                    context, Session.BASE_URL, (route) => false);
              },
              child: Container(
                width: 186,
                height: 58,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(600),
                  border: Border.all(
                    color: Color(0xffdc0f21),
                    width: 2,
                  ),
                  color: Colors.white,
                ),
                child: Center(
                  child: Text(
                    "Shop Now",
                    style: TextStyle(
                      color: Color(0xffdc0f21),
                      fontSize: 14,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ):
      ListView.builder(itemCount: _orderBloc.myOrders.length,itemBuilder: (c,i){
        Map order = _orderBloc.myOrders.elementAt(i);
        return ListTile(title: Text("$order"),);
      }),
    );
  }
}
