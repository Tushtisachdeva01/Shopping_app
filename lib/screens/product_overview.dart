import 'package:flutter/material.dart';
import 'package:shop_app/widgets/product_grid.dart';


class ProductOverview extends StatelessWidget {

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Shop'),
      ),
      body: new ProductGrid(),
    );
  }
}
