import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/cart.dart';
import '../widgets/single_cart_item.dart';
import '../providers/orders.dart';

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
                OrderButton(cart: cart)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key? key,
    required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  State<OrderButton> createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var _isLoading = false;
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
        onPressed: widget.cart.cartTotalAmount <= 0
            ? null
            : () async {
              setState(() {
                _isLoading = true;
              });
                await Provider.of<Orders>(context, listen: false).addItem(
                    widget.cart.itemsList, widget.cart.cartTotalAmount);
                widget.cart
                    .clear(); // Method defined in cart.dart to clear our cart items
                    setState(() {
                      _isLoading = false;
                    });
              },
        child: _isLoading ? const Center(child: CircularProgressIndicator(),) : Text('ORDER NOW', style: Theme.of(context).textTheme.bodyText1));
  }
}
