import 'package:flutter/material.dart';

import '../model/product.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    Product(
      id: 'p1',
      title: 'Red Shirt',
      description: 'A red shirt - it is pretty red!',
      price: 29.99,
      imageUrl:
          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    ),
    Product(
      id: 'p2',
      title: 'Trousers',
      description: 'A nice pair of trousers.',
      price: 59.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    ),
    Product(
      id: 'p3',
      title: 'Yellow Scarf',
      description: 'Warm and cozy - exactly what you need for the winter.',
      price: 19.99,
      imageUrl:
          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    ),
    Product(
      id: 'p4',
      title: 'A Pan',
      description: 'Prepare any meal you want.',
      price: 49.99,
      imageUrl:
          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    ),
  ];

  List<Product> get items {
    return [..._items]; // This will return a copy of our list.
    // ? Why we want copy and why the list is private
    //
    //* The list is private because only the data inside this class should be changed by this class only coz then and only then we will be able to notify our listeners(Look below method) that data has changed please take in new data
    // * An that is why we are returning a copy, becuase by default dart retutns the reference to that list which is in the memory
  }

  List<Product> get favoriteItem {
    return [..._items.where((prodItem) => prodItem.isFavorite)];
    // return _items.where((prodItem) => prod.isFavorite).toList(); // also correct
  }

  Product findById(String id) {
    return _items.firstWhere((prod) => prod.id == id);
  }

  void addProduct(Product product) {
    _items.insert(0, product); // at the beginning of the list
    notifyListeners(); // * This will notify our child listeners about the data changed once we add new product to the list
  }
}
