import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Constants.dart';

class Brands extends StatefulWidget {
  final List brandsData;

  const Brands({Key key, this.brandsData = const []}) : super(key: key);

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
          Padding(
            padding: const EdgeInsets.only(left: 20.0,),
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
      Padding(
        padding: const EdgeInsets.all(8.0),
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
                  color: Colors.white,
                  child: CachedNetworkImage(
                    imageUrl:
                        "${Constants.BASE_URL}/assets/images/partner/${data['photo']}",
                  ),
                ),
              );
            }),
      ),
      if (moreThanSix)
        ListTile(
          onTap: () => setState(() {
            expand = !expand;
          }),
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
    ]));
  }
}
