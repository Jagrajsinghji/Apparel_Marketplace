import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/UI/SignInUp/MobileLogin.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

import 'CheckOut.dart';

class ShoppingBag extends StatefulWidget {
  @override
  _ShoppingBagState createState() => _ShoppingBagState();
}

class _ShoppingBagState extends State<ShoppingBag> {
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width / 1.2;
    return SafeArea(
      child: WillPopScope(
        onWillPop: () async {
          if (isLoading) {
            if (mounted)
              setState(() {
                isLoading = false;
              });
            return false;
          }
          return true;
        },
        child: Container(
          width: width,
          color: Colors.white,
          child: Stack(
            children: [
              Align(
                alignment: Alignment.topLeft,
                child: Container(
                  height: 55,
                  child: Center(
                    child: Text(
                      "Shopping Bag",
                      style: TextStyle(
                        color: Color(0xff2c393f),
                        fontSize: 18,
                      ),
                    ),
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 55.0),
                child: Consumer<CartBloc>(builder: (context, snapshot, w) {
                  if (snapshot.cartData.length == 0)
                    return Center(
                        child: SpinKitFadingCircle(
                      color: Color(0xffDC0F21),
                    ));
                  else {
                    Map data = snapshot?.cartData ?? {};
                    Map products = data['products'] ?? {};
                    // print(products);
                    if (products.length == 0) {
                      return noProducts();
                    }
                    return Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 80.0),
                          child: SmartRefresher(
                            controller: _refreshController,
                            onRefresh: () async {
                              await Future.delayed(
                                  Duration(milliseconds: 1000));
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
                                  return productTile(
                                      key, details, snapshot, width);
                                }).toList(),
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
                              onTap: () async {
                                if (mounted)
                                  setState(() {
                                    isLoading = true;
                                  });
                                AuthBloc _authBloc = Provider.of<AuthBloc>(
                                    context,
                                    listen: false);
                                if (_authBloc.userData.length > 0) {
                                  Navigator.push(
                                      context,
                                      SlideLeftPageRouteBuilder(
                                          reverseTransitionDuration:
                                              Duration(milliseconds: 800),
                                          transitionDuration:
                                              Duration(milliseconds: 800),
                                          pageBuilder: (c, a, b) =>
                                              CheckOut()));
                                } else {
                                  Function func = () {
                                    AuthBloc _authBloc1 = Provider.of<AuthBloc>(
                                        context,
                                        listen: false);
                                    if (_authBloc1.userData.length > 0) {
                                      Navigator.push(
                                          context,
                                          SlideLeftPageRouteBuilder(
                                              reverseTransitionDuration:
                                                  Duration(milliseconds: 800),
                                              transitionDuration:
                                                  Duration(milliseconds: 800),
                                              pageBuilder: (c, a, b) =>
                                                  CheckOut()));
                                    }
                                  };

                                  await Navigator.push(
                                      context,
                                      PageRouteBuilder(
                                          opaque: false,
                                          barrierColor: Colors.black54,
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
                                          pageBuilder: (c, a, b) => MobileLogin(
                                              )));
                                  func();
                                }
                                if (mounted)
                                  setState(() {
                                    isLoading = false;
                                  });
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(600),
                                  color: Color(0xffdc0f21),
                                ),
                                child: Center(
                                  child: Text(
                                    "Check Out",
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
              ),
              if (isLoading)
                BackdropFilter(
                  filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
                  child: Container(
                    color: Colors.black26,
                    child: Center(
                        child: SpinKitFadingCircle(
                      color: Color(0xffDC0F21),
                    )),
                  ),
                )
            ],
          ),
        ),
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
          "Save items that you like in your wishlist.\nReview them anytime and easily move\nthem to bag",
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
              Navigator.pop(context);
            },
            child: Container(
              width: 150,
              height: 50,
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

  Widget productTile(
      String itemID, Map details, CartBloc snapshot, double width) {
    // print(details);
    double newPrice = double.parse(details['price']?.toString());
    double itemPrice = double.parse(details['item']['price']?.toString());

    //TODO: ask ravjot to send currency value
    double currency = 68.95;
    double sizePrice = itemPrice;
    try {
      sizePrice =
          itemPrice + double.parse(details['size_price']?.toString() ?? "0");
    } catch (err) {
      print(err.toString() + "Error In Shopping Bag");
    }
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
                width: width / 2.4,
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
                                  fontSize: 14,
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
                                            fontSize: 10,
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
                                                  sizePrice: sizePrice ?? "",
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
                                                sizePrice: sizePrice ?? "",
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
}
