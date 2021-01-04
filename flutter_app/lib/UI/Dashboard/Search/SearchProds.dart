import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Components/CartIcon.dart';
import 'package:flutter_app/UI/Components/GlobalWidget.dart';
import 'package:flutter_app/UI/Dashboard/Cart/WishList.dart';

class SearchProds extends StatefulWidget {

  @override
  _SearchProdsState createState() => _SearchProdsState();
}

class _SearchProdsState extends State<SearchProds> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        appBar: AppBar(
          elevation: 0,
          leading: FlatButton(
            child: Image.asset("assets/backArrow.png"),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          backgroundColor: Colors.white,
          title: TextFormField(
            decoration: InputDecoration(prefixIcon:  Hero(
              tag: "SearchTag",
              child: Icon(Icons.search,size: 30,color: Colors.black,),
            ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent)),
              focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide(color: Colors.transparent)),
              errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              hintText: "Search for products and brands",
              hintStyle: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w400,
            ),
          ),
          titleSpacing: -15,
          actions: [
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: InkWell(
            //     focusColor: Colors.transparent,
            //     splashColor: Colors.transparent,
            //     child: Hero(
            //       tag: "WishList",
            //       child: Image.asset(
            //         "assets/favourite.png",
            //         width: 20,
            //         height: 20,
            //       ),
            //     ),
            //     onTap: () {
            //       Navigator.push(
            //           context,
            //           PageRouteBuilder(
            //               transitionDuration: Duration(seconds: 1),
            //               reverseTransitionDuration:
            //                   Duration(milliseconds: 800),
            //               pageBuilder: (c, a, b) => WishList()));
            //     },
            //   ),
            // ),
            CartIcon()
          ],
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: Container(),
        bottomNavigationBar: bottomNavigation(context, voidCallback: () {
          Navigator.popUntil(context, (p) => p.isFirst);
        }),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        floatingActionButton: floatingActionButton(context, voidCallback: () {
          Navigator.popUntil(context, (p) => p.isFirst);
        }));
  }
}
