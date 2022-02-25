import 'package:flutter/material.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'MyShop',
      theme: ThemeData(
        primarySwatch: Colors.deepOrange,
        accentColor: Colors.purple,
        fontFamily: 'Lato'
      ),
      home: ProductsOverviewScreen(),
      routes: {
        ProductDetailScreen.routeName : (ctx) => ProductDetailScreen(),
      },
    );
  }
}