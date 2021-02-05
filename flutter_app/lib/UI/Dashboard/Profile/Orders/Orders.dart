import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Orders/OrderDetails.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
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
                Map products = order['products'] ?? {};
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 5),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(SlideLeftPageRouteBuilder(
                            pageBuilder: (c, a, b) => OrderDetails(
                                  orderId: order['order_id'],
                                )));
                      },
                      child: Container(
                        height: 140,
                        decoration: BoxDecoration(
                            color: Colors.white38,
                            border: Border.all(color: Colors.grey),
                            borderRadius: BorderRadius.circular(10)),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Container(
                                width: MediaQuery.of(context).size.width / 3,
                                child: Stack(
                                  children: [
                                    ClipRRect(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(10)),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Session.IMAGE_BASE_URL}/assets/images/products/${products.entries.first.value['item']['photo']}",
                                        fit: BoxFit.fill,
                                        height: 140,
                                        width:
                                            MediaQuery.of(context).size.width /
                                                3,
                                      ),
                                    ),
                                    if (products.length > 1)
                                      Align(
                                        alignment: Alignment.bottomRight,
                                        child: Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8.0),
                                          child: Container(
                                            decoration: BoxDecoration(
                                                color: Colors.white,
                                                shape: BoxShape.circle),
                                            child: Padding(
                                              padding: const EdgeInsets.all(5),
                                              child: Text(
                                                "+${products.length}",
                                                style: TextStyle(
                                                  color: Color(0xffDC0F21),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 1,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 10.0, top: 5, bottom: 5),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      Text(
                                        "${products.entries.first.value['item']['name']}",
                                        maxLines: 1,
                                        style: TextStyle(fontSize: 16),
                                      ),
                                      Text(
                                        "Order Number : ${order['order_number']}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Order Status : ${order['order_status']}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Order Date : ${order['order_date']}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                      Text(
                                        "Order Total : ${order['order_total']}",
                                        style: TextStyle(fontSize: 12),
                                      ),
                                    ],
                                  ),
                                )),
                            Expanded(
                              flex: 0,
                              child: Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Align(
                                    alignment: Alignment.centerRight,
                                    child:
                                        Icon(Icons.arrow_forward_ios_rounded)),
                              ),
                            )
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
