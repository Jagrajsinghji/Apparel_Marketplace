import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/ProductRateIcon.dart';
import 'package:flutter_app/UI/Components/SearchIcon.dart';
import 'package:flutter_app/UI/Components/WishListIcon.dart';
import 'package:flutter_app/UI/Dashboard/Cart/ShoppingBag.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';

class AlRecentProds extends StatefulWidget {
  final List products;

  const AlRecentProds({Key key, this.products}) : super(key: key);

  @override
  _AlRecentProdsState createState() => _AlRecentProdsState();
}

class _AlRecentProdsState extends State<AlRecentProds> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
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
          "Recently Viewed Products",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 14,fontFamily: goggleFont
          ),
        ),
        actions: [
          SearchIcon(),
          WishListIcon(),
          CartIcon(
            globalKey: _scaffoldKey,
          )
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      endDrawer: ShoppingBag(),
      body: Padding(
        padding: const EdgeInsets.only(bottom: 10.0, right: 5, left: 5),
        child: GridView.builder(
            itemCount: widget.products?.length,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              childAspectRatio: .6,
              crossAxisCount: 2,
            ),
            itemBuilder: (c, i) {
              Map data = (widget.products.elementAt(i) ?? {})['product'];
              String shopName = (data['user'] ?? {})['shop_name'];
              double newPrice = double.parse(data['price']?.toString());
              double prevPrice =
                  double.parse(data['previous_price']?.toString() ?? "0");
              int discount = 0;
              if (prevPrice > 0)
                discount = (((prevPrice - newPrice) / prevPrice) * 100).round();
              //TODO: ask ravjot to send currency value
              double currency = 68.95;
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: InkWell(
                  onTap: () {
                    Navigator.of(context).push(SlideLeftPageRouteBuilder(
                        pageBuilder: (c, a, b) => ItemPage(
                              itemSlug: data['slug'],
                            )));
                  },
                  key: Key(data['id']?.toString() ?? "$i"),
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300),
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
                                    "${Session.IMAGE_BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                              ),
                            ),
                          ),
                        ),
                        // Expanded(
                        //   flex: 0,
                        //   child: Padding(
                        //     padding: const EdgeInsets.only(left: 5.0),
                        //     child: Align(
                        //       alignment: Alignment.centerLeft,
                        //       child: Text(
                        //         shopName ?? "",
                        //         maxLines: 2,
                        //         textAlign: TextAlign.start,
                        //         style: TextStyle(
                        //           color: Colors.black54,
                        //           fontSize: 10,
                        //           letterSpacing: 0.45,
                        //         ),
                        //       ),
                        //     ),
                        //   ),
                        // ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Expanded(
                                  child: Text(
                                    data['name'] ?? "",
                                    maxLines: 2,
                                    textAlign: TextAlign.start,
                                    style: TextStyle(
                                      color: Color(0xff515151),
                                      fontSize: 14,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.45,
                                    ),
                                  ),
                                ),
                                // Padding(
                                //   padding:
                                //       const EdgeInsets.all(
                                //           4.0),
                                //   child: Row(
                                //     children: [
                                //       Text(
                                //         "4.2",
                                //         style: TextStyle(
                                //           color: Color(
                                //               0xff515151),
                                //           fontSize: 12,
                                //           letterSpacing: 0.24,
                                //         ),
                                //       ),
                                //       Icon(
                                //         Icons.star,
                                //         color:
                                //             Color(0xffF2EB33),
                                //         size: 16,
                                //       ),
                                //     ],
                                //   ),
                                // )
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(
                                top: 5, left: 5.0, bottom: 10, right: 4),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              crossAxisAlignment: CrossAxisAlignment.center,
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
                                if (prevPrice != 0 && prevPrice != newPrice)
                                  Expanded(
                                    flex: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "\u20B9 ${(prevPrice * currency).round()}",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffA9A9A9),
                                            decoration:
                                                TextDecoration.lineThrough),
                                      ),
                                    ),
                                  ),
                                if (discount > 0)
                                  Expanded(
                                    flex: 0,
                                    child: Padding(
                                      padding: const EdgeInsets.only(left: 5.0),
                                      child: Text(
                                        "$discount% Off",
                                        maxLines: 1,
                                        style: TextStyle(
                                            fontSize: 14,
                                            color: Color(0xffDC0F21)),
                                      ),
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 5, bottom: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  flex: 0,
                                  child: ProductRateIcon(
                                    productData: data,
                                  ),
                                ),
                                Expanded(
                                  child: AddToWishListIcon(
                                    productsData: data,
                                  ),
                                ),
                                Expanded(
                                  child: AddToCartIcon(
                                    productData: data,
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
              );
            }),
      ),
    );
  }
}
