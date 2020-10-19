import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../provider/cart.dart';
import '../Screens/Product_details_Screen.dart';
import '../provider/product.dart';

class ProductItem extends StatelessWidget {
//  final String id;
//  final String title;
//  final String imageUrl;
//
//  const ProductItem({this.id, this.title, this.imageUrl});

  @override
  Widget build(BuildContext context) {
    final loadedProduct = Provider.of<Product>(context, listen: false);
    final token = Provider.of<Auth>(context);
    return ClipRRect(
      borderRadius: BorderRadius.circular(10.0),
      child: GridTile(
        child: GestureDetector(
            onTap: () {
              Navigator.of(context).pushNamed(ProductDetailScreen.routeName,
                  arguments: loadedProduct.id);
            },
            child: Hero(
                tag: loadedProduct.imageUrl,
                child: FadeInImage(
                    fit: BoxFit.cover,
                    placeholder: AssetImage('assets/images/bmxbike.jpg'),
                    image: NetworkImage(
                      loadedProduct.imageUrl,
                    )))),
        footer: GridTileBar(
            backgroundColor: Colors.black45,
            title: Text(loadedProduct.title),
            leading: Consumer<Product>(
              child: Text('you can lock if you don\'t want to '),
              builder: (context, product, child) => IconButton(
                icon: Icon(loadedProduct.isFavorite
                    ? Icons.favorite
                    : Icons.favorite_border),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  loadedProduct.toggleFavorite(token.token, token.userId);
                },
              ),
            ),
            trailing: Consumer<Cart>(
              builder: (context, cart, child) => IconButton(
                icon: Icon(Icons.shopping_cart),
                color: Theme.of(context).accentColor,
                onPressed: () {
                  cart.addItem(loadedProduct.id, loadedProduct.title,
                      loadedProduct.price);
                  Scaffold.of(context).removeCurrentSnackBar(
                      reason: SnackBarClosedReason.timeout);
                  Scaffold.of(context).showSnackBar(SnackBar(
                    duration: Duration(seconds: 2),
                    content: Text('Item added !'),
                    action: SnackBarAction(
                      label: 'UNDO',
                      onPressed: () {
                        cart.removeSingleItem(loadedProduct.id);
                      },
                    ),
                  ));
                },
              ),
            )),
      ),
    );
  }
}
// ChangeNotifierProvider .
