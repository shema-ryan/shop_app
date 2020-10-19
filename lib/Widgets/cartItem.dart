import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String productId;
  final String id;
  final String title;
  final int quantity;
  final double price;
  CartItem({this.productId, this.id, this.title, this.quantity, this.price});
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (context) => AlertDialog(
                  content: Text(' Delete a cart item '),
                  shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.brown),
                      borderRadius: BorderRadius.circular(10)),
                  title: Text(
                    'Are you Sure ?',
                    textAlign: TextAlign.center,
                  ),
                  actions: <Widget>[
                    FlatButton(
                      child: Text('No'),
                      onPressed: () {
                        Navigator.of(context).pop(false);
                      },
                    ),
                    FlatButton(
                      child: Text('Yes'),
                      onPressed: () {
                        Navigator.of(context).pop(true);
                      },
                    ),
                  ],
                ));
      },
      direction: DismissDirection.endToStart,
      onDismissed: (direction) {
        Provider.of<Cart>(context, listen: false).removeItem(productId);
      },
      key: ValueKey(id),
      background: Container(
        alignment: Alignment.centerRight,
        child: Icon(
          Icons.delete_outline,
          color: Colors.white,
          size: 25,
        ),
        margin: EdgeInsets.all(10.0),
        color: Theme.of(context).accentColor,
      ),
      child: Card(
        margin: EdgeInsets.all(10.0),
        child: ListTile(
          leading: Padding(
            padding: EdgeInsets.all(5.0),
            child: CircleAvatar(
              child: Padding(
                  padding: EdgeInsets.all(5.0),
                  child: FittedBox(child: Text('\$$price'))),
            ),
          ),
          title: Text(title),
          subtitle: Text('\$ ${(quantity * price)}'),
          trailing: Text(' $quantity X'),
        ),
      ),
    );
  }
}
