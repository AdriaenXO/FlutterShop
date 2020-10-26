import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shop/providers/cart.dart';
import 'package:shop/providers/product.dart';

class CartItem extends StatelessWidget {
  final Product product;
  final int quantity;
  CartItem(this.product, this.quantity);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: ValueKey(product.id),
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
        padding: const EdgeInsets.only(
          right: 20,
        ),
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
      ),
      direction: DismissDirection.endToStart,
      onDismissed: (direction) =>
          Provider.of<Cart>(context, listen: false).removeItem(
        product.id,
      ),
      child: Card(
        margin: const EdgeInsets.symmetric(
          horizontal: 15,
          vertical: 5,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8),
          child: ListTile(
            leading: CircleAvatar(
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: FittedBox(
                  child: Text(
                    '\$' + product.price.toString(),
                  ),
                ),
              ),
            ),
            title: Text(product.title),
            subtitle: Text(
              'Total: \$${product.price * quantity}',
            ),
            trailing: Text(
              'x' + quantity.toString(),
            ),
          ),
        ),
      ),
    );
  }
}
