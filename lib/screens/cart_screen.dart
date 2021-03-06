import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/orders.dart';
import '../widgets/cart_products.dart';
import '../providers/cart.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(15),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 30),
                  ),
                  Spacer(),
                  Chip(
                    label: Text(
                      '\$' + cart.totalAmount.toStringAsFixed(2),
                      //'\$${cart.totalAmount}
                      style: TextStyle(
                          color:
                              Theme.of(context).primaryTextTheme.title.color),
                    ),
                    backgroundColor: Theme.of(context).primaryColor,
                  ),
                  OrderButton(cart: cart),
                ],
              ),
            ),
          ),
          SizedBox(height: 10),
          Expanded(
            child: ListView.builder(
              itemBuilder: (ctx, i) => CartProduct(
                id: cart.items.values.toList()[i].id,
                price: cart.items.values.toList()[i].price,
                title: cart.items.values.toList()[i].title,
                quantity: cart.items.values.toList()[i].quantity,
                productId: cart.items.keys.toList()[i],
              ),
              itemCount: cart.items.length,
            ),
          ),
        ],
      ),
    );
  }
}

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final Cart cart;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isloading = false;
  @override
  Widget build(BuildContext context) {
    return FlatButton(
      // disabledTextColor: Colors.grey,
      textColor: Colors.purple,
      child: isloading
          ? CircularProgressIndicator()
          : Text(
              'ORDER',
            ),
      onPressed: (widget.cart.totalAmount <= 0 || isloading)
          ? null
          : () async {
              setState(() {
                isloading = true;
              });
              await Provider.of<Orders>(context, listen: false).addOrder(
                widget.cart.items.values.toList(),
                widget.cart.totalAmount,
              );
              setState(() {
                isloading = false;
              });
              widget.cart.clear();
            },
    );
  }
}
