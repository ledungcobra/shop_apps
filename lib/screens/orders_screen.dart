import 'package:flutter/material.dart';
import '../widgets/app_drawers.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  // const OrdersScreen({Key key}) : super(key: key);
  static const String nameRoute = '/OrderScreen';

  @override
  Widget build(BuildContext context) {
    final ordersData = Provider.of<Orders>(context);
    return Scaffold(
      drawer: AppDrawers(),
      appBar: AppBar(
        title: Text('Your  Orders'),
      ),
      body: ListView.builder(
        itemBuilder: (context, i) => OrderItem(ordersData.orders[i]),
        itemCount: ordersData.orders.length,
      ),
    );
  }
}
