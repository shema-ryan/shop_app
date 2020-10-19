import 'dart:math';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../provider/order.dart' as ci;

class OrderItem extends StatefulWidget {
  final ci.OrderItem order;
  const OrderItem({this.order});

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      shape: expanded
          ? RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
            )
          : null,
      margin: EdgeInsets.all(10.0),
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.all(5),
            leading: Icon(Icons.shopping_cart),
            title: Text('Total Amount : \$ ${widget.order.amount}'),
            subtitle: Text(DateFormat.yMMMd().format(widget.order.dateTime)),
            trailing: IconButton(
              onPressed: () {
                setState(() {
                  expanded = !expanded;
                });
              },
              icon:
                  expanded ? Icon(Icons.expand_less) : Icon(Icons.expand_more),
            ),
          ),
          AnimatedContainer(
            curve: Curves.bounceIn,
            duration: Duration(seconds: 1),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                bottomLeft: Radius.circular(10),
                bottomRight: Radius.circular(10),
              ),
              color: Colors.brown[100],
            ),
            padding: EdgeInsets.all(10),
            height: expanded
                ? min(widget.order.products.length * 10.0 + 80.0, 100.0)
                : 0,
            child: ListView(
              children: widget.order.products
                  .map((prod) => Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: <Widget>[
                          Text(
                            prod.title,
                            textScaleFactor: 1.2,
                          ),
                          Text(
                            '${prod.quantity} X \$ ${prod.price} ',
                            textScaleFactor: 1.2,
                          )
                        ],
                      ))
                  .toList(),
            ),
          ),
        ],
      ),
    );
  }
}
