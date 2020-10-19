import 'package:flutter/material.dart';
import '../Widgets/drawerBar.dart';
import '../provider/order.dart' show Order;
import 'package:provider/provider.dart';
import '../Widgets/order_item.dart';

class OrderScreen extends StatelessWidget {
  static const String routeName = '/orders';

//  this will would be workaround if you were using a stateless widget .
//  var isLoading = false;
//  @override
//  void initState() {
//    Future.delayed(Duration.zero).then((value) async {
//      setState(() {
//        isLoading = true;
//      });
//      await Provider.of<Order>(context, listen: false).fetchOrder();
//      setState(() {
//        isLoading = false;
//      });
//    });
//    super.initState();
//  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: DrawerBar(),
        appBar: AppBar(
          title: Text('Orders Details'),
          centerTitle: true,
        ),
        body: FutureBuilder(
          future: Provider.of<Order>(context, listen: false).fetchOrder(),
          builder: (ctx, fData) {
            if (fData.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else {
              return Consumer<Order>(
                builder: (context, orderData, child) {
                  return ListView.builder(
                    itemCount: orderData.order.length,
                    itemBuilder: (BuildContext context, int index) => OrderItem(
                      order: orderData.order[index],
                    ),
                  );
                },
              );
            }
          },
        ));
  }
}
