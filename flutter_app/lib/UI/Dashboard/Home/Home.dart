import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/UI/Dashboard/Category/Categories.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/UI/Dashboard/Home/ProductGridWIthThumbnail.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';
import 'package:pull_to_refresh/pull_to_refresh.dart';
import 'package:shimmer/shimmer.dart';

import 'Product4GridWIthThumbnail.dart';
import 'ProductListWIthThumbnail.dart';
import 'Sliders.dart';

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  @override
  void initState() {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Color(0xffdc0f21),
    ));
    super.initState();
  }

  RefreshController _refreshController =
      RefreshController(initialRefresh: false);

  ScrollController _scrollController = ScrollController();



  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
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
          child: CustomScrollView(
            controller: _scrollController,
            physics: BouncingScrollPhysics(),
            shrinkWrap: true,
            slivers: [
              SliverList(
                  delegate: SliverChildListDelegate([
                Container(
                  height: 100,
                  decoration: BoxDecoration(color: Colors.white, boxShadow: [
                    BoxShadow(
                        color: Colors.black26,
                        offset: Offset(0, 1),
                        spreadRadius: 2,
                        blurRadius: 2)
                  ]),
                  child:
                      Consumer<CategoryBloc>(builder: (context, snapshot, w) {
                    if (snapshot.categoryData.length == 0)
                      return Shimmer.fromColors(
                        baseColor: Colors.grey.shade400,
                        highlightColor: Colors.redAccent,
                        child: ListView.builder(
                            shrinkWrap: true,
                            scrollDirection: Axis.horizontal,
                            physics: BouncingScrollPhysics(),
                            itemCount: 10,
                            itemBuilder: (c, i) {
                              return Container(
                                width: 70,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Container(
                                      height: 60,
                                      width: 60,
                                      decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.grey),
                                    ),
                                    Expanded(
                                      flex: 1,
                                      child: Padding(
                                        padding: const EdgeInsets.only(
                                          left: 4.0,
                                          top: 6,
                                          bottom: 6,
                                          right: 4,
                                        ),
                                        child: Container(
                                          decoration: BoxDecoration(
                                              color: Colors.grey,
                                              borderRadius:
                                                  BorderRadius.circular(10)),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              );
                            }),
                      );
                    Map respData = snapshot?.categoryData ?? {};
                    List categories = respData['categories'] ?? [];
                    return ListView.builder(
                        shrinkWrap: true,
                        scrollDirection: Axis.horizontal,
                        physics: BouncingScrollPhysics(),
                        itemCount: (categories?.length??0)+1,
                        itemBuilder: (c, i) {
                          if(i == 0){
                            return Padding(
                              padding: const EdgeInsets.all(.5),
                              child: Container(
                                width: 70,
                                color: Colors.white,
                                child: InkWell(
                                  onTap: () {
                                    Navigator.of(context).push(PageRouteBuilder(
                                        transitionDuration: Duration(seconds: 1),
                                        reverseTransitionDuration:
                                        Duration(milliseconds: 800),
                                        pageBuilder: (c, a, b) => CategoriesPage(
                                        )));
                                  },
                                  child: Material(
                                    color: Colors.transparent,
                                    child: Column(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      crossAxisAlignment:
                                      CrossAxisAlignment.center,
                                      children: [
                                        Container(
                                          height: 60,
                                          width: 60,
                                          decoration: BoxDecoration(
                                              shape: BoxShape.circle,
                                              color: Colors.white),
                                          child: ClipRRect(
                                            borderRadius:
                                            BorderRadius.circular(100),
                                            child: Image.asset(
                                              "assets/newArr.jpg",
                                              fit: BoxFit.cover,
                                            ),
                                          ),
                                        ),
                                        Expanded(
                                          flex: 1,
                                          child: Padding(
                                            padding: const EdgeInsets.only(
                                              left: 4.0,
                                              right: 4,bottom: 4
                                            ),
                                            child: Text(
                                              "New Arrivals",
                                              maxLines: 2,
                                              textAlign: TextAlign.center,
                                              style: TextStyle(
                                                color: Colors.black,
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.45,
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }
                          i-=1;
                          Map data = categories.elementAt(i);
                          return Padding(
                            padding: const EdgeInsets.all(.5),
                            child: Container(
                              width: 70,
                              color: Colors.white,
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      transitionDuration: Duration(seconds: 1),
                                      reverseTransitionDuration:
                                          Duration(milliseconds: 800),
                                      pageBuilder: (c, a, b) => CategoriesPage(

                                            categoryName: data['slug'],
                                          )));
                                },
                                child: Material(
                                  color: Colors.transparent,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    children: [
                                      Container(
                                        height: 60,
                                        width: 60,
                                        decoration: BoxDecoration(
                                            shape: BoxShape.circle,
                                            color: Colors.white),
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(100),
                                          child: Center(
                                            child: CachedNetworkImage(
                                              imageUrl:
                                                  "${Session.IMAGE_BASE_URL}/assets/images/categories/${data['image']}",
                                              fit: BoxFit.fill,
                                            ),
                                          ),
                                        ),
                                      ),
                                      Expanded(
                                        flex: 1,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                            left: 4.0,
                                            right: 4,bottom: 4
                                          ),
                                          child: Text(
                                            "${data['name']}",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Colors.black,
                                              fontSize: 12,
                                              fontWeight: FontWeight.bold,
                                              letterSpacing: 0.45,
                                            ),
                                          ),
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ),
                          );
                        });
                  }),
                ),
                Consumer<ProductsBloc>(
                  builder: (c, s, w) {
                    Map resp1Data = s?.homePageData ?? {};
                    Map resp2Data = s?.homePageExtras ?? {};
                    if (resp1Data.length == 0 && resp2Data.length == 0)
                      return Center(
                          child: CircularProgressIndicator(
                        valueColor: AlwaysStoppedAnimation(Color(0xffdc0f21)),
                      ));
                    else {
                      bool slider =
                          (resp1Data['slider'] as int).toBool() ?? false;
                      bool service =
                          (resp1Data['service'] as int).toBool() ?? false;
                      bool featured =
                          (resp1Data['featured'] as int).toBool() ?? false;
                      bool topSmallBanner =
                          (resp1Data['small_banner'] as int).toBool() ?? false;
                      bool best = (resp1Data['best'] as int).toBool() ?? false;
                      bool topRated =
                          (resp1Data['top_rated'] as int).toBool() ?? false;
                      bool big = (resp1Data['big'] as int).toBool() ?? false;
                      bool hotSale =
                          (resp1Data['hot_sale'] as int).toBool() ?? false;
                      bool partners =
                          (resp1Data['partners'] as int).toBool() ?? false;
                      bool reviewBlog =
                          (resp1Data['review_blog'] as int).toBool() ?? false;
                      bool bottomSmall =
                          (resp1Data['bottom_small'] as int).toBool() ?? false;
                      bool flashDeal =
                          (resp1Data['flash_deal'] as int).toBool() ?? false;
                      bool featuredCategory =
                          (resp1Data['featured_category'] as int).toBool() ??
                              false;

                      bool largeBanner =
                          (resp2Data['large_banner'] as int).toBool() ?? false;
                      bool bottomSmallBanner =
                          (resp2Data['small_banner'] as int).toBool() ?? false;

                      List largeBannersData = resp2Data['large_banners'] ?? [];

                      //TODO: add static banners if null
                      String bestSellerBanner = (resp1Data['pagesettings'] ??
                              {})['best_seller_banner'] ??
                          "";
                      String bestSellerBanner1 = (resp1Data['pagesettings'] ??
                              {})['best_seller_banner1'] ??
                          "";
                      String bigSaveBanner = (resp1Data['pagesettings'] ??
                              {})['big_save_banner'] ??
                          "";
                      String bigSaveBanner1 = (resp1Data['pagesettings'] ??
                              {})['big_save_banner1'] ??
                          "";

                      return CustomScrollView(
                        shrinkWrap: true,
                        physics: NeverScrollableScrollPhysics(),
                        slivers: [
                          if (slider)
                            Sliders(
                              height: 200,
                              numb: 0,
                              duration: Duration(seconds: 3),
                              slidersData: resp1Data['sliders'],
                              picsPath: "sliders",
                            ),

                          // if (partners)
                          //   Brands(
                          //     scrollController: _scrollController,
                          //     brandsData: resp2Data['partners'],
                          //   ),

                          // if (topSmallBanner)
                          //   Sliders(numb: 1,
                          //     height: 250,
                          //     duration: Duration(milliseconds: 500, seconds: 3),
                          //     slidersData: resp1Data['top_small_banners'],
                          //     picsPath: "banners",
                          //   ),
                          /// Trending Products
                          Product4GridWIthThumbnail(
                            productData: resp2Data['trending_products'],
                            title: "Trending Products",
                          ),

                          /// Best Products
                          if (best)
                            ProductListWIthThumbnail(
                              productData: resp2Data['best_products'],
                              title: "Best Buy",
                            ),

                          /// Larger Banner if present
                          if (largeBanner && largeBannersData.length > 0)
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Padding(
                                padding:
                                    const EdgeInsets.only(top: 20, bottom: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => CategoriesPage(

                                                  categoryName: "women",
                                                )));
                                  },
                                  child: Stack(
                                    children: [
                                      CachedNetworkImage(
                                        imageUrl:
                                            "${Session.BASE_URL}/assets/images/banners/${(largeBannersData[0] ?? {})['photo']}",
                                      ),
                                      Positioned(
                                          right: 5,
                                          bottom: 0,
                                          child: FlatButton.icon(
                                              shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20)),
                                              onPressed: () {
                                                Navigator.push(
                                                    context,
                                                    MaterialPageRoute(
                                                        builder: (c) =>
                                                            CategoriesPage(

                                                              categoryName:
                                                                  "women",
                                                            )));
                                              },
                                              icon: Icon(
                                                  Icons.touch_app_outlined),
                                              label: Text("Explore")))
                                    ],
                                  ),
                                ),
                              ),
                            ])),

                          /// Top Rated
                          if (topRated)
                            ProductGridWIthThumbnail(
                              title: "Top Rated",
                              productData: resp2Data['top_products'],
                            ),

                          Categories(),

                          /// Big Products
                          if (big)
                            ProductListWIthThumbnail(
                              productData: resp2Data['big_products'],
                              title: "Big Products",
                            ),

                          if (bigSaveBanner != null)
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => CategoriesPage(

                                                  categoryName: "men",
                                                  subCatName: "mens-footwear",
                                                  childCatName:
                                                      "mens-sport-shoes",
                                                )));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Session.BASE_URL}/assets/images/$bigSaveBanner",
                                  ),
                                ),
                              ),
                            ])),

                          /// Latest Products
                          ProductGridWIthThumbnail(
                            title: "Latest Products",
                            productData: resp2Data['latest_products'],
                          ),

                          if (bigSaveBanner1 != null)
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (c) => CategoriesPage(

                                                  categoryName: "women",
                                                )));
                                  },
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Session.BASE_URL}/assets/images/$bigSaveBanner1",
                                  ),
                                ),
                              ),
                            ])),

                          ///Hot Products
                          ProductListWIthThumbnail(
                            title: "Hot Products",
                            productData: resp2Data['hot_products'],
                          ),

                          /// Featured Products from Response 1
                          if (featured)
                            ProductGridWIthThumbnail(
                              productData: resp1Data['feature_products'],
                              title: "Featured Products",
                            ),

                          if (bottomSmallBanner)
                            Sliders(
                              numb: 2,
                              height: 400,
                              duration: Duration(seconds: 4),
                              slidersData: resp2Data['bottom_small_banners'],
                              picsPath: "banners",
                            ),

                          /// Hot Sale Products
                          if (hotSale)
                            ProductListWIthThumbnail(
                              title: "Hot Sale",
                              productData: resp2Data['sale_products'],
                            ),

                          /// Discount Products
                          ProductGridWIthThumbnail(
                            title: "Discount Products",
                            productData: resp2Data['discount_products'],
                          ),

                          if (largeBanner && largeBannersData.length > 1)
                            SliverList(
                                delegate: SliverChildListDelegate([
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 10),
                                child: InkWell(
                                  onTap: () {},
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Session.BASE_URL}/assets/images/banners/${(largeBannersData[1] ?? {})['photo']}",
                                  ),
                                ),
                              ),
                            ])),
                          // else if (bestSellerBanner != null ||
                          //     bestSellerBanner1 != null)
                          //   Sliders(
                          //     height: 400,
                          //     duration: Duration(seconds: 4),
                          //     slidersData: [
                          //       if (bestSellerBanner != null)
                          //         {"photo": bestSellerBanner},
                          //       if (bigSaveBanner1 != null)
                          //         {"photo": bestSellerBanner1},
                          //     ],
                          //     picsPath: "",
                          //   ),
                        ],
                      );
                    }
                  },
                ),
              ])),
            ],
          ),
        ));
  }
}
