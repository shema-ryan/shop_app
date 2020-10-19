import 'package:flutter/material.dart';
import '../Widgets/cart_screen_flat_button.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart' show Cart;
import '../Widgets/cartItem.dart';

/*
TO show interest in cartItem of provider , use show key word infront of cart import as /provider/cart.dart show Cart
   or
 Use   AS key word to differ from the one above ;
*/

class CartScreen extends StatelessWidget {
  static const String routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        centerTitle: true,
        title: Text('cart'),
      ),
      body: Column(
        children: <Widget>[
          Card(
            color: Colors.brown[100],
            margin: EdgeInsets.all(10.0),
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: <Widget>[
                  Text(
                    'Total',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    backgroundColor: Theme.of(context).primaryColor,
                    padding: EdgeInsets.all(5.0),
                    label: Text(
                      '\$ ${cart.totalAmount.toStringAsFixed(2)}',
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  SizedBox(
                    width: 10,
                  ),
                  CartScreenFlatButton(cart: cart)
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
                itemCount: cart.items.length,
                itemBuilder: (context, index) => CartItem(
                      productId: cart.items.keys.toList()[index],
                      title: cart.items.values.toList()[index].title,
                      id: cart.items.values.toList()[index].id,
                      price: cart.items.values.toList()[index].price,
                      quantity: cart.items.values.toList()[index].quantity,
                    )),
          ),
        ],
      ),
    );
  }
}
