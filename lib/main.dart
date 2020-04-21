import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_app/helpers/custom.dart';

import 'package:shop_app/screens/auth_screen.dart';
import 'package:shop_app/screens/product_overview.dart';
import 'package:shop_app/screens/splash_screen.dart';
import './screens/edit_add_product.dart';
import './screens/orders_screen.dart';
import './screens/user_product.dart';
import './providers/orders.dart';
import './screens/cart_screen.dart';
import './screens/product_detail.dart';
import './providers/cart.dart';
import './providers/products_provider.dart';
import 'providers/auth.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProv>(
          create: (_) => ProductsProv('', [], ''),
          update: (ctx, auth, previousProducts) => ProductsProv(
            auth.token,
            previousProducts == null ? [] : previousProducts.items,
            auth.userId,
          ),
        ),
        ChangeNotifierProvider.value(
          value: Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (_) => Orders('', [], ''),
          update: (ctx, auth, previousOrders) => Orders(
            auth.token,
            previousOrders == null ? [] : previousOrders.orders,
            auth.userId,
          ),
        ),
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.amber[900],
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.android:CustomPage(),
              TargetPlatform.iOS: CustomPage(),
            },),
          ),
          home: auth.isAuth
              ? ProductOverview()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (ctx, authResultSnapShot) =>
                      authResultSnapShot.connectionState ==
                              ConnectionState.waiting
                          ? SplashScreen()
                          :  AuthScreen(),
                ),
          routes: {
            ProductDetail.routeName: (ctx) => ProductDetail(),
            CartScreen.routeName: (ctx) => CartScreen(),
            OrdersScreen.routeName: (ctx) => OrdersScreen(),
            UserProducts.routeName: (ctx) => UserProducts(),
            EditAddProduct.routeName: (ctx) => EditAddProduct(),
          },
        ),
      ),
    );
  }
}
