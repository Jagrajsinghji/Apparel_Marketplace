import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Category/CategoriesPage.dart';

class DealsPage extends StatefulWidget {
  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  Map<String, Widget> bannersLinks = {
    "1.jpg": CategoriesPage(
      subCatName: "men-topwear",
      categoryName: "men",
    ),
    "assets/Banners/Deal_Zone1.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      childCatName: "women-jackets-coats",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone2.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      childCatName: "cardigan",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone3.jpg": CategoriesPage(
      subCatName: "boys-clothing",
      childCatName: "jackets-sweater-and-sweatshirts",
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone4.jpg": CategoriesPage(
      subCatName: "men-topwear",
      childCatName: "men-t-shirts",
      categoryName: "men",
    ),
    "2.jpg": CategoriesPage(
      subCatName: "men-topwear",
      categoryName: "men",
    ),
    "assets/Banners/Deal_Zone5.jpg": CategoriesPage(
      childCatName: "men-t-shirts",
      subCatName: "men-topwear",
      categoryName: "men",
    ),
    "assets/Banners/Deal_Zone6.jpg": CategoriesPage(
      subCatName: "boys-clothing",
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone7.jpg": CategoriesPage(
      subCatName: "boys-clothing",
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone8.jpg": CategoriesPage(
      subCatName: "boys-clothing",
      categoryName: "kids",
    ),
    "3.jpg": CategoriesPage(
      subCatName: "men-topwear",
      categoryName: "men",
    ),
    "assets/Banners/Deal_Zone9.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      childCatName: "dresses",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone10.jpg": CategoriesPage(
      subCatName: "men-topwear",
      childCatName: "men-t-shirts",
      categoryName: "men",
    ),
    "assets/Banners/Deal_Zone11.jpg": CategoriesPage(
      subCatName: "womens-sleepwear-and-lounge-wear",
      childCatName: "womens-nightsuit-and-tracksuit",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone12.jpg": CategoriesPage(
      subCatName: "womens-sleepwear-and-lounge-wear",
      childCatName: "womens-nightsuit-and-tracksuit",
      categoryName: "women",
    ),
    "4.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone13.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      childCatName: "cardigan",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone14.jpg": CategoriesPage(
      subCatName: "women-ethnic-wear",
      childCatName: "women-saree",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone15.jpg": CategoriesPage(
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone16.jpg": CategoriesPage(
      categoryName: "kids",
    ),
    "5.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone17.jpg": CategoriesPage(
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone18.jpg": CategoriesPage(
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone19.jpg": CategoriesPage(
      categoryName: "kids",
    ),
    "assets/Banners/Deal_Zone20.jpg": CategoriesPage(
      categoryName: "kids",
    ),
    "6.jpg": CategoriesPage(
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone21.jpg": CategoriesPage(
      categoryName: "women",
    ),
    "assets/Banners/Deal_Zone22.jpg": CategoriesPage(
      subCatName: "womens-western-wear",
      categoryName: "women",
    ),
    "800X250.jpg": CategoriesPage(
      categoryName: "kids",
    )
  };
  int i = 0;

  @override
  Widget build(BuildContext context) {
    return ListView(
      physics: BouncingScrollPhysics(),
      shrinkWrap: true,
      children: [
        // InkWell(
        //   onTap: () async {
        //     PickedFile file = await ImagePicker().getImage(
        //       source: ImageSource.camera,
        //     );
        //     if (file != null) {
        //       showDialog(
        //           context: context,
        //           child: AlertDialog(
        //             title: Text("Your request is being processed by us."),
        //             content: Text(
        //                 "Please wait! After processing your request your account will be credited with WOWFAS Points. "),
        //           ));
        //     }
        //   },
        //   child: Padding(
        //     padding: const EdgeInsets.symmetric(vertical: 20),
        //     child: Container(
        //       color: Colors.white,
        //       height: 80,
        //       child: Row(
        //         mainAxisAlignment: MainAxisAlignment.center,
        //         children: [
        //           Expanded(
        //               flex: 0,
        //               child: Padding(
        //                 padding: const EdgeInsets.symmetric(horizontal: 20),
        //                 child: Icon(Icons.camera),
        //               )),
        //           Expanded(
        //               flex: 1,
        //               child: Text(
        //                 "Scan your bills\n&\nGet 10% upto \u20B9 100 ",
        //                 style: TextStyle(fontSize: 16),
        //               ))
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        Wrap(
          crossAxisAlignment: WrapCrossAlignment.center,
          alignment: WrapAlignment.center,
          children: [
            ...List.generate(bannersLinks.length, (index) {
              String element = bannersLinks.entries.elementAt(index).key;
              Widget widget = bannersLinks.entries.elementAt(index).value;
              if (element.contains("Deal_Zone"))
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (c) => widget));
                    },
                    child: Container(
                      width: MediaQuery.of(context).size.width / 2.5,
                      child: Image.asset("$element"),
                    ),
                  ),
                );
              else
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.push(
                          context, MaterialPageRoute(builder: (c) => widget));
                    },
                    child: Image.asset("assets/DealsBanners/$element"),
                  ),
                );
            })
          ],
        ),
        // .builder(gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2),
        // shrinkWrap: true,
        // physics: NeverScrollableScrollPhysics(),
        // itemCount: 21,
        // itemBuilder: (BuildContext context, int index) {
        //
        // },
        // ),
      ],
    );
  }
}
