import 'dart:math';
import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Dashboard/Cart/WishList.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';
import 'package:shimmer/shimmer.dart';

import 'SliderDots.dart';

class ItemPage extends StatefulWidget {
  final String itemSlug;

  const ItemPage({Key key, this.itemSlug}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String selectedSize = "", selectedSizeKey = "0", selectedSizeQty = "0";
  String selectedColor = "";
  double selectedSizePrice = 0;

  bool alreadyAdded = false, outOfStock = false;
  Map<String, Map<String, String>> sizeMap = {};
  PageController _pageController = PageController();
  GlobalKey _dotsKey = GlobalKey();
  bool isLoading = false;

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = Provider.of<CartBloc>(context);
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
        actions: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: InkWell(
              focusColor: Colors.transparent,
              splashColor: Colors.transparent,
              child: Image.asset(
                "assets/favourite.png",
                width: 20,
                height: 20,
              ),
              onTap: () {
                Navigator.push(
                    context,
                    PageRouteBuilder(
                        transitionDuration: Duration(seconds: 1),
                        reverseTransitionDuration: Duration(milliseconds: 800),
                        pageBuilder: (c, a, b) => WishList()));
              },
            ),
          ),
          CartIcon()
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: Stack(
        children: [
          FutureBuilder<Response>(
            future: ItemBloc().getItemBySlug(widget.itemSlug),
            builder: (c, snapshotItem) {
              if (snapshotItem.data == null)
                return Shimmer(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Colors.grey.shade400,
                        Colors.white60,
                        Colors.redAccent,
                        Colors.grey.shade200,
                        Colors.grey.shade400
                      ],
                      stops: const <double>[
                        0.0,
                        0.35,
                        0.45,
                        0.55,
                        1.0
                      ]),
                  child: ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: MediaQuery.of(context).size.height / 2.5,
                          decoration: BoxDecoration(
                              color: Colors.grey,
                              borderRadius: BorderRadius.circular(8)),
                        ),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 5, bottom: 5),
                            child: Container(
                              width: 200,
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 5, bottom: 5, right: 20),
                            child: Container(
                              height: 20,
                              decoration: BoxDecoration(
                                  color: Colors.grey,
                                  borderRadius: BorderRadius.circular(8)),
                            ),
                          ),
                        ],
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, bottom: 15),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8)),
                                  height: 25,
                                  width: 100,
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 20.0),
                                child: Wrap(
                                  alignment: WrapAlignment.start,
                                  crossAxisAlignment: WrapCrossAlignment.start,
                                  runSpacing: 8,
                                  spacing: 8,
                                  children: [
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey),
                                      width: 35,
                                      height: 35,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey),
                                      width: 35,
                                      height: 35,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey),
                                      width: 35,
                                      height: 35,
                                    ),
                                    Container(
                                      decoration: BoxDecoration(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          color: Colors.grey),
                                      width: 35,
                                      height: 35,
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, bottom: 10),
                                child: Container(
                                  height: 25,
                                  width: 150,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 20),
                                child: Container(
                                  height: 50,
                                  decoration: BoxDecoration(
                                      color: Colors.grey,
                                      borderRadius: BorderRadius.circular(8)),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20, right: 20, top: 10),
                                child: Text(
                                  "Pay on delivery might be available\nTry & buy might be available",
                                  style: TextStyle(
                                    color: Color(0xff969696),
                                    fontSize: 10,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.only(right: 5.0),
                                  child: Container(
                                    height: 60,
                                    decoration: BoxDecoration(
                                        color: Colors.grey,
                                        borderRadius: BorderRadius.circular(8)),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, bottom: 2),
                                child: Text(
                                  "Easy 30 days return and exchange",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: Text(
                                  "Choose to return or exchange for a different size (if available) within 30 days",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      Container(
                        height: 60,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Image.asset(
                              "assets/trophy.png",
                              height: 20,
                              width: 20,
                            ),
                            Image.asset(
                              "assets/lightAward.png",
                              height: 20,
                              width: 20,
                            ),
                            Image.asset(
                              "assets/freshTag.png",
                              height: 20,
                              width: 20,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                );
              else {
                Map data = snapshotItem.data.data ?? {};
                Map productData = data["product"];
                sizeMap = mapSizeToQty(data);

                outOfStock = ((sizeMap.values
                        .every((element) => element['qty'] == "0")) &&
                    (productData['stock'] == null));
                var colorsList = productData['color'] ?? [];
                if (colorsList is List && colorsList.length > 0)
                  selectedColor = colorsList.first;
                else if (colorsList is String) selectedColor = colorsList;
                String itemId = productData['id'].toString() +
                    selectedSize.trim().replaceAll(" ", "-") +
                    selectedColor;

                Map cartProds = (_cartBloc.cartData ?? {})['products'] ?? {};
                alreadyAdded = cartProds.containsKey(itemId);
                var vendorName = data['shop_name'];
                double newPrice =
                    double.parse(productData['price']?.toString());
                double prevPrice = double.parse(
                    productData['previous_price']?.toString() ?? "0");
                int discount = 0;
                if (prevPrice > 0)
                  discount =
                      (((prevPrice - newPrice) / prevPrice) * 100).round();
                double currency = double.parse(
                    (data['curr'] ?? {})['value']?.toString() ?? "68.95");
                List gallery = data['galleries_images_array'];
                if (!outOfStock) {
                  if (selectedSize.trim().length == 0) {
                    selectedSize = (sizeMap.values.length > 0)
                        ? sizeMap.keys
                            .where((element) => sizeMap[element]['qty'] != "0")
                            .first
                        : "";
                    selectedSizeKey = (sizeMap.values.length > 0)
                        ? sizeMap[selectedSize]['key']
                        : "0";
                    selectedSizePrice = double.parse((sizeMap.values.length > 0)
                        ? sizeMap[selectedSize]['price']
                        : "0");
                    selectedSizeQty = (sizeMap.values.length > 0)
                        ? sizeMap[selectedSize]['qty']
                        : "0";
                  }
                }
                return ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(
                      height: MediaQuery.of(context).size.height / 2.5,
                      color: Colors.white,
                      child: Stack(
                        children: [
                          PageView.builder(
                              controller: _pageController,
                              itemCount: (gallery?.length ?? 0) + 1,
                              itemBuilder: (c, i) {
                                if (i == 0) {
                                  return CachedNetworkImage(
                                    imageUrl:
                                        "${Session.IMAGE_BASE_URL}/assets/images/products/${productData['photo']}",
                                    fit: BoxFit.fitHeight,
                                    width: double.infinity,
                                  );
                                }
                                i -= 1;
                                return CachedNetworkImage(
                                  imageUrl:
                                      "${Session.IMAGE_BASE_URL}/assets/images/galleries/${gallery.elementAt(i)}",
                                  fit: BoxFit.fitHeight,
                                  width: double.infinity,
                                );
                              }),
                          // Positioned(
                          //   bottom: 0,
                          //   right: 10,
                          //   child: Row(
                          //     children: [
                          //       Text(
                          //         "4.2",
                          //         style: TextStyle(
                          //           color: Color(0xff515151),
                          //           fontSize: 12,
                          //           letterSpacing: 0.24,
                          //         ),
                          //       ),
                          //       Icon(
                          //         Icons.star,
                          //         color: Color(0xffF2EB33),
                          //         size: 16,
                          //       ),
                          //     ],
                          //   ),
                          // )
                        ],
                      ),
                    ),
                    SliderDots(
                      length: gallery.length ?? 0,
                      pageController: _pageController,
                    ),
                    Container(
                      color: Colors.white,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 5, bottom: 5),
                            child: Text(
                              "$vendorName",
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 15,
                                letterSpacing: 0.45,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 5),
                            child: Text(
                              "${productData['name']}",
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 15,
                                letterSpacing: 0.45,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 20.0, top: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: Text(
                                    "\u20B9 ${((newPrice + selectedSizePrice) * currency).round()}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                if (prevPrice != 0)
                                  Expanded(
                                    flex: 0,
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "\u20B9 ${(prevPrice * currency).round()}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xffA9A9A9),
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                  ),
                                if (discount > 0)
                                  Expanded(
                                    child: Padding(
                                      padding:
                                          const EdgeInsets.only(left: 10.0),
                                      child: Text(
                                        "$discount% Off",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 15,
                                            color: Color(0xffDC0F21)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                          if (outOfStock)
                            Padding(
                              padding: const EdgeInsets.only(
                                  left: 20.0, top: 5, bottom: 5),
                              child: Text(
                                "Out of Stock",
                                maxLines: 1,
                                style: TextStyle(
                                    fontSize: 15, color: Color(0xffDC0F21)),
                              ),
                            ),
                        ],
                      ),
                    ),

                    ///Size
                    if (sizeMap.length > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 15),
                                  child: Text(
                                    "Select Size",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    runSpacing: 8,
                                    spacing: 8,
                                    children: [
                                      ...sizeMap.entries.map((s) {
                                        bool selected = selectedSize == s.key;
                                        return InkWell(
                                          borderRadius:
                                              BorderRadius.circular(4),
                                          onTap: () {
                                            if (s.value['qty'] == "0") return;
                                            selectedSize = s.key;
                                            selectedSizeKey = s.value['key'];
                                            selectedSizeQty = s.value['qty'];
                                            selectedSizePrice =
                                                double.parse(s.value['price']);
                                            if (mounted) setState(() {});
                                          },
                                          child: Container(
                                            decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Color(0xff969696),
                                                width: 1,
                                              ),
                                              color: (s.value['qty'] == "0")
                                                  ? Color(0xffE3E3E3)
                                                  : selected
                                                      ? Color(0xff686868)
                                                      : Colors.white,
                                            ),
                                            child: Row(
                                              mainAxisSize: MainAxisSize.min,
                                              children: [
                                                Padding(
                                                  padding: EdgeInsets.only(
                                                      left: 10.0,
                                                      top: 10,
                                                      bottom: 10,
                                                      right: int.parse(s.value[
                                                                      'qty']) ==
                                                                  0 ||
                                                              int.parse(s.value[
                                                                      'qty']) >=
                                                                  6
                                                          ? 10
                                                          : 0),
                                                  child: Text(
                                                    "${s.key}",
                                                    style: TextStyle(
                                                      color: selected
                                                          ? Colors.white
                                                          : Color(0xff969696),
                                                      fontSize: 14,
                                                    ),
                                                  ),
                                                ),
                                                if (int.parse(s.value['qty']) >
                                                        0 &&
                                                    int.parse(s.value['qty']) <
                                                        6)
                                                  Transform.translate(
                                                    offset: Offset(0, -20),
                                                    child: Container(
                                                      width: 25,
                                                      height: 25,
                                                      decoration: BoxDecoration(
                                                        borderRadius:
                                                            BorderRadius
                                                                .circular(160),
                                                        color:
                                                            Color(0xffdc0f21),
                                                      ),
                                                      child: Center(
                                                        child: Text(
                                                          "${s.value['qty']} Left",
                                                          style: TextStyle(
                                                            color: Colors.white,
                                                            fontSize: 8,
                                                          ),
                                                        ),
                                                      ),
                                                    ),
                                                  )
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                    ///Colors
                    if (selectedColor.trim().length > 0)
                      Padding(
                        padding: const EdgeInsets.only(top: 10.0),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, bottom: 15),
                                  child: Text(
                                    "Select Color",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 16,
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 20.0),
                                  child: Wrap(
                                    alignment: WrapAlignment.start,
                                    crossAxisAlignment:
                                        WrapCrossAlignment.start,
                                    runSpacing: 8,
                                    spacing: 8,
                                    children: [
                                      if (colorsList is List)
                                        ...colorsList.map((s) {
                                          bool selected = selectedColor == s;
                                          return InkWell(
                                            borderRadius:
                                                BorderRadius.circular(4),
                                            onTap: () {
                                              selectedColor = s;
                                              if (mounted) setState(() {});
                                            },
                                            child: Container(
                                              decoration: BoxDecoration(
                                                borderRadius:
                                                    BorderRadius.circular(4),
                                                border: Border.all(
                                                  color: Color(0xff969696),
                                                  width: 1,
                                                ),
                                                color: selected
                                                    ? Color(0xff686868)
                                                    : Colors.white,
                                              ),
                                              child: Row(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Padding(
                                                    padding: EdgeInsets.only(
                                                        left: 10.0,
                                                        top: 10,
                                                        bottom: 10,
                                                        right: 10),
                                                    child: Text(
                                                      "$s",
                                                      style: TextStyle(
                                                        color: selected
                                                            ? Colors.white
                                                            : Color(0xff969696),
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          );
                                        }).toList()
                                      else
                                        Container(
                                          decoration: BoxDecoration(
                                              borderRadius:
                                                  BorderRadius.circular(4),
                                              border: Border.all(
                                                color: Color(0xff969696),
                                                width: 1,
                                              ),
                                              color: Color(0xff686868)),
                                          child: Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              Padding(
                                                padding: EdgeInsets.only(
                                                    left: 10.0,
                                                    top: 10,
                                                    bottom: 10,
                                                    right: 10),
                                                child: Text(
                                                  "$selectedColor",
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 14,
                                                  ),
                                                ),
                                              ),
                                            ],
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

                    ///Check Delivery

                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10),
                    //   child: Container(
                    //     color: Colors.white,
                    //     child: Padding(
                    //       padding: const EdgeInsets.symmetric(vertical: 10),
                    //       child: Column(
                    //         crossAxisAlignment: CrossAxisAlignment.start,
                    //         children: [
                    //           Padding(
                    //             padding:
                    //                 const EdgeInsets.only(left: 20.0, bottom: 10),
                    //             child: Text(
                    //               "Check Delivery",
                    //               style: TextStyle(
                    //                 color: Colors.black,
                    //                 fontSize: 16,
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding:
                    //                 const EdgeInsets.symmetric(horizontal: 20),
                    //             child: Container(
                    //               height: 50,
                    //               child: TextField(
                    //                 style: TextStyle(
                    //                   fontSize: 12,
                    //                 ),
                    //                 decoration: InputDecoration(
                    //                     hintText: "Enter PIN Code",
                    //                     hintStyle: TextStyle(
                    //                       color: Color(0xffdc0f21),
                    //                       fontSize: 10,
                    //                     ),
                    //                     focusedBorder: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(4),
                    //                         borderSide: BorderSide(
                    //                             color: Color(0xff979797))),
                    //                     enabledBorder: OutlineInputBorder(
                    //                         borderRadius:
                    //                             BorderRadius.circular(4),
                    //                         borderSide: BorderSide(
                    //                             color: Color(0xff979797)))),
                    //               ),
                    //             ),
                    //           ),
                    //           Padding(
                    //             padding: const EdgeInsets.only(
                    //                 left: 20, right: 20, top: 10),
                    //             child: Text(
                    //               "Pay on delivery might be available\nTry & buy might be available",
                    //               style: TextStyle(
                    //                 color: Color(0xff969696),
                    //                 fontSize: 10,
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Expanded(
                              //   child: Padding(
                              //     padding: const EdgeInsets.only(right: 5.0),
                              //     child: FlatButton(
                              //       onPressed: () {
                              //         Navigator.pop(context);
                              //       },
                              //       color: Color(0xff7B8387),
                              //       height: 60,
                              //       shape: RoundedRectangleBorder(
                              //           borderRadius: BorderRadius.circular(8)),
                              //       child: Text(
                              //         "Wishlist",
                              //         style: TextStyle(
                              //           color: Colors.white,
                              //           fontSize: 14,
                              //         ),
                              //       ),
                              //     ),
                              //   ),
                              // ),
                              Expanded(
                                child: redButton(alreadyAdded, productData),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),

                    ///Reviews
                    // Padding(
                    //   padding: const EdgeInsets.only(top: 10.0),
                    //   child: Container(
                    //     color: Colors.white,
                    //     child: Padding(
                    //       padding: const EdgeInsets.all(20),
                    //       child: Row(mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    //         children: [
                    //           Expanded(flex: 3,
                    //             child: Padding(
                    //               padding: const EdgeInsets.symmetric(horizontal: 5),
                    //               child: Text(
                    //                 "Reviews by certified customers",
                    //                 style: TextStyle(
                    //                   color: Colors.black,
                    //                   fontSize: 16,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //           Expanded(flex: 0,
                    //             child: Padding(
                    //               padding: const EdgeInsets.symmetric(horizontal: 5),
                    //               child: Row(mainAxisSize: MainAxisSize.min,
                    //                 children: [
                    //                   Text(
                    //                     "4.2",
                    //                     style: TextStyle(
                    //                       color: Color(0xff515151),
                    //                       fontSize: 16,
                    //                       letterSpacing: 0.24,
                    //                     ),
                    //                   ),
                    //                   Icon(
                    //                     Icons.star,
                    //                     color: Color(0xffF2EB33),
                    //                     size: 18,
                    //                   ),
                    //                 ],
                    //               ),
                    //             ),
                    //           ),
                    //           Expanded(flex: 0,
                    //             child: Padding(
                    //               padding: const EdgeInsets.symmetric(horizontal: 5),
                    //               child: Text(
                    //                 "74 Ratings &\n29 Reviews",
                    //                 textAlign: TextAlign.right,
                    //                 style: TextStyle(
                    //                   color: Color(0xff888888),
                    //                   fontSize: 10,
                    //                 ),
                    //               ),
                    //             ),
                    //           ),
                    //         ],
                    //       ),
                    //     ),
                    //   ),
                    // ),

                    ...products(
                        data['similar_products'] ?? [], "Similar Products"),

                    SizedBox(
                      height: 20,
                    ),

                    ...products(data['similar_brands'] ?? [],
                        "More products by $vendorName"),

                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, bottom: 2),
                                child: Text(
                                  "Easy 30 days return and exchange",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontSize: 16,
                                  ),
                                ),
                              ),
                              Padding(
                                padding: const EdgeInsets.only(
                                    left: 20.0, right: 20),
                                child: Text(
                                  "Choose to return or exchange for a different size (if available) within 30 days",
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 60,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Image.asset(
                            "assets/trophy.png",
                            height: 20,
                            width: 20,
                          ),
                          Image.asset(
                            "assets/lightAward.png",
                            height: 20,
                            width: 20,
                          ),
                          Image.asset(
                            "assets/freshTag.png",
                            height: 20,
                            width: 20,
                          ),
                        ],
                      ),
                    )
                  ],
                );
              }
            },
          ),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
              child: Container(
                color: Colors.black54,
                child: Center(
                    child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xffDC0F21)),
                )),
              ),
            )
        ],
      ),
    );
  }

  void addToCart(Map productData) async {
    if (mounted)
      setState(() {
        isLoading = true;
      });
    CartBloc _cartBloc = Provider.of<CartBloc>(context, listen: false);
    await _cartBloc.addItemToCart(productData['id'], 1,
        size: selectedSize,
        sizePrice: selectedSizePrice,
        sizeKey: selectedSizeKey,
        sizeQty: selectedSizeQty,
        color: selectedColor);
    if (mounted)
      setState(() {
        isLoading = false;
      });
  }

  Map<String, Map<String, String>> mapSizeToQty(Map data) {
    Map productData = data["product"];
    var size = productData['size'];
    var sizeQty = productData['size_qty'];
    var sizePrice = productData['size_price'];
    var sizeKey = data['size_key'];
    if (size is String &&
        sizeQty is String &&
        sizePrice is String &&
        sizeKey is String) {
      if (size.trim().length == 0)
        return {};
      else
        return {
          size: {"qty": sizeQty, "price": sizePrice, "key": sizeKey}
        };
    } else if (size is List &&
        sizeQty is List &&
        sizePrice is List &&
        sizeKey is List) {
      Map<String, Map<String, String>> data = {};
      for (int x = 0; x < size.length; x++)
        data.addAll({
          size.elementAt(x).toString(): {
            "qty": sizeQty.elementAt(x).toString(),
            "price": sizePrice.elementAt(x).toString(),
            "key": sizeKey.elementAt(x).toString()
          }
        });
      return data;
    } else
      return {};
  }

  Widget redButton(bool added, Map productData) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: AnimatedContainer(
            duration: Duration(milliseconds: 500),
            transform: Matrix4.translationValues(
                added ? 0 : MediaQuery.of(context).size.width, 0, 0),
            child: FlatButton(
              minWidth: double.maxFinite,
              onPressed: () {
                Navigator.pushNamed(context, "ShoppingBag");
              },
              color: Color(0xffDC0F21),
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Text(
                "Go To Bag",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 5.0),
          child: AnimatedContainer(
            padding: EdgeInsets.zero,
            duration: Duration(milliseconds: 500),
            transform: Matrix4.rotationX(!added ? 0 : -pi / 2),
            child: FlatButton(
              key: UniqueKey(),
              minWidth: double.maxFinite,
              onPressed: outOfStock ? null : () => addToCart(productData),
              color: Color(0xffDC0F21),
              disabledColor: Color(0xffDC0F21).withOpacity(.5),
              height: 60,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(100)),
              child: Text(
                "Add to Cart",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              ),
            ),
          ),
        )
      ],
    );
  }

  List<Widget> products(List data, String name) {
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 10.0,
        ),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "$name",
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color(0xff727272),
                  fontSize: 15,
                  letterSpacing: 0.45,
                ),
              ),
            ),
          ),
        ),
      ),
      Container(
        height: 250,
        color: Colors.grey.shade200,
        child: ListView.builder(
            itemCount: data.length ?? 0,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              Map prods = data.elementAt(i) ?? {};
              String tag = prods['slug'] + "ItemsPage";
              return Padding(
                key: Key(prods['id']?.toString() ?? "$i"),
                padding:
                    const EdgeInsets.symmetric(vertical: 10, horizontal: 5),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(MaterialPageRoute(
                        builder: (c) => ItemPage(
                              itemSlug: prods['slug'],
                            )));
                  },
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    width: 150,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8)),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Container(
                              color: Colors.white,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Session.IMAGE_BASE_URL}/assets/images/thumbnails/${prods['thumbnail']}",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.only(
                                  left: 4.0, right: 4, top: 4, bottom: 10),
                              child: Text(
                                "${prods['name']}",
                                maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff727272),
                                  fontSize: 12,
                                  letterSpacing: 0.45,
                                ),
                              ),
                            )),
                      ],
                    ),
                  ),
                ),
              );
            }),
      ),
    ];
  }
}
