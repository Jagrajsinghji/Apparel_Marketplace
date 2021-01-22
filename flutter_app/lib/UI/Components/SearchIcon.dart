import 'package:flutter/material.dart';
import 'package:flutter_app/UI/Dashboard/Search/SearchProds.dart';

class SearchIcon extends StatefulWidget {
  @override
  _SearchIconState createState() => _SearchIconState();
}

class _SearchIconState extends State<SearchIcon> {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: InkWell(
        focusColor: Colors.transparent,
        splashColor: Colors.transparent,
        child: Hero(tag: "SearchTag",
          child: Image.asset(
            "assets/search.png",
            width: 20,
            height: 20,
          ),
        ),
        onTap: () {
          Navigator.push(
              context,
              PageRouteBuilder(
                  opaque: false,
                  barrierColor: Colors.black.withOpacity(.8),
                  transitionDuration: Duration(
                    milliseconds: 500,
                  ),
                  reverseTransitionDuration:
                  Duration(milliseconds: 500),
                  transitionsBuilder: (c, a, b, w) {
                    return SlideTransition(
                      position: Tween(
                          end: Offset.zero,
                          begin: Offset(0, -1))
                          .animate(CurvedAnimation(
                          parent: a,
                          curve: Curves.fastLinearToSlowEaseIn)),
                      child: w,
                    );
                  },
                  pageBuilder: (c, a, b) => SearchProds()));
        },
      ),
    );
  }
}
