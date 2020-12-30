import 'package:flutter/material.dart';

class ScreenBloc with ChangeNotifier {
  int page = 0;

  void setPage(int page) {
    this.page = page;
    notifyListeners();
  }
}
