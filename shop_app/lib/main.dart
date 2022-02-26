import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/product_Display/screens/products_overview_screen.dart';
import 'features/product_Display/screens/product_details_screen.dart';
import 'features/product_Display/providers/products.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (ctx) =>
          Products(), // Setting up the provider in the root widget because we want access to ProductsOverviewScreen & ProductDetailScreen which are instantiated here
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.red,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
        },
      ),
    );
  }
}
