import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

class OrderDetails extends StatefulWidget {
  final int orderId;

  const OrderDetails({Key key, this.orderId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
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
          "My Orders",style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xffE5E5E5),
      body: FutureBuilder<Response>(
        future: _orderBloc.getOrderDetails(widget.orderId),
        builder: (c, snap) {
          if (snap?.data?.data == null)
            return Center(
                child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xffdc0f21)),
            ));
          else {
            Map orderData = snap?.data?.data ?? {};
            Map billingAddress = orderData['billing_address'] ?? {};
            Map shippingAddress = orderData['shipping_address'] ?? {};
            Map orderDetails = orderData['order_details'] ?? {};
            bool isOnlinePayment =
                orderData['payment_method'] != "cashondelivery";
            Map cartItems = orderData['cart'] ?? {};
            int itemLength = cartItems?.length ?? 0;
            return ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Center(
                    child: Text(
                  "Order Number : ${orderDetails['order_number']}",
                  style: TextStyle(fontSize: 20),
                  textAlign: TextAlign.center,
                )),
                Center(child: Text("Status: ${orderDetails['order_status']}")),
                Center(child: Text("Order on : ${orderDetails['order_date']}")),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Shipping Address',
                            style: TextStyle(
                              color: Color(0xff515151),
                              fontSize: 15,
                              letterSpacing: 0.45,
                            ),
                          ),
                          Text(
                            "Name : ${shippingAddress['shipping_name']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Email Id : ${shippingAddress['shipping_email']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Phone Number : ${shippingAddress['shipping_phone']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Shipping Address : ${shippingAddress['shipping_address']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Shipping City : ${shippingAddress['shipping_city']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Pin Code : ${shippingAddress['pin_code']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Billing Address',
                            style: TextStyle(
                              color: Color(0xff515151),
                              fontSize: 15,
                              letterSpacing: 0.45,
                            ),
                          ),
                          Text(
                            "Name: ${billingAddress['customer_name']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Email Id: ${billingAddress['customer_email']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Phone Number: ${billingAddress['customer_phone']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Shipping Address: ${billingAddress['customer_address']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Shipping City: ${billingAddress['customer_city']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Pin Code: ${billingAddress['customer_pincode']}",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(bottom: 10, top: 10),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Price Details ($itemLength${itemLength > 1 ? " Items)" : " Item)"} ",
                            style: TextStyle(
                              color: Color(0xff515151),
                              fontSize: 15,
                              letterSpacing: 0.45,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Shipping Fee",
                                  style: TextStyle(
                                    color: Color(0xff7f7f7f),
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                                Text(
                                  "${(orderDetails['shipping_cost'])}",
                                  style: TextStyle(
                                    color: Color(0xff7f7f7f),
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Packaging Fee",
                                  style: TextStyle(
                                    color: Color(0xff7f7f7f),
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                                Text(
                                  "${(orderDetails['packaging_cost'])}",
                                  style: TextStyle(
                                    color: Color(0xff7f7f7f),
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Divider(
                            color: Color(0xffDCDCDC),
                            height: 2,
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Total Amount",
                                  style: TextStyle(
                                    color: Color(0xff515151),
                                    fontSize: 15,
                                    letterSpacing: 0.45,
                                  ),
                                ),
                                Text(
                                  "${(orderDetails['total'])}",
                                  style: TextStyle(
                                    color: Color(0xff515151),
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top:10.0,bottom: 5),
                  child: Text(
                    'Items Purchased',
                    style: TextStyle(
                      color: Color(0xff515151),
                      fontSize: 15,
                      letterSpacing: 0.45,
                    ),
                  ),
                ),
                ...cartItems.entries
                    .map((e) => productTile(e.key, e.value))
                    .toList()
              ],
            );
          }
        },
      ),
    );
  }

  Widget productTile(String key, Map details) {
    double newPrice = double.parse(details['price']?.toString());
    //TODO: ask ravjot to send currency value
    double currency = 68.95;

    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 150,
        color: Colors.white,
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ItemPage(

                              itemSlug: details['item']['slug'],
                            )));
              },
              child: Container(
                height: double.maxFinite,
                child: CachedNetworkImage(
                  imageUrl:
                      "${Session.IMAGE_BASE_URL}/assets/images/products/${details['item']['photo']}",
                  fit: BoxFit.fitHeight,
                ),
                width: MediaQuery.of(context).size.width / 2.4,
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        "${details['item']['name']}",
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xff515151),
                          fontSize: 15,
                          letterSpacing: 0.45,
                        ),
                      ),
                    ),
                    if (details['size'].toString().length > 0)
                      Expanded(
                        flex: 0,
                        child: Text(
                          "Size : ${details['size']}",
                          style: TextStyle(
                            color: Color(0xff515151),
                            fontSize: 12,
                            fontWeight: FontWeight.w300,
                            letterSpacing: 0.30,
                          ),
                        ),
                      ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        "Qty : ${details['qty']}",
                        style: TextStyle(
                          color: Color(0xff515151),
                          fontSize: 12,
                          fontWeight: FontWeight.w300,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        "\u20B9 ${(newPrice * currency).round()}",
                        maxLines: 1,
                        style: TextStyle(
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Text(
                        "30 days easy return",
                        style: TextStyle(
                          color: Color(0xff999999),
                          fontSize: 10,
                          letterSpacing: 0.30,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
