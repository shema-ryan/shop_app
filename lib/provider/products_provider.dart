import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import '../Exception/httpExcept.dart';
import 'product.dart';
import 'package:http/http.dart' as Http;

class ProductsProvider with ChangeNotifier {
  final String _token;
  final String userId;
  ProductsProvider(this._token, this._items, this.userId);
  List<Product> _items = [
//    Product(
//      id: 'p1',
//      title: 'Red Shirt',
//      description: 'A red shirt - it is pretty red!',
//      price: 29.99,
//      imageUrl:
//          'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
//    ),
//    Product(
//      id: 'p2',
//      title: 'Trousers',
//      description: 'A nice pair of trousers.',
//      price: 59.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
//    ),
//    Product(
//      id: 'p3',
//      title: 'Yellow Scarf',
//      description: 'Warm and cozy - exactly what you need for the winter.',
//      price: 19.99,
//      imageUrl:
//          'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
//    ),
//    Product(
//      id: 'p4',
//      title: 'A Pan',
//      description: 'Prepare any meal you want.',
//      price: 49.99,
//      imageUrl:
//          'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
//    ),
  ];
  var showFavorite = false;
  List<Product> get items {
    if (showFavorite) {
      return _items.where((element) => element.isFavorite).toList();
    }
    return _items;
  }

  Future<void> fetchProduct([bool filterUser = false]) async {
    /*
    if a user is anonymous which is a rare case you do not need to provide token id , if the user is registered then  you  add token to the request so as to quickly retrieve it so that to ensure that a user can fetch the actual data
    */
    final String urlFilter =
        filterUser ? 'orderBy="creatorId"&equalTo="$userId"' : '';

    var url =
        'https://shop-7547f.firebaseio.com/products.json?auth=$_token&$urlFilter';
    var results = await Http.get(
      url, /* u can use specify header options for other API as header:{
    'id token' : token}*/
    );
    final extracted = jsonDecode(results.body) as Map<String, dynamic>;
    final List<Product> loadedProduct = [];
    if (extracted == null) {
      return null;
    }
    final Response response = await Http.get(
        'https://shop-7547f.firebaseio.com/userfavorite/$userId.json?auth=$_token');
    final favExtract = jsonDecode(response.body) as Map<String, dynamic>;

    extracted.forEach((prodId, prodData) {
      loadedProduct.add(Product(
        imageUrl: prodData['imgUrl'],
        description: prodData['description'],
        price: prodData['price'],
        title: prodData['title'],
        id: prodId,
        isFavorite:
            favExtract == null ? false : favExtract[prodId] == null ?? false,
      ));
    });
    _items = loadedProduct;
    notifyListeners();
  }

  Future<void> addProduct(Product product) {
    final url = 'https://shop-7547f.firebaseio.com/products.json?auth=$_token';
    return Http.post(url,
        body: jsonEncode({
          'title': product.title,
          'description': product.description,
          'price': product.price,
          'imgUrl': product.imageUrl,
          'creatorId': '$userId',
        })).then((Response value) {
      _items.add(Product(
        id: jsonDecode(value.body)['name'],
        title: product.title,
        price: product.price,
        description: product.description,
        imageUrl: product.imageUrl,
        isFavorite: product.isFavorite,
      ));
      notifyListeners();
    }).catchError((error) {
      throw error;
    });
  }

  Future<void> updateProduct(String id, Product newProduct) async {
    final url =
        'https://shop-7547f.firebaseio.com/products/$id.json?auth=$_token';
    var indexCal = _items.indexWhere((element) => element.id == id);
    if (indexCal >= 0) {
      await Http.patch(url,
          body: jsonEncode({
            'description': newProduct.description,
            'imgUrl': newProduct.imageUrl,
            'title': newProduct.title,
            'price': newProduct.price,
          }));
      _items[indexCal] = newProduct;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    /*
    the server sends back status code if the run fails
    200 - 2001 : means successful
    300 : means redirected
    4-- : means error .
    the server only throws an error status code on only get and post but delete it doesn't
    those can be helpful in terms of troubleshooting

    this is usually called optimistic delete by first making a copy so that it is retrived if failed to do so .
     */
    final url =
        'https://shop-7547f.firebaseio.com/products/$id.json?auth=$_token';
    final index0fProduct = _items.indexWhere((element) => element.id == id);
    var copy = _items[index0fProduct];
    _items.removeAt(index0fProduct);
    notifyListeners();
    final value = await Http.delete(url);
    if (value.statusCode >= 400) {
      _items.insert(index0fProduct, copy);
      notifyListeners();
      throw HttpExcept('could not delete');
    }
    copy = null;
//    _items.removeWhere((element) => element.id == id);
    notifyListeners();
  }
}
