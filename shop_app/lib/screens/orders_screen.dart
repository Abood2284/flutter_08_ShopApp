import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import '../widgets/drawer.dart';
import '../model/https_exception.dart';
import '../constants.dart';

class OrdersScreen extends StatefulWidget {
  static const routeName = 'order-screen';

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  //future: needs type of future
  late Future _obtainedEarlier;

  //to execute the provider function
  Future _runFuture() async {
    // * if the orders json body is null we end up here in catch block
    // * still we are not able to show the center Text message the logger is printed the center text isn't
    // TODO: If the orders fetched are null then show user that not orders found message 
    try {
      return await Provider.of<Orders>(context, listen: false)
          .fetchAndSetOrder();
    } on HttpException catch (error) {
      logger.d('Exception caught');
      const Center(
        child: Text('No orders found'),
      );
    }
  }

  @override
  void initState() {
    //called the provider function before futurebuilder
    _obtainedEarlier = _runFuture();
    super.initState();
  }

  Widget displayCenterText(String text) {
    return Center(child: Text(text));
  }

  // Why using these many variable & methods just to initialize the Future.
  // We could also directly use [Provider.of<Orders>(context, listen: false).fetchAndSetOrder()] in FutureBuilder though it will not have any problem in this app
  // Becuase build is not runnig again Resulting in re-creating of new Future but in your other app buil migh be called By any other state you manage and that will again trigger FutureBuilder to re run and create new Futures
  // ! and you dont want that
  // * This is the Correct way to create a FutureBuilder

  @override
  Widget build(BuildContext context) {
    // This is will push our code in endless loop as Future will keep building and changing Orders and provider will listen to changes and rebuild the state again Future to the same becuase the state was re-build
    // Solution -> Use consumer where you need it
    // final orderData = Provider.of<Orders>(context);
    return Scaffold(
        appBar: AppBar(
          title: const Text('Ordered Item'),
        ),
        drawer: AppDrawer(),

        /// This the more optimized way of handling data instead of creating _isLoading variable and setState several times just to load a spiner this will load a spinner without even building build multiple times
        ///
        /// [FutureBuilder] takes in future:[needs a future which is recomended that must be initated befote the FutureBuilder is called hence instantiate in initState], builder:[build the widget based on the sate of the connection, it returns context & current data snapshot(AsynccSnapshot)]
        body: FutureBuilder(
            future: _obtainedEarlier,
            builder: (ctx, dataSnapshot) {
              // Means we are still fetching data
              if (dataSnapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                // We have an error / no order could be fetch
                if (dataSnapshot.error != null) {
                  // Imported from center_text_widget.dart
                  return displayCenterText('Some error occured');
                } else {
                  // Everything is fine data is Fetched and no error returned
                  return Consumer<Orders>(
                    builder: (_, orderData, _c) => ListView.builder(
                      itemCount: orderData.orders.length,
                      itemBuilder: (ctx, i) => OrderItem(orderData.orders[i]),
                    ),
                  );
                }
              }
            }));
  }
}
