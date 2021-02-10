import 'dart:ui';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/Bloc/RecentProdsBloc.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/ProductRateIcon.dart';
import 'package:flutter_app/UI/Components/WishListIcon.dart';
import 'package:flutter_app/UI/Dashboard/Cart/ShoppingBag.dart';
import 'package:flutter_app/UI/Dashboard/Cart/WishList.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/UI/Dashboard/Item/ViewItemImages.dart';
import 'package:flutter_app/UI/Dashboard/RecentProds/RecentProdsList.dart';
import 'package:flutter_app/UI/SignInUp/MobileLogin.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
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
  bool isLoading = false;

  Map itemData;

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  void initState() {
    super.initState();
    getItem(forceRefresh: false);
  }

  @override
  void dispose() {
    _pageController?.dispose();
    _refreshController?.dispose();
    super.dispose();
  }

  void getItem({VoidCallback callback,bool forceRefresh}) {
    ItemBloc _itemBloc = Provider.of<ItemBloc>(context, listen: false);
    _itemBloc.getItemBySlug(widget.itemSlug,forceRefresh: forceRefresh).then((value) {
      if (mounted)
        setState(() {
          itemData = value.data;
          Provider.of<RecentProdsBloc>(context,listen: false).setProduct(itemData,widget.itemSlug);
        });
      if (callback != null) callback();
    });
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {

    CartBloc _cartBloc = Provider.of<CartBloc>(context);
    ItemBloc _itemBloc = Provider.of<ItemBloc>(context);
    List wishListProds = _itemBloc.wishListData['wishlists'] ?? [];
    bool isPresentInWishlist =
        wishListProds.any((element) => element['slug'] == widget.itemSlug);
    var shimmer = Shimmer(
      gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: <Color>[
            Colors.grey.shade400,
            Colors.white60,
            Colors.redAccent.withOpacity(.5),
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
                  color: Colors.grey, borderRadius: BorderRadius.circular(8)),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20.0, top: 5, bottom: 5),
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
                    padding: const EdgeInsets.only(left: 20.0, bottom: 15),
                    child: Container(
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                      height: 25,
                      width: 100,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey),
                          width: 35,
                          height: 35,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey),
                          width: 35,
                          height: 35,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
                              color: Colors.grey),
                          width: 35,
                          height: 35,
                        ),
                        Container(
                          decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(4),
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
                    padding: const EdgeInsets.only(left: 20.0, bottom: 10),
                    child: Container(
                      height: 25,
                      width: 150,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                          color: Colors.grey,
                          borderRadius: BorderRadius.circular(8)),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 20, right: 20, top: 10),
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
                    padding: const EdgeInsets.only(left: 20.0, bottom: 2),
                    child: Text(
                      "Easy 30 days return and exchange",
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(left: 20.0, right: 20),
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
    Map productData = (itemData ?? {})["product"] ?? {};
    sizeMap = mapSizeToQty(itemData);

    outOfStock = ((sizeMap.values.every((element) => element['qty'] == "0")) &&
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
    var shopName = (itemData ?? {})['shop_name'] ?? "";
    double newPrice = double.parse(productData['price']?.toString() ?? "0");
    double prevPrice =
        double.parse(productData['previous_price']?.toString() ?? "0");
    int discount = 0;
    if (prevPrice > 0)
      discount = (((prevPrice - newPrice) / prevPrice) * 100).round();
    double currency = double.parse(
        ((itemData ?? {})['curr'] ?? {})['value']?.toString() ?? "68.95");
    List gallery = (itemData ?? {})['galleries_images_array'] ?? [];
    if (!outOfStock) {
      if (selectedSize.trim().length == 0) {
        selectedSize = (sizeMap.values.length > 0)
            ? sizeMap.keys
                .where((element) => sizeMap[element]['qty'] != "0")
                .first
            : "";
        selectedSizeKey =
            (sizeMap.values.length > 0) ? sizeMap[selectedSize]['key'] : "0";
        selectedSizePrice = double.parse(
            (sizeMap.values.length > 0) ? sizeMap[selectedSize]['price'] : "0");
        selectedSizeQty =
            (sizeMap.values.length > 0) ? sizeMap[selectedSize]['qty'] : "0";
      }
    }
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        title: Transform.translate(
          offset: Offset(-25, 0),
          child: InkWell(
            onTap: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, Session.BASE_URL, (route) => false);
            },
            child: Image.asset(
              "assets/logo.png",
              width: 120,
            ),
          ),
        ),
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png",color: Colors.black,),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        actions: [
          WishListIcon(),
          CartIcon(
            globalKey: _scaffoldKey,
          )
        ],
        iconTheme: IconThemeData(color: Colors.black),
      ),
      endDrawer: ShoppingBag(),
      body: Stack(
        children: [
          SmartRefresher(
            controller: _refreshController,
            primary: true,
            physics: BouncingScrollPhysics(),
            enablePullDown: true,
            header: WaterDropMaterialHeader(
              distance: 100,
              backgroundColor: Color(0xffDC0F21),
            ),
            onRefresh: () async {
              getItem(callback: () {
                _refreshController.refreshCompleted();
              },forceRefresh: true);
            },
            child: (itemData == null)
                ? shimmer
                : ListView(
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
                                    return InkWell(
                                      onTap: () {
                                        List<String> urls = [];
                                        urls.add(
                                            "assets/images/products/${productData['photo']}");
                                        gallery.forEach((element) {
                                          urls.add(
                                              "assets/images/galleries/$element");
                                        });
                                        Navigator.push(
                                            context,
                                            PageRouteBuilder(
                                                pageBuilder: (c, a, b) =>
                                                    ViewItemImages(
                                                      title:
                                                          productData['name'],
                                                      imageUrls: urls,
                                                    )));
                                      },
                                      child: CachedNetworkImage(
                                        imageUrl:
                                            "${Session.IMAGE_BASE_URL}/assets/images/products/${productData['photo']}",
                                        fit: BoxFit.fitHeight,
                                        width: double.infinity,
                                      ),
                                    );
                                  }
                                  i -= 1;
                                  return InkWell(
                                    onTap: () {
                                      List<String> urls = [];
                                      urls.add(
                                          "assets/images/products/${productData['photo']}");
                                      gallery.forEach((element) {
                                        urls.add(
                                            "assets/images/galleries/$element");
                                      });
                                      Navigator.push(
                                          context,
                                          PageRouteBuilder(
                                              pageBuilder: (c, a, b) =>
                                                  ViewItemImages(
                                                    title: productData['name'],
                                                    imageUrls: urls,
                                                  )));
                                    },
                                    child: CachedNetworkImage(
                                      imageUrl:
                                          "${Session.IMAGE_BASE_URL}/assets/images/galleries/${gallery.elementAt(i)}",
                                      fit: BoxFit.fitHeight,
                                      width: double.infinity,
                                    ),
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
                            // Padding(
                            //   padding: const EdgeInsets.only(
                            //       left: 20.0, top: 5, bottom: 5),
                            //   child: Text(
                            //     "$shopName",
                            //     style: TextStyle(
                            //       color: Color(0xff515151),
                            //       fontSize: 15,
                            //       letterSpacing: 0.45,
                            //     ),
                            //   ),
                            // ),
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
                              padding:
                                  const EdgeInsets.only(left: 20.0, bottom: 5),
                              child: Text(
                                "SKU: ${productData['sku']}",
                                style: TextStyle(
                                  color: Color(0xff515151),
                                  fontSize: 12,
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
                                  if (prevPrice != 0 && prevPrice != newPrice)
                                    Expanded(
                                      flex: 0,
                                      child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
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
                          padding: const EdgeInsets.only(top: 2.0),
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
                                              selectedSizePrice = double.parse(
                                                  s.value['price']);
                                              if (mounted) setState(() {});
                                            },
                                            child: Container(
                                              width:
                                                  s.key.length > 6 ? 120 : 50,
                                              child: Column(
                                                mainAxisSize: MainAxisSize.min,
                                                children: [
                                                  Container(
                                                    decoration: BoxDecoration(
                                                      shape: s.key.length > 6
                                                          ? BoxShape.rectangle
                                                          : BoxShape.circle,
                                                      borderRadius:
                                                          s.key.length > 6
                                                              ? BorderRadius
                                                                  .circular(10)
                                                              : null,
                                                      color: (s.value['qty'] ==
                                                              "0")
                                                          ? Color(0xffE3E3E3)
                                                          : selected
                                                              ? Color(
                                                                  0xffDC0F21)
                                                              : Colors.white,
                                                    ),
                                                    width: s.key.length > 3
                                                        ? 120
                                                        : 45,
                                                    height: 45,
                                                    child: Center(
                                                      child: Text(
                                                        "${s.key.toUpperCase()}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                          color: selected
                                                              ? Colors.white
                                                              : Color(
                                                                  0xff969696),
                                                          fontSize: 14,
                                                        ),
                                                      ),
                                                    ),
                                                  ),
                                                  if (int.parse(
                                                              s.value['qty']) >
                                                          0 &&
                                                      int.parse(
                                                              s.value['qty']) <
                                                          6)
                                                    Center(
                                                      child: Text(
                                                        "${s.value['qty']} Left",
                                                        style: TextStyle(
                                                          color: Colors.black,
                                                          fontSize: 8,
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
                          padding: const EdgeInsets.only(top: 2.0),
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
                                                width: s.length > 6 ? 120 : 50,
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  children: [
                                                    Container(
                                                      decoration: BoxDecoration(
                                                        shape: s.length > 6
                                                            ? BoxShape.rectangle
                                                            : BoxShape.circle,
                                                        borderRadius: s.length >
                                                                6
                                                            ? BorderRadius
                                                                .circular(10)
                                                            : null,
                                                        color: selected
                                                            ? Color(0xffDC0F21)
                                                            : Colors.white,
                                                      ),
                                                      width: s.length > 6
                                                          ? 120
                                                          : 45,
                                                      height: 45,
                                                      child: Center(
                                                        child: Text(
                                                          "$s",
                                                          style: TextStyle(
                                                            color: selected
                                                                ? Colors.white
                                                                : Color(
                                                                    0xff969696),
                                                            fontSize: 14,
                                                          ),
                                                        ),
                                                      ),
                                                    )
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
                        padding: const EdgeInsets.only(top: 2.0),
                        child: Container(
                          color: Colors.white,
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 20.0),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.only(
                                      bottom: 10.0, left: 20),
                                  child: Align(
                                    alignment: Alignment.topLeft,
                                    child: Row(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Image.asset(
                                            "assets/deliveryCarIcon.png",
                                            width: 25,
                                            height: 25,
                                          ),
                                        ),
                                        Text(
                                          "Delivery in 3-7 days",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.only(
                                      left: 20.0, right: 20),
                                  child: Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Expanded(
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              right: 10.0),
                                          child: Container(
                                            child: FlatButton(
                                              minWidth: double.maxFinite,
                                              onPressed: () async {
                                                if (isPresentInWishlist) {
                                                  Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                          opaque: false,
                                                          barrierColor: Colors
                                                              .black
                                                              .withOpacity(.8),
                                                          transitionDuration:
                                                              Duration(
                                                            milliseconds: 500,
                                                          ),
                                                          reverseTransitionDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionsBuilder:
                                                              (c, a, b, w) {
                                                            return SlideTransition(
                                                              position: Tween(
                                                                      end: Offset
                                                                          .zero,
                                                                      begin:
                                                                          Offset(
                                                                              0,
                                                                              -1))
                                                                  .animate(CurvedAnimation(
                                                                      parent: a,
                                                                      curve: Curves
                                                                          .decelerate)),
                                                              child: w,
                                                            );
                                                          },
                                                          pageBuilder:
                                                              (c, a, b) =>
                                                                  WishList()));
                                                  return;
                                                }
                                                Function function = () async
                                                {
                                                  AuthBloc _authBloc1 = Provider.of<AuthBloc>(
                                                      context,
                                                      listen: false);
                                                  if(_authBloc1.userData.length==0)
                                                    return;
                                                  int id = productData['id'];
                                                  if (id == null) return;
                                                  if (mounted)
                                                    setState(() {
                                                      isLoading = true;
                                                    });
                                                  await Provider.of<ItemBloc>(
                                                      context,
                                                      listen: false)
                                                      .addItemToWishlist(id);
                                                  if (mounted)
                                                    setState(() {
                                                      isLoading = false;
                                                    });
                                                };

                                                Map data =
                                                    Provider.of<AuthBloc>(
                                                            context,
                                                            listen: false)
                                                        .userData;
                                                if (data.length == 0) {
                                                  await Navigator.push(
                                                      context,
                                                      PageRouteBuilder(
                                                          opaque: false,
                                                          barrierColor:
                                                              Colors.black54,
                                                          transitionDuration:
                                                              Duration(
                                                                  milliseconds:
                                                                      500),
                                                          transitionsBuilder:
                                                              (c, a, b, w) {
                                                            return SlideTransition(
                                                              position: Tween(
                                                                      begin:
                                                                          Offset(
                                                                              0,
                                                                              1),
                                                                      end: Offset
                                                                          .zero)
                                                                  .animate(CurvedAnimation(
                                                                      curve: Curves
                                                                          .fastLinearToSlowEaseIn,
                                                                      parent:
                                                                          a)),
                                                              child: w,
                                                            );
                                                          },
                                                          pageBuilder: (c, a,
                                                                  b) =>
                                                              MobileLogin()));
                                                  function();
                                                } else
                                                  function();

                                              },
                                              color: Color(0xffDC0F21),
                                              height: 50,
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          100)),
                                              child: Text(
                                                isPresentInWishlist
                                                    ? "Go To Wishlist"
                                                    : "Add to Wishlist",
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 14,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                          child: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 10.0),
                                        child: Container(
                                          padding: EdgeInsets.zero,
                                          child: FlatButton(
                                            key: UniqueKey(),
                                            minWidth: double.maxFinite,
                                            onPressed: outOfStock
                                                ? null
                                                : alreadyAdded
                                                    ? () => _scaffoldKey
                                                        .currentState
                                                        .openEndDrawer()
                                                    : () =>
                                                        addToCart(productData),
                                            color: Color(0xffDC0F21),
                                            disabledColor: Color(0xffDC0F21)
                                                .withOpacity(.5),
                                            height: 50,
                                            shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(100)),
                                            child: Text(
                                              alreadyAdded
                                                  ? "Go to Bag"
                                                  : "Add to Cart",
                                              style: TextStyle(
                                                color: Colors.white,
                                                fontSize: 14,
                                              ),
                                            ),
                                          ),
                                        ),
                                      )),
                                    ],
                                  ),
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

                      ...products(itemData['similar_products'] ?? [],
                          "Similar@Products"),

                      ...products(itemData['similar_brands'] ?? [],
                          "More@products by Same Brand"),

                      RecentProdsList(),

                      Padding(
                        padding: const EdgeInsets.only(top: 2.0),
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
                    ],
                  ),
          ),
          if (isLoading)
            BackdropFilter(
              filter: ImageFilter.blur(sigmaY: 3, sigmaX: 3),
              child: Container(
                  color: Colors.black54,
                  child: Center(
                      child: SpinKitFadingCircle(
                    color: Color(0xffDC0F21),
                  ))),
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
    if (data == null) return {};
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

  List<Widget> products(List data, String name) {
    if (data.length == 0) return [];
    return [
      Padding(
        padding: const EdgeInsets.only(
          top: 2.0,
        ),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: "${name.split("@").first}",
                    style: TextStyle(
                      color: Color(0xffdc0f21),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.45,
                    ),
                    children: [
                      TextSpan(
                        text: " ${name.split("@").last}",
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
      ),
      Container(
        height: 260,
        color: Colors.grey.shade200,
        child: ListView.builder(
            itemCount: (data.length ?? 0) + 1,
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              if (i == data.length) {
                return Padding(
                  key: Key("$i"),
                  padding: const EdgeInsets.all(2),
                  child: InkWell(
                    onTap: () {
                      String catSlug, subCatSlug;
                      Map prods = data.elementAt(i - 1) ?? {};
                      int catID = prods['category_id'] ?? 0;
                      int subCatID = prods['subcategory_id'] ?? 0;
                      Map catData =
                          Provider.of<CategoryBloc>(context, listen: false)
                              .categoryData;
                      List categories = catData['categories'] ?? [];
                      List subCategories = catData['subcategories'] ?? [];
                      List catList = categories
                          .where((element) => element['id'] == catID)
                          .toList();
                      List subCatList = subCategories
                          .where((element) => element['id'] == subCatID)
                          .toList();
                      if (catList.length > 0) catSlug = catList.first['slug'];
                      if (subCatList.length > 0)
                        subCatSlug = subCatList.first['slug'];
                      Navigator.of(context).push(SlideLeftPageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          reverseTransitionDuration:
                              Duration(milliseconds: 800),
                          pageBuilder: (c, a, b) => CategoriesPage(
                                categoryName: catSlug,
                                subCatName: subCatSlug,
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
                  ),
                );
              }
              Map prods = data.elementAt(i) ?? {};
              double newPrice = double.parse(prods['price']?.toString());
              double prevPrice =
                  double.parse(prods['previous_price']?.toString() ?? "0");
              int discount = 0;
              if (prevPrice > 0)
                discount = (((prevPrice - newPrice) / prevPrice) * 100).round();
              double currency = double.parse(
                  (prods['curr'] ?? {})['value']?.toString() ?? "68.95");
              return Padding(
                key: Key(prods['id']?.toString() ?? "$i"),
                padding: const EdgeInsets.all(2),
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
                                    "\u20B9 ${((newPrice) * currency).round()}",
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
                                            fontSize: 12,
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
                                Expanded(flex: 0,child: ProductRateIcon(productData: prods,),),
                                Expanded(
                                  child: AddToWishListIcon(
                                    productsData: prods,
                                  ),
                                ),
                                Expanded(
                                  child: AddToCartIcon(
                                    productData: prods,
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
    ];
  }
}
