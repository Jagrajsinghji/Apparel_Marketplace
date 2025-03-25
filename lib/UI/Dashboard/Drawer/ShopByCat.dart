import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:provider/provider.dart';

class ShopByCategory extends StatefulWidget {
  @override
  _ShopByCategoryState createState() => _ShopByCategoryState();
}

class _ShopByCategoryState extends State<ShopByCategory> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CategoryBloc>(builder: (context, snapshot, w) {
      if (snapshot.categoryData.length == 0) return Container();
      Map respData = snapshot?.categoryData ?? {};
      List categories = respData['categories'] ?? [];
      List subCategories = respData['subcategories'] ?? [];
      List childCategories = respData['childcategories'] ?? [];
      return Padding(
        padding: const EdgeInsets.only(left: 8.0),
        child: Theme(
          data: ThemeData(accentColor: Color(0xffDC0F21),fontFamily: goggleFont,),
          child: ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: categories.length,
              itemBuilder: (c, i) {
                Map data = categories.elementAt(i);
                var children = subCats(subCategories, childCategories,
                    data['id'].toString(), data['slug']);
                if (children.length > 0)
                  return ExpansionTile(
                    title: Text(
                        "${data['slug']}".replaceAll("-", " ").toUpperCase()),
                    children: children,
                    tilePadding: EdgeInsets.zero,
                    childrenPadding: EdgeInsets.zero,
                  );
                else
                  return Container(
                    color: Colors.white,
                    child: ListTile(
                      onTap: () {
                        Navigator.of(context).push(SlideLeftPageRouteBuilder(
                            pageBuilder: (c, a, b) => CategoriesPage(
                                  categoryName: data['slug'],
                                )));
                      },
                      contentPadding: EdgeInsets.zero,
                      title: Text(
                          "${data['slug']}".replaceAll("-", " ").toUpperCase()),
                    ),
                  );
              }),
        ),
      );
    });
  }

  List<Widget> subCats(
      List subCat, List childCat, String categoryId, String catSlug) {
    List idCat = subCat
        .where((element) => element['category_id'].toString() == categoryId)
        .toList();
    return List.generate(idCat.length, (index) {
      Map subCatData = idCat.elementAt(index);
      var children = childCats(
          childCat, subCatData['id'].toString(), catSlug, subCatData['slug']);
      if (children.length > 0)
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ExpansionTile(
            tilePadding: EdgeInsets.zero,
            childrenPadding: EdgeInsets.zero,
            title: Text(
                "${subCatData['slug']}".replaceAll("-", " ").toUpperCase()),
            children: children,
          ),
        );
      else
        return Padding(
          padding: const EdgeInsets.only(left: 10.0),
          child: ListTile(
            onTap: () {
              Navigator.of(context).push(SlideLeftPageRouteBuilder(
                  pageBuilder: (c, a, b) => CategoriesPage(
                        categoryName: catSlug,
                        subCatName: subCatData['slug'],
                      )));
            },
            contentPadding: EdgeInsets.zero,
            title: Text(
                "${subCatData['slug']}".replaceAll("-", " ").toUpperCase()),
          ),
        );
    });
  }

  List<Widget> childCats(
      List childCat, String subCategoryId, String catSlug, String subCatSlug) {
    List idCat = childCat
        .where(
            (element) => element['subcategory_id'].toString() == subCategoryId)
        .toList();
    return List.generate(idCat.length, (index) {
      Map childCatData = idCat.elementAt(index);
      return Padding(
        padding: const EdgeInsets.only(left: 10.0),
        child: ListTile(
          onTap: () {
            Navigator.of(context).push(SlideLeftPageRouteBuilder(
                pageBuilder: (c, a, b) => CategoriesPage(
                      categoryName: catSlug,
                      subCatName: subCatSlug,
                      childCatName: childCatData['slug'],
                    )));
          },
          contentPadding: EdgeInsets.zero,
          title: Text(
              "${childCatData['slug']}".replaceAll("-", " ").toUpperCase()),
        ),
      );
    });
  }
}
