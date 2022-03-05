import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';
import '../widgets/product_single_item.dart';

class ProductsGrid extends StatelessWidget {
  final bool showFavs;

  ProductsGrid(this.showFavs);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<Products>(context);
    /// * If showFav is true then show we items(which you will get from getter in products.dart) that is favorite
    /// * else show me all items
    /// 🎢 Logic for this getter is in Provider
    final products = showFavs ? productsData.favoriteItem : productsData
        .items; // Now this is just a list of product(copy) returned by Provider
    return GridView.builder(
        padding: const EdgeInsets.all(10),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 3 / 2,
          crossAxisSpacing: 10,
          mainAxisSpacing: 10,
        ),
        itemBuilder: (ctx, index) => ChangeNotifierProvider.value(
              // create: (cttx) => products[index] /// * you should this approach if you are providing Provider a new class object like we are doing in main dart, here we are just resuing the created object and recycling it so this approach of using .value is appropriate
              value: products[
                  index], // Doing this so isFavorite bool can be accsed by every single product and every single product class is instatiated here,
              // * Since we are using provider we dont need to use the constructors
              child: ProductSingleItem(
                  // id: products[index].id,
                  // title: products[index].title,
                  // imageUrl: products[index].imageUrl
                  ),
            ),
        itemCount: products.length);
  }
}
