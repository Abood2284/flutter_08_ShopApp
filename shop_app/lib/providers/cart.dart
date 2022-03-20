// how should a item look like in a cart
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
  Map<String, Cartitem> _items = {};

  /// * Reutns us a copy of our original map
  Map<String, Cartitem> get items {
    return {..._items};
  }

  /// * Returning the values of the map as a list
  List<Cartitem> get itemsList {
    return items.values.toList();
  }

  /// * Returns the total cart count inlcuding the quantity of the item
  int get itemsCount {
    var totalCartCount = 0;
    _items.forEach(((key, value) {
      totalCartCount += value.quantity;
    }));
    return totalCartCount;
  }

  /// * Returns the total cart amount by quantity * price
  double get cartTotalAmount {
    var totalAmount = 0.0;
    _items.forEach((key, value) {
      totalAmount += value.price * value.quantity;
    });
    return totalAmount;
  }

  /// * Returns the item count, excluding the quantity of the item
  int get cartItemCount {
    return _items.length;
  }

  /// * To add new item to the map
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
    notifyListeners();
  }

  /// * Removes item from the cart
  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  /// * Removes single quantity from the cart if there is more than 1 used for undo using snackbar
  void removeSingleItem(String prodId) {
    if (!_items.containsKey(prodId)) {
      return;
    }
    if (_items[prodId]!.quantity > 1) {
      _items.update(
          prodId,
          (existingCartItem) => Cartitem(
              id: existingCartItem.id,
              price: existingCartItem.price,
              title: existingCartItem.title,
              quantity: existingCartItem.quantity - 1));
    } else {
      _items.remove(prodId);
    }
    notifyListeners();
  }

  /// * Clears item in the cart
  void clear() {
    _items = {};
    notifyListeners();
  }
}
