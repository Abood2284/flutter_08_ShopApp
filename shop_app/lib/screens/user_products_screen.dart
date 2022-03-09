import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = 'user-product-screen';

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products'), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
          icon: Icon(Icons.add),
        ),
      ]),
      drawer: AppDrawer(),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: ListView.builder(
          itemCount: productsData.items.length,
          itemBuilder: (_, i) => Column(
            children: [
              UserProductItem(productsData.items[i]),
              const Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
