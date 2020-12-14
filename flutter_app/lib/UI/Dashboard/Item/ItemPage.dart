import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:provider/provider.dart';

class ItemPage extends StatefulWidget {
  final String itemSlug;

  const ItemPage({Key key, this.itemSlug}) : super(key: key);

  @override
  _ItemPageState createState() => _ItemPageState();
}

class _ItemPageState extends State<ItemPage> {
  String selectedSize;

  @override
  Widget build(BuildContext context) {
    AppErrorBloc errorBloc = Provider.of<AppErrorBloc>(context);
    print(widget.itemSlug);
    return FutureBuilder<Response>(
      future: ItemBloc.getItemBySlug(widget.itemSlug, errorBloc),
      builder: (c, s) {
        if (s.data == null)
          return Material(child: Center(child: Text("Loading")));
        else {
          Map data = s.data.data ?? {};
          Map productData = data["product"];

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
                    onTap: () {Navigator.pushNamed(context,  "WishList");},
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    focusColor: Colors.transparent,
                    splashColor: Colors.transparent,
                    child: Image.asset(
                      "assets/cart.png",
                      width: 20,
                      height: 20,
                    ),
                    onTap: () {Navigator.pushNamed(context,  "ShoppingBag");},
                  ),
                ),
              ],
              iconTheme: IconThemeData(color: Colors.black),
            ),
            body: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Container(
                  color: Colors.white,
                  child: Stack(
                    children: [
                      Container(
                        height: MediaQuery.of(context).size.height / 2.5,
                        child: CachedNetworkImage(
                          imageUrl:
                              "${Constants.BASE_URL}/assets/images/products/${productData['photo']}",
                          fit: BoxFit.fitHeight,
                          width: double.infinity,
                        ),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 10,
                        child: Row(
                          children: [
                            Text(
                              "4.2",
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 12,
                                letterSpacing: 0.24,
                              ),
                            ),
                            Icon(
                              Icons.star,
                              color: Color(0xffF2EB33),
                              size: 16,
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
                Container(
                  color: Colors.white,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(
                            left: 20.0, top: 5, bottom: 5),
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
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              child: Text(
                                "\u20B9 ${productData['price'].toString().substring(0, 4)}",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 15,
                                ),
                              ),
                            ),
                            if ((productData['previous_price'] ?? 0) != 0)
                              Expanded(
                                child: Text(
                                  "\u20B9 ${productData['previous_price'].toString().substring(0, 4)}",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15,
                                      color: Color(0xffA9A9A9),
                                      decoration: TextDecoration.lineThrough),
                                ),
                              ),
                            if ((productData['is_discount'] ?? 0) > 0)
                              Expanded(
                                child: Text(
                                  "${productData['whole_sell_discount']}% Off",
                                  maxLines: 1,
                                  style: TextStyle(
                                      fontSize: 15, color: Colors.red),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                if (productData['size'] is List &&
                    productData['size'].length > 0)
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
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 15),
                              child: Text(
                                "Select Size",
                                style: TextStyle(
                                  color: Colors.black,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 20.0),
                              child: Wrap(
                                alignment: WrapAlignment.start,
                                crossAxisAlignment: WrapCrossAlignment.start,
                                runSpacing: 8,
                                spacing: 8,
                                children: [
                                  ...(productData['size'] as List).map((s) {
                                    bool selected = selectedSize == s;
                                    return InkWell(
                                      borderRadius: BorderRadius.circular(4),
                                      onTap: () {
                                        if (productData['size_qty'].length == 0)
                                          return;
                                        if (selected)
                                          selectedSize = "";
                                        else
                                          selectedSize = s;
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
                                          color:
                                              (productData['size_qty'].length ==
                                                      0)
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
                                                  right: ((productData[
                                                                  'size_qty']
                                                              is List) &&
                                                          productData['size_qty']
                                                                  .length >
                                                              6)
                                                      ? 10
                                                      : 0),
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
                                            if (productData['size_qty']
                                                    is List &&
                                                productData['size_qty'].length >
                                                    0 &&
                                                productData['size_qty'].length <
                                                    6)
                                              Transform.translate(
                                                offset: Offset(0, -20),
                                                child: Container(
                                                  width: 25,
                                                  height: 25,
                                                  decoration: BoxDecoration(
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            160),
                                                    color: Color(0xffdc0f21),
                                                  ),
                                                  child: Center(
                                                    child: Text(
                                                      "${(productData['size_qty'] as List).elementAt((productData['size'] as List).indexOf(s))} Left",
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
                Padding(
                  padding: const EdgeInsets.only(top: 10),
                  child: Container(
                    color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                                const EdgeInsets.only(left: 20.0, bottom: 10),
                            child: Text(
                              "Check Delivery",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Container(
                              height: 50,
                              child: TextField(
                                style: TextStyle(
                                  fontSize: 12,
                                ),
                                decoration: InputDecoration(
                                    hintText: "Enter PIN Code",
                                    hintStyle: TextStyle(
                                      color: Color(0xffdc0f21),
                                      fontSize: 10,
                                    ),
                                    focusedBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: Color(0xff979797))),
                                    enabledBorder: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(4),
                                        borderSide: BorderSide(
                                            color: Color(0xff979797)))),
                              ),
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
                ),
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
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(right: 5.0),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Color(0xff7B8387),
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "Wishlist",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                            child: Padding(
                              padding: const EdgeInsets.only(left: 5.0),
                              child: FlatButton(
                                onPressed: () {
                                  Navigator.pop(context);
                                },
                                color: Color(0xffDC0F21),
                                height: 60,
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(8)),
                                child: Text(
                                  "Add to Cart",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.only(top:10.0),
                  child: Container(color: Colors.white,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Column(crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 20.0, bottom: 2),
                            child: Text(
                              "Easy 30 days return and exchange",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          Padding(
                            padding:
                            const EdgeInsets.only(left: 20.0,right: 20),
                            child: Text("Choose to return or exchange for a different size (if available) within 30 days", ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                // Row(children: [
                //   Image.asset("asstes/trophy.png"),
                //   Image.asset("asstes/lightAward.png"),
                //   Image.asset("asstes/freshTag.png"),
                // ],)
              ],
            ),
          );
        }
      },
    );
  }
}
