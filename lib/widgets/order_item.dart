import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart' show Cart;
import 'package:flutter_complete_guide/widgets/cart_item.dart';
import 'dart:math';
import '../providers/orders.dart' as ci;
import 'package:intl/intl.dart';

class OrderItem extends StatefulWidget {
  // const OrderItem({Key key}) : super(key: key);
  final ci.OrderItem orderItem;
  OrderItem(this.orderItem);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  var _expanded = false;
  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.symmetric(vertical: 10),
      child: Column(
        children: <Widget>[
          ListTile(
            title: Text('Total amout: \$${widget.orderItem.amount}',
                style: Theme.of(context).textTheme.title),
            subtitle: Text(
              DateFormat('dd-MM-yyyy hh:mm')
                  .format(widget.orderItem.dateTime)
                  .toString(),
            ),
            trailing: IconButton(
              icon: Icon(_expanded ? Icons.expand_less : Icons.expand_more),
              onPressed: () {
                setState(() {
                  _expanded = !_expanded;
                });
              },
            ),
          ),
          if (_expanded)
            Container(
              padding: EdgeInsets.symmetric(horizontal: 15,vertical: 4),
              height: min(widget.orderItem.products.length * 20.0 + 10, 100),
              child: ListView(
                children: widget.orderItem.products
                    .map((prod) => Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Text(
                              prod.title,
                              style: Theme.of(context).textTheme.title,
                            ),
                            Text(
                              '${prod.quantity} x ${prod.price}',
                              style: Theme.of(context).textTheme.title,
                            )
                          ],
                        ))
                    .toList(),
              ),
            )
        ],
      ),
    );
  }
}
