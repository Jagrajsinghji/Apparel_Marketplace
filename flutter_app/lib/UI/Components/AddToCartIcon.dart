import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class AddToCartIcon extends StatefulWidget {
  final Map productData;
  final bool inWishlist;

  const AddToCartIcon({Key key, this.productData, this.inWishlist=false}) : super(key: key);

  @override
  _AddToCartIconState createState() => _AddToCartIconState();
}

class _AddToCartIconState extends State<AddToCartIcon> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    CartBloc _cartBloc = Provider.of<CartBloc>(context);
    String itemId = widget.productData['id'].toString();
    Map cartProds = (_cartBloc.cartData ?? {})['products'] ?? {};
    bool alreadyAdded =
        cartProds.keys.any((element) => element.toString().contains(itemId));
    return (alreadyAdded&&widget.inWishlist)? Container(height: 0,width: 0,): isLoading
        ? SpinKitSquareCircle(
            color: Color(0xffDC0F21),
            size: 20,
          )
        : InkWell(
            onTap: () async {
              if (alreadyAdded) {
                var list = cartProds.entries.where(
                    (element) => element.key.toString().contains(itemId));
                if (list.length > 0) if (mounted)
                  setState(() {
                    isLoading = true;
                  });

                await _cartBloc.removeItemFromCart(list.first.key);
                if (mounted)
                  setState(() {
                    isLoading = false;
                  });
                return;
              }
              int id = widget.productData['id'];
              if (id == null) return;
              if (mounted)
                setState(() {
                  isLoading = true;
                });

              await _cartBloc.addItemByID(id);
              if (mounted)
                setState(() {
                  isLoading = false;
                });
            },
            child:widget.inWishlist
                ? Padding(
                  padding: const EdgeInsets.only(left:5.0,top: 5.0),
                  child: Container(height: 30,
                  decoration: BoxDecoration(border: Border.all(color: Color(0xffDC0F21)),
                      borderRadius: BorderRadius.circular(10)
                  ),
                  child: Center(child: Text("Add to Cart",style: TextStyle(color: Colors.black),))),
                )
                : Tooltip(
              message: alreadyAdded?"Remove From Cart":"Add To Cart",
              child: Image.asset(
                "assets/cart.png",
                width: 20,
                height: 20,
                color: alreadyAdded ? Color(0xffDC0F21) : Colors.black,
              ),
            ),
          );
  }
}
