import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = 'cart-screen';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Your Orders'),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Chip(
                    label: Text(
                      '\$${cart.cartTotalAmount}',
                      style: TextStyle(color: Theme.of(context).primaryColor),
                    ),
                    backgroundColor: Colors.white,
                  ),
                  FlatButton(
                      onPressed: () {},
                      child: Text('ORDER NOW',
                          style: Theme.of(context).textTheme.bodyText1))
                ]),
          )
        ],
      ),
    );
  }
}
