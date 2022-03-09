import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../screens/edit_product_screen.dart';
import '../model/product.dart';
import '../providers/products.dart';

class UserProductItem extends StatelessWidget {
  final Product product;

  UserProductItem(this.product);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      title: Text(product.title),
      leading: CircleAvatar(
        backgroundImage: NetworkImage(product.imageUrl),
      ),

      /// ! Because row takes infinite Wdith and trailing dont stop it resulting in out of the box render so to stop added a fixed width.
      trailing: Container(
        width: 100,
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.edit,
                color: Theme.of(context).primaryColor,
              ),
              onPressed: () {
                //..Edit the product
                Navigator.of(context)
                    .pushNamed(EditProductScreen.routeName, arguments: product);
              },
            ),
            IconButton(
              onPressed: () {
                //..Delete the product
                Provider.of<Products>(context, listen: false).deleteItem(product.id!);
              },
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
            ),
          ],
        ),
      ),
    );
  }
}
