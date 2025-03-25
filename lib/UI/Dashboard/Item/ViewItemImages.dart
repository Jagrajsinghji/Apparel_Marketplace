import 'dart:math';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:photo_view/photo_view.dart';

class ViewItemImages extends StatefulWidget {
  final List<String> imageUrls;
  final String title;

  const ViewItemImages({Key key, this.imageUrls, this.title}) : super(key: key);

  @override
  _ViewItemImagesState createState() => _ViewItemImagesState();
}

class _ViewItemImagesState extends State<ViewItemImages> {
  PageController _pageController = PageController();
  int page = 0;

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      page = _pageController.page.round();
      if (mounted) setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
        title: Text(
          "${widget.title}",
          style: TextStyle(color: Colors.black,fontFamily: goggleFont),
        ),
      ),
      body: Center(
        child: Column(
          children: [
            Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  height: height - 200,
                  child: PageView.builder(
                      physics: BouncingScrollPhysics(),
                      controller: _pageController,
                      itemCount: widget.imageUrls.length,
                      itemBuilder: (c, i) {
                        return PhotoView(
                          minScale: .5,
                          backgroundDecoration:
                              BoxDecoration(color: Colors.white),
                          imageProvider: CachedNetworkImageProvider(
                              "${Session.IMAGE_BASE_URL}/${widget.imageUrls.elementAt(i)}"),
                        );
                      }),
                ),
                if (page != 0)
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                        icon: Transform.rotate(
                            angle: -pi,
                            child: Icon(Icons.arrow_right_alt_outlined)),
                        onPressed: () {
                          page--;
                          _pageController.animateToPage(page,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }),
                  ),
                if (page != widget.imageUrls.length - 1)
                  Align(
                    alignment: Alignment.centerRight,
                    child: IconButton(
                        icon: Icon(Icons.arrow_right_alt_outlined),
                        onPressed: () {
                          page++;
                          _pageController.animateToPage(page,
                              duration: Duration(milliseconds: 500),
                              curve: Curves.easeIn);
                        }),
                  ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: Container(
                height: 80,
                child: ListView.builder(
                    itemCount: widget.imageUrls.length,
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemBuilder: (c, i) {
                      return Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: InkWell(
                          onTap: () {
                            page = i;
                            _pageController.animateToPage(page,
                                duration: Duration(milliseconds: 500),
                                curve: Curves.easeIn);
                          },
                          child: Container(
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black26),
                            ),
                            width: 80,
                            child: Stack(
                              children: [
                                CachedNetworkImage(
                                  imageUrl:
                                      "${Session.IMAGE_BASE_URL}/${widget.imageUrls.elementAt(i)}",
                                ),
                                if (page != i)
                                  Container(
                                    color: Colors.black45,
                                    width: 80,
                                  )
                              ],
                            ),
                          ),
                        ),
                      );
                    }),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }
}
