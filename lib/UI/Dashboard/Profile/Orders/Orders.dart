import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Orders/OrderDetails.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

class Orders extends StatefulWidget {
  @override
  _OrdersState createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  Map filters = {
    "Delivered": 0,
    "Processing": 0,
    "Canceled": 0,
    "Pending": 0,
    "Confirmed": 0,
    "Ready To Ship": 0,
    "Shipped": 0,
    "In Transit": 0,
  };

  @override
  Widget build(BuildContext context) {
    OrdersBloc _orderBloc = Provider.of<OrdersBloc>(context);

    List myOrders = [];
    List fil = filters.entries.where((element) => element.value == 1).toList();
    if (fil.length == 0)
      myOrders = _orderBloc.myOrders;
    else
      fil.forEach((element) {
        myOrders.addAll(_orderBloc.myOrders
            .where((order) => order['order_status'].toString() == element.key)
            .toList());
      });
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
          style: TextStyle(color: Colors.black, fontFamily: goggleFont),
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
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 40,
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    children: [
                      ...filters.entries.map((e) {
                        bool isSelected = e.value == 1;
                        return Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10),
                          child: GestureDetector(
                              onTap: () {
                                if (isSelected)
                                  filters[e.key] = 0;
                                else
                                  filters[e.key] = 1;
                                if (mounted) setState(() {});
                              },
                              child: Chip(
                                label: Text(e.key),
                                backgroundColor:
                                    isSelected ? Color(0xfffaae00) : null,
                                elevation: 2,
                              )),
                        );
                      }).toList()
                    ],
                  ),
                ),
                if (myOrders.length != 0)
                  Expanded(
                    child: Scrollbar(
                      radius: Radius.circular(20),
                      child: ListView.builder(
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          itemCount: myOrders.length,
                          itemBuilder: (c, i) {
                            Map order = myOrders.elementAt(i);
                            Map products = order['products'] ?? {};
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(
                                        SlideLeftPageRouteBuilder(
                                            pageBuilder: (c, a, b) =>
                                                OrderDetails(
                                                  orderId: order['order_id'],
                                                )));
                                  },
                                  child: Container(
                                    height: 140,
                                    decoration: BoxDecoration(
                                        color: Colors.white38,
                                        border: Border.all(color: Colors.grey.shade300),
                                        borderRadius:
                                            BorderRadius.circular(10)),
                                    child: Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      children: [
                                        Expanded(
                                          flex: 0,
                                          child: Container(
                                            width: MediaQuery.of(context)
                                                    .size
                                                    .width /
                                                3,
                                            child: Stack(
                                              children: [
                                                Padding(
                                                  padding: const EdgeInsets.all(2.0),
                                                  child: Container(
                                                    decoration: BoxDecoration(
                                                        borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey.shade300)
                                                    ),
                                                    child: Padding(
                                                      padding: const EdgeInsets.all(4.0),
                                                      child: ClipRRect(
                                                        borderRadius:
                                                            BorderRadius.circular(10),
                                                        child: CachedNetworkImage(
                                                          imageUrl:
                                                              "${Session.IMAGE_BASE_URL}/assets/images/products/${products.entries.first.value['item']['photo']}",
                                                          fit: BoxFit.fill,
                                                          height: 140,
                                                          width:
                                                              MediaQuery.of(context)
                                                                      .size
                                                                      .width /
                                                                  3,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                ),
                                                if (products.length > 1)
                                                  Align(
                                                    alignment:
                                                        Alignment.bottomRight,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              right: 8.0),
                                                      child: Container(
                                                        decoration:
                                                            BoxDecoration(
                                                                color: Colors
                                                                    .white,
                                                                shape: BoxShape
                                                                    .circle),
                                                        child: Padding(
                                                          padding:
                                                              const EdgeInsets
                                                                  .all(5),
                                                          child: Text(
                                                            "+${products.length}",
                                                            style: TextStyle(
                                                              color: Color(
                                                                  0xffDC0F21),
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
                                                  left: 10.0,
                                                  top: 5,
                                                  bottom: 5),
                                              child: Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: [
                                                  Text(
                                                    "${products.entries.first.value['item']['name']}",
                                                    maxLines: 2,
                                                    style:
                                                        TextStyle(fontSize: 16),
                                                  ),
                                                  RichText(
                                                    text: TextSpan(
                                                        text: "Order Status",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontFamily:
                                                              goggleFont,
                                                          fontSize: 12,
                                                          letterSpacing: 0.45,
                                                        ),
                                                        children: [
                                                          TextSpan(
                                                            text:
                                                                " ${order['order_status']}",
                                                            style: TextStyle(
                                                              color: order[
                                                                          'order_status']
                                                                      .toString()
                                                                      .toLowerCase()
                                                                      .contains(
                                                                          "deliver")
                                                                  ? Colors.green
                                                                  : (order['order_status']
                                                                          .toString()
                                                                          .toLowerCase()
                                                                          .contains("cancel")||order['order_status']
                                                                  .toString()
                                                                  .toLowerCase()
                                                                  .contains("ftd"))
                                                                      ? Color(
                                                                          0xffdc0f21)
                                                                      : Color(
                                                                          0xfffaae00),
                                                              letterSpacing:
                                                                  0.45,
                                                            ),
                                                          ),
                                                        ]),
                                                    textAlign: TextAlign.center,
                                                  ),
                                                  Text(
                                                    "Order Date : ${order['order_date']}",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                  Text(
                                                    "Order Total : ${order['order_total']}",
                                                    style:
                                                        TextStyle(fontSize: 12),
                                                  ),
                                                ],
                                              ),
                                            )),
                                        Expanded(
                                          flex: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Icon(Icons
                                                    .arrow_forward_ios_rounded)),
                                          ),
                                        )
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }),
                    ),
                  )
                else ...[
                  Padding(
                    padding: const EdgeInsets.only(top:200.0),
                    child: Center(
                      child: Text("No Orders\n"
                          "Try Clearing Filters",textAlign: TextAlign.center,),
                    ),
                  ),
                  Center(
                      child: Container(
                    width: 120,
                    child: FlatButton(
                      child: Text(" Clear All"),
                      onPressed: () {
                        filters.forEach((key, value) => filters[key] = 0);
                        if(mounted)setState(() {

                        });
                      },
                      color: Color(0xfffaae00),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  )),
                ]
              ],
            ),
    );
  }
}
