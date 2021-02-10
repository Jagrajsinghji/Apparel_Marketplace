import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Components/ProductRateIcon.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:google_fonts/google_fonts.dart';

import 'ViewAll.dart';

class Product4GridWIthThumbnail extends StatefulWidget {
  final List productData;
  final String title, filter;

  const Product4GridWIthThumbnail(
      {Key key, this.productData, this.title, @required this.filter})
      : super(key: key);

  @override
  _Product4GridWIthThumbnailState createState() =>
      _Product4GridWIthThumbnailState();
}

class _Product4GridWIthThumbnailState extends State<Product4GridWIthThumbnail> {
  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width - 30, height = 460;
    int itemCount = widget.productData?.length ?? 0;
    if (itemCount % 4 != 0) {
      itemCount = itemCount - (itemCount % 4);
    }
    return itemCount == 0
        ? SliverList(
            delegate: SliverChildListDelegate([]),
          )
        : SliverList(
            delegate: SliverChildListDelegate([
            Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: RichText(
                    text: TextSpan(
                        text: "${widget.title.split(" ").first}",
                        style: TextStyle(
                          color: Color(0xffdc0f21),
                          fontSize: 15,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.45,fontFamily:goggleFont
                        ),
                        children: [
                          TextSpan(
                            text: " ${widget.title.split(" ").last}",
                            style: TextStyle(
                              color: Colors.black,
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
            ),
            Container(
              height: height,
              child: ListView(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                children: [
                  ...List.generate((itemCount ~/ 4), (index) {
                    List listOf4 = [];
                    listOf4.addAll(widget.productData
                        .getRange((index * 4), (index * 4) + 4));
                    return Center(
                      child: Container(
                        width: width,
                        child: Wrap(
                          children: [
                            ...listOf4.map((e) {
                              Map data = e ?? {};
                              double newPrice =
                                  double.parse(data['price']?.toString());
                              double prevPrice = double.parse(
                                  data['previous_price']?.toString() ?? "0");
                              int discount = 0;
                              if (prevPrice > 0)
                                discount =
                                    (((prevPrice - newPrice) / prevPrice) * 100)
                                        .round();
                              double currency = double.parse(
                                  (data['curr'] ?? {})['value']?.toString() ??
                                      "68.95");
                              return Container(
                                height: height / 2,
                                width: width / 2,
                                child: Padding(
                                  padding: const EdgeInsets.all(1.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          SlideLeftPageRouteBuilder(
                                              pageBuilder: (c, a, b) =>
                                                  ItemPage(
                                                    itemSlug: data['slug'],
                                                  )));
                                    },
                                    key: Key(data['id']?.toString() ?? "$e"),
                                    borderRadius: BorderRadius.circular(8),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
                                          border: Border.all(
                                              color: Colors.grey.shade300),
                                          borderRadius:
                                              BorderRadius.circular(8)),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.center,
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        children: [
                                          Expanded(
                                            flex: 1,
                                            child: Container(
                                              color: Colors.white,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${Session.IMAGE_BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                              flex: 0,
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.only(
                                                        left: 4,
                                                        right: 4,
                                                        top: 4,
                                                        bottom: 4),
                                                child: Text(
                                                  "${data['name']}",
                                                  maxLines: 2,
                                                  textAlign:
                                                      TextAlign.start,
                                                  style: TextStyle(
                                                    color: Colors.black,
                                                    fontSize: 12,
                                                    letterSpacing: 0.45,
                                                  ),
                                                ),
                                              )),
                                          Expanded(
                                            flex: 0,
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 5, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.start,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  Expanded(
                                                    flex: 0,
                                                    child: Text(
                                                      "\u20B9 ${((newPrice) * currency).round()}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 14,
                                                      ),
                                                    ),
                                                  ),
                                                  if (prevPrice != 0 &&
                                                      prevPrice != newPrice)
                                                    Expanded(
                                                      flex: 0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: Text(
                                                          "\u20B9 ${(prevPrice * currency).round()}",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 12,
                                                              color: Color(
                                                                  0xffA9A9A9),
                                                              decoration:
                                                                  TextDecoration
                                                                      .lineThrough),
                                                        ),
                                                      ),
                                                    ),
                                                  if (discount > 0)
                                                    Expanded(
                                                      flex: 0,
                                                      child: Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
                                                        child: Text(
                                                          "$discount% Off",
                                                          maxLines: 1,
                                                          style: TextStyle(
                                                              fontSize: 14,
                                                              color: Color(
                                                                  0xffDC0F21)),
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
                                              padding:
                                                  const EdgeInsets.only(
                                                      left: 5, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment
                                                        .center,
                                                children: [
                                                  Expanded(flex: 0,child: ProductRateIcon(productData: data,),),
                                                  Expanded(
                                                    child:
                                                        AddToWishListIcon(
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
                                ),
                              );
                            })
                          ],
                        ),
                      ),
                    );
                  }),
                  InkWell(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (c) => ViewAllPage(title: widget.title,
                                    filters: widget.filter,
                                  )));
                    },borderRadius:BorderRadius.circular(8),
                    child: Container(
                      width: 150,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.explore),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text("Explore More"),
                          )
                        ],
                      ),
                    ),
                  )
                ],
              ),
            ),
          ]));
  }
}
