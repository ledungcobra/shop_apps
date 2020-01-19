import 'package:flutter/material.dart';
import '../widgets/app_drawers.dart';
import '../providers/orders.dart' show Orders;
import '../widgets/order_item.dart';
import 'package:provider/provider.dart';

class OrdersScreen extends StatelessWidget {
  // const OrdersScreen({Key key}) : super(key: key);
  static const String nameRoute = '/OrderScreen';

  

  // @override
  // void initState(){
  //   Future.delayed(Duration.zero).then((_){
  //     setState(() {
  //        _isLoading = true;

  //     });

  //     Provider.of<Orders>(context,listen: false).fetchAndSetOrders().then((_){
  //       setState(() {
  //         _isLoading = false;

  //       });

  //     });

  //   });

  //   super.initState();
  // }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: AppDrawers(),
        appBar: AppBar(
          title: Text('Your  Orders'),
        ),
        body: FutureBuilder(
          future:
              Provider.of<Orders>(context, listen: false).fetchAndSetOrders(),
          builder: (ctx, snapshotData) {
            if (snapshotData.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            } else if (snapshotData.error == null) {
              return Consumer<Orders>(
                builder: (ctx, ordersObject, child) {
                  final orders = ordersObject.orders;

                  return ListView.builder(
                    itemCount: orders.length,
                    itemBuilder: (ctx, i) {
                      return OrderItem(orders[i]);
                    },
                  );
                },
              );
            }
          },
        ));
  }
}
