import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatefulWidget {
  final GlobalKey<ScaffoldState> globalKey;

  const CartIcon({Key key, @required this.globalKey}) : super(key: key);

  @override
  _CartIconState createState() => _CartIconState();
}

class _CartIconState extends State<CartIcon> {
  @override
  Widget build(BuildContext context) {
    return Consumer<CartBloc>(
      builder: (c, s, w) {
        int totalItems = (s.cartData['products'] ?? {})?.length ?? 0;
        return Padding(
          padding: const EdgeInsets.only(right: 10.0, top: 8.0, bottom: 8.0),
          child: Container(
            width: 30,
            child: Hero(tag: "CartIcon",
              child: Material(color: Colors.transparent,
                child: InkWell(
                  focusColor: Colors.transparent,
                  splashColor: Colors.transparent,
                  child: Stack(
                    children: [
                      Center(
                        child: Image.asset(
                          "assets/cart.png",
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
                    widget.globalKey.currentState.openEndDrawer();
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
