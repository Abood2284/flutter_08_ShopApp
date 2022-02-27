import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'features/product_Display/screens/products_overview_screen.dart';
import 'features/product_Display/screens/product_details_screen.dart';
import 'features/product_Display/providers/products.dart';
import './features/cart/providers/cart.dart';
import './features/cart/screens/cart_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Thata how you can add mutiple providers without making code cumbersum
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) =>
              Products(), // Setting up the provider in the root widget because we want access to ProductsOverviewScreen & ProductDetailScreen which are instantiated here
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        )
      ],
      child: MaterialApp(
        title: 'MyShop',
        theme: ThemeData(
            primarySwatch: Colors.deepOrange,
            accentColor: Colors.red,
            fontFamily: 'Lato'),
        home: ProductsOverviewScreen(),
        routes: {
          ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
        },
      ),
    );
  }
}
