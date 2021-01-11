import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Session.dart';

class Product4GridWIthThumbnail extends StatefulWidget {
  final List productData;
  final String title;

  const Product4GridWIthThumbnail({Key key, this.productData, this.title})
      : super(key: key);

  @override
  _Product4GridWIthThumbnailState createState() =>
      _Product4GridWIthThumbnailState();
}

class _Product4GridWIthThumbnailState extends State<Product4GridWIthThumbnail> {
  @override
  Widget build(BuildContext context) {
    int itemCount = widget.productData?.length ?? 0;
    if (itemCount % 4 != 0) {
      itemCount = itemCount - (itemCount % 4);
    }
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
                    child: RichText(
                      text: TextSpan(
                          text: "${widget.title.split(" ").first}",
                          style: TextStyle(
                            color: Color(0xffdc0f21),
                            fontSize: 15,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.45,
                          ),
                          children: [
                            TextSpan(
                              text: " ${widget.title.split(" ").last}",
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
              height: 340,
              child: ListView.builder(
                physics: BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemBuilder: (c, index) {
                  List listOf4 = [];
                  listOf4.addAll(widget.productData
                      .getRange((index * 4), (index * 4) + 4));
                  return Center(
                    child: Container(
                      width: MediaQuery.of(context).size.width - 30,
                      child: GridView(
                        scrollDirection: Axis.vertical,
                        children: [
                          ...listOf4.map((e) {
                            Map data = e ?? {};
                            String tag = data['slug'] + widget.title;
                            return Padding(
                              padding: const EdgeInsets.all(2.0),
                              child: InkWell(
                                onTap: () {
                                  Navigator.of(context).push(PageRouteBuilder(
                                      pageBuilder: (c, a, b) => ItemPage(
                                            itemSlug: data['slug'],
                                          )));
                                },
                                key: Key(data['id']?.toString() ?? "$e"),
                                borderRadius: BorderRadius.circular(8),
                                child: Container(
                                  decoration: BoxDecoration(
                                      color: Colors.white,
                                      border: Border.all(
                                          color: Colors.grey.shade300),
                                      borderRadius: BorderRadius.circular(8)),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
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
                                                left: 4,
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
                                                fontWeight: FontWeight.bold,
                                                letterSpacing: 0.45,
                                              ),
                                            ),
                                          )),
                                    ],
                                  ),
                                ),
                              ),
                            );
                          })
                        ],
                        shrinkWrap: true,
                        primary: false,
                        physics: NeverScrollableScrollPhysics(),
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount: 2,
                        ),
                      ),
                    ),
                  );
                },
                itemCount: (itemCount ~/ 4),
              ),
            ),
          ]));
  }
}
