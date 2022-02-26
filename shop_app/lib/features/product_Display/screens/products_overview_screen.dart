import 'package:flutter/material.dart';

import '../widgets/products_grid.dart';

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
              icon: const Icon(Icons.more_vert))
        ],
      ),
      body: SafeArea(
        child: ProductsGrid(_showOnlyFavorites),
      ),
    );
  }
}
