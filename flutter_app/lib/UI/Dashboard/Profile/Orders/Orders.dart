import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

import 'OrderDetails.dart';

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
        title: Text(
          "My Orders",
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Colors.white,
      body: _orderBloc.myOrders.length == 0
          ? Column(
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
            )
          : ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: _orderBloc.myOrders.length,
              itemBuilder: (c, i) {
                Map order = _orderBloc.myOrders.elementAt(i);
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          border: Border.all(color: Colors.grey),
                          borderRadius: BorderRadius.circular(20)),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (c) => OrderDetails(
                                        orderId: order['order_id'],
                                      )));
                        },
                        title: Text("Order Number: ${order['order_number']}"),
                        isThreeLine: true,
                        subtitle: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text("Date: ${order['order_date']}\n"
                                "Status: ${order['order_status']}"),
                            Text(" Total Price: ${order['order_total']}")
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              }),
    );
  }
}
