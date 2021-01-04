import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:flutter_app/Bloc/CategoryBloc.dart';
import 'package:flutter_app/Bloc/ProductsBloc.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:provider/provider.dart';

extension intToBool on int {
  bool toBool() => this != 0;
}

void refreshBlocs(BuildContext context) {
  ProductsBloc productsBloc = Provider.of<ProductsBloc>(context, listen: false);
  CategoryBloc categoryBloc = Provider.of<CategoryBloc>(context, listen: false);
  CartBloc cartBloc = Provider.of<CartBloc>(context, listen: false);
  AuthBloc authBloc = Provider.of<AuthBloc>(context, listen: false);
  OrdersBloc orderBloc = Provider.of<OrdersBloc>(context, listen: false);
  productsBloc.getHomePage();
  productsBloc.getHomePageExtras();
  categoryBloc.getAllCategories();
  cartBloc.getCartItems();
  authBloc.getUserProfile();
  orderBloc.getMyOrders();
}
