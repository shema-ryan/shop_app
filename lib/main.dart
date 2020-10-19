import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop_update/Screens/splash_screen.dart';
import './provider/auth.dart';
import './Screens/user_edit_product_screen.dart';
import './Screens/user_productScreen.dart';
import './Screens/OrderScreen.dart';
import './provider/order.dart';
import './Screens/Product_details_Screen.dart';
import './provider/cart.dart';
import './provider/products_provider.dart';
import './Screens/Product_overView_Screen.dart';
import './Screens/cartScreen.dart';
import 'Screens/auth_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (BuildContext context) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, ProductsProvider>(
          update:
              (BuildContext context, Auth auth, ProductsProvider products) =>
                  ProductsProvider(auth.token,
                      products == null ? [] : products.items, auth.userId),
        ),
        ChangeNotifierProvider(
          create: (BuildContext context) => Cart(),
        ),
        ChangeNotifierProxyProvider<Auth, Order>(
          update: (BuildContext context, Auth auth, Order order) =>
              Order(auth.token, order == null ? [] : order.order, auth.userId),
        )
      ],
      child: Consumer<Auth>(
        builder: (ctx, auth, _) => MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'shop',
          theme: ThemeData(
            primarySwatch: Colors.brown,
            fontFamily: 'Lato',
            accentColor: Colors.brown[200],
          ),
          home: auth.isAuth
              ? ProductOverView()
              : FutureBuilder(
                  future: auth.tryAutoLogin(),
                  builder: (context, copy) =>
                      copy.connectionState == ConnectionState.waiting
                          ? SplashScreen()
                          : AuthScreen(),
                ),
          routes: {
            ProductOverView.routeName: (context) => ProductOverView(),
            ProductDetailScreen.routeName: (context) => ProductDetailScreen(),
            CartScreen.routeName: (context) => CartScreen(),
            OrderScreen.routeName: (context) => OrderScreen(),
            UserProductScreen.routeName: (context) => UserProductScreen(),
            EditProductScreen.routeName: (context) => EditProductScreen(),
          },
          onUnknownRoute: (_) {
            return MaterialPageRoute(builder: (context) => ProductOverView());
          },
          onGenerateRoute: (_) {
            return MaterialPageRoute(builder: (context) => ProductOverView());
          },
        ),
      ),
    );
  }
}
