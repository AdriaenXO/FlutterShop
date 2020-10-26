import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart' hide CartItem;
import 'package:shop/providers/orders.dart';
import 'package:shop/widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your cart'),
      ),
      body: Consumer<Cart>(
        builder: (ctx, cart, child) => Column(
          children: [
            Card(
              margin: const EdgeInsets.all(15),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Total',
                      style: TextStyle(
                        fontSize: 20,
                      ),
                    ),
                    Spacer(),
                    Chip(
                      label: Text('\$' + cart.totalAmount.toStringAsFixed(2),
                          style: TextStyle(
                            color:
                                Theme.of(ctx).primaryTextTheme.headline6.color,
                          )),
                      backgroundColor: Theme.of(ctx).primaryColor,
                    ),
                    FlatButton(
                      onPressed: () {
                        if (cart.totalAmount != 0) {
                          Provider.of<Orders>(
                            context,
                            listen: false,
                          ).addOrder(
                              cart.items.values.toList(), cart.totalAmount);
                          cart.clear();
                        }
                      },
                      child: Text(
                        'ORDER NOW',
                        style: TextStyle(
                          color: Theme.of(ctx).primaryColor,
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemBuilder: (ctx, index) => CartItem(
                  cart.items.values.toList()[index].product,
                  cart.items.values.toList()[index].quantity,
                ),
                itemCount: cart.itemCount,
              ),
            )
          ],
        ),
      ),
    );
  }
}
