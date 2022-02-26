import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments
        as String; // is Id of the product
    /// * Return the product objecte where the id is met
    final loadedPoduct = Provider.of<Products>(context, listen: false).findById(productId); // Coz i dont want to run build method when we add new products bcoz this screen doesnt have any relation to what product is added
    return Scaffold(
      appBar: AppBar(
        title: Text(loadedPoduct.title),
      ),
    );
  }
}
