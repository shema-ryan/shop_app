import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/auth.dart';
import '../Screens/OrderScreen.dart';
import '../Screens/user_productScreen.dart';

class DrawerBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
                image: DecorationImage(
                    fit: BoxFit.cover,
                    image: NetworkImage(
                        'https://cdn.pixabay.com/photo/2014/10/23/18/05/burger-500054_1280.jpg'))),
            child: DecoratedBox(
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        begin: Alignment.centerLeft,
                        end: Alignment.bottomRight,
                        colors: [
                  Colors.brown[300].withOpacity(0.7),
                  Colors.brown[500].withOpacity(0.7),
                ]))),
          ),
          ListTile(
            onTap: () => Navigator.of(context).pushReplacementNamed('/'),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 17),
            ),
            leading: Icon(
              Icons.shopping_basket,
            ),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(OrderScreen.routeName),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 17),
            ),
            leading: Icon(Icons.payment),
          ),
          ListTile(
            onTap: () => Navigator.of(context)
                .pushReplacementNamed(UserProductScreen.routeName),
            title: Text(
              'Manage product',
              style: TextStyle(fontSize: 17),
            ),
            leading: Icon(Icons.settings),
          ),
          ListTile(
            onTap: () {
              Navigator.of(context).pushReplacementNamed('/');
              Provider.of<Auth>(context, listen: false).logOut();
            },
            title: Text(
              'Log-Out',
              style: TextStyle(fontSize: 17),
            ),
            leading: Icon(Icons.exit_to_app),
          )
        ],
      ),
    );
  }
}
