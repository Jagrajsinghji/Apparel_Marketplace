import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/UI/Dashboard/Profile/AddAddress.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  bool isLoading = false;

  double couponAmt = 0, packingAmt = 0, shippingAmt = 0;

  bool initializeVars = false;

  int shippingMethodValue = 0, packingValue = 0;
  Map<String, dynamic> checkOutData = {};

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = Provider.of<CartBloc>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        title: Text(
          "Check Out",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 18,
          ),
        ),
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
      body: Stack(
        children: [
          FutureBuilder<Response>(
              future: _cartBloc.getCheckOutItems(),
              builder: (context, snapshot) {
                if (snapshot?.data == null)
                  return Center(
                      child: SpinKitFadingCircle(
                    color: Color(0xffDC0F21),
                  ));
                else {
                  Map data = snapshot?.data?.data ?? {};
                  Map products = data['products'] ?? {};
                  if (products.length == 0) {
                    return noProducts();
                  }
                  double totalMRP =
                      double.parse(data['totalMRP']?.toString() ?? "0");
                  List shippingData = data['shipping_data'] ?? [];
                  List packageData = data['package_data'] ?? [];
//TODO: ask ravjot to send currency
                  double currency = 68.95;
                  if (_cartBloc.couponData.length > 0)
                    couponAmt = double.parse(
                        _cartBloc.couponData['coupon_amt']?.toString() ?? "0");
                  if (!initializeVars) {
                    if (shippingData.length > 0) {
                      shippingMethodValue = shippingData.first['id'] ?? 0;
                      shippingAmt = double.parse(
                          shippingData.first['price']?.toString() ?? "0");
                    }
                    if (packageData.length > 0) {
                      packingValue = packageData.first['id'] ?? 0;
                      packingAmt = double.parse(
                          packageData.first['price']?.toString() ?? "0");
                    }
                    initializeVars = true;
                  }
                  checkOutData.addAll({
                    "totalMRP": totalMRP,
                    "shippingCost": shippingAmt,
                    "packingCost": packingAmt,
                    "totalQty": double.parse("${data['totalQty'] ?? "0"}"),
                    "vendorShippingId": data['vendor_shipping_id'],
                    "vendorPackingId": data['vendor_packing_id'],
                    "couponCode": _cartBloc.couponData['coupon_code'],
                    "couponId": _cartBloc.couponData['coupon_id'],
                    "couponDiscount": couponAmt,
                  });
                  return Stack(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 80.0),
                        child: SmartRefresher(
                          controller: _refreshController,
                          onRefresh: () async {
                            await Future.delayed(Duration(milliseconds: 1000));
                            _refreshController.refreshCompleted();
                          },
                          physics: BouncingScrollPhysics(),
                          enablePullDown: true,
                          enablePullUp: false,
                          header: WaterDropMaterialHeader(
                            distance: 100,
                            backgroundColor: Color(0xffDC0F21),
                          ),
                          child: ListView(
                            shrinkWrap: true,
                            physics: NeverScrollableScrollPhysics(),
                            children: [
                              ...products.entries.map((prod) {
                                String key = prod.key;
                                Map details = prod.value;
                                return productTile(key, details, _cartBloc);
                              }).toList(),

                              /// Apply Coupon
                              // if (_cartBloc.couponData.length == 0)
                              //   Padding(
                              //     padding: const EdgeInsets.only(bottom: 10.0),
                              //     child: Container(
                              //       color: Colors.white,
                              //       child: ListTile(
                              //         onTap: () {
                              //           Navigator.of(context).push(
                              //               PageRouteBuilder(
                              //                   opaque: false,
                              //                   pageBuilder: (c, a, b) =>
                              //                       ApplyCoupon(
                              //                         totalPrice:
                              //                             totalMRP.toString(),
                              //                       )));
                              //         },
                              //         leading: Container(
                              //             width: 25,
                              //             height: 25,
                              //             child: Image.asset(
                              //                 "assets/freshTag.png")),
                              //         title: Text(
                              //           "Apply Coupons",
                              //           style: TextStyle(
                              //             color: Color(0xff515151),
                              //             fontSize: 15,
                              //             letterSpacing: 0.45,
                              //           ),
                              //         ),
                              //         trailing: Icon(
                              //           Icons.arrow_forward_ios,
                              //           size: 15,
                              //         ),
                              //       ),
                              //     ),
                              //   )
                              // else
                              //   Padding(
                              //     padding: const EdgeInsets.only(bottom: 10.0),
                              //     child: Container(
                              //       color: Colors.white,
                              //       child: ListTile(
                              //         onTap: () async {
                              //           Navigator.of(context).push(
                              //               PageRouteBuilder(
                              //                   opaque: false,
                              //                   pageBuilder: (c, a, b) =>
                              //                       ApplyCoupon(
                              //                         totalPrice:
                              //                             totalMRP.toString(),
                              //                       )));
                              //         },
                              //         leading: Container(
                              //             width: 25,
                              //             height: 25,
                              //             child: Image.asset(
                              //                 "assets/freshTag.png")),
                              //         title: Text(
                              //           "${_cartBloc.couponData['coupon_code']}",
                              //           style: TextStyle(
                              //             color: Color(0xff515151),
                              //             fontSize: 15,
                              //             letterSpacing: 0.45,
                              //           ),
                              //         ),
                              //         subtitle: Text(
                              //           "Coupon Applied",
                              //           style: TextStyle(
                              //               color: Color(0xff515151),
                              //               letterSpacing: 0.45,
                              //               fontSize: 10),
                              //         ),
                              //         trailing: Icon(
                              //           Icons.arrow_forward_ios,
                              //           size: 15,
                              //         ),
                              //       ),
                              //     ),
                              //   ),

                              /// Shipping Data
                              if (shippingData.length > 0)
                                Theme(
                                  data: ThemeData(
                                    accentColor: Color(0xffFF1D1D),
                                  ),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2, top: 2),
                                    child: Container(
                                      color: Colors.white,
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        children: [
                                          ...shippingData.map((sd) {
                                            return ListTile(
                                              leading: Radio(
                                                value: sd['id'] ??
                                                    shippingData.indexOf(sd),
                                                groupValue: shippingMethodValue,
                                                activeColor: Color(0xffFF1D1D),
                                                onChanged: (v) {
                                                  if (mounted)
                                                    setState(() {
                                                      shippingMethodValue = v;
                                                      shippingAmt = double
                                                          .parse(sd['price']
                                                                  ?.toString() ??
                                                              0);
                                                    });
                                                },
                                              ),
                                              trailing: Text(
                                                "\u20B9 ${(double.parse(sd['price'].toString()) * currency).round()}",
                                                style: TextStyle(
                                                  color: Color(0xff515151),
                                                  fontSize: 15,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                              title: Text(
                                                "${sd['title']}",
                                                style: TextStyle(
                                                  color: Color(0xff515151),
                                                  fontSize: 15,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "${sd['subtitle']}",
                                                style: TextStyle(
                                                  color: Color(0xff515151),
                                                  fontSize: 15,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                        title: Text(
                                          "Shipping",
                                          style: TextStyle(
                                            color: Color(0xff515151),
                                            fontSize: 15,
                                            letterSpacing: 0.45,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              /// Packing Data
                              if (packageData.length > 0)
                                Theme(
                                  data:
                                      ThemeData(accentColor: Color(0xffFF1D1D)),
                                  child: Padding(
                                    padding: EdgeInsets.only(bottom: 2, top: 2),
                                    child: Container(
                                      color: Colors.white,
                                      child: ExpansionTile(
                                        childrenPadding: EdgeInsets.zero,
                                        children: [
                                          ...packageData.map((pd) {
                                            return ListTile(
                                              leading: Radio(
                                                value: pd['id'] ??
                                                    packageData.indexOf(pd),
                                                groupValue: packingValue,
                                                activeColor: Color(0xffFF1D1D),
                                                onChanged: (v) {
                                                  if (mounted)
                                                    setState(() {
                                                      packingValue = v;
                                                      packingAmt = double.parse(
                                                          pd['price']
                                                                  ?.toString() ??
                                                              0);
                                                    });
                                                },
                                              ),
                                              trailing: Text(
                                                "\u20B9 ${(double.parse(pd['price'].toString()) * currency).round()}",
                                                style: TextStyle(
                                                  color: Color(0xff515151),
                                                  fontSize: 15,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                              title: Text(
                                                "${pd['title']}",
                                                style: TextStyle(
                                                  color: Color(0xff515151),
                                                  fontSize: 15,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                              subtitle: Text(
                                                "${pd['subtitle']}",
                                                style: TextStyle(
                                                  color: Color(0xff515151),
                                                  fontSize: 15,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                            );
                                          }).toList(),
                                        ],
                                        title: Text(
                                          "Packaging",
                                          style: TextStyle(
                                            color: Color(0xff515151),
                                            fontSize: 15,
                                            letterSpacing: 0.45,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                              Padding(
                                padding: EdgeInsets.only(bottom: 2, top: 2),
                                child: Container(
                                  color: Colors.white,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10.0),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Price Details (${data['totalQty']}${data['totalQty'] > 1 ? " Items)" : " Item)"} ",
                                          style: TextStyle(
                                            color: Color(0xff515151),
                                            fontSize: 15,
                                            letterSpacing: 0.45,
                                          ),
                                        ),
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
                                                "Total MRP",
                                                style: TextStyle(
                                                  color: Color(0xff7f7f7f),
                                                  fontSize: 14,
                                                  letterSpacing: 0.42,
                                                ),
                                              ),
                                              Text(
                                                "\u20B9 ${(totalMRP * currency).round()}",
                                                style: TextStyle(
                                                  color: Color(0xff7f7f7f),
                                                  fontSize: 14,
                                                  letterSpacing: 0.42,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                        // Padding(
                                        //   padding: const EdgeInsets.symmetric(
                                        //       vertical: 10),
                                        //   child: Row(
                                        //     mainAxisAlignment:
                                        //         MainAxisAlignment.spaceBetween,
                                        //     crossAxisAlignment:
                                        //         CrossAxisAlignment.center,
                                        //     children: [
                                        //       Text(
                                        //         "Coupon Discount",
                                        //         style: TextStyle(
                                        //           color: Color(0xff7f7f7f),
                                        //           fontSize: 14,
                                        //           letterSpacing: 0.42,
                                        //         ),
                                        //       ),
                                        //       if (_cartBloc.couponData.length ==
                                        //           0)
                                        //         InkWell(
                                        //           onTap: () async {
                                        //             Navigator.of(context).push(
                                        //                 PageRouteBuilder(
                                        //                     opaque: false,
                                        //                     pageBuilder:
                                        //                         (c, a, b) =>
                                        //                             ApplyCoupon(
                                        //                               totalPrice:
                                        //                                   totalMRP
                                        //                                       .toString(),
                                        //                             )));
                                        //           },
                                        //           child: Text(
                                        //             "Apply Coupon",
                                        //             style: TextStyle(
                                        //               color: Color(0xffFF1D1D),
                                        //               fontSize: 14,
                                        //               letterSpacing: 0.42,
                                        //             ),
                                        //           ),
                                        //         )
                                        //       else
                                        //         Text(
                                        //           "-\u20B9 $couponAmt",
                                        //           style: TextStyle(
                                        //             color: Color(0xff05B90D),
                                        //             fontSize: 14,
                                        //             letterSpacing: 0.42,
                                        //           ),
                                        //         ),
                                        //     ],
                                        //   ),
                                        // ),
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
                                                "Shipping Fee",
                                                style: TextStyle(
                                                  color: Color(0xff7f7f7f),
                                                  fontSize: 14,
                                                  letterSpacing: 0.42,
                                                ),
                                              ),
                                              Text(
                                                "\u20B9 ${(shippingAmt * currency).round()}",
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
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
                                                "\u20B9 ${(packingAmt * currency).round()}",
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
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
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
                                                "\u20B9 ${((totalMRP + shippingAmt + packingAmt - couponAmt) * currency).round()}",
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
                            ],
                          ),
                        ),
                      ),
                      Align(
                        alignment: Alignment.bottomCenter,
                        child: Padding(
                          padding: const EdgeInsets.all(20.0),
                          child: InkWell(
                            borderRadius: BorderRadius.circular(600),
                            onTap: checkOut,
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(600),
                                color: Color(0xffdc0f21),
                              ),
                              child: Center(
                                child: Text(
                                  "Place Order",
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
                  );
                }
              }),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
              child: Container(
                color: Colors.black54,
                child: Center(
                    child: SpinKitFadingCircle(
                  color: Color(0xffDC0F21),
                )),
              ),
            )
        ],
      ),
    );
  }

  Widget noProducts() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Container(
                height: 35, width: 35, child: Image.asset("assets/wind.png")),
            Container(
                height: 100,
                width: 100,
                child: Image.asset("assets/shopingBag.png")),
          ],
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Hey, it feels so empty",
          style: TextStyle(
            color: Color(0xff5b5b5b),
            fontSize: 20,
          ),
        ),
        SizedBox(
          height: 20,
        ),
        Text(
          "Save items that you like in your wihlist.\nReview them anytime and easily move\nthem to bag",
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
    );
  }

  Widget productTile(String itemID, Map details, CartBloc snapshot) {
    // print(details);
    double newPrice = double.parse(details['price']?.toString());
    double itemPrice = double.parse(details['item']['price']?.toString());

    //TODO: ask ravjot to send currency value
    double currency = 68.95;
    double sizePrice =
        itemPrice + double.parse(details['size_price']?.toString() ?? "0");
    return Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Container(
        height: 130,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: 1,
              spreadRadius: 1,
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
                    // Expanded(
                    //   flex: 0,
                    //   child: Padding(
                    //     padding: const EdgeInsets.only(
                    //         top: 5.0, bottom: 5),
                    //     child: Container(
                    //       decoration: BoxDecoration(
                    //           color: Color(0xffF2F2F2),
                    //           borderRadius:
                    //               BorderRadius.circular(
                    //                   8)),
                    //       child: Row(
                    //         mainAxisAlignment:
                    //             MainAxisAlignment
                    //                 .spaceEvenly,
                    //         crossAxisAlignment:
                    //             CrossAxisAlignment
                    //                 .center,
                    //         children: [
                    //           Padding(
                    //             padding:
                    //                 const EdgeInsets
                    //                         .only(
                    //                     left: 5.0,
                    //                     right: 2.5),
                    //             child: Center(
                    //               child: Text(
                    //                 "Size : ${details['size']}",
                    //                 style: TextStyle(
                    //                   color: Color(
                    //                       0xff515151),
                    //                   fontSize: 12,
                    //                   fontFamily:
                    //                       "Poppins",
                    //                   fontWeight:
                    //                       FontWeight
                    //                           .w300,
                    //                   letterSpacing:
                    //                       0.30,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //
                    //           // DropdownButton(
                    //           //   dropdownColor:
                    //           //       Color(0xffF2F2F2),
                    //           //   style: TextStyle(
                    //           //     color:
                    //           //         Color(0xff515151),
                    //           //     fontSize: 12,
                    //           //
                    //           //     fontWeight:
                    //           //         FontWeight.w300,
                    //           //     letterSpacing: 0.30,
                    //           //   ),
                    //           //   value: details['size'],
                    //           //   elevation: 0,
                    //           //   underline: Container(
                    //           //     width: 0,
                    //           //     height: 0,
                    //           //   ),
                    //           //   items: [
                    //           //     if (details['item'][
                    //           //                 'size'] !=
                    //           //             null &&
                    //           //         details['item']
                    //           //                 ['size']
                    //           //             is List)
                    //           //       ...(details['item']
                    //           //                   ['size']
                    //           //               as List)
                    //           //           .map((e) =>
                    //           //               DropdownMenuItem(
                    //           //                 child: Text(
                    //           //                     "$e"),
                    //           //                 value: e,
                    //           //                 onTap:
                    //           //                     () async {
                    //           //                   if (mounted)
                    //           //                     setState(
                    //           //                         () {
                    //           //                       isLoading =
                    //           //                           true;
                    //           //                     });
                    //           //                   CartBloc
                    //           //                       cBloc =
                    //           //                       CartBloc();
                    //           //                   await cBloc
                    //           //                       .removeItemFromCart(
                    //           //                     key,
                    //           //                   );
                    //           //                   print("item removed");
                    //           //                   await cBloc.addItemToCart(
                    //           //                       details['item'][
                    //           //                           'id'],
                    //           //                       1,
                    //           //                       size:
                    //           //                           e);
                    //           //                   print("item added again");
                    //           //                   if (mounted)
                    //           //                     setState(
                    //           //                         () {
                    //           //                       isLoading =
                    //           //                           false;
                    //           //                     });
                    //           //                 },
                    //           //               ))
                    //           //           .toList(),
                    //           //   ],
                    //           //   onChanged: (x) {},
                    //           // )
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
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
                              child: Container(
                                decoration: BoxDecoration(
                                    color: Color(0xffF2F2F2),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5.0, right: 2.5),
                                      child: Center(
                                        child: Text(
                                          "Qty : ",
                                          style: TextStyle(
                                            color: Color(0xff515151),
                                            fontSize: 12,
                                            fontWeight: FontWeight.w300,
                                            letterSpacing: 0.30,
                                          ),
                                        ),
                                      ),
                                    ),
                                    DropdownButton(
                                      dropdownColor: Color(0xffF2F2F2),
                                      style: TextStyle(
                                        color: Color(0xff515151),
                                        fontSize: 12,
                                        fontWeight: FontWeight.w300,
                                        letterSpacing: 0.30,
                                      ),
                                      value: 0,
                                      elevation: 0,
                                      underline: Container(
                                        width: 0,
                                        height: 0,
                                      ),
                                      items: [
                                        if (details['qty'] > 1)
                                          DropdownMenuItem(
                                            child: Text("-1"),
                                            value: -1,
                                            onTap: () async {
                                              if (mounted)
                                                setState(() {
                                                  isLoading = true;
                                                });
                                              await snapshot.reduceByOne(
                                                  details['item']['id'], itemID,
                                                  sizePrice: sizePrice,
                                                  sizeQty: details['size_qty']);
                                              if (mounted)
                                                setState(() {
                                                  isLoading = false;
                                                });
                                            },
                                          ),
                                        DropdownMenuItem(
                                          child: Text("${details['qty']}"),
                                          value: 0,
                                        ),
                                        DropdownMenuItem(
                                          child: Text("+1"),
                                          value: 1,
                                          onTap: () async {
                                            if (mounted)
                                              setState(() {
                                                isLoading = true;
                                              });
                                            await snapshot.addByOne(
                                                details['item']['id'], itemID,
                                                sizePrice: sizePrice,
                                                getCartItem: false,
                                                sizeQty: details['size_qty']);
                                            if (mounted)
                                              setState(() {
                                                isLoading = false;
                                              });
                                          },
                                        )
                                      ],
                                      onChanged: (x) {},
                                    )
                                  ],
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 0,
                                child: IconButton(
                                    icon: Icon(Icons.delete_outline),
                                    onPressed: () async {
                                      if (mounted)
                                        setState(() {
                                          isLoading = true;
                                        });
                                      await snapshot.removeItemFromCart(itemID);
                                      if (mounted)
                                        setState(() {
                                          isLoading = false;
                                        });
                                    }))
                          ],
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

  void checkOut() async {
    if (mounted)
      setState(() {
        isLoading = true;
      });
    AuthBloc _authBloc = Provider.of<AuthBloc>(context, listen: false);
    if (_authBloc.userData.length > 0) {
      Navigator.push(
          context,
          MaterialPageRoute(
              builder: (c) => AddAddress(
                    checkOutData: checkOutData,
                  )));
    } else {
      await Navigator.push(
          context, MaterialPageRoute(builder: (c) => SignIn()));
      AuthBloc _authBloc1 = Provider.of<AuthBloc>(context, listen: false);
      if (_authBloc1.userData.length > 0) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (c) => AddAddress(
                      checkOutData: checkOutData,
                    )));
      } else
        Fluttertoast.showToast(msg: "Please Login To Proceed");
    }
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }
}
