import 'package:flutter/material.dart';
import '../providers/cart.dart';
import '../providers/orders.dart' show Orders;

import 'package:provider/provider.dart';

class CartItem extends StatelessWidget {
  final String id;
  final double price;
  final int quantity;
  final String productId;
  final String title;
  CartItem({this.id, this.price, this.quantity, this.title,this.productId});

  @override
  Widget build(BuildContext context) {
    final cartItems = Provider.of<Cart>(context);
    return Dismissible(
      crossAxisEndOffset: 3,
      onDismissed: (_) {
        cartItems.removeItem(productId);
      },
      background: Container(
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          color: Colors.white,
          size: 40,
        ),
        alignment: Alignment.centerRight,
      ),
      key: ValueKey(id),
      child: Card(
          margin: EdgeInsets.symmetric(horizontal: 15, vertical: 4),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: ListTile(
              isThreeLine: true,
              leading: CircleAvatar(
                maxRadius: 50,
                minRadius: 25,
                child: FittedBox(
                    child: Padding(
                        padding: EdgeInsets.all(30), child: Text('\$ $price'))),
              ),
              title: Text(title),
              trailing: Text('$quantity x'),
              subtitle: Text('Total: \$${price * quantity}'),
            ),
          )),
    );
  }
}
