import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/screens/orders_screen.dart';
import '../screens/products_overview_screen.dart';
import 'package:flutter_complete_guide/screens/products_overview_screen.dart';

class AppDrawers extends StatelessWidget {
  //const AppDrawers({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: <Widget>[
          AppBar(
            title: Text('Hello friend! '),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text('Shop'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed('/');
            }, 
          ),
          Divider(),
          ListTile(
              leading: Icon(Icons.payment),
              title: Text('Orders'),
              onTap: () {
                Navigator.of(context)
                    .pushReplacementNamed(OrdersScreen.nameRoute);
              })
        ],
      ),
      //child: child,
    );
  }
}
