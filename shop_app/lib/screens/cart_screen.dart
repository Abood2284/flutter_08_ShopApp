import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/single_cart_item.dart';
import '../providers/order_provider.dart';

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
                // ignore: deprecated_member_use
                FlatButton(
                    onPressed: () {
                      Provider.of<Orders>(context, listen: false)
                          .addItem(cart.itemsList, cart.cartTotalAmount);
                      cart.clear(); // Method defined in cart.dart to clear our cart items
                    },
                    child: Text('ORDER NOW',
                        style: Theme.of(context).textTheme.bodyText1))
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItemCount,

              /// * There are 2 ways to pass data first you convert the map to list (becuase items return a map check in cart.dart) -> cart.items.values.toList()[i].title,
              /// * You can use itemsList(which returns the list of values in that map, also defined in cart.dart) -> cart.itemsList[i].quantity
              itemBuilder: (ctx, i) => SingleCartItem(
                cart.items.values.toList()[i].title,
                cart.items.values.toList()[i].price,
                cart.itemsList[i].quantity,
                cart.itemsList[i].id,
                cart.items.keys.toList()[
                    i], // Becoz we need the key of he map, whihc is products id p1,p2
                // ! NOTE: id refrers to cart id which date.now to string, and ProductId referes to p1,p2 our products id,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
