import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
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
    return WillPopScope(
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
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          title: Hero(
            tag: "ShoppingBag",
            child: Material(
              color: Colors.transparent,
              child: Text(
                "Shopping Bag",
                style: TextStyle(
                  color: Color(0xff2c393f),
                  fontSize: 18,
                ),
              ),
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
        backgroundColor: Color(0xffE5E5E5),
        body: Stack(
          children: [
            Consumer<CartBloc>(builder: (context, snapshot, w) {
              if (snapshot.cartData.length == 0)
                return Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffDC0F21)),
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
                          refreshBlocs(context);
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
                              return productTile(key, details, snapshot);
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
                          onTap: () {
                            // Fluttertoast.showToast(msg: "Still in Development");
                            Navigator.push(context,
                                PageRouteBuilder(reverseTransitionDuration: Duration(milliseconds: 800),transitionDuration: Duration(milliseconds: 800),pageBuilder:  (c,a,b) => CheckOut()));
                          },
                          child: Hero(tag: "CheckOUtTag",
                            child: Material(color: Colors.transparent,
                              child: Container(
                                height: 60,
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
                      child: CircularProgressIndicator(
                    valueColor:
                        AlwaysStoppedAnimation<Color>(Color(0xffDC0F21)),
                  )),
                ),
              )
          ],
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

  Widget productTile(String key, Map details, CartBloc snapshot) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Container(
        height: 190,
        color: Colors.white,
        child: Row(
          children: [
            Container(
              height: double.maxFinite,
              child: CachedNetworkImage(
                imageUrl:
                    "${Session.IMAGE_BASE_URL}/assets/images/products/${details['item']['photo']}",
                fit: BoxFit.fitHeight,
              ),
              width: MediaQuery.of(context).size.width / 2.4,
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
                                                  details['item']['id'], key,
                                                  sizePrice: details['price']);
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
                                                details['item']['id'], key,
                                                sizePrice: details['price']);
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
                                      await snapshot.removeItemFromCart(key);
                                      if (mounted)
                                        setState(() {
                                          isLoading = false;
                                        });
                                    }))
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 0,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Expanded(
                            child: Text(
                              "\u20B9 ${details['price'].toString()}",
                              maxLines: 1,
                              style: TextStyle(
                                fontSize: 15,
                              ),
                            ),
                          ),
                          if ((details['previous_price'] ?? 0) != 0)
                            Expanded(
                              child: Text(
                                "\u20B9 ${details['previous_price'].toString()}",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15,
                                    color: Color(0xffA9A9A9),
                                    decoration: TextDecoration.lineThrough),
                              ),
                            ),
                          if ((details['is_discount'] ?? 0) > 0)
                            Expanded(
                              child: Text(
                                "${details['whole_sell_discount']}% Off",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xffDC0F21)),
                              ),
                            ),
                        ],
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
