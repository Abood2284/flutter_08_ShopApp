import 'package:flutter/material.dart';

class Cartitem {
  final String id;
  final String title;
  final double price;
  final int quantity;

  Cartitem(
      {required this.id,
      required this.title,
      required this.price,
      required this.quantity});
}

class Cart with ChangeNotifier {
  late Map<String, Cartitem> _items;

  Map<String, Cartitem> get items {
    return {..._items};
  }

  void addItem(String id, String title, double price) {
    if (_items.containsKey(id)) {
// Change quantity if product is already there
// .update gives us the existing carditem value which we can use
      _items.update(
          id,
          (existingCartItemValue) => Cartitem(
              id: existingCartItemValue.id,
              title: existingCartItemValue.title,
              price: existingCartItemValue.price,
              quantity: existingCartItemValue.quantity + 1));
    } else {
      // Else add the item with quantity 1 if item not there already in the cart
      _items.putIfAbsent(
          id,
          () => Cartitem(
              id: DateTime.now().toString(),
              title: title,
              price: price,
              quantity: 1));
    }
  }
}
