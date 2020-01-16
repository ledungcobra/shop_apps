import 'package:flutter/material.dart';
import '../screens/orders_screen.dart';
import '../screens/user_products_screen.dart';
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
              Navigator.of(context).pushReplacementNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text('Orders'),
            onTap: () {
              Navigator.of(context)
                  .pushReplacementNamed(OrdersScreen.nameRoute);
            },
          ),
          Divider(),
          ListTile(leading: Icon(Icons.transform),title: Text('User manage item'),onTap: (){
            Navigator.of(context).pushReplacementNamed(UserProductsScreen.nameRoute);
          },)

        ],
      ),
      //child: child,
    );
  }
}
