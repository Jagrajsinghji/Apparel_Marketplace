import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';

class WishList extends StatefulWidget {
  @override
  _WishListState createState() => _WishListState();
}

class _WishListState extends State<WishList> {
  @override
  Widget build(BuildContext context) {
    ItemBloc _itemBloc = Provider.of<ItemBloc>(context);
    List wishListProds = _itemBloc.wishListData['wishlists'] ?? [];
    wishListProds.sort((a, b) => int.parse(b['wishlist_id'].toString())
        .compareTo(int.parse(a['wishlist_id'].toString())));
    RefreshController _refreshController =
        RefreshController(initialRefresh: false);
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          appBar: AppBar(
            title: Text(
              "WishList",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 18,
              ),
            ),
            elevation: 0,
            leading: FlatButton(
              child: Image.asset("assets/backArrow.png"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            backgroundColor: Colors.white,
            iconTheme: IconThemeData(color: Colors.black),
          ),
          backgroundColor: Colors.transparent,
          body: InkWell(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height / 1.5,
              color: Colors.white,
              child: wishListProds?.length == 0
                  ? ListView(
                      physics: BouncingScrollPhysics(),
                      children: [
                        SizedBox(
                          height: MediaQuery.of(context).size.height / 5,
                        ),
                        Center(
                          child: Text(
                            "Your Wishlist is empty",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontSize: 20,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
                        Center(
                          child: Text(
                            "Save items that you like in your wihlist.\nReview them anytime and easily move\nthem to bag",
                            style: TextStyle(
                              color: Color(0xff5b5b5b),
                              fontSize: 14,
                            ),
                          ),
                        ),
                        SizedBox(height: 20),
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
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: SmartRefresher(
                        controller: _refreshController,
                        onRefresh: () async {
                          await _itemBloc.getWishList();
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
                            ...wishListProds.map((prod) {
                              return productTile(
                                  prod, MediaQuery.of(context).size.width);
                            }).toList(),
                          ],
                        ),
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget productTile(Map details, double width) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
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
                              itemSlug: details['slug'],
                            )));
              },
              child: Container(
                height: double.maxFinite,
                child: CachedNetworkImage(
                  imageUrl:
                      "${Session.IMAGE_BASE_URL}/assets/images/products/${details['product_image']}",
                  fit: BoxFit.fitHeight,
                ),
                width: width / 2.4,
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
                    Row(
                      children: [
                        Expanded(
                          flex: 1,
                          child: Text(
                            "${details['product_name']}",
                            maxLines: 2,
                            style: TextStyle(
                              color: Color(0xff515151),
                              fontSize: 14,
                              letterSpacing: 0.45,
                            ),
                          ),
                        ),
                        Expanded(
                          flex: 0,
                          child: AddToWishListIcon(
                            productsData: details,
                            inWishlist: true,
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(left: 5, bottom: 5),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 0,
                              child: Text(
                                "${details['product_price']?.toString()}",
                                maxLines: 1,
                                style: TextStyle(
                                  fontSize: 14,
                                ),
                              ),
                            ),
                            if (details['product_previous_price']?.toString() !=
                                "0")
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "${details['product_previous_price']?.toString()}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 12,
                                        color: Color(0xffA9A9A9),
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                              ),
                            if (details['discount_percentage']?.toString() !=
                                "0")
                              Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 5.0),
                                  child: Text(
                                    "${details['discount_percentage']?.toString()}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 14, color: Color(0xffDC0F21)),
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
                        padding: const EdgeInsets.only(bottom: 5),
                        child: AddToCartIcon(
                          inWishlist: true,
                          productData: details,
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
