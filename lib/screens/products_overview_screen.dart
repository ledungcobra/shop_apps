import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/screens/cart_screen.dart';
import '../widgets/app_drawers.dart';
import 'package:provider/provider.dart';
import '../widgets/products_grid.dart';
import '../widgets/badge.dart';

enum FilterOptions { All, Favorites, GO }

class ProductsOverviewScreen extends StatefulWidget {
  static const String nameRoute = '/ProductsOverviewScreen';
  @override
  _ProductOverViewScreenState createState() => _ProductOverViewScreenState();
}

class _ProductOverViewScreenState extends State<ProductsOverviewScreen> {
  var _showFavorites = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: <Widget>[
          //Left side filtter
          PopupMenuButton(
            icon: Icon(Icons.more_vert),
            onSelected: (FilterOptions value) {
              setState(() {
                if (value == FilterOptions.Favorites) {
                  _showFavorites = true;
                } else if (value == FilterOptions.All) {
                  _showFavorites = false;
                }
              });
            },
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text('Only Favorites'),
                value: FilterOptions.Favorites,
              ),
              PopupMenuItem(
                child: Text('Show All'),
                value: FilterOptions.All,
              ),
              
            ],
          ),
          Consumer<Cart>(
                  child: IconButton(
                    icon: Icon(Icons.shopping_cart),
                    onPressed: () {
                      Navigator.pushNamed(context, CartScreen.nameRoute);
                    },
                  ),
                  //Lay ra car single ton;

                  builder: (_, cart, ch) => Badge(
                    child: ch,
                    value: cart.itemCount.toString(),
                  ),
                ),
        ],
      ),
      body: ProductsGrid(_showFavorites),
      drawer: AppDrawers(),
    );
  }
}
