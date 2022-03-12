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
    final scaffold = ScaffoldMessenger.of(
        context); // Becuase context will not be availble in async method as build will be running and flutter will not be able to indentify which context you want this or previous one
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
              onPressed: () async {
                //..Delete the product
                try {
                  /// Wait for .delete to be finished as its method return Future and throws error if it throws error the below catch block will handle it
                  await Provider.of<Products>(context, listen: false)
                      .deleteItem(product.id!);
                } catch (error) {
                  scaffold.showSnackBar(
                    const SnackBar(
                      content: Text(
                        'Deleting failed!',
                        textAlign: TextAlign.center,
                      ),
                    ),
                  );
                }
              },
              icon: Icon(Icons.delete, color: Theme.of(context).errorColor),
            ),
          ],
        ),
      ),
    );
  }
}
