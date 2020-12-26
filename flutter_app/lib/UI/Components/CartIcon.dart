import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:provider/provider.dart';

class CartIcon extends StatefulWidget {
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
                            style: TextStyle(fontSize: 8),
                          ),
                        ),
                        decoration: BoxDecoration(
                            color: Color(0xffdc0f21), shape: BoxShape.circle),
                      ),
                    )
                ],
              ),
              onTap: () {
                Navigator.pushNamed(context, "ShoppingBag");
              },
            ),
          ),
        );
      },
    );
  }
}
