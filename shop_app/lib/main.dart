import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/products_overview_screen.dart';
import './screens/product_details_screen.dart';
import './providers/products.dart';
import './providers/cart.dart';
import './screens/cart_screen.dart';
import 'providers/orders.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/auth_screen.dart';
import './providers/auth.dart';
import './widgets/splash_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Thata how you can add mutiple providers without making code cumbersum
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),

        /// * This also combines another provider.
        /// * Thats why in type reference you have to specify 2 Values
        /// FIRST: value you want to listen to
        /// SECOND: value you want to have for the provider(basically the main create method)
        ///
        /// * Now this notifier is also listenning to Auth so it will rebuild of notifyListeners are called in Auth
        /// and this will clear the previous state that is why you get previousProducts value in update which you can set in newProducts
        /// when the state is cleared our managed _items is cleared so we also set it in the newly created object of products so that our products are not lost
        /// also if previous state is null then we know no previousProducts were there so initialize it to empty list
        ///
        /// * This is will search for Auth in upper tree so the notifier should be initialized before you use it
        /// ! More on this can be found in your notion book
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (ctx) => Products(null, null,
              []), // Setting up the provider in the root widget because we want access to ProductsOverviewScreen & ProductDetailScreen which are instantiated here
          /// * We are providing this because we need, token in products.dart also we dont want to loose previous state that is why previous state _items is passed
          update: (ctx, auth, previousProducts) => Products(
              auth.token,
              auth.userId,
              previousProducts == null ? [] : previousProducts.items),
        ),
        ChangeNotifierProvider(
          create: (ctx) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (ctx) => Orders(null, null, []),
          update: (ctx, auth, previousOrders) => Orders(auth.token, auth.userId,
              previousOrders == null ? [] : previousOrders.orders),
        ),
      ],
      child: Consumer<Auth>(
        builder: ((context, auth, child) {
          // To avoid code duplication now you can check this on every screen that is auth true then allow
          ifAuth(targetScreen) => auth.isAuth ? targetScreen : AuthScreen();
          return MaterialApp(
            title: 'MyShop',
            theme: ThemeData(
                primarySwatch: Colors.deepOrange,
                accentColor: Colors.red,
                fontFamily: 'Lato'),

            /// * If isAuth returns true then user is authenticated and you can display the product screen
            /// * if not authenticated then try autoLogin
            /// Also you could use authResultSnapshot.data == false render authScreen else product screen
            /// But yeah this will also work just fine
            /// ? Explanation:-> Here if you are auth then please use our app if not app then call FutureBuilder, running waititng for provided Future to complete once done run the builder method and render screens accordingly
            home: auth.isAuth
                ? ProductsOverviewScreen()
                : FutureBuilder(
                    future: auth.tryAutoLogin(),
                    builder: (ctx, authResultSnapshot) =>
                        authResultSnapshot.connectionState ==
                                ConnectionState.waiting
                            ? SplashScreen()
                            : AuthScreen(),
                  ),
            routes: {
              ProductDetailScreen.routeName: (ctx) =>
                  ifAuth(ProductDetailScreen()),
              CartScreen.routeName: (ctx) => ifAuth(CartScreen()),
              OrdersScreen.routeName: (ctx) => ifAuth(OrdersScreen()),
              UserProductScreen.routeName: (ctx) => ifAuth(UserProductScreen()),
              EditProductScreen.routeName: (ctx) => ifAuth(EditProductScreen()),
            },
          );
        }),
      ),
    );
  }
}
