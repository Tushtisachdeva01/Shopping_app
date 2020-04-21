import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/screens/edit_add_product.dart';
import '../widgets/drawer.dart';
import '../widgets/user_prod_item.dart';
import '../providers/products_provider.dart';

class UserProducts extends StatelessWidget {
  static const routeName = '/user_products';

  Future<void> refreshProds(BuildContext context) async {
    await Provider.of<ProductsProv>(context, listen: false).fetchSet(true);
  }

  @override
  Widget build(BuildContext context) {
    // final productData = Provider.of<ProductsProv>(context);
    return Scaffold(
      drawer: AppDrawer(),
      appBar: AppBar(
        title: const Text('Your Products'),
        actions: <Widget>[
          IconButton(
            icon: const Icon(Icons.add_circle),
            onPressed: () {
              Navigator.of(context).pushNamed(EditAddProduct.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: refreshProds(context),
        builder: (ctx, snapShot) =>
            snapShot.connectionState == ConnectionState.waiting
                ? Center(
                    child: CircularProgressIndicator(),
                  )
                : RefreshIndicator(
                    onRefresh: () => refreshProds(context),
                    child: Consumer<ProductsProv>(
                      builder: (ctx, productData, _) => Padding(
                        padding: EdgeInsets.all(8),
                        child: ListView.builder(
                          itemBuilder: (_, i) => Column(
                            children: [
                              UserProductItem(
                                productData.items[i].id,
                                productData.items[i].title,
                                productData.items[i].imageUrl,
                              ),
                              Divider(),
                            ],
                          ),
                          itemCount: productData.items.length,
                        ),
                      ),
                    ),
                  ),
      ),
    );
  }
}
