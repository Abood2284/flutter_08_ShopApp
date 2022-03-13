import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/order_provider.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  var _isLoading = false;
  @override
  void initState() {
    super.initState();

    /// You could also use didChangeDependencies this is also another workaround to get context
    ///
    /// This means that future will be called as soon as the build i finished and then run provider
    /// Build -> Future(running for zero duration) -> then Provider called
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      try {
        await Provider.of<Orders>(context, listen: false).fetchAndSetOrder();
      } catch (e) {
        print("ERROR HERE");
        print(e);
      }
      setState(() {
        _isLoading = false;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final orderData = Provider.of<Orders>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ordered Item'),
      ),
      drawer: AppDrawer(),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(),
            )
          : ListView.builder(
              itemCount: orderData.orders.length,
              itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
            ),
    );
  }
}
