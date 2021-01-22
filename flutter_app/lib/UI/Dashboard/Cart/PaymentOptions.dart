import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

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
  double currency = 68.95;
  Razorpay _razorPay;

  Map orderData = {};

  @override
  void initState() {
    super.initState();
    initRazorPay();
  }

  @override
  Widget build(BuildContext context) {
    Map<String, dynamic> data = widget.checkOutData;
    total = data["totalMRP"] +
        data["shippingCost"] +
        data["packingCost"] -
        data['couponDiscount'];

    return Scaffold(
      backgroundColor: Colors.white,
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
              child: SpinKitFadingCircle(
              color: Color(0xffDC0F21),
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
                      Container(
                          color: Colors.white,
                          child: ListTile(
                              onTap: () {
                                if (mounted)
                                  setState(() {
                                    paymentOption = 1;
                                  });
                              },
                              leading: Image.asset("assets/razorPay.png"),
                              title: Text("RazorPay"),
                              trailing: paymentOption == 1
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
                                  "Price Details (${data['totalQty'].round()}${data['totalQty'] > 1 ? " Items)" : " Item)"} ",
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
                                        "\u20B9 ${(data["totalMRP"] * currency).round()}",
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
                                          "-\u20B9 ${(data["couponDiscount"] * currency).round()}",
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
                                        "\u20B9 ${(data["shippingCost"] * currency).round()}",
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
                                        "\u20B9 ${(data["packingCost"] * currency).round()}",
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
                                        "\u20B9 ${(total * currency).round()}",
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
    if (paymentOption == 0)
      cashOnDelivery();
    else
      placeRazorPay();
  }

  void cashOnDelivery() async {
    Map<String, dynamic> data = widget.checkOutData;
    CartBloc _cBloc = Provider.of<CartBloc>(context, listen: false);
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
      OrdersBloc _oBloc = Provider.of<OrdersBloc>(context, listen: false);
      _oBloc.getMyOrders();
      Map data = resp.data['order'] ?? {};
      Navigator.pushAndRemoveUntil(
          context,
          PageRouteBuilder(
              pageBuilder: (c, a, b) => OrderPlaced(
                    paymentStatus: "Pending",
                    data: data,
                  )),
          (route) => route.isFirst);
    } else {
      Fluttertoast.showToast(msg: "An Error Occurred while placing your order");
    }
  }

  void placeRazorPay() async {
    Map<String, dynamic> data = widget.checkOutData;
    CartBloc _cBloc = Provider.of<CartBloc>(context, listen: false);
    Response resp = await _cBloc.placeRazorPayOrder(
      address: data['address'],
      city: data['city'],
      couponCode: data['couponCode'].toString(),
      couponDiscount: data['couponDiscount'].toString(),
      couponId: data['couponId'].toString(),
      customerCountry: "India",
      vendorPackingId: data['vendorPackingId'].toString(),
      dp: "0",
      email: data['personalEmail'],
      name: data['name'],
      packingCost: data['packingCost'].toString(),
      personalConfirm: null,
      personalEmail: data['personalEmail'],
      personalName: data['personalName'],
      personalPass: null,
      phone: data['phone'].toString(),
      shipping: "shipto",
      shippingCost: data['shippingCost'].toString(),
      tax: "0",
      total: "$total",
      totalQty: data['totalQty'].toString(),
      userId: data['userId'].toString(),
      vendorShippingId: data['vendorShippingId'].toString(),
      zip: data['zip'].toString(),
    );
    if (resp.data is Map && resp.data.containsKey('order')) {
      OrdersBloc _oBloc = Provider.of<OrdersBloc>(context, listen: false);
      _oBloc.getMyOrders();
      orderData = resp.data['order'] ?? {};
      Map<String, dynamic> razorPayData = resp.data['razorpay_data'] ?? {};
      razorpayPayment(razorPayData);
    } else {
      Fluttertoast.showToast(msg: "An Error Occurred while placing your order");
      if (mounted)
        setState(() {
          loading = false;
        });
    }
  }

  void razorpayPayment(Map<String, dynamic> razorPayData) async {
    try {
      _razorPay.open(razorPayData);
    } catch (e) {
      debugPrint(e.toString());
      if (this.mounted)
        setState(() {
          loading = false;
        });
    }
  }

  // c07cdb3ffe812125c4789de53410bd3555c152fa481f6e01279ecad5e00d11c1
  // order_GPclNLtKqWPeIs
  // pay_GPclWVcH7XsUUD
  // eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiIsImp0aSI6ImQ5NjFkNjdhY2M5MjM4ZTk2NWM3N2MyMzc3MTE4YTcxZDZkZGRkNzM0NzkyZmE0OWFmMDgxMzViNDkwM2U4MDBhNjE2ODZiNmFlN2JkOWY3In0.eyJhdWQiOiIxIiwianRpIjoiZDk2MWQ2N2FjYzkyMzhlOTY1Yzc3YzIzNzcxMThhNzFkNmRkZGQ3MzQ3OTJmYTQ5YWYwODEzNWI0OTAzZTgwMGE2MTY4NmI2YWU3YmQ5ZjciLCJpYXQiOjE2MTA3MTkyMjksIm5iZiI6MTYxMDcxOTIyOSwiZXhwIjoxNjQyMjU1MjI5LCJzdWIiOiIyIiwic2NvcGVzIjpbXX0.sdDjcF6_ar3HS5FXb0zrTfI2zfdUlaqC6HIUmYz6Ay19pqZt5k8vQBBSYJvJtoMX7BYAI4OSL99OkcnGFM2ZWaTIM-GVMSKWsPGHBZF7iC5k43aOZvhDd4OzdrLssp_MIuWJKQeTwofgDnWpqlzgiLnTsuegx5Y1gspsHRSsErjEtRx8dFUTG2hH7bKb7NypZfZ5GkMFMX3ThXQnV0IeWJ78PNoHfA7V-fZNJRhz56JPdlNRQQ5rC_V6IG07LkAHJXxaadcsT1eTUibczgQ-m5GDMNlg9m0wAOhDgmGF6otp3KS6Mv1_wNWg94I1eNxdtET0JxAfH9nonfSGiIJlV4V3oIP-TDn-UQRtajQ5KIJP2Vc6OrAFvXELuzQMKpMP_foCZqXSqYTA04g8NnhPIfnnsWGY1qZGmyYvT-DT6a6xySa7Ce3SFnVV9MAPOb6TbTPVmwTu5PYJEsj_RJ2RmFJStv-rtyH6L_Wkik55KiDRltAIbXo5CJIKofI8oukKxYh-PMYcarKUcSfTkgSx3U92AHLJ2XTjlJdZ8ATEKxHtVI9KKSZza

  initRazorPay() {
    _razorPay = Razorpay();
    _razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (c, a, b) => OrderPlaced(
                  paymentStatus: "Pending",
                  data: orderData,
                )),
        (route) => route.isFirst);
    Fluttertoast.showToast(
      msg: response.message,
    );
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (c, a, b) => OrderPlaced(
                  data: orderData,
                  paymentStatus: "Pending",
                )),
        (route) => route.isFirst);
    Fluttertoast.showToast(
      msg: response.walletName,
    );
  }

  void _handlePaymentSuccess(PaymentSuccessResponse paymentRes) async {
    CartBloc _cBloc = Provider.of<CartBloc>(context, listen: false);
    Response response = await _cBloc.razorPayCallack(
        orderId: paymentRes.orderId,
        paymentId: paymentRes.paymentId,
        signature: paymentRes.signature,
        wowfasID: orderData['order_number']);
    OrdersBloc _oBloc = Provider.of<OrdersBloc>(context, listen: false);
    _oBloc.getMyOrders();
    Map odata = response.data['order'] ?? {};
    Navigator.pushAndRemoveUntil(
        context,
        PageRouteBuilder(
            pageBuilder: (c, a, b) => OrderPlaced(
                  paymentStatus: "Successful",
                  data: odata,
                )),
        (route) => route.isFirst);
    Fluttertoast.showToast(
      msg: "SUCCESS",
    );
  }
}
