import 'package:flutter/material.dart';
import './providers/auth.dart';
import './screens/auth_screen.dart';
import './screens/edit_product_screen.dart';
import './screens/orders_screen.dart';
import './screens/user_products_screen.dart';
import 'package:provider/provider.dart';

import './providers/orders.dart';
import './screens/cart_screen.dart';
import './providers/cart.dart';
import './providers/products.dart';
import './screens/product_detail_screen.dart';
import './screens/products_overview_screen.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    // Listen de thay rebuild lai nhung widget ma lamf object products thay doi
    return MultiProvider(
      providers: [
        ChangeNotifierProvider.value(
          value: Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          create: (BuildContext context) {
            return Products('','', []);
          },
          update: (BuildContext context, Auth auth, Products previous) {
            return Products(auth.token,auth.userId, previous.items);
          },
        ),
    
        ChangeNotifierProxyProvider<Auth, Cart>(
          create: (BuildContext context) {
            return Cart('',{});

          },
          update: (BuildContext context, Auth value, Cart previous) {
            return Cart(value.token,previous.items);
          },
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          create: (BuildContext context) {
            return Orders('',[]);

          },
          update: (BuildContext context, Auth value, Orders previous) {
            return Orders(value.token,previous.orders);
            
          },
        )
      ],
      child: Consumer<Auth>(builder: (ctx, auth, _) {
        return MaterialApp(
          debugShowCheckedModeBanner: false,
          title: 'MyShop',
          theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
          ),
          home: auth.isAuth ? ProductsOverviewScreen() : AuthScreen(),
          routes: {
            ProductsOverviewScreen.nameRoute: (ctx) => ProductsOverviewScreen(),
            ProductDetailScreen.routeName: (ctx) => ProductDetailScreen(),
            CartScreen.nameRoute: (ctx) => CartScreen(),
            OrdersScreen.nameRoute: (ctx) => OrdersScreen(),
            UserProductsScreen.nameRoute: (ctx) => UserProductsScreen(),
            EditProductScreen.nameRoute: (ctx) => EditProductScreen()
          },
        );
      }),
    );
  }
}
