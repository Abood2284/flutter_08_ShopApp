import 'dart:convert'; // to convert dart code to json

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/product.dart';
import '../constants.dart';

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

  Future<void> addProduct(Product product) {
    /// sTORING OUR FIREBASE URL IN A VARIABLE THIS WILL BE CONVERTED TO QUERY BY FLUTTER.
    /// In fireBase url you can create folders by adding /folder-name.json as this will be converted to quert which will execute and create a folder if not there already-> here products.json folder is created inside that we post
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/products');

    /// we imported our http.dart as http
    /// .post takes in url where you want to post and some named args,
    /// body defines how and what your db should have.
    /// as body and everything on backend works on json so we import dart:converter to import our dart to json.
    /// As you know Js more works with maps some key and value that is why we tried to pass maps which suited us, though body takes dynamic value
    /// 
    /// Since we made this Future we need to return something, also .then returns us a future which makes dart satisfied
   return http
        .post(url,
            body: json.encode({
              'title': product.title,
              'description': product.description,
              'price': product.price,
              'imageUrl': product.imageUrl,
              'isFavorite': product.isFavorite,
            }))
            /// * Http requests runs async(this will execute but it will not wait for response it will continue it's execution of code below it) so if you want to wait to get back the response then use Future returned by post
        .then((response) {
          logger.d('Response Recieved');
      // Firebase sends us the response which is the cryptic id you see infront of your products.json to see this
      logger.d(json.decode(response.body)); // It will print id of the product which just added though it will in map
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)['name'], // as it is map, how i know? when you print logger you can see   And now we can use our Firebase Backend unique Id generated in our frontEnd also, this will help us in deleting item in the backend as well as frontend
      );
      _items.add(newProduct);
      notifyListeners(); // * This will notify our child listeners about the data changed once we add new product to the list
      return Future.value();// Returning Future
    }).catchError((error) {
      throw error; // becuase this is not our widget class and we cannot do much here so we throw trh error and catch this error in edit_product_screen were we could do something about this error
    });
  }

  void updateProduct(String id, Product newProduct) {
    /// Return the index where the first cond. is met
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    _items[productIndex] = newProduct;
    notifyListeners();
  }

// * Deletes the item with the respected id
  void deleteItem(String id) {
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
