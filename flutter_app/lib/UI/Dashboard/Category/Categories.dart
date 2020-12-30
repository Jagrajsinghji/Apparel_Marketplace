import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
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
              child: Text(
                "Categories to bag",
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
      Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: Container(
          color: Colors.white,
          child: Consumer<CategoryBloc>(builder: (context, snapshot, w) {
            if (snapshot.categoryData.length == 0)
              return Center(child: Text("Loading Categories"));
            Map respData = snapshot?.categoryData ?? {};
            List categories = respData['categories'] ?? [];
            return GridView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: categories.length,
                gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 3,
                    crossAxisSpacing: 5,
                    mainAxisSpacing: 5,
                    childAspectRatio: .9),
                itemBuilder: (c, i) {
                  Map data = categories.elementAt(i);
                  return InkWell(
                    onTap: () {
                      Navigator.of(context).push(PageRouteBuilder(
                          transitionDuration: Duration(seconds: 1),
                          reverseTransitionDuration:
                              Duration(milliseconds: 800),
                          pageBuilder: (c, a, b) => CategoriesPage(
                                tag: data['slug'] + "tag",
                                categoryName: data['slug'],
                              )));
                    },
                    child: Hero(
                      tag: data['slug'] + "tag",
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
                                      errorWidget: (c, w, e) {
                                        ///TODO: change this to something else default
                                        return Image.asset(
                                          "assets/men.png",
                                        );
                                      },
                                      imageUrl:
                                          "${Session.BASE_URL}/assets/images/categories/${data['photo'] ?? "1568878596home.jpg"}",
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
                    ),
                  );
                });
          }),
        ),
      ),
    ]));
  }
}
