import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import 'GetRemarks.dart';

class OrderDetails extends StatefulWidget {
  final int orderId;

  const OrderDetails({Key key, this.orderId}) : super(key: key);

  @override
  _OrderDetailsState createState() => _OrderDetailsState();
}

class _OrderDetailsState extends State<OrderDetails> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    OrdersBloc _orderBloc = Provider.of<OrdersBloc>(context);
    return isLoading
        ? Material(
            color: Colors.white,
            child: Center(
                child: SpinKitFadingCircle(
              color: Color(0xffDC0F21),
            )),
          )
        : FutureBuilder<Response>(
            future: _orderBloc.getOrderDetails(widget.orderId),
            builder: (c, snap) {
              if (snap?.data?.data == null)
                return Material(
                  color: Colors.white,
                  child: Center(
                      child: SpinKitFadingCircle(
                    color: Color(0xffDC0F21),
                  )),
                );
              else {
                Map orderData = snap?.data?.data ?? {};
                Map billingAddress = orderData['billing_address'] ?? {};
                Map shippingAddress = orderData['shipping_address'] ?? {};
                Map orderDetails = orderData['order_details'] ?? {};
                bool isOnlinePayment =
                    orderData['payment_method'] != "cashondelivery";
                Map cartItems = orderData['cart'] ?? {};
                bool eligibleForCancel =
                    orderDetails['eligible_for_cancel'] ?? false;
                DateTime deliveryDate;
                try {
                  deliveryDate = DateTime.parse(orderDetails['delivery_date']);
                } catch (err) {}
                return Scaffold(
                    appBar: AppBar(
                      elevation: 0,
                      leading: FlatButton(
                        child: Image.asset("assets/backArrow.png"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      actions: [
                        IconButton(
                          icon: Icon(Icons.print_outlined),
                          onPressed: () {
                            Fluttertoast.showToast(msg: "Generating Details");
                            _orderBloc.printOrder(
                                id: orderDetails['order_id'].toString());
                          },
                        )
                      ],
                      titleSpacing: -10,
                      title: Text(
                        "${orderDetails['order_number']}",
                        style: TextStyle(
                            color: Colors.black, fontFamily: goggleFont),
                      ),
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.black),
                    ),
                    backgroundColor: Colors.white,
                    body: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: "Order Status",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: goggleFont,
                                    letterSpacing: 0.45,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " ${orderDetails['order_status']}",
                                      style: TextStyle(
                                        color: orderDetails['order_status']
                                                .toString()
                                                .toLowerCase()
                                                .contains("deliver")
                                            ? Colors.green
                                            : (orderDetails['order_status']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains("cancel") ||
                                                    orderDetails['order_status']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains("ftd"))
                                                ? Color(0xffdc0f21)
                                                : Color(0xfffaae00),
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0.45,
                                      ),
                                    ),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        if (deliveryDate != null)
                          Align(
                            alignment: Alignment.centerLeft,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: RichText(
                                text: TextSpan(
                                    text: "Delivered On: ",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: goggleFont,
                                      letterSpacing: 0.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text:
                                            "${DateFormat("dd-MM-yyyy").format(deliveryDate)}",
                                        style: TextStyle(
                                          fontWeight: FontWeight.normal,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Align(
                            alignment: Alignment.centerLeft,
                            child: RichText(
                              text: TextSpan(
                                  text: "Items",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 15,
                                    fontFamily: goggleFont,
                                    fontWeight: FontWeight.bold,
                                    letterSpacing: 0.45,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " Purchased",
                                      style: TextStyle(
                                        color: Color(0xffdc0f21),
                                        fontWeight: FontWeight.normal,
                                        fontSize: 15,
                                        letterSpacing: 0.45,
                                      ),
                                    ),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),
                        ...cartItems.entries
                            .map((e) => productTile(e.key, e.value,
                                orderData ?? {}, deliveryDate != null))
                            .toList(),
                        if (eligibleForCancel)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(600),
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Text("Are you sure?"),
                                          content: Text(
                                              "Are you sure you want to cancel this order?"),
                                          actions: [
                                            FlatButton(
                                                onPressed: () async {
                                                  Navigator.pop(c);
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await _orderBloc.cancelOrder(
                                                      orderDetails['order_id']
                                                          .toString());
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Color(0xffDC0F21)),
                                                )),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(c);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ],
                                        ));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(600),
                                  color: Color(0xffdc0f21),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel Order",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),

                        Theme(
                          data: ThemeData(
                            accentColor: Color(0xffDC0F21),
                            fontFamily: goggleFont,
                          ),
                          child: ExpansionTile(
                            initiallyExpanded: true,
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: "Payment",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: goggleFont,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Info",
                                        style: TextStyle(
                                          color: Color(0xffdc0f21),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            childrenPadding: EdgeInsets.only(left: 20),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Payment Status : ${orderDetails['payment_status']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Method : ${isOnlinePayment ? "Prepaid (Razorpay)" : "Cash On Delivery"}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              if (isOnlinePayment)
                                Align(
                                  alignment: Alignment.centerLeft,
                                  child: Text(
                                    "Transaction ID : ${orderData['Razorpay Transaction ID']}",
                                    style: TextStyle(
                                      fontSize: 14,
                                      letterSpacing: 0.42,
                                    ),
                                  ),
                                ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Shipping Fee : ${orderDetails['shipping_cost']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Packaging Fee : ${orderDetails['packaging_cost']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Total : ${orderDetails['total']}",
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 15,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        Theme(
                          data: ThemeData(
                            accentColor: Color(0xffDC0F21),
                            fontFamily: goggleFont,
                          ),
                          child: ExpansionTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: "Shipping",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: goggleFont,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Address",
                                        style: TextStyle(
                                          color: Color(0xffdc0f21),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            childrenPadding: EdgeInsets.only(left: 20),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name : ${shippingAddress['shipping_name']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email Id : ${shippingAddress['shipping_email']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Phone Number : ${shippingAddress['shipping_phone']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Shipping Address : ${shippingAddress['shipping_address']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Shipping City : ${shippingAddress['shipping_city']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pin Code : ${shippingAddress['pin_code']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                            accentColor: Color(0xffDC0F21),
                            fontFamily: goggleFont,
                          ),
                          child: ExpansionTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: "Billing",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: goggleFont,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Address",
                                        style: TextStyle(
                                          color: Color(0xffdc0f21),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            childrenPadding: EdgeInsets.only(left: 20),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name: ${billingAddress['customer_name']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email Id: ${billingAddress['customer_email']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Billing Number: ${billingAddress['customer_phone']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Billing Address: ${billingAddress['customer_address']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Billing City: ${billingAddress['customer_city']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pin Code: ${billingAddress['customer_pincode']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        // Padding(
                        //   padding: EdgeInsets.only(bottom: 10, top: 10),
                        //   child: Container(
                        //     color: Colors.white,
                        //     child: Padding(
                        //       padding: const EdgeInsets.all(10.0),
                        //       child: Column(
                        //         crossAxisAlignment: CrossAxisAlignment.start,
                        //         children: [
                        //           Align(
                        //             alignment: Alignment.centerLeft,
                        //             child: RichText(
                        //               text: TextSpan(
                        //                   text: "Price Details",
                        //                   style: TextStyle(
                        //                     color: Colors.black,
                        //                     fontSize: 15,
                        //                     fontFamily: goggleFont,
                        //                     fontWeight: FontWeight.bold,
                        //                     letterSpacing: 0.45,
                        //                   ),
                        //                   children: [
                        //                     TextSpan(
                        //                       text:
                        //                           " ($itemLength${itemLength > 1 ? " Items)" : " Item)"} ",
                        //                       style: TextStyle(
                        //                         color: Color(0xffdc0f21),
                        //                         fontWeight: FontWeight.normal,
                        //                         fontSize: 15,
                        //                         letterSpacing: 0.45,
                        //                       ),
                        //                     ),
                        //                   ]),
                        //               textAlign: TextAlign.center,
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 vertical: 10),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   "Shipping Fee",
                        //                   style: TextStyle(
                        //
                        //                     fontSize: 14,
                        //                     letterSpacing: 0.42,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   "${(orderDetails['shipping_cost'])}",
                        //                   style: TextStyle(
                        //
                        //                     fontSize: 14,
                        //                     letterSpacing: 0.42,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 vertical: 10),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   "Packaging Fee",
                        //                   style: TextStyle(
                        //
                        //                     fontSize: 14,
                        //                     letterSpacing: 0.42,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   "${(orderDetails['packaging_cost'])}",
                        //                   style: TextStyle(
                        //
                        //                     fontSize: 14,
                        //                     letterSpacing: 0.42,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //           Divider(
                        //             color: Color(0xffDCDCDC),
                        //             height: 2,
                        //           ),
                        //           Padding(
                        //             padding: const EdgeInsets.symmetric(
                        //                 vertical: 10),
                        //             child: Row(
                        //               mainAxisAlignment:
                        //                   MainAxisAlignment.spaceBetween,
                        //               crossAxisAlignment:
                        //                   CrossAxisAlignment.center,
                        //               children: [
                        //                 Text(
                        //                   "Total Amount",
                        //                   style: TextStyle(
                        //                     color: Color(0xff515151),
                        //                     fontSize: 15,
                        //                     fontWeight: FontWeight.bold,
                        //                     letterSpacing: 0.45,
                        //                   ),
                        //                 ),
                        //                 Text(
                        //                   "${(orderDetails['total'])}",
                        //                   style: TextStyle(
                        //                     color: Color(0xffDC0f21),
                        //                     fontSize: 14,
                        //                     letterSpacing: 0.42,
                        //                   ),
                        //                 ),
                        //               ],
                        //             ),
                        //           ),
                        //         ],
                        //       ),
                        //     ),
                        //   ),
                        // ),
                      ],
                    ));
              }
            });
  }

  Widget productTile(String key, Map details, Map orderData, bool isDelivered) {
    double newPrice = double.parse(details['price']?.toString());
    //TODO: ask ravjot to send currency value
    double currency = 68.95;
    Map returnStatus = (orderData['return_status'] ?? {})[key] ?? {};
    String rStatus = returnStatus['return_current_status'].toString();
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child: Container(
        height: 130,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: .5,
              spreadRadius: .5,
              offset: Offset(0, 1))
        ], color: Colors.white),
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
                width: MediaQuery.of(context).size.width / 2.4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.grey.shade300)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl:
                                "${Session.IMAGE_BASE_URL}/assets/images/products/${details['item']['photo']}",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
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
                          fontSize: 14,
                          letterSpacing: 0.45,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
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
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: (details['size'].toString().length > 0)
                                    ? 20.0
                                    : 0),
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
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "\u20B9 ${(newPrice * currency).round()}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                    if (isDelivered) ...[
                      if (rStatus == "Eligible For Return")
                        Expanded(
                          flex: 0,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(10),
                            onTap: () async {
                              Map data = await Navigator.push(
                                  context,
                                  PageRouteBuilder(
                                      opaque: false,
                                      barrierColor: Colors.black54,
                                      reverseTransitionDuration:
                                          Duration(milliseconds: 100),
                                      transitionDuration:
                                          Duration(milliseconds: 500),
                                      transitionsBuilder: (c, a, b, w) {
                                        return SlideTransition(
                                          position: Tween(
                                                  begin: Offset(0, 1),
                                                  end: Offset.zero)
                                              .animate(CurvedAnimation(
                                                  curve: Curves
                                                      .fastLinearToSlowEaseIn,
                                                  parent: a)),
                                          child: w,
                                        );
                                      },
                                      pageBuilder: (c, a, b) => GetRemarks(
                                            remarks: orderData['remarks_array'],
                                            slots: orderData['date_slots'],
                                          )));
                              if (data == null) return;
                              if (mounted)
                                setState(() {
                                  isLoading = true;
                                });
                              Map userData =
                                  Provider.of<AuthBloc>(context, listen: false)
                                      .userData;
                              Map<String, dynamic> formData = {
                                "order_id": widget.orderId,
                                "user_id": userData['user_id'],
                                "product_size": returnStatus['size'],
                                "vendor_id": returnStatus['vendor_id'],
                                "product_id": returnStatus['product_id'],
                                "product_price": returnStatus['product_price'],
                                "qty": returnStatus['qty'],
                                "remarks": data['remarks'],
                                "date_time": data['slot']
                              };
                              Response res = await Provider.of<OrdersBloc>(
                                      context,
                                      listen: false)
                                  .returnOrder(
                                      returnId: null,
                                      returnStatus: null,
                                      formData: formData);
                              Fluttertoast.showToast(
                                  msg: res.data['message']?.toString());
                              if (mounted)
                                setState(() {
                                  isLoading = false;
                                });
                            },
                            child: Container(
                                height: 25,
                                decoration: BoxDecoration(
                                    border:
                                        Border.all(color: Color(0xffDC0F21)),
                                    borderRadius: BorderRadius.circular(20)),
                                child: Center(
                                    child: Text(
                                  "Return Item",
                                  style: TextStyle(color: Colors.black),
                                ))),
                          ),
                        )
                      else
                        Expanded(
                          flex: 0,
                          child: Text(
                            "Return Status: " + rStatus,
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                    ]
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
