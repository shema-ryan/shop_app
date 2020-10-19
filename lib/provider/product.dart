import 'package:flutter/foundation.dart';
import 'dart:convert';
import 'package:http/http.dart' as Http;

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final String imageUrl;
  final double price;
  bool isFavorite;

  Product({
    @required this.price,
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  Future<void> toggleFavorite(String token, String userId) async {
    final oldFav = isFavorite;
    final url =
        'https://shop-7547f.firebaseio.com/userfavorite/$userId/$id.json?auth=$token';
    isFavorite = !isFavorite;
    notifyListeners();

    try {
      final response = await Http.put(url, body: jsonEncode(isFavorite));
      if (response.statusCode >= 400) {
        isFavorite = oldFav;
        notifyListeners();
      }
    } catch (e) {
      isFavorite = oldFav;
      notifyListeners();
    }
  }
}
