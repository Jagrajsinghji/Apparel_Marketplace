
import 'package:flutter/material.dart';

class AppErrorBloc with ChangeNotifier{
  String errorMessage = "";

   void updateError(String msg){
    this.errorMessage = msg;
    notifyListeners();
  }



}