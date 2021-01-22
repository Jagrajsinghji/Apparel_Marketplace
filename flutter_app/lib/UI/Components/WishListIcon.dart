import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/UI/Dashboard/Cart/WishList.dart';
import 'package:provider/provider.dart';

class WishListIcon extends StatefulWidget {
  const WishListIcon({Key key}) : super(key: key);

  @override
  _WishListIconState createState() => _WishListIconState();
}

class _WishListIconState extends State<WishListIcon> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ItemBloc>(
      builder: (c, s, w) {
        int totalItems = (s.wishListData['wishlists'] ?? [])?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 8.0, bottom: 8.0),
          child: Container(
            width: 30,
            child: Hero(tag: "WishlistIcon",
              child: Material(color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/favourite.png",
                          width: 20,
                          height: 20,
                        ),
                      ),
                      if (totalItems != 0)
                        Positioned(
                          top: 5,
                          right: 0,
                          child: Container(
                            child: Padding(
                              padding: const EdgeInsets.all(4.0),
                              child: Text(
                                "$totalItems",
                                style: TextStyle(fontSize: 8,color: Colors.white),
                              ),
                            ),
                            decoration: BoxDecoration(
                                color: Color(0xffdc0f21), shape: BoxShape.circle),
                          ),
                        )
                    ],
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
                            reverseTransitionDuration: Duration(milliseconds: 500),
                            transitionsBuilder: (c, a, b, w) {
                              return SlideTransition(
                                position:
                                    Tween(end: Offset.zero, begin: Offset(0, -1))
                                        .animate(CurvedAnimation(
                                            parent: a, curve: Curves.decelerate)),
                                child: w,
                              );
                            },
                            pageBuilder: (c, a, b) => WishList()));
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
