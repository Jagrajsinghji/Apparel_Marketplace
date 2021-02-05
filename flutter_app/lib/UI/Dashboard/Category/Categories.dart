import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  Map moreCats = {
    "assets/bottomWear.jpg": "men/men-bottomwear/null",
    "assets/jackets.jpg": "women/women-ethnic-wear/kurti-and-kurti-set",
    "assets/kurtis.jpg": "women/women-ethnic-wear/kurti-and-kurti-set",
    "assets/winterWear.jpg": "women/womens-western-wear/women-sweaters",
  };

  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildListDelegate([
      Padding(
        padding: const EdgeInsets.only(top: 10.0),
        child: Container(
          color: Colors.white,
          child: Padding(
            padding: const EdgeInsets.only(left: 20.0, top: 10, bottom: 10),
            child: Align(
              alignment: Alignment.centerLeft,
              child: RichText(
                text: TextSpan(
                    text: "Categories",
                    style: TextStyle(
                      color: Color(0xffdc0f21),
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      letterSpacing: 0.45,
                    ),
                    children: [
                      TextSpan(
                        text: " To bag",
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
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          color: Colors.white,
          child: Consumer<CategoryBloc>(builder: (context, snapshot, w) {
            if (snapshot.categoryData.length == 0) return Container();
            Map respData = snapshot?.categoryData ?? {};
            List categories = respData['categories'] ?? [];
            return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length + 5,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: .9),
                itemBuilder: (c, i) {
                  if (i == categories.length + 4) {
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => CategoriesPage(
                                  categoryName: null,
                                )));
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 25.0, top: 10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.grey.shade300,
                              shape: BoxShape.circle),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(bottom: 10.0),
                                child: Icon(Icons.explore),
                              ),
                              Text(
                                "Explore\nMore",
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff727272),
                                  fontSize: 14,
                                  letterSpacing: 0.45,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  } else if (i >= categories.length) {
                    i = i - categories.length;
                    String asset = moreCats.entries.elementAt(i).key;
                    String val = moreCats.entries.elementAt(i).value;
                    return InkWell(
                      onTap: () {
                        Navigator.of(context).push(MaterialPageRoute(
                            builder: (c) => CategoriesPage(
                                  categoryName: val.split("/").first,
                                  subCatName: val.split("/")[1],
                                  childCatName: val.split("/").last,
                                )));
                      },
                      child: ClipRRect(
                        borderRadius: BorderRadius.circular(10),
                        child: Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border(
                                  bottom:
                                      BorderSide(color: Colors.grey.shade300),
                                  left:
                                      BorderSide(color: Colors.grey.shade300))),
                          child: Center(
                            child: Image.asset(
                              asset,
                              fit: BoxFit.fill,
                            ),
                          ),
                        ),
                      ),
                    );
                  }
                  Map data = categories.elementAt(i);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(SlideLeftPageRouteBuilder(
                          pageBuilder: (c, a, b) => CategoriesPage(
                                categoryName: data['slug'],
                              )));
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(10),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.white,
                            border: Border(
                                bottom: BorderSide(color: Colors.grey.shade300),
                                left: BorderSide(color: Colors.grey.shade300))),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Expanded(
                              flex: 1,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(500),
                                child: Container(
                                  color: Colors.white,
                                  child: CachedNetworkImage(
                                    imageUrl:
                                        "${Session.IMAGE_BASE_URL}/assets/images/categories/${data['image']}",
                                    fit: BoxFit.fill,
                                  ),
                                ),
                              ),
                            ),
                            Expanded(
                                flex: 0,
                                child: Padding(
                                  padding: const EdgeInsets.only(
                                      left: 4.0, right: 4, top: 4, bottom: 4),
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
                  );
                });
          }),
        ),
      ),
    ]));
  }
}
