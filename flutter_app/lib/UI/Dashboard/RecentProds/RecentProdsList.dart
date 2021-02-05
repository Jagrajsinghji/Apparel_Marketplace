import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/RecentProdsBloc.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Components/ProductRateIcon.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:hive/hive.dart';
import 'package:provider/provider.dart';

import 'AllRecentProducts.dart';

class RecentProdsList extends StatefulWidget {
  @override
  _RecentProdsListState createState() => _RecentProdsListState();
}

class _RecentProdsListState extends State<RecentProdsList> {
  @override
  Widget build(BuildContext context) {
    RecentProdsBloc _recentBloc = Provider.of<RecentProdsBloc>(context);
    return ValueListenableBuilder<Box>(
      valueListenable: _recentBloc.listenable,
      builder: (c, hiveBox, w) {
        List productData = hiveBox.getProducts();
        productData.sort((a, b) {
          return DateTime.parse(b['lastViewedByUser'])
              .compareTo(DateTime.parse(a['lastViewedByUser']));
        });
        int itemCount = productData?.length ?? 0;
        return itemCount == 0
            ? Container(
                width: 0,
                height: 0,
              )
            : Material(
                color: Colors.transparent,
                child: ListView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 10.0),
                      child: Container(
                        color: Colors.white,
                        child: Padding(
                          padding: const EdgeInsets.only(
                              left: 20.0, top: 10, bottom: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Align(
                                  alignment: Alignment.centerLeft,
                                  child: RichText(
                                    text: TextSpan(
                                        text: "Recently",
                                        style: TextStyle(
                                          color: Color(0xffdc0f21),
                                          fontSize: 15,
                                          fontWeight: FontWeight.bold,
                                          letterSpacing: 0.45,
                                        ),
                                        children: [
                                          TextSpan(
                                            text: " Viewed",
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.normal,
                                              fontSize: 15,
                                              letterSpacing: 0.45,
                                            ),
                                          ),
                                        ]),
                                    textAlign: TextAlign.center,
                                  )),
                              Padding(
                                padding: const EdgeInsets.only(right: 10.0),
                                child: InkWell(
                                    onTap: () {
                                      Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                              builder: (c) => AlRecentProds(
                                                products: productData,
                                              )));
                                    },
                                    child: Text("View All")),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    Container(
                      height: 250,
                      color: Colors.white,
                      child: ListView.builder(
                          itemCount: itemCount,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.horizontal,
                          itemBuilder: (c, i) {
                            Map data =
                                (productData.elementAt(i) ?? {})['product'] ??
                                    {};
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
                            return Padding(
                              key: Key(data['id']?.toString() ?? "$i"),
                              padding: const EdgeInsets.only(
                                  bottom: 10, right: 2, left: 2),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context)
                                      .push(SlideLeftPageRouteBuilder(
                                          pageBuilder: (c, a, b) => ItemPage(
                                                itemSlug: data['slug'],
                                              )));
                                },
                                borderRadius: BorderRadius.circular(8),
                                child: Material(
                                  color: Colors.transparent,
                                  child: Container(
                                    width: 160,
                                    decoration: BoxDecoration(
                                        color: Colors.white,
                                        border: Border.all(
                                            color: Colors.grey.shade300),
                                        borderRadius: BorderRadius.circular(8)),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceBetween,
                                      children: [
                                        Expanded(
                                          flex: 1,
                                          child: ClipRRect(
                                            borderRadius: BorderRadius.only(
                                                topLeft: Radius.circular(8),
                                                topRight: Radius.circular(8)),
                                            child: Container(
                                              color: Colors.white,
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${Session.IMAGE_BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                                                fit: BoxFit.fill,
                                              ),
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                            flex: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 4,
                                                  right: 4,
                                                  top: 4,
                                                  bottom: 4),
                                              child: Text(
                                                "${data['name']}",
                                                maxLines: 2,
                                                textAlign: TextAlign.start,
                                                style: TextStyle(
                                                  color: Colors.black,
                                                  fontSize: 12,
                                                  fontWeight: FontWeight.bold,
                                                  letterSpacing: 0.45,
                                                ),
                                              ),
                                            )),
                                        Expanded(
                                          flex: 0,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                                left: 5.0, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                          const EdgeInsets.only(
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
                                                          const EdgeInsets.only(
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
                                            padding: const EdgeInsets.only(
                                                left: 5, bottom: 5),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                              ),
                            );
                          }),
                    ),
                  ],
                ));
      },
    );
  }
}
