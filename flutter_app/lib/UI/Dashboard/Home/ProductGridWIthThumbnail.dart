import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Constants.dart';

class ProductGridWIthThumbnail extends StatefulWidget {
  final List productData;
  final String title;

  const ProductGridWIthThumbnail({Key key, this.productData, this.title})
      : super(key: key);

  @override
  _ProductGridWIthThumbnailState createState() =>
      _ProductGridWIthThumbnailState();
}

class _ProductGridWIthThumbnailState extends State<ProductGridWIthThumbnail> {
  @override
  Widget build(BuildContext context) {
    int itemCount = widget.productData?.length ?? 0;
    if (itemCount % 2 != 0) {
      itemCount = itemCount - (itemCount % 2);
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
                color: Colors.grey.shade200,
                child: Padding(
                  padding:
                      const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "${widget.title}",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        color: Color(0xff727272),
                        fontSize: 15,
                        letterSpacing: 0.45,
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Container(
              color: Colors.grey.shade200,
              child: Padding(
                padding:
                    const EdgeInsets.only(bottom: 10.0, right: 10, left: 10),
                child: GridView.builder(
                    itemCount: itemCount,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        childAspectRatio: .8,
                        crossAxisCount: 2,
                        crossAxisSpacing: 10,
                        mainAxisSpacing: 10),
                    itemBuilder: (c, i) {
                      Map data = widget.productData.elementAt(i) ?? {};
                      return InkWell(
                        onTap: () {
                          Navigator.of(context).push(MaterialPageRoute(
                              builder: (c) => ItemPage(
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
                                          "${Constants.BASE_URL}/assets/images/thumbnails/${data['thumbnail']}",
                                    ),
                                  ),
                                ),
                              ),
                              Expanded(
                                  flex: 0,
                                  child: Padding(
                                    padding: const EdgeInsets.only(
                                        left: 4, right: 4, top: 4, bottom: 10),
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
                      );
                    }),
              ),
            ),
          ]));
  }
}
