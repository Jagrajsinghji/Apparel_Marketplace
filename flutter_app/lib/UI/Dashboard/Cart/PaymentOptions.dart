import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'OrderPlaced.dart';

class PaymentOptions extends StatefulWidget {
  final Map<String, dynamic> checkOutData;

  const PaymentOptions({Key key, this.checkOutData}) : super(key: key);

  @override
  _PaymentOptionsState createState() => _PaymentOptionsState();
}

class _PaymentOptionsState extends State<PaymentOptions> {
  int paymentOption;
  double total;
  bool loading = false;
double currency = 68.5;

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.checkOutData;
    total = data["totalMRP"] +
        data["shippingCost"] +
        data["packingCost"] -
        data['couponDiscount'];

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
          "Choose Payment Options",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: loading
          ? Center(
              child: CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation(Color(0xffdc0f21)),
            ))
          : Stack(
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 80.0),
                  child: ListView(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(top: 20.0, bottom: 20),
                        child: Container(
                          height: 60,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/securePayment.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 2.0),
                                        child: Text(
                                          "Secure Payment",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/easyReturn.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "Easy Return",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Image.asset(
                                        "assets/refund.png",
                                        height: 20,
                                        width: 20,
                                      ),
                                      Padding(
                                        padding:
                                            const EdgeInsets.only(left: 5.0),
                                        child: Text(
                                          "Fast Refund",
                                          style: TextStyle(fontSize: 10),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                          color: Colors.white,
                          child: ListTile(
                              onTap: () {
                                if (mounted)
                                  setState(() {
                                    paymentOption = 0;
                                  });
                              },
                              title: Text("Pay on Delivery (Cash, card, UPI)"),
                              trailing: paymentOption == 0
                                  ? Container(
                                      child: Center(
                                          child: Icon(
                                        Icons.check,
                                        size: 12,
                                      )),
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.green),
                                      width: 20,
                                      height: 20,
                                    )
                                  : Container(
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey.shade400),
                                      width: 20,
                                      height: 20,
                                    ))),
                      // Container(
                      //     color: Colors.white,
                      //     child: ListTile(
                      //         onTap: () {
                      //           if (mounted)
                      //             setState(() {
                      //               paymentOption = 1;
                      //             });
                      //         },
                      //         leading: Image.asset("assets/razorPay.png"),
                      //         title: Text("RazorPay"),
                      //         trailing: paymentOption == 1
                      //             ? Container(
                      //                 child: Center(
                      //                     child: Icon(
                      //                   Icons.check,
                      //                   size: 12,
                      //                 )),
                      //                 decoration: BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     color: Colors.green),
                      //                 width: 20,
                      //                 height: 20,
                      //               )
                      //             : Container(
                      //                 decoration: BoxDecoration(
                      //                     shape: BoxShape.circle,
                      //                     color: Colors.grey.shade400),
                      //                 width: 20,
                      //                 height: 20,
                      //               ))),
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
                                  "Price Details (${data['totalQty'].toInt()}${data['totalQty'] > 1 ? " Items)" : " Item)"} ",
                                  style: TextStyle(
                                    color: Color(0xff515151),
                                    fontSize: 15,
                                    letterSpacing: 0.45,
                                  ),
                                ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Text(
                                        "Total MRP",
                                        style: TextStyle(
                                          color: Color(0xff7f7f7f),
                                          fontSize: 14,
                                          letterSpacing: 0.42,
                                        ),
                                      ),
                                      Text(
                                        "\u20B9 ${(data["totalMRP"] *currency).ceil()}",
                                        style: TextStyle(
                                          color: Color(0xff7f7f7f),
                                          fontSize: 14,
                                          letterSpacing: 0.42,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                if (data['couponDiscount'] > 0)
                                  Padding(
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 10),
                                    child: Row(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      children: [
                                        Text(
                                          "Coupon Discount",
                                          style: TextStyle(
                                            color: Color(0xff7f7f7f),
                                            fontSize: 14,
                                            letterSpacing: 0.42,
                                          ),
                                        ),
                                        Text(
                                          "-\u20B9 ${(data["couponDiscount"]*currency).ceil()}",
                                          style: TextStyle(
                                            color: Color(0xff05B90D),
                                            fontSize: 14,
                                            letterSpacing: 0.42,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                Padding(
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        "\u20B9 ${(data["shippingCost"]*currency).ceil()}",
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        "\u20B9 ${(data["packingCost"]*currency).ceil()}",
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
                                  padding:
                                      const EdgeInsets.symmetric(vertical: 10),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
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
                                        "\u20B9 ${(total*currency).ceil()}",
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
                      )
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.bottomCenter,
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(600),
                      onTap: paymentOption != null ? _confirmOrder : null,
                      child: Container(
                        height: 60,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(600),
                          color: paymentOption == null
                              ? Color(0xffdc0f21).withOpacity(.5)
                              : Color(0xffdc0f21),
                        ),
                        child: Center(
                          child: Text(
                            "Confirm",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                )
              ],
            ),
    );
  }

  Future<void> _confirmOrder() async {
    if (mounted)
      setState(() {
        loading = true;
      });
    Map<String, dynamic> data = widget.checkOutData;
    CartBloc _cBloc = Provider.of(context, listen: false);
    Response resp = await _cBloc.placeCashOnDeliveryOrder(
      address: data['address'],
      city: data['city'],
      couponCode: data['couponCode'].toString(),
      couponDiscount: data['couponDiscount'].toString(),
      couponId: data['couponId'].toString(),
      customerCountry: "India",
      vendorPackingId: data['vendorPackingId'].toString(),
      dp: "0",
      email: data['personalEmail'],
      method: "cashondelivery",
      name: data['name'],
      packingCost: data['packingCost'].toString(),
      personalConfirm: null,
      personalEmail: data['personalEmail'],
      personalName: data['personalName'],
      personalPass: null,
      phone: data['phone'].toString(),
      pickupLocation: null,
      shipping: "shipto",
      shippingCost: data['shippingCost'].toString(),
      tax: "0",
      total: "$total",
      totalQty: data['totalQty'].toString(),
      userId: data['userId'].toString(),
      vendorShippingId: data['vendorShippingId'].toString(),
      zip: data['zip'].toString(),
    );
    if (mounted)
      setState(() {
        loading = false;
      });
    if (resp.data is Map && resp.data.containsKey('order')) {
      Map data = resp.data['order'] ?? {};
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (c, a, b) => OrderPlaced(
                    data: data,
                  )),
          (route) => route.isFirst);
    } else
      Fluttertoast.showToast(msg: "An Error Occurred while placing your order");
  }
}
