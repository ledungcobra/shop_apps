import 'package:flutter/material.dart';
import '../providers/cart.dart' show Cart;
import '../providers/orders.dart';
import '../screens/orders_screen.dart';
import '../widgets/app_drawers.dart';
import 'package:provider/provider.dart';
import '../widgets/cart_item.dart';

class CartScreen extends StatelessWidget {
  //const CartScreen({Key key}) : sup//er(key: key);
  static const String nameRoute = '/CartScreen';
  CartScreen() {
    print("calue");
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;

    final orders = Provider.of<Orders>(context,listen: false );

    return Scaffold(
      drawer: AppDrawers(),
      appBar: AppBar(
        title: Text('Your Card '),
      ),
      body: Column(
        children: <Widget>[
          Card(
            margin: EdgeInsets.all(10),
            child: Padding(
              padding: EdgeInsets.all(8),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Text(
                    'Total',
                    style: TextStyle(fontSize: 20),
                  ),
                  Spacer(),
                  Chip(
                    label: Text('\$ ${cart.totalSum.toStringAsFixed(3)}',
                        style: TextStyle(
                            fontSize: 20,
                            color: Theme.of(context)
                                .primaryTextTheme
                                .title
                                .color)),
                    backgroundColor:
                        Theme.of(context).primaryColor.withOpacity(0.5),
                  ),
                  FlatButton(
                    child: Text('ORDER NOW'),
                    onPressed: () {
                      orders.addOrder(
                          cart.items.values.toList(), cart.totalSum);
                          cart.clear();
                          Navigator.of(context).pushNamed(OrdersScreen.nameRoute);
                    },
                    textColor: Theme.of(context).primaryColor,
                  )
                ],
              ),
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Expanded(
            child: ListView.builder(
              itemCount: cart.itemCount,
              itemBuilder: (ctx, i) => CartItem(
                productId: cartItems.keys.toList()[i],
                id: cartItems.values.toList()[i].id,
                price: cartItems.values.toList()[i].price,
                title: cartItems.values.toList()[i].title,
                quantity: cartItems.values.toList()[i].quantity,
              ),
            ),
          )
        ],
      ),
    );
  }
}
