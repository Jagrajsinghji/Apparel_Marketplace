import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Components/AddToCartIcon.dart';
import 'package:flutter_app/UI/Components/AddToWishListIcon.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/GlobalWidget.dart';
import 'package:flutter_app/UI/Components/ProductRateIcon.dart';
import 'package:flutter_app/UI/Components/SearchIcon.dart';
import 'package:flutter_app/UI/Components/WishListIcon.dart';
import 'package:flutter_app/UI/Dashboard/Cart/ShoppingBag.dart';
import 'package:flutter_app/UI/Dashboard/Category/FilterBy.dart';
import 'package:flutter_app/UI/Dashboard/Category/SortBy.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

class BrandProductsPage extends StatefulWidget {
  final String brandName;

  const BrandProductsPage({Key key, @required this.brandName})
      : super(key: key);

  @override
  _BrandProductsPageState createState() => _BrandProductsPageState();
}

class _BrandProductsPageState extends State<BrandProductsPage> {
  Sort sort = Sort.NONE;

  Map<String, Set> generatedFilters = {};
  Map<String, Set> appliedFilters = {};

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  List mainAllProductsList;
  Map apiProductsResponseData;

  ///final show list which user will be.
  List filteredProductsList;
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    super.initState();
    getProducts(false);
  }

  Future<bool> getProducts(bool fetchMore,
      {int currentPage = 1, int lastPage, bool forceRefresh = false}) async {
    if (lastPage != null && currentPage > lastPage) return false;
    if (fetchMore) currentPage++;
    ProductsBloc _pBloc = Provider.of<ProductsBloc>(context, listen: false);
    Future _future = _pBloc.getBrandProducts(widget.brandName,
        page: currentPage, forceRefresh: forceRefresh);
    Response response = await _future;
    apiProductsResponseData = {}..addAll((response?.data ?? {}));
    if (fetchMore) {
      /// adding fetched prods in main list.
      mainAllProductsList.addAll(apiProductsResponseData['products'] ?? []);

      ///generating new filters with new prods fetched
      Map<String, Set> _filters =
          generateFilters(apiProductsResponseData['products'] ?? []);
      _filters.forEach((key, value) {
        generatedFilters[key].addAll(value);
      });

      ///adding flitered prods in show list
      filteredProductsList
          .addAll(filterProds(apiProductsResponseData['products'] ?? []));
      sort = Sort.NONE;
    } else {
      /// getting all prods
      mainAllProductsList = []
        ..addAll(apiProductsResponseData['products'] ?? []);

      ///generating filters
      generatedFilters = generateFilters(mainAllProductsList ?? []);

      /// sort prods if refresh
      filteredProductsList = []..addAll(sortProds(mainAllProductsList));

      /// filter prods if refresh
      filteredProductsList = []..addAll(filterProds(mainAllProductsList ?? []));
    }
    if (mounted) setState(() {});
    return true;
  }

  @override
  void dispose() {
    _refreshController?.dispose();
    super.dispose();
  }

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
            widget?.brandName?.toUpperCase() ?? "Branded Products",
            style: TextStyle(
              color: Color(0xff2c393f),
              fontSize: 14,
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
          bottom: PreferredSize(
            child: Container(
              height: 50,
              color: Color(0xffDC0F21),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        if (generatedFilters?.length == 0) {
                          Fluttertoast.showToast(msg: "No Filters Available.");
                          return;
                        }
                        var filters =
                            await Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.black12,
                          transitionDuration: Duration(
                            milliseconds: 500,
                          ),
                          reverseTransitionDuration:
                              Duration(milliseconds: 500),
                          transitionsBuilder: (c, a, b, w) {
                            return SlideTransition(
                              position:
                                  Tween(end: Offset.zero, begin: Offset(0, -1))
                                      .animate(CurvedAnimation(
                                          parent: a, curve: Curves.decelerate)),
                              child: w,
                            );
                          },
                          pageBuilder: (c, a, b) => FilterBy(
                            appliedFilters: appliedFilters,
                            allFilters: generatedFilters,
                          ),
                        ));

                        if (filters != null)
                          setState(() {
                            appliedFilters = filters;
                            filteredProductsList = []
                              ..addAll(filterProds(mainAllProductsList ?? []));
                          });
                      },
                      child: Center(
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
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: InkWell(
                      onTap: () async {
                        var sortCat =
                            await Navigator.of(context).push(PageRouteBuilder(
                          opaque: false,
                          barrierColor: Colors.black12,
                          transitionDuration: Duration(
                            milliseconds: 500,
                          ),
                          reverseTransitionDuration:
                              Duration(milliseconds: 500),
                          transitionsBuilder: (c, a, b, w) {
                            return SlideTransition(
                              position:
                                  Tween(end: Offset.zero, begin: Offset(0, -1))
                                      .animate(CurvedAnimation(
                                          parent: a, curve: Curves.decelerate)),
                              child: w,
                            );
                          },
                          pageBuilder: (c, a, b) => SortBy(
                            sort: sort,
                          ),
                        ));
                        if (sortCat != null)
                          setState(() {
                            sort = sortCat;
                            List st = sortProds(filteredProductsList);
                            filteredProductsList = []..addAll(st);
                          });
                      },
                      child: Center(
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
                    ),
                  ),
                ],
              ),
            ),
            preferredSize: Size(double.maxFinite, 40),
          ),
        ),
        endDrawer: ShoppingBag(),
        body: SmartRefresher(
          controller: _refreshController,
          onRefresh: () async {
            await getProducts(
              false,
              forceRefresh: true,
            );
            _refreshController.refreshCompleted();
          },
          onLoading: () async {
            if (mainAllProductsList != null) {
              int currentPage = int.parse(
                      apiProductsResponseData['current_page'].toString()) ??
                  1;
              int lastPage = int.parse(
                      apiProductsResponseData['total_pages'].toString()) ??
                  1;
              var list = []..addAll(filteredProductsList);
              bool complete = await getProducts(true,
                  currentPage: currentPage, lastPage: lastPage);
              if (complete) {
                if (listEquals(list, filteredProductsList))
                  _refreshController.loadNoData();
                else
                  _refreshController.loadComplete();
              } else {
                _refreshController.loadNoData();
              }
            } else
              _refreshController.loadComplete();
          },
          footer: ClassicFooter(),
          primary: true,
          physics: BouncingScrollPhysics(),
          enablePullDown: true,
          enablePullUp: true,
          header: WaterDropMaterialHeader(
            distance: 100,
            backgroundColor: Color(0xffDC0F21),
          ),
          child: mainAllProductsList == null
              ? Shimmer(
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
                )
              : mainAllProductsList?.length == 0
                  ? Container(
                      height: double.maxFinite,
                      child: Center(child: Text("No Products Found")),
                    )
                  : filteredProductsList?.length == 0
                      ? Container(
                          height: double.maxFinite,
                          child: Center(
                              child: Text(
                                  "No Products Found\nTry to clear filters")),
                        )
                      : Padding(
                          padding: const EdgeInsets.only(
                              bottom: 10.0, right: 10, left: 10),
                          child: GridView.builder(
                              primary: false,
                              itemCount: filteredProductsList?.length,
                              shrinkWrap: true,
                              physics: NeverScrollableScrollPhysics(),
                              gridDelegate:
                                  SliverGridDelegateWithFixedCrossAxisCount(
                                childAspectRatio: .6,
                                crossAxisCount: 2,
                              ),
                              itemBuilder: (c, i) {
                                Map data =
                                    filteredProductsList?.elementAt(i) ?? {};
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
                                return Padding(
                                  padding: const EdgeInsets.all(5.0),
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          PageRouteBuilder(
                                              pageBuilder: (c, a, b) =>
                                                  ItemPage(
                                                    itemSlug: data['slug'],
                                                  )));
                                    },
                                    key: Key(data['id']?.toString() ?? "$i"),
                                    borderRadius: BorderRadius.circular(8),
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
                                                      "${Session.IMAGE_BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                                                ),
                                              ),
                                            ),
                                          ),
                                          Expanded(
                                            flex: 0,
                                            child: Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 5.0),
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
                                                        fontSize: 14,
                                                        fontWeight:
                                                            FontWeight.bold,
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
                                                  top: 5,
                                                  left: 5.0,
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
                                                            const EdgeInsets
                                                                    .only(
                                                                left: 5.0),
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
                                              padding: const EdgeInsets.only(
                                                  left: 5, bottom: 5),
                                              child: Row(
                                                mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                                crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                                children: [
                                                  Expanded(flex: 0,child: ProductRateIcon(productData: data,),),
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
          return b['price']?.compareTo(a['price']);
          break;
        case Sort.PriceLowToHigh:
          return a['price']?.compareTo(b['price']);
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
          return 1;
      }
    });
    return prodsData;
  }

  List filterProds(List prodsData) {
    List filteredList = []..addAll(prodsData);
    Set price = appliedFilters['price'] ?? Set(),
        size = appliedFilters['size'] ?? Set(),
        colors = appliedFilters['colors'] ?? Set(),
        star = appliedFilters['stars'] ?? Set(),
        discount = appliedFilters['discount'] ?? Set();

    if (price.length != 0) {
      print("applying price filter");
      print("filters list length till now ${filteredList.length}");
      List priceFilList = [];
      priceFilList.addAll(filteredList.where((element) =>
          (double.parse(element['price'].toString()) * 68.95) <= price.last &&
          (double.parse(element['price'].toString()) * 68.95) >= price.first));
      filteredList.clear();
      filteredList.addAll(priceFilList);
      print("applied price filter ${filteredList.length}");
    }

    if (size.length != 0 && size.length != generatedFilters['size'].length) {
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
    }

    if (colors.length != 0 &&
        colors.length != generatedFilters['colors'].length) {
      List colorList = [];
      colors.forEach((selectedColor) {
        filteredList
            .where((element) => element['color'] is List)
            .forEach((element) {
          List defColor = element['color'] ?? [];
          if (defColor.any((defS) => defS == selectedColor))
            colorList.add(element);
        });
      });
      filteredList.clear();
      filteredList.addAll(colorList);
    }
    return filteredList;
  }

  Map<String, Set> generateFilters(List prods) {
    Set price = Set(), size = Set(), colors = Set();
    prods.forEach((element) {
      double newPrice = double.parse(element['price']?.toString());
      //TODO: ask ravjot to send currency value
      newPrice = newPrice * 68.95;
      if (!price.contains(newPrice)) price.add(newPrice);
      if (element['color'] is List) {
        List defColor = element['color'] ?? [];
        defColor.forEach((element) {
          if (element.toString().trim().length > 0 && !size.contains(element))
            colors.add(element);
        });
      }
      if (element['size'] is List) {
        List defSize = element['size'] ?? [];
        defSize.forEach((element) {
          if (element.toString().trim().length > 0 && !size.contains(element))
            size.add(element);
        });
      }
    });
    Map<String, Set> generatedFilters = {}..addAll({
        "brands": Set(),
        "price": price,
        "colors": colors,
        "size": size,
        "stars": Set(),
        "discount": Set()
      });
    return generatedFilters;
  }
}
