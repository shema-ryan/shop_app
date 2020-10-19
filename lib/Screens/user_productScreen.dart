import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/user_edit_product_screen.dart';
import '../Widgets/drawerBar.dart';
import '../Widgets/user_product_item.dart';
import '../provider/products_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/userProductScreen';
  Future<void> _refreshProduct(BuildContext context) async {
    await Provider.of<ProductsProvider>(context, listen: false)
        .fetchProduct(true);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: DrawerBar(),
      appBar: AppBar(
        title: Text('user product'),
        centerTitle: true,
        actions: <Widget>[
          IconButton(
            icon: Icon(Icons.add),
            onPressed: () {
              Navigator.of(context).pushNamed(EditProductScreen.routeName);
            },
          ),
        ],
      ),
      body: FutureBuilder(
        future: _refreshProduct(context),
        builder: (ctx, copy) => copy.connectionState == ConnectionState.waiting
            ? Center(
                child: CircularProgressIndicator(),
              )
            : RefreshIndicator(
                onRefresh: () => _refreshProduct(context),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Consumer<ProductsProvider>(
                    builder: (context, product, _) => ListView.builder(
                      itemBuilder: (context, index) => Column(
                        children: <Widget>[
                          UserProductItem(
                            id: product.items[index].id,
                            title: product.items[index].title,
                            imageUrl: product.items[index].imageUrl,
                          ),
                          Divider(
                            thickness: 1,
                          ),
                        ],
                      ),
                      itemCount: product.items.length,
                    ),
                  ),
                ),
              ),
      ),
    );
  }
}
