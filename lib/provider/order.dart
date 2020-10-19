import 'package:flutter/widgets.dart';
import 'cart.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

class OrderItem {
  final String id;
  final DateTime dateTime;
  final double amount;

  final List<CartItem> products;

  OrderItem({this.id, this.dateTime, this.amount, this.products});
}

class Order with ChangeNotifier {
  final String userId;
  final String auth;
  List<OrderItem> _order = [];
  Order(this.auth, this._order, this.userId);
  List<OrderItem> get order {
    return _order;
  }

  Future<void> fetchOrder() async {
    final url =
        'https://shop-7547f.firebaseio.com/order/$userId.json?auth=$auth';
    final response = await Http.get(url);
    final loadedOrder = jsonDecode(response.body) as Map<String, dynamic>;
    if (loadedOrder.isEmpty) {
      return;
    }
    List<OrderItem> loadedOrders = [];
    loadedOrder.forEach((orderId, orderData) {
      loadedOrders.add(OrderItem(
          id: orderId,
          amount: orderData['amount'],
          dateTime: DateTime.parse(orderData['time']),
          products: (orderData['products'] as List<dynamic>)
              .map((productData) => CartItem(
                    id: productData['id'],
                    title: productData['Title'],
                    price: productData['price'],
                    quantity: productData['quantity'],
                  ))
              .toList()));
      _order = loadedOrders.reversed.toList();
      notifyListeners();
    });
  }

  Future<void> addOrder(List<CartItem> cartProduct, double total) async {
    final url =
        'https://shop-7547f.firebaseio.com/order/$userId.json?auth=$auth';
    final time = DateTime.now();
    final response = await Http.post(url,
        body: jsonEncode({
          'time': time.toIso8601String(),
          'amount': total,
          'products': cartProduct
              .map((cart) => {
                    'id': cart.id,
                    'Title': cart.title,
                    'price': cart.price,
                    'quantity': cart.quantity,
                  })
              .toList(),
        }));
    _order.insert(
        0,
        OrderItem(
          id: jsonDecode(response.body)['name'],
          dateTime: DateTime.now(),
          amount: total,
          products: cartProduct,
        ));
    notifyListeners();
  }
}
