import 'package:flutter/foundation.dart';
import 'package:hive/hive.dart';
import 'package:hive_flutter/hive_flutter.dart';

class RecentProdsBloc {
  static Box _box;
  static RecentProdsBloc _instance;

  RecentProdsBloc._private() {
    initializeHive();
  }

  factory RecentProdsBloc.instance() {
    _instance ??= RecentProdsBloc._private();
    return _instance;
  }


  ValueListenable<Box> get listenable=> _box?.listenable();
  initializeHive() async {
    await Hive.initFlutter("Recents");
    _box = await Hive.openBox("RecentViewedProducts");

  }

  setProduct(Map product, String slug) async {
    Map data = {}..addAll(product)
    ..addAll({"lastViewedByUser":DateTime.now().toIso8601String()});
    if (_box.isOpen) {
      _box.put(slug, data);
    } else {
      await initializeHive();
      setProduct(product,slug);
    }
  }
}
extension GetProds on Box{
  List getProducts() {
    if (this.isOpen) {
      List data = [];
      this.keys.forEach((element) {
        data.add(this.get(element));
      });

      return data;
    } else
      return [];
  }
}