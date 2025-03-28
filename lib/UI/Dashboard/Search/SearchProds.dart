import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/ProductRateIcon.dart';
import 'package:flutter_app/UI/Components/WishListIcon.dart';
import 'package:flutter_app/UI/Dashboard/Cart/ShoppingBag.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class SearchProds extends StatefulWidget {
  @override
  _SearchProdsState createState() => _SearchProdsState();
}

class _SearchProdsState extends State<SearchProds> {
  String keyword = "";
  bool isLoading = false;
  List searchedProducts = [];
  int totalPages = 0, currentPage = 1;
  bool noProductsFound = false;
  Timer t;

  void getProducts({int page}) async {
    if (keyword.trim().length < 4) return;
    print("Getting Prods");
    List products = [];
    if (mounted)
      setState(() {
        isLoading = true;
        noProductsFound = false;
      });
    try {
      ProductsBloc productsBloc = Provider.of(context, listen: false);
      Response response = await productsBloc.getSearchedProducts(
        keyword,
        page ?? 1,
      );
      print(response.data);
      if (!response.data['message'].toString().contains("No Products Found")) {
        products.addAll(response.data['products'] ?? []);
        currentPage =
            int.parse(response.data['current_page'].toString() ?? "1");
        totalPages = int.parse(response.data['total_pages'].toString() ?? "1");
      }

      if (products.length == 0) {
        noProductsFound = true;
        Fluttertoast.showToast(msg: "No Products Found");
      } else {
        searchedProducts.clear();
        searchedProducts.addAll(products);
      }
    } catch (err) {
      print(err);
      Fluttertoast.showToast(msg: "An Error Occurred!");
    } finally {
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () => Navigator.pop(context),
        child: Scaffold(
          key: _scaffoldKey,
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            elevation: 0,
            backgroundColor: Colors.white,
            title: Padding(
              padding: const EdgeInsets.only(right: 8.0),
              child: TextFormField(
                autofocus: true,
                onChanged: (c) {
                  if (mounted)
                    setState(() {
                      keyword = c;
                    });
                  initiateSearch();
                },
                onFieldSubmitted: (e) async {
                  keyword = e;
                  // initiateSearch();
                },
                decoration: InputDecoration(
                  suffixIcon: isLoading
                      ? Transform.scale(
                          scale: .5,
                          child: CircularProgressIndicator(
                            valueColor: AlwaysStoppedAnimation(Colors.red),
                          ),
                        )
                      : IconButton(
                          onPressed: () async {
                            // if (keyword.trim().length == 0) return;
                            // FocusScope.of(context).requestFocus(FocusNode());
                            // initiateSearch();
                          },
                          icon: Hero(
                            tag: "SearchTag",
                            child: Icon(
                              Icons.search,
                              size: 28,
                              color: keyword.trim().length > 0
                                  ? Color(0xffDC0F21)
                                  : Colors.black,
                            ),
                          ),
                        ),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent)),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(8),
                      borderSide: BorderSide(color: Colors.transparent)),
                  errorBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  hintText: "Search for products and brands",
                  hintStyle: TextStyle(
                    color: Color(0xff9d9d9d),
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            titleSpacing: -15,
            actions: [
              WishListIcon(),
              CartIcon(
                globalKey: _scaffoldKey,
              )
            ],
            iconTheme: IconThemeData(color: Colors.black),
          ),
          endDrawer: ShoppingBag(),
          body: InkWell(
            onTap: () {},
            child: Container(
              height: MediaQuery.of(context).size.height / 2,
              color: Colors.white,
              child: noProductsFound
                  ? Container(
                      color: Colors.white,
                      child: Center(child: Text("No Products Found")),
                    )
                  : Padding(
                      padding: const EdgeInsets.only(bottom: 8.0),
                      child: searchedProducts.length == 0
                          ? Container(
                              color: Colors.white,
                              child: Center(
                                child: Text("Search Products"),
                              ),
                            )
                          : GridView.builder(
                              primary: false,
                              itemCount: searchedProducts?.length ?? 0,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: .6,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (c, i) {
                                Map data = searchedProducts.elementAt(i) ?? {};
                                String shopName =
                                    (data['user'] ?? {})['shop_name'];
                                double newPrice =
                                    double.parse(data['price']?.toString());
                                double prevPrice = double.parse(
                                    data['previous_price']?.toString() ?? "0");
                                int discount = 0;
                                if (prevPrice > 0)
                                  discount =
                                      (((prevPrice - newPrice) / prevPrice) *
                                              100)
                                          .round();
                                //TODO: ask ravjot to send currency value
                                double currency = 68.95;
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context)
                                        .push(SlideLeftPageRouteBuilder(
                                            pageBuilder: (c, a, b) => ItemPage(
                                                  itemSlug: data['slug'],
                                                )));
                                  },
                                  key: Key(data['id']?.toString() ?? "$i"),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Container(
                                    decoration: BoxDecoration(
                                        color: Colors.white,
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
                                            borderRadius:
                                                BorderRadius.circular(8),
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
                                        //     padding: const EdgeInsets.only(
                                        //         left: 10.0),
                                        //     child: Align(
                                        //       alignment: Alignment.centerLeft,
                                        //       child: Text(
                                        //         shopName ?? "",
                                        //         maxLines: 2,
                                        //         textAlign: TextAlign.start,
                                        //         style: TextStyle(
                                        //           color: Colors.black,
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
                                            padding: const EdgeInsets.only(
                                                left: 10.0),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Expanded(
                                                  child: Text(
                                                    data['name'] ?? "",
                                                    maxLines: 2,
                                                    textAlign: TextAlign.start,
                                                    style: TextStyle(
                                                      color: Color(0xff515151),
                                                      fontSize: 14,
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
                                                top: 10,
                                                left: 10.0,
                                                bottom: 10,
                                                right: 4),
                                            child: Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.start,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.center,
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
                                                if (prevPrice != 0 &&
                                                    prevPrice != newPrice)
                                                  Expanded(
                                                    flex: 0,
                                                    child: Padding(
                                                      padding:
                                                          const EdgeInsets.only(
                                                              left: 10.0),
                                                      child: Text(
                                                        "\u20B9 ${(prevPrice * currency).round()}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 14,
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
                                                              left: 10.0),
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
                                );
                              }),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  void initiateSearch({int page}) async {
    print("initiating");
    t?.cancel();
    t = Timer(
        Duration(milliseconds: 800), () => getProducts(page: page));
  }

  @override
  void dispose() {
    t?.cancel();
    super.dispose();
  }
}
