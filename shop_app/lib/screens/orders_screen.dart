import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrdersScreen extends StatelessWidget {
  static const routeName = 'order-screen';
  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordered Item'),
      ),
      drawer: AppDrawer(),
      body: ListView.builder(
        itemCount: orderData.orders.length,
        itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
      ),
    );
  }
}
