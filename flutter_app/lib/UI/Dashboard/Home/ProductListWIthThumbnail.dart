import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Session.dart';

class ProductListWIthThumbnail extends StatefulWidget {
  final List productData;
  final String title;

  const ProductListWIthThumbnail({Key key, this.productData, this.title})
      : super(key: key);

  @override
  _ProductListWIthThumbnailState createState() =>
      _ProductListWIthThumbnailState();
}

class _ProductListWIthThumbnailState extends State<ProductListWIthThumbnail> {
  @override
  Widget build(BuildContext context) {
    int itemCount = widget.productData?.length ?? 0;

    return itemCount == 0
        ? SliverList(
            delegate: SliverChildListDelegate([]),
          )
        : SliverList(
            delegate: SliverChildListDelegate([
            Padding(
              padding: const EdgeInsets.only(top: 10.0),
              child: Container(
                color: Colors.white,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 15,
                        letterSpacing: 0.45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              height: 200,
              color: Colors.white,
              child: ListView.builder(
                  itemCount: itemCount,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  scrollDirection: Axis.horizontal,
                  itemBuilder: (c, i) {
                    Map data = widget.productData.elementAt(i) ?? {};
                    String tag = data['slug'] + widget.title;
                    return Padding(
                      key: Key(data['id']?.toString() ?? "$i"),
                      padding:
                          const EdgeInsets.only(bottom: 10, right: 5, left: 5),
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push(PageRouteBuilder(
                              transitionDuration: Duration(seconds: 1),
                              reverseTransitionDuration:
                                  Duration(milliseconds: 800),
                              pageBuilder: (c, a, b) => ItemPage(
                                    tag: tag,
                                    itemSlug: data['slug'],
                                  )));
                        },
                        borderRadius: BorderRadius.circular(8),
                        child: Hero(
                          tag: tag,
                          child: Material(color: Colors.transparent,
                            child: InteractiveViewer(onInteractionUpdate: (d){
                              print(d);
                            },minScale: 2,
                              child: Container(
                                width: 130,
                                decoration: BoxDecoration(
                                    color: Colors.white,
                                    border: Border.all(color: Colors.grey.shade300),
                                    borderRadius: BorderRadius.circular(8)),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      flex: 1,
                                      child: Container(
                                        color: Colors.white,
                                        child: CachedNetworkImage(
                                          imageUrl:
                                              "${Session.IMAGE_BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                        flex: 0,
                                        child: Padding(
                                          padding: const EdgeInsets.only(
                                              left: 4.0,
                                              right: 4,
                                              top: 4,
                                              bottom: 10),
                                          child: Text(
                                            "${data['name']}",
                                            maxLines: 2,
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              color: Color(0xff727272),
                                              fontSize: 12,
                                              letterSpacing: 0.45,
                                            ),
                                          ),
                                        )),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  }),
            ),
          ]));
  }
}
