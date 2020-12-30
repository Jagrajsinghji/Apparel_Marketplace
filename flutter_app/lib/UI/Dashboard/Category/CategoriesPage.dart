import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/GlobalWidget.dart';
import 'package:flutter_app/UI/Dashboard/Cart/WishList.dart';
import 'package:flutter_app/UI/Dashboard/Category/FilterBy.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/UI/Dashboard/Search/SearchProds.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'SortBy.dart';

class CategoriesPage extends StatefulWidget {
  final String categoryName;
  final String tag;

  const CategoriesPage({Key key, this.categoryName, this.tag})
      : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  Sort sort = Sort.WhatsNew;

  bool filtersGenerated = false;
  Map generatedFilters = {};

  Map appliedFilters = {};
  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            widget.categoryName ?? "Category",
            style: TextStyle(
              color: Color(0xff2c393f),
              fontSize: 18,
            ),
          ),
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Hero(
                  tag: "SearchTag",
                  child: Image.asset(
                    "assets/search.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          reverseTransitionDuration:
                              Duration(milliseconds: 800),
                          pageBuilder: (c, a, b) => SearchProds()));
                },
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: InkWell(
                focusColor: Colors.transparent,
                splashColor: Colors.transparent,
                child: Hero(
                  tag: "WishList",
                  child: Image.asset(
                    "assets/favourite.png",
                    width: 20,
                    height: 20,
                  ),
                ),
                onTap: () {
                  Navigator.push(
                      context,
                      PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          reverseTransitionDuration:
                              Duration(milliseconds: 800),
                          pageBuilder: (c, a, b) => WishList()));
                },
              ),
            ),
            CartIcon()
          ],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: SmartRefresher(
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
          child: FutureBuilder<Response>(
            future:
                ProductsBloc().getProductsByCategoryName(widget.categoryName),
            builder: (c, s) {
              if (s?.data?.data == null)
                return Hero(tag: widget.tag??"",
                  child: Shimmer.fromColors(
                    direction: ShimmerDirection.rtl,
                    baseColor: Colors.grey.shade400,
                    highlightColor: Colors.redAccent,
                    child: Padding(
                      padding: const EdgeInsets.only(
                          bottom: 10.0, right: 10, left: 10),
                      child: GridView.builder(
                          itemCount: 10,
                          shrinkWrap: true,
                          physics: BouncingScrollPhysics(),
                          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                              childAspectRatio: .6,
                              crossAxisCount: 2,
                              crossAxisSpacing: 10,
                              mainAxisSpacing: 10),
                          itemBuilder: (c, i) {
                            return Container(
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey),
                                  borderRadius: BorderRadius.circular(8)),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    flex: 1,
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(8),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(8)),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0),
                                    child: Container(
                                        height: 12,
                                        width: 100,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ),
                                  Padding(
                                    padding: const EdgeInsets.only(
                                        left: 8.0, top: 8.0, bottom: 8.0),
                                    child: Container(
                                        height: 12,
                                        width: 80,
                                        decoration: BoxDecoration(
                                            color: Colors.grey,
                                            borderRadius:
                                                BorderRadius.circular(8))),
                                  ),
                                ],
                              ),
                            );
                          }),
                    ),
                  ),
                );
              List prodsData =
                  (((s?.data?.data ?? {})['prods'] ?? {})['data']) ?? [];
              generateFilters(prodsData);
              prodsData = []..addAll(sortProds(prodsData));

              prodsData = []..addAll(filterProds(prodsData));

              return Container(
                height: double.infinity,
                color: Colors.grey.shade200,
                child: Column(
                  children: [
                    Container(
                      height: 50,
                      color: Color(0xff557187),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          InkWell(
                            onTap: () async {
                              var filters = await Navigator.of(context)
                                  .push(PageRouteBuilder(
                                      pageBuilder: (c, a, b) => FilterBy(
                                            appliedFilters: appliedFilters,
                                            allFilters: generatedFilters,
                                          ),
                                      opaque: false));

                              if (filters != null)
                                setState(() {
                                  appliedFilters = filters;
                                });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/fliter.png",
                                  height: 25,
                                  width: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Filter",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          InkWell(
                            onTap: () async {
                              var sortCat = await Navigator.of(context)
                                  .push(PageRouteBuilder(
                                      pageBuilder: (c, a, b) => SortBy(
                                            sort: sort,
                                          ),
                                      opaque: false));
                              if (sortCat != null)
                                setState(() {
                                  sort = sortCat;
                                });
                            },
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Image.asset(
                                  "assets/sortBy.png",
                                  height: 25,
                                  width: 25,
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Text(
                                    "Sort By",
                                    textAlign: TextAlign.center,
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
                    if (prodsData.length == 0)
                      Expanded(
                        child: Container(
                          height: double.maxFinite,
                          child: Center(child: Text("No Products Found")),
                        ),
                      )
                    else
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, right: 10, left: 10),
                          child: GridView.builder(
                              itemCount: prodsData.length,
                              shrinkWrap: true,
                              physics: BouncingScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                      childAspectRatio: .6,
                                      crossAxisCount: 2,
                                      crossAxisSpacing: 10,
                                      mainAxisSpacing: 10),
                              itemBuilder: (c, i) {
                                Map data = prodsData.elementAt(i) ?? {};
                                String tag = data['slug'] + "CategoriesPage";
                                return InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        transitionDuration:
                                            Duration(seconds: 1),
                                        reverseTransitionDuration:
                                            Duration(milliseconds: 800),
                                        pageBuilder: (c, a, b) => ItemPage(
                                              tag: tag,
                                              itemSlug: data['slug'],
                                            )));
                                  },
                                  key: Key(data['id']?.toString() ?? "$i"),
                                  borderRadius: BorderRadius.circular(8),
                                  child: Hero(
                                    tag: tag,
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: Colors.white,
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
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(8),
                                              child: Container(
                                                color: Colors.white,
                                                child: CachedNetworkImage(
                                                  imageUrl:
                                                      "${Session.BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                                                ),
                                              ),
                                            ),
                                          ),
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
                                                      textAlign:
                                                          TextAlign.start,
                                                      style: TextStyle(
                                                        color:
                                                            Color(0xff515151),
                                                        fontSize: 15,
                                                        letterSpacing: 0.45,
                                                      ),
                                                    ),
                                                  ),
                                                  Padding(
                                                    padding:
                                                        const EdgeInsets.all(
                                                            4.0),
                                                    child: Row(
                                                      children: [
                                                        Text(
                                                          "4.2",
                                                          style: TextStyle(
                                                            color: Color(
                                                                0xff515151),
                                                            fontSize: 12,
                                                            letterSpacing: 0.24,
                                                          ),
                                                        ),
                                                        Icon(
                                                          Icons.star,
                                                          color:
                                                              Color(0xffF2EB33),
                                                          size: 16,
                                                        ),
                                                      ],
                                                    ),
                                                  )
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
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(
                                                    child: Text(
                                                      "\u20B9 ${data['price'].toString().substring(0, 4)}",
                                                      maxLines: 1,
                                                      style: TextStyle(
                                                        fontSize: 15,
                                                      ),
                                                    ),
                                                  ),
                                                  if ((data['previous_price'] ??
                                                          0) !=
                                                      0)
                                                    Expanded(
                                                      child: Text(
                                                        "\u20B9 ${data['previous_price'].toString().substring(0, 4)}",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xffA9A9A9),
                                                            decoration:
                                                                TextDecoration
                                                                    .lineThrough),
                                                      ),
                                                    ),
                                                  if ((data['is_discount'] ??
                                                          0) >
                                                      0)
                                                    Expanded(
                                                      child: Text(
                                                        "${data['whole_sell_discount']}% Off",
                                                        maxLines: 1,
                                                        style: TextStyle(
                                                            fontSize: 15,
                                                            color: Color(
                                                                0xffDC0F21)),
                                                      ),
                                                    ),
                                                ],
                                              ),
                                            ),
                                          )
                                        ],
                                      ),
                                    ),
                                  ),
                                );
                              }),
                        ),
                      ),
                  ],
                ),
              );
            },
          ),
        ),
        bottomNavigationBar: bottomNavigation(context, voidCallback: () {
          Navigator.popUntil(context, (p) => p.isFirst);
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: floatingActionButton(context, voidCallback: () {
          Navigator.popUntil(context, (p) => p.isFirst);
        }));
  }

  List sortProds(List prodsData) {
    prodsData.sort((a, b) {
      switch (sort) {
        case Sort.WhatsNew:
          return a['updated_at']
              ?.toString()
              ?.compareTo(b['updated_at']?.toString());
          break;
        case Sort.PriceHighToLow:
          return b['price']?.toString()?.compareTo(a['price']?.toString());
          break;
        case Sort.PriceLowToHigh:
          return a['price']?.toString()?.compareTo(b['price']?.toString());
          break;
        case Sort.Popularity:
          return a['views']?.toString()?.compareTo(b['views']?.toString());
          break;
        case Sort.Discount:
          return a['is_discount']
              ?.toString()
              ?.compareTo(b['is_discount']?.toString());
          break;
        case Sort.CustomerRating:
          return a['views']?.toString()?.compareTo(b['views']?.toString());
          break;
        default:
          return a['created_at']
              ?.toString()
              ?.compareTo(b['created_at']?.toString());
      }
    });
    return prodsData;
  }

  List filterProds(List prodsData) {
    print(prodsData.length);
    List filteredList = [];
    List brands = appliedFilters['brands'] ?? [],
        price = appliedFilters['price'] ?? [],
        size = appliedFilters['size'] ?? [],
        colors = appliedFilters['colors'] ?? [];
    String star = appliedFilters['stars'],
        discount = appliedFilters['discount'];

    if (brands.length != 0) {
      print('applying brand filter');
      brands.forEach((brand) {
        filteredList.addAll(prodsData
            .where((prod) => prod['user']['name'].toString() == brand));
      });
      print("applied brand filter ${filteredList.length}");
    } else {
      print('NO Brand Filter');
      filteredList.addAll(prodsData);
      print("Length ${filteredList.length}");
    }

    if (price.length != 0) {
      print("applying price filter");
      List priceFilList = [];
      priceFilList.addAll(filteredList.where((element) =>
          element['price'] <= price.last && element['price'] >= price.first));
      filteredList.clear();
      filteredList.addAll(priceFilList);
      print("applied price filter ${filteredList.length}");
    }

    if (size.length != 0 && size.length != generatedFilters['size'].length) {
      print("applying size filter");
      List sizeFilList = [];
      size.forEach((selectedSize) {
        filteredList
            .where((element) => element['size'] is List)
            .forEach((element) {
          List defSize = element['size'] ?? [];
          if (defSize.any((defS) => defS == selectedSize))
            sizeFilList.add(element);
        });
      });
      filteredList.clear();
      filteredList.addAll(sizeFilList);
      print("applied size filter ${filteredList.length}");
    }
    return filteredList;
  }

  void generateFilters(List prods) {
    if (filtersGenerated) return;
    List brands = [], price = [], size = [], colors = [];
    prods.forEach((element) {
      if (!brands.contains(element['user']['name'].toString()))
        brands.add(element['user']['name'].toString());
      if (!price.contains(element['price'])) price.add(element['price']);
      var color = element['color'].toString();
      if (color.trim().length > 0 && !colors.contains(color))
        colors.add(element['color'].toString());
      if (element['size'] is List) {
        List defSize = element['size'] ?? [];
        defSize.forEach((element) {
          if (element.toString().trim().length > 0 && !size.contains(element))
            size.add(element);
        });
      }
    });
    generatedFilters.addAll({
      "brands": brands,
      "price": price,
      "colors": colors,
      "size": size,
      "stars": "",
      "discount": ""
    });
    filtersGenerated = true;
  }
}
