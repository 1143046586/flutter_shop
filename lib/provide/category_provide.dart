import 'package:flutter/material.dart';

class CategoryProvide with ChangeNotifier {
  List wineTypeList = [];

  setWineTypeList(List list) {
    wineTypeList = list;
    notifyListeners();
  }
}
