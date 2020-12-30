import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Session.dart';

class Brands extends StatefulWidget {
  final List brandsData;
  final ScrollController scrollController;

  const Brands({Key key, this.brandsData = const [], this.scrollController})
      : super(key: key);

  @override
  _BrandsState createState() => _BrandsState();
}

class _BrandsState extends State<Brands> {
  bool moreThanSix, expand = false;

  @override
  Widget build(BuildContext context) {
    int itemCount = widget.brandsData?.length ?? 0;
    if (itemCount % 3 != 0) {
      itemCount = itemCount - (itemCount % 3);
    }
    moreThanSix = itemCount > 6;

    return SliverList(
        delegate: SliverChildListDelegate([
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 10, left: 20.0, bottom: 10),
          child: Align(
            alignment: Alignment.centerLeft,
            child: Text(
              "Brands",
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
      Container(
        color: Colors.white,
        child: Padding(
          padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
          child: GridView.builder(
              itemCount: (!expand && moreThanSix) ? 6 : itemCount,
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 3, crossAxisSpacing: 10, mainAxisSpacing: 10),
              itemBuilder: (c, i) {
                Map data = widget.brandsData.elementAt(i) ?? {};
                return ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Container(
                    decoration: BoxDecoration(
                        color: Colors.white,
                        border: Border.all(color: Colors.grey.shade300)),
                    child: CachedNetworkImage(
                      imageUrl:
                          "${Session.BASE_URL}/assets/images/partner/${data['photo']}",
                    ),
                  ),
                );
              }),
        ),
      ),
      if (moreThanSix)
        Container(
          color: Colors.white,
          child: ListTile(
            onTap: () {
              setState(() {
                expand = !expand;
              });
              if (!expand)
                widget.scrollController.animateTo(250,
                    duration: Duration(milliseconds: 500),
                    curve: Curves.easeIn);
            },
            trailing: Icon(expand
                ? Icons.keyboard_arrow_up_sharp
                : Icons.keyboard_arrow_down_sharp),
            title: Text(
              "Show ${expand ? "Less" : "More"} Brands",
              textAlign: TextAlign.center,
              style: TextStyle(
                color: Color(0xff727272),
                fontSize: 15,
                letterSpacing: 0.45,
              ),
            ),
          ),
        ),
    ]));
  }
}
