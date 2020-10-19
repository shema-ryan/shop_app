import 'package:flutter/material.dart';
import '../provider/product.dart';
import 'package:provider/provider.dart';
import '../provider/products_provider.dart';

class ProductDetailScreen extends StatelessWidget {
  static const String routeName = '/productDetailScreen';
  @override
  Widget build(BuildContext context) {
    final String routeArgsId = ModalRoute.of(context).settings.arguments;
    final Product _loadedProduct =
        Provider.of<ProductsProvider>(context, listen: false)
            .items
            .firstWhere((product) => product.id == routeArgsId);
    return Scaffold(
//      appBar: AppBar(
//        elevation: 0.0,
//        centerTitle: true,
//        title: Text(_loadedProduct.title),
//      ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            actions: [
              IconButton(
                onPressed: () {},
                icon: Icon(Icons.share),
              )
            ],
            pinned: true,
            floating: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(_loadedProduct.title),
              centerTitle: true,
              background: Hero(
                tag: _loadedProduct.imageUrl,
                child: Image.network(
                  _loadedProduct.imageUrl,
                  fit: BoxFit.cover,
                  height: 300,
                  width: double.infinity,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate([
              SizedBox(
                height: 10,
              ),
              Text(
                '\$ ${_loadedProduct.price}',
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 10,
              ),
              Text(
                _loadedProduct.description,
                softWrap: true,
                overflow: TextOverflow.fade,
                textAlign: TextAlign.center,
              ),
              SizedBox(
                height: 900,
              ),
            ]),
          )
        ],
      ),
    );
  }
}
