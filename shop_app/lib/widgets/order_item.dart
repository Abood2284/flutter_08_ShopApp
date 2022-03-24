import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../model/order.dart' as ord;

class OrderItem extends StatefulWidget {
  final ord.OrderItem order;

  OrderItem(this.order);

  @override
  State<OrderItem> createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.all(20),
      child: Column(
        children: [
          ListTile(
            title: Text('\$${widget.order.amount}'),
            subtitle: Text(
              DateFormat('dd MM yyyy hh:mm').format(widget.order.dateTime),
            ),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
              icon: _expanded
                  ? const Icon(Icons.expand_less)
                  : const Icon(Icons.expand_more),
            ),
          ),
          // if (_expanded) // Bcoz we are using animated container and ternary expression in height
          // Show the animation on the container, that exapnds when the icon is pressedlk
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              padding:
                  const EdgeInsets.symmetric(horizontal: 15, vertical: 4),

              /// * This will take lesser of the 2 height
              height: _expanded ? min(widget.order.products.length * 20 + 10, 100) : 0, // Bcoz this container should not be visisble if we are not expanded
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (ctx, i) => Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      widget.order.products[i].title,
                      style: const TextStyle(fontSize: 17),
                    ),
                    Row(
                      children: [
                        Text('${widget.order.products[i].quantity}x'),
                        const SizedBox(width: 4),
                        Text('${widget.order.products[i].price}'),
                      ],
                    ),
                  ],
                ),
              ),
            )
        ],
      ),
    );
  }
}
