import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../Screens/cartScreen.dart';
import '../Widgets/badge.dart';
import '../Widgets/drawerBar.dart';
import '../provider/products_provider.dart';
import '../provider/cart.dart';
import '../Widgets/product_over_view_builder.dart';

class ProductOverView extends StatefulWidget {
  static const routeName = '/productOverview';
  @override
  _ProductOverViewState createState() => _ProductOverViewState();
}

class _ProductOverViewState extends State<ProductOverView> {
  var showFavorite = false;
  bool isInt = true;
  bool isLoading = false;
  @override
//  void initState() {
////    Future.delayed(Duration.zero).then((value) {
////      Provider.of<ProductsProvider>(context).fetchProduct();
////    });
////    super.initState();
//  }

  @override
  void didChangeDependencies() {
    if (isInt) {
      setState(() {
        isLoading = true;
      });
      Provider.of<ProductsProvider>(context).fetchProduct().then((value) {
        setState(() {
          isLoading = false;
        });
      });
    }
    isInt = false;
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        actions: <Widget>[
          PopupMenuButton(
            onSelected: (int selectedValue) {
              setState(() {
                if (selectedValue == 1) {
                  showFavorite = true;
                } else {
                  showFavorite = false;
                }
              });
            },
            icon: Icon(Icons.more_vert),
            tooltip: 'filter products',
            itemBuilder: (context) => [
              PopupMenuItem(
                child: Text('show all'),
                value: 0,
              ),
              PopupMenuItem(
                child: Text('show favorite'),
                value: 1,
              ),
            ],
          ),
          Consumer<Cart>(
            builder: (context, cart, chd) => Badge(
              child: chd,
              value: cart.itemCount.toString(),
            ),
            child: IconButton(
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
              icon: Icon(Icons.shopping_cart),
            ),
          ),
        ],
        title: Text('Shop Categories'),
        centerTitle: true,
      ),
      body: isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : ProductOverViewBuilder(showFavorite: showFavorite),
      drawer: DrawerBar(),
    );
  }
}
