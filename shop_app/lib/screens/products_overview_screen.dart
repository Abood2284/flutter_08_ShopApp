import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../widgets/products_grid.dart';
import '../widgets/badge.dart';
import '../providers/cart.dart';
import '../screens/cart_screen.dart';
import '../widgets/drawer.dart';
import '../providers/products.dart';

/// * Because we as developers we want to work with string and computer wants int so 😃
enum FilterOptions {
  Favorites,
  All,
}

class ProductsOverviewScreen extends StatefulWidget {
  @override
  State<ProductsOverviewScreen> createState() => _ProductsOverviewScreenState();
}

class _ProductsOverviewScreenState extends State<ProductsOverviewScreen> {
  /// ! We are not using a privider because this should be managed only by this class ... why??
  /// becuase if we use Provider the data is managed globally and if we have multiple screens we dont want items to be already favorited ,
  var _showOnlyFavorites = false;
  var _initState = true; // to run didChangeDependencies only once
  var _isLoading = false; // to show the loading spinner

  @override
  void initState() {
    // This would be best place to fetch product as this runs before the build is runned, though the down side is as we have added the logic of fetching in our provider class we need to use .of(context) to acces it, hence context is not accecssble in initState as it is called super early -> didChangeDependencies would be better option for this then
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if (_initState) {
      setState(() {
        _isLoading = true;
      });
      // I am using .then here bcoz using async and await is not recommended bcoz this would change the return value of the method hence this method should not be overriden as it is important for flutter
      Provider.of<Products>(context).fetchProduct().then((_) {
        setState(() {
          _isLoading = false;
        });
      });
    }
    _initState = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('MyShop'),
        actions: [
          PopupMenuButton(
            onSelected: (selectedValue) {
              setState(() {
                if (selectedValue == FilterOptions.Favorites) {
                  _showOnlyFavorites = true;
                } else {
                  _showOnlyFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              const PopupMenuItem(
                  child: Text('Only Favorites'),
                  value: FilterOptions.Favorites),
              const PopupMenuItem(
                  child: Text('Show all'), value: FilterOptions.All),
            ],
            icon: const Icon(Icons.more_vert),
          ),
          Consumer<Cart>(
            /// * Here Badge class was provided by our tutor from Lecture 203
            builder: (_, cart, ch) => Badge(
              child: ch
                  as Widget, // This is will take consumer child which is IconButton
              value: cart.itemsCount.toString(),
            ),
            child: IconButton(
              onPressed: () =>
                  Navigator.of(context).pushNamed(CartScreen.routeName),
              icon: const Icon(Icons.shopping_cart),
            ),
          ),
        ],
      ),
      drawer: AppDrawer(),
      body: SafeArea(
        child: _isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : ProductsGrid(_showOnlyFavorites),
      ),
    );
  }
}
