import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';
import '../providers/products_provider.dart';

class ProductGrid extends StatelessWidget {
  final bool favDisplay;
  ProductGrid(this.favDisplay);

  @override
  Widget build(BuildContext context) {
    final productsData = Provider.of<ProductsProv>(context);
    final products =
        favDisplay ? productsData.favouriteItems : productsData.items;
    return GridView.builder(
      padding: const EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (ctx, i) => ChangeNotifierProvider.value(
        value: products[i],
        child: ProductItem(
            // id: products[i].id,
            // title: products[i].title,
            // imageUrl: products[i].imageUrl,
            ),
      ),
    );
  }
}
