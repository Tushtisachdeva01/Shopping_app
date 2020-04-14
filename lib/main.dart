import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import './screens/edit_add_product.dart';
import './screens/orders_screen.dart';
import './screens/user_product.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail.dart';
import './screens/product_overview.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: ProductsProv(),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProvider.value(
          value: Orders(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.purple,
          accentColor: Colors.amber[900],
          fontFamily: 'Lato',
        ),
        home: ProductOverview(),
        routes: {
          ProductDetail.routeName: (ctx) => ProductDetail(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrdersScreen.routeName: (ctx) => OrdersScreen(),
          UserProducts.routeName: (ctx) => UserProducts(),
          EditAddProduct.routeName: (ctx) => EditAddProduct(),
        },
      ),
    );
  }
}
