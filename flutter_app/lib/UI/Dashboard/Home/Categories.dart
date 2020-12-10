import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:provider/provider.dart';

class Categories extends StatefulWidget {
  @override
  _CategoriesState createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories> {
  @override
  Widget build(BuildContext context) {
    AppErrorBloc errorBloc = Provider.of<AppErrorBloc>(context);
    return SliverList(
        delegate: SliverChildListDelegate([
          Padding(
            padding: const EdgeInsets.only(top:10.0),
            child: Container(color: Colors.grey.shade200,
              child: Padding(
                padding: const EdgeInsets.only(left: 20.0,top: 10,bottom: 10),
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
      Container(color: Colors.grey.shade200,
        child: FutureBuilder<Response>(
            future: CategoryBloc.getAllCategories(errorBloc),
            builder: (context, snapshot) {
              if (snapshot.data == null)
                return Center(child: Text("Loading Categories"));
              Map respData = snapshot?.data?.data ?? {};
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
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          flex: 1,
                          child: ClipRRect(borderRadius: BorderRadius.circular(500),
                            child: Container( color: Colors.white,
                              child: CachedNetworkImage(
                                imageUrl:
                                    "${Constants.BASE_URL}/assets/images/categories/${data['photo'] ?? "1568878596home.jpg"}",
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                            flex: 0,
                            child: Padding(
                              padding:
                              const EdgeInsets.only(left: 4.0, right: 4, top: 4,bottom: 4),
                              child: Text(
                                "${data['name']}",maxLines: 2,
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: Color(0xff727272),
                                  fontSize: 12,
                                  letterSpacing: 0.45,
                                ),
                              ),
                            )),
                      ],
                    );
                  });
            }),
      ),
    ]));
  }
}
