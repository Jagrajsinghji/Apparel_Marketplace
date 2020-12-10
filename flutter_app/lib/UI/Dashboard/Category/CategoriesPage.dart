import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AppErrorBloc.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/Utils/Constants.dart';
import 'package:provider/provider.dart';

class CategoriesPage extends StatefulWidget {
  final String categoryName;

  const CategoriesPage({Key key, this.categoryName}) : super(key: key);

  @override
  _CategoriesPageState createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage> {
  @override
  Widget build(BuildContext context) {
    AppErrorBloc errorBloc = Provider.of<AppErrorBloc>(context);
    return Scaffold(
      body: FutureBuilder<Response>(
        future: ProductsBloc.getProductsByCategoryName(
            widget.categoryName, errorBloc),
        builder: (c, s) {
          if(s.data == null)
            return Center(child: Text("Loading"));
          List prodsData = s.data.data['prods']['data'];
          return Container(
            color: Colors.grey.shade200,
            child: Padding(
              padding: const EdgeInsets.only(bottom:10.0,right: 10,left: 10),
              child: GridView.builder(
                  itemCount: prodsData.length,
                  shrinkWrap: true,
                  physics: BouncingScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      childAspectRatio: .8,
                      crossAxisCount: 2,
                      crossAxisSpacing: 10,
                      mainAxisSpacing: 10),
                  itemBuilder: (c, i) {
                    Map data = prodsData.elementAt(i) ?? {};
                    return Container( decoration: BoxDecoration(color: Colors.white,
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
                                padding:
                                const EdgeInsets.only(left: 4, right: 4, top: 4,bottom: 10),
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
                      ),
                    );
                  }),
            ),
          );
        },
      ),
    );
  }
}
