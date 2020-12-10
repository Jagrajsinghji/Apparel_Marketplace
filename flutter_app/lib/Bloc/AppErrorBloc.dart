
import 'package:flutter/material.dart';

class AppErrorBloc with ChangeNotifier{
  String errorMessage = "Couldn't Connect to Server.";


   void updateError(String msg){
    this.errorMessage = msg;
    notifyListeners();
  }

}