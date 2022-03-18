import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import '../model/order.dart';
import './cart.dart';
// import '../constants.dart';

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  late String? authToken;

  Orders(this.authToken, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchAndSetOrder() async {
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    try {
      final response = await http.get(url);
      // print(json.decode(response.body));
      /// Now we are going to convert this cryptic data into our OrderItem
      /// same as the format Map<String, dynamic>
      /// though in dynamic map products key is List of dynamic(CartItem object) values
      ///
      // {-My2AXI0raOqoGEKOBjK: {amount: 54.22, dateTime: 2022-03-13T17:38:31.895862, products: [{id: 2022-03-13 17:37:58.785862, price: 12.99, quantity: 1, title: Book}, {id: 2022-03-13 17:38:24.490091, price: 20.0, quantity: 2, title: Red Shirt}, {id: 2022-03-13 17:38:26.625944, price: 1.23, quantity: 1, title: Steel pen}]}}
      final List<OrderItem> _loadedOrders = [];
      final extractedData = json.decode(response.body) as Map<String, dynamic>;
      // logger.d(extractedData);
      if (jsonDecode(response.body) == null) {
        return;
      }
      extractedData.forEach((orderId, orderData) {
        _loadedOrders.add(OrderItem(
            id: orderId,
            amount: orderData['amount'],
            dateTime: DateTime.parse(orderData['dateTime']),
            products: (orderData['products']
                    as List<dynamic>) // its a list so run .map
                .map((item) => Cartitem(
                    //  Where each item is a map
                    id: item['id'],
                    title: item['title'],
                    price: item['price'],
                    quantity: item['quantity']))
                .toList()));
      });
      // So that newest orders are on top
      _orders = _loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      rethrow;
    }
  }

  Future<void> addItem(List<Cartitem> cartProducts, double total) async {
    final url = Uri.parse(
        'https://flutter-08-shopapp-udemy-default-rtdb.firebaseio.com/orders.json?auth=$authToken');
    final commonDateTime = DateTime.now();
    final response = await http.post(url,
        body: json.encode({
          'amount': total,
          'dateTime': commonDateTime.toIso8601String(),
          'products': cartProducts
              .map((cp) => {
                    'id': cp.id,
                    'title': cp.title,
                    'price': cp.price,
                    'quantity': cp.quantity
                  })
              .toList()
        }));
    _orders.insert(
        0,
        OrderItem(
          id: json.decode(response.body)['name'],
          amount: total,
          dateTime: commonDateTime,
          products: cartProducts,
        ));
    notifyListeners();
  }
}
