import 'package:flutter/foundation.dart';

class FoodItem {
  final String id;
  final String name;
  final double price;
  int qty;
  FoodItem({required this.id, required this.name, required this.price, this.qty = 0});
}

class FnbViewModel extends ChangeNotifier {
  final List<FoodItem> items = [
    FoodItem(id: 'p1', name: 'Popcorn', price: 5.0),
    FoodItem(id: 'd1', name: 'Soft Drink', price: 3.0),
    FoodItem(id: 'c1', name: 'Combo', price: 7.5),
  ];

  double get total => items.fold(0.0, (sum, i) => sum + i.price * i.qty);

  void inc(FoodItem i) {
    i.qty++;
    notifyListeners();
  }

  void dec(FoodItem i) {
    if (i.qty > 0) i.qty--;
    notifyListeners();
  }
}
