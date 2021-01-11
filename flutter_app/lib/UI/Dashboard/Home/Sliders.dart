import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/Utils/Session.dart';

class Sliders extends StatefulWidget {
  final List slidersData;
  final String picsPath;
  final double height;
  final Duration duration;
  final int numb;

  const Sliders({
    Key key,
    this.slidersData = const [],
    this.picsPath,
    this.height,
    this.duration = const Duration(seconds: 3),
    this.numb,
  }) : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> with TickerProviderStateMixin {
  AnimationController _controller;
  PageController _pageController;
  int page =0;

  @override
  void initState() {
    _controller = AnimationController(
        vsync: this,
        duration: widget.duration,
        upperBound: 1.0,
        lowerBound: 0.0);
    _pageController = PageController(initialPage: 0);
    super.initState();
    _controller.addStatusListener((s) {
      int page = _pageController.page.floor();
      if (page + 1 == widget?.slidersData?.length) page = -1;
      if (s == AnimationStatus.completed) {
        _pageController.animateToPage(page + 1,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
        _controller.reverse();
      }
      if (s == AnimationStatus.dismissed) {
        _pageController.animateToPage(page + 1,
            duration: Duration(seconds: 1), curve: Curves.easeIn);
        _controller.forward();
      }
    });
    _controller.addListener(() =>setState((){
      page = _pageController.page.toInt();
    }));
    Timer(Duration(seconds: 1), () {
      try {
        _controller?.forward();
      } catch (e) {}
    });
  }

  @override
  void dispose() {
    _controller?.dispose();
    _pageController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.only(top: 5),
        child: Container(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.slidersData?.length ?? 0,
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemBuilder: (c, i) {
              Map data = widget.slidersData.elementAt(i) ?? {};
              Widget _widget;
              return InkWell(
                onTap: () {
                  switch (widget.numb) {
                    case 0:
                      _widget = CategoriesPage(

                        subCatName: "womens-western-wear",
                        childCatName: "cardigan",
                        categoryName: "women",
                      );
                      break;
                    case 1:
                      if (i == 0)
                        _widget = CategoriesPage(

                          categoryName: "women",
                          subCatName: "womens-western-wear",
                        );
                      else
                        _widget = CategoriesPage(

                          categoryName: "men",
                          subCatName: "men-topwear",
                          childCatName: "men-t-shirts",
                        );
                      break;
                    default:
                      if (i == 0)
                        _widget = CategoriesPage(

                          categoryName: "women",
                          subCatName: "women-ethnic-wear",
                          childCatName: "kurti-and-kurti-set",
                        );
                      else if (i == 2)
                        _widget = CategoriesPage(

                          categoryName: "women",
                          subCatName: "womens-western-wear",
                          childCatName: "cardigan",
                        );
                      else
                        _widget = CategoriesPage(

                          categoryName: "men",
                          subCatName: "men-topwear",
                          childCatName: "men-t-shirts",
                        );
                  }
                  Navigator.push(
                      context, MaterialPageRoute(builder: (c) => _widget));
                },
                child: CachedNetworkImage(
                  errorWidget: (c, e, d) {
                    return Center(child: Text("Error Loading File"));
                  },
                  width: double.infinity,
                  height: widget.height,
                  imageUrl:
                      "${Session.BASE_URL}/assets/images/${widget.picsPath}/${data['photo']}",
                  fit: BoxFit.cover,
                ),
              );
            },
          ),
        ),
      ),
      Center(
        child: Container(
          height: 20,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemBuilder: (c, i) {
              if (page == i)
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                        color: Colors.black, shape: BoxShape.circle),
                  ),
                );
              else
                return Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Container(
                    height: 6,
                    width: 6,
                    decoration: BoxDecoration(
                        border: Border.all(
                          color: Colors.black,
                        ),
                        shape: BoxShape.circle),
                  ),
                );
            },
            itemCount: (widget.slidersData?.length??0),
            shrinkWrap: true,
          ),
        ),
      )
    ]));
  }
}
