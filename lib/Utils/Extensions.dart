import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/Bloc/ItemBloc.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

extension intToBool on int {
  bool toBool() => this != 0;
}

Future<void> refreshBlocs(BuildContext context,
    {bool logInOutRefresh = false}) async {
  ProductsBloc productsBloc = Provider.of<ProductsBloc>(context, listen: false);
  CategoryBloc categoryBloc = Provider.of<CategoryBloc>(context, listen: false);
  CartBloc cartBloc = Provider.of<CartBloc>(context, listen: false);
  AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
  OrdersBloc orderBloc = Provider.of<OrdersBloc>(context, listen: false);
  ItemBloc itemBloc = Provider.of<ItemBloc>(context, listen: false);

  orderBloc.getMyOrders();
  orderBloc.getReturnItems();
  itemBloc.getWishList();
  if (logInOutRefresh) return;
  authBloc.getUserProfile();
  cartBloc.getCartItems();
  productsBloc.getHomePage(forceRefresh: true);
  productsBloc.getHomePageExtras(forceRefresh: true);
  categoryBloc.getAllCategories(forceRefresh: true);
}

String versionName;

bool askedForLogin = false;

void initLinks() async {
  try {
    Uri initialUri = await getInitialUri();
    if (initialUri != null) {
      print(initialUri);
    }
  } on FormatException {
    print("exce");
  }
}
var goggleFont = GoogleFonts.crimsonPro().fontFamily;