import 'package:flutter/material.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments as String; // is Id of the product
    return Scaffold(
      appBar: AppBar(
        title: Text('title'),
      ),
    );
  }
}
