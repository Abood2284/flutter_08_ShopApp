import 'dart:convert'; // to convert dart code to json

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/product.dart';
import '../constants.dart';

class Products with ChangeNotifier {
  // ignore: prefer_final_fields
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
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

  /// Async wraps the code in a future so everything inside is a future also in async code you can use a keyword await : whihc when added on a line or group of code then other code in async will have to wait till await code has been completed it is replacement of .then method
  Future<void> addProduct(Product product) async {
    /// sTORING OUR FIREBASE URL IN A VARIABLE THIS WILL BE CONVERTED TO QUERY BY FLUTTER.
    /// In fireBase url you can create folders by adding /folder-name.json as this will be converted to quert which will execute and create a folder if not there already-> here products.json folder is created inside that we post
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/products.json');

    /// .post takes in url where you want to post and some named args,
    /// body defines how and what your db should have.
    /// as body and everything on backend works on json so we import dart:converter to import our dart to json.
    /// As you know Js more works with maps some key and value that is why we tried to pass maps which suited us, though body takes dynamic value
    ///
    /// await: first let this code complete then only other should run
    /// Also down there we need response as i said wrapping code in async returns future so now we can store the result of await in variable response
    ///
    /// As this code have a chance of throwing an error lets wrap it then try-catch block
    try {
      final response = await http.post(url,
          body: json.encode({
            'title': product.title,
            'description': product.description,
            'price': product.price,
            'imageUrl': product.imageUrl,
            'isFavorite': product.isFavorite,
          }));

      /// I will only run once the await block is completed is running
      // Firebase sends us the response which is the cryptic id you see infront of your products.json
      final newProduct = Product(
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        id: json.decode(response.body)[
            'name'], // as it is map, how i know? when you print logger you can see   And now we can use our Firebase Backend unique Id generated in our frontEnd also, this will help us in deleting item in the backend as well as frontend
      );
      _items.add(newProduct);
      notifyListeners(); // * This will notify our child listeners about the data changed once we add new product to the list
      return Future.value(); // Returning Future
    } catch (error) {
      logger.d(error);
      // in case we get an error we can throw that error,
      // and so that we can handle it in our widget class/tree
      rethrow; // throw error -> rethrow
    }
  }

  Future<void> fetchProduct() async {
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/products.json');
    try {
      final response = await http
          .get(url); // wait the execution of below code till i am done
      // logger.d(json.decode(response.body));
      final extractedData = json.decode(response.body) as Map<String,
          dynamic>; // how i know? you can use logger to first print the decoded json value there you will see key as id and value is another map having key descrotion, title and value thier value which i added
          if(extractedData == null) {
            return;
          }
      final List<Product> _loadedItems =
          []; // Creating empty list that will store loaded product and replace the original list with this later

      // will run for each id, here we fetch 2 maps as for now having thier own map
      //! FORMAT WHEN YOU DECODE JSON RESPONSE
//       ┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄┄
// I/flutter (12878): │ 🐛 {
// I/flutter (12878): │ 🐛   "-Mxxz3RFnljMkHRtTKm-": {
// I/flutter (12878): │ 🐛     "description": "This is a great book!",
// I/flutter (12878): │ 🐛     "imageUrl": "https://pixabay.com/get/gbded59789b3bdcdab570a582a19574b49baa39993976c30cf2d58fd5008a99c45eca32ade29588e0270d9ced39afb8fdb4f6fc92504ee13e96d61767c244bb7930e7b30ffca4d55c8233a61caf584f36_1920.jpg",
// I/flutter (12878): │ 🐛     "isFavorite": false,
// I/flutter (12878): │ 🐛     "price": 12.99,
// I/flutter (12878): │ 🐛     "title": "Book"
// I/flutter (12878): │ 🐛   },
// I/flutter (12878): │ 🐛   "-MxxzO1dGU_X-0WYkx_H": {
// I/flutter (12878): │ 🐛     "description": "This is a red gucci t-shirt!",
// I/flutter (12878): │ 🐛     "imageUrl": "https://pixabay.com/get/gd7428864dfa36b3cb4436a03be352c970c2db044bd8f0b3b4d3b02cbd57d9bdc91fc4a45daf203ad12dbc0fd20246786a6bd63d9bb754f97b28f04469bc5437afe654ede7b020b901e8178e278615eb3_1280.jpg",
// I/flutter (12878): │ 🐛     "isFavorite": false,
// I/flutter (12878): │ 🐛     "price": 9.34,
// I/flutter (12878): │ 🐛     "title": "Red T-shirt"
// I/flutter (12878): │ 🐛   }
// I/flutter (12878): │ 🐛 }
// I/flutter (12878): └───────────────────────────────────

// also create new prdocut object for each map you run
      extractedData.forEach((prodId, prodData) {
        _loadedItems.add(Product(
          id: prodId,
          title: prodData['title'],
          description: prodData['description'],
          imageUrl: prodData['imageUrl'],
          price: prodData['price'],
          isFavorite: prodData['isFavorite'],
        ));
      });
      // replace empty list with loaded list
      _items = _loadedItems;
      notifyListeners();
    } catch (e) {
      // throw e;
      rethrow;
    }
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    /// Return the index where the first cond. is met
    final productIndex = _items.indexWhere((prod) => prod.id == id);
    // Json allow us to dig deeper into project strucuture using /
    // SInce we need only single product and we also have the id of the product we can refer to it now
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/products/$id.json');
    await http.patch(url,
        body: json.encode({
          'title': newProduct.title,
          'imageUrl': newProduct.imageUrl,
          'description': newProduct.description,
          'price': newProduct.price,
        }));
    _items[productIndex] = newProduct;
    notifyListeners();
  }

// * Deletes the item with the respected id
/// LOGIC BEHIND DELETE PRODUCT
/// 
/// 1 - We store the product url to be deleted
/// 2 - we store that product index in a variable 
/// 3 - we store the product which is going to be deleted in a variable
/// 4 - we remove the product from the list not the database
/// 5 - we send request to db to delete prodcut waiting for response
/// 6 - if response code is greater than 400 then we know its an error and we make into if block
/// 7 - recovering the deleted product by again inserting the product back at the same index using the variable we created to store index and product
/// 8 - we throw error if we made into if block which is handled in user_products_screen
/// 
/// 9 - if we make out of if block the variable holding the product will be null so there will no chance to recover hence making the db response success
  Future<void> deleteItem(String id) async {
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/products/$id.json');
    final existingProductIndex =
        _items.indexWhere((element) => element.id == id);
    Product? existingProduct = _items[existingProductIndex];
    _items.removeWhere((element) => element.id == id);
    notifyListeners();
    final response = await http.delete(url);
    // only get & post returns error reponse. for patch, update, delete you need to set your own response code error condition since we are familiair that status code above 400 is error
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw Exception();
    }
    //! You will not make here if throw Exception() is called.
    existingProduct = null;
  }
}
