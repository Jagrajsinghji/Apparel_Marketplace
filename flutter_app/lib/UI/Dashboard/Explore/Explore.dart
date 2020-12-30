import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:provider/provider.dart';

class Explore extends StatefulWidget {
  @override
  _ExploreState createState() => _ExploreState();
}

class _ExploreState extends State<Explore> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: Consumer<CategoryBloc>(builder: (context, snapshot, w) {
        if (snapshot.categoryData.length == 0)
          return Center(child: Text("Loading Categories"));
        Map respData = snapshot?.categoryData ?? {};
        List categories = respData['categories'] ?? [];
        List subCategories = respData['subcategories'] ?? [];
        List childCategories = respData['childcategories'] ?? [];
        return ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: categories.length,
            itemBuilder: (c, i) {
              Map data = categories.elementAt(i);
              var children = subCats(
                  subCategories, childCategories, data['id'].toString());
              if (children.length > 0)
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    color: Colors.white,
                    child: ExpansionTile(
                      title: Text("$data"),
                      children: children,
                    ),
                  ),
                );
              else
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 10),
                  child: Container(
                    color: Colors.white,
                    child: ListTile(
                      title: Text("$data"),
                    ),
                  ),
                );
            });
      }),
    );
  }

  List<Widget> subCats(List subCat, List childCat, String categoryId) {
    List idCat = subCat
        .where((element) => element['category_id'].toString() == categoryId)
        .toList();
    return List.generate(idCat.length, (index) {
      Map subCatData = idCat.elementAt(index);
      var children = childCats(childCat, subCatData['id'].toString());
      if (children.length > 0)
        return ExpansionTile(
          title: Text("${idCat.elementAt(index)}"),
          children: children,
        );
      else
        return ListTile(
          title: Text("$subCatData"),
        );
    });
  }

  List<Widget> childCats(List childCat, String subCategoryId) {
    List idCat = childCat
        .where(
            (element) => element['subcategory_id'].toString() == subCategoryId)
        .toList();
    return List.generate(idCat.length, (index) {
      Map childCatData = idCat.elementAt(index);
      return ListTile(
        title: Text("$childCatData"),
      );
    });
  }
}
