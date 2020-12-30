import 'dart:async';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Session.dart';

class Sliders extends StatefulWidget {
  final List slidersData;
  final String picsPath;
  final double height;
  final Duration duration;

  const Sliders(
      {Key key,
      this.slidersData = const [],
      this.picsPath,
      this.height,
      this.duration = const Duration(seconds: 3)})
      : super(key: key);

  @override
  _SlidersState createState() => _SlidersState();
}

class _SlidersState extends State<Sliders> with TickerProviderStateMixin {
  AnimationController _controller;
  PageController _pageController;

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
        padding: const EdgeInsets.symmetric(vertical: 10),
        child: Container(
          height: widget.height,
          width: double.infinity,
          child: PageView.builder(
            itemCount: widget.slidersData?.length ?? 0,
            physics: BouncingScrollPhysics(),
            controller: _pageController,
            itemBuilder: (c, i) {
              Map data = widget.slidersData.elementAt(i) ?? {};
              return CachedNetworkImage(
                errorWidget: (c, e, d) {
                  return Center(child: Text("Error Loading File"));
                },
                width: double.infinity,
                height: widget.height,
                imageUrl:
                    "${Session.BASE_URL}/assets/images/${widget.picsPath}/${data['photo']}",
                fit: BoxFit.fitHeight,
              );
            },
          ),
        ),
      ),
    ]));
  }
}
