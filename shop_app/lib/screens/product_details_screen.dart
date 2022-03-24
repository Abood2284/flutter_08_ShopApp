import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/products.dart';

class ProductDetailScreen extends StatelessWidget {
  static const routeName = 'product-details-screen';

  @override
  Widget build(BuildContext context) {
    final productId = ModalRoute.of(context)!.settings.arguments
        as String; // is Id of the product
    /// * Return the product objecte where the id is met
    final loadedProduct = Provider.of<Products>(context, listen: false).findById(
        productId); // Coz i dont want to run build method when we add new products bcoz this screen doesnt have any relation to what product is added
    return Scaffold(
      // appBar: AppBar(
      //   title: Text(loadedProduct.title),
      // ),
      /// * We dont want app bar when we open this screen but we want app bar when user scrolls from the top
      body: CustomScrollView(
        /// * Are just scrollable parts on the screen
        slivers: [
          SliverAppBar(
            expandedHeight:
                300, // will be the height of the image as the image will the background
            pinned:
                true, // always be visible when we scroll from top then appBar should come and stay
            flexibleSpace: FlexibleSpaceBar(
              title: Text(loadedProduct
                  .title), // this will be visible when your scroll app bar down this is normal appBar when this comes down image will be gone for good
              // This will be visisble when the app bar is not
              background: Hero(
                tag: loadedProduct.id!,
                child: Image.network(loadedProduct.imageUrl, fit: BoxFit.cover),
              ),
            ),
          ),
          SliverList(
              delegate: SliverChildListDelegate([
            const SizedBox(
              height: 20,
            ),
            Text(
              '\$${loadedProduct.price}',
              style: Theme.of(context).textTheme.headline6,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
              height: 10,
            ),
            Text(
              loadedProduct.description,
              style: Theme.of(context).textTheme.bodyText2,
              softWrap: true,
              textAlign: TextAlign.center,
            ),
            const SizedBox(
                height:
                    900), // used for demonstration purposes to make the screen scrollable and show how appBar works
          ])),
        ],
      ),
    );
  }
}
