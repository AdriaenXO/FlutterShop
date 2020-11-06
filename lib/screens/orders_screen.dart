import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/orders.dart' hide OrderItem;
import 'package:shop/widgets/app_drawer.dart';
import 'package:shop/widgets/order_item.dart';

class OrdersScreen extends StatelessWidget {
  static final routeName = '/orders';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
      ),
      drawer: AppDrawer(),
      // body: Consumer<Orders>(
      //   builder: (ctx, orders, child) => _isLoading
      //       ? Center(child: CircularProgressIndicator())
      //       : ListView.builder(
      //           itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
      //           itemCount: orders.orders.length,
      //         ),
      // ),
      body: FutureBuilder(
        future: Provider.of<Orders>(context, listen: false).fetchOrders(),
        builder: (ctx, dataSnapshot) {
          if (dataSnapshot.connectionState == ConnectionState.waiting)
            return Center(child: CircularProgressIndicator());
          else {
            if (dataSnapshot.error == null) {
              return Consumer<Orders>(
                builder: (ctx, orders, child) => ListView.builder(
                  itemBuilder: (ctx, i) => OrderItem(orders.orders[i]),
                  itemCount: orders.orders.length,
                ),
              );
            } else {
              return Center(
                child: Text('An error occurred!'),
              );
            }
          }
        },
      ),
    );
  }
}
