import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Session.dart';

class OrderPlaced extends StatefulWidget {
  final Map data;

  const OrderPlaced({Key key, this.data}) : super(key: key);

  @override
  _OrderPlacedState createState() => _OrderPlacedState();
}

class _OrderPlacedState extends State<OrderPlaced> {
  Map data;
  @override
  Widget build(BuildContext context) {
    data=widget.data;
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        elevation: 0,
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Order Details",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Column(mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.only(top:20.0,bottom: 10),
            child: Center(child: Text("Order Placed Successfully",style: TextStyle(fontSize: 24),)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text("Order Number: ${data['order_number']}"),
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
                    "Shop More",
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
      ),
    );
  }
}
