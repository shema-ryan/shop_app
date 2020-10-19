import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';
import '../provider/product.dart';
import 'Product_Item.dart';

class ProductOverViewBuilder extends StatelessWidget {
  final bool showFavorite;
  ProductOverViewBuilder({this.showFavorite});
  @override
  Widget build(BuildContext context) {
    ProductsProvider productData = Provider.of<ProductsProvider>(context);
    List<Product> loadedProducts = showFavorite
        ? productData.items.where((product) => product.isFavorite).toList()
        : productData.items;
    return GridView.builder(
      itemCount: loadedProducts.length,
      itemBuilder: (BuildContext context, int index) =>
          ChangeNotifierProvider.value(
        value: loadedProducts[index],
        child: ProductItem(
//          title: loadedProducts[index].title,
//          imageUrl: loadedProducts[index].imageUrl,
//          id: loadedProducts[index].id,
            ),
      ),
      padding: EdgeInsets.all(10.0),
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        mainAxisSpacing: 10,
        crossAxisSpacing: 10,
        childAspectRatio: 3 / 2,
      ),
    );
  }
}
