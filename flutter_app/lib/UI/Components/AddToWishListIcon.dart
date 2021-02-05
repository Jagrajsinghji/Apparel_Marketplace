import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/UI/SignInUp/MobileLogin.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

class AddToWishListIcon extends StatefulWidget {
  final Map productsData;
  final bool inWishlist;

  const AddToWishListIcon({Key key, this.productsData, this.inWishlist = false})
      : super(key: key);

  @override
  _AddToWishListIconState createState() => _AddToWishListIconState();
}

class _AddToWishListIconState extends State<AddToWishListIcon> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    AuthBloc authBloc = Provider.of<AuthBloc>(
      context,
    );
    ItemBloc _itemBloc = Provider.of<ItemBloc>(context);
    List wishListProds = _itemBloc.wishListData['wishlists'] ?? [];
    bool isPresentInWishlist = wishListProds
        .any((element) => element['slug'] == widget.productsData['slug']);
    return isLoading
        ? SpinKitSquareCircle(
            color: Color(0xffDC0F21),
            size: 20,
          )
        : InkWell(
            onTap: () async {
              Map data = authBloc.userData;
              Function function = () async
              {
                AuthBloc _authBloc1 = Provider.of<AuthBloc>(
                    context,
                    listen: false);
                if(_authBloc1.userData.length==0)
                  return;
                int id = widget.productsData['id'];
                if (id == null) return;

                if (mounted)
                  setState(() {
                    isLoading = true;
                  });

                if (!isPresentInWishlist) {
                  await Provider.of<ItemBloc>(context, listen: false)
                      .addItemToWishlist(id);
                } else {
                  var list = wishListProds.where((element) =>
                      element['slug'] == widget.productsData['slug']);
                  if (list.length != 0)
                    await Provider.of<ItemBloc>(context, listen: false)
                        .removeItemFromWishlist(list.first['wishlist_id']);
                }
                if (mounted)
                  setState(() {
                    isLoading = false;
                  });
              };

              if (data.length == 0) {
                await Navigator.push(
                    context,
                    PageRouteBuilder(
                        opaque: false,
                        barrierColor: Colors.black54,
                        transitionDuration: Duration(milliseconds: 500),
                        transitionsBuilder: (c, a, b, w) {
                          return SlideTransition(
                            position:
                                Tween(begin: Offset(0, 1), end: Offset.zero)
                                    .animate(CurvedAnimation(
                                        curve: Curves.fastLinearToSlowEaseIn,
                                        parent: a)),
                            child: w,
                          );
                        },
                        pageBuilder: (c, a, b) => MobileLogin()));
                function();
              } else
                function();
            },
            child: widget.inWishlist
                ? Padding(
                    padding: const EdgeInsets.only(right: 5.0),
                    child: Image.asset(
                      "assets/cross.png",
                      height: 15,
                      width: 15,
                    ),
                  )
                : Tooltip(
                    message: isPresentInWishlist
                        ? "Added To Wishlist"
                        : "Add To WishList",
                    child: isPresentInWishlist
                        ? Icon(
                            Icons.favorite,
                            color: Color(0xffDC0F21),
                            size: 23,
                          )
                        : Image.asset(
                            "assets/favourite.png",
                            width: 20,
                            height: 20,
                          ),
                  ),
          );
  }
}
