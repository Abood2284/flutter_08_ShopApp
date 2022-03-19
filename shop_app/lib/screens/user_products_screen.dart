import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/user_product_item.dart';
import '../widgets/drawer.dart';
import './edit_product_screen.dart';

class UserProductScreen extends StatefulWidget {
  static const routeName = 'user-product-screen';

  @override
  State<UserProductScreen> createState() => _UserProductScreenState();
}

class _UserProductScreenState extends State<UserProductScreen> {
  //future: needs type of future
  late Future _obtainedEarlier;

  Future<void> _refreshAndFetchData() async {
    return await Provider.of<Products>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  void initState() {
    _obtainedEarlier = _refreshAndFetchData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    // final productsData = Provider.of<Products>(context); // This will no force FutureBuilder to run in loop, to fix, we use consumer in FutureBuilder

    return Scaffold(
      appBar: AppBar(title: const Text('Manage Products'), actions: [
        IconButton(
          onPressed: () {
            Navigator.of(context).pushNamed(EditProductScreen.routeName);
          },
          icon: const Icon(Icons.add),
        ),
      ]),
      drawer: AppDrawer(),
      body: FutureBuilder(
        future: _obtainedEarlier,
        builder: (ctx, snapshot) =>
            snapshot.connectionState == ConnectionState.waiting
                ? const Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => _refreshAndFetchData(),
                    child: Consumer<Products>(
                      builder: (ctx, productsData, _) => Padding(
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
                    ),
                  ),
      ),
    );
  }
}
