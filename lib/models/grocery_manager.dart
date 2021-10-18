import 'package:flutter/material.dart';
import 'grocery_item.dart';

class GroceryManager extends ChangeNotifier {
  final _groceryItems = <GroceryItem>[];

  List<GroceryItem> get groceryItems => List.unmodifiable(_groceryItems);

  void deleteItem(int idx) {
    _groceryItems.removeAt(idx);
    notifyListeners();
  }

  void addItem(GroceryItem item) {
    _groceryItems.add(item);
    notifyListeners();
  }

  void updateItem(GroceryItem item, int idx) {
    _groceryItems[idx] = item;
    notifyListeners();
  }

  void completeItem(int idx, bool change) {
    final item = _groceryItems[idx];
    _groceryItems[idx] = item.copyWith(isComplete: change);
    notifyListeners();
  }
}
