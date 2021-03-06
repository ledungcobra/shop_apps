import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/providers/auth.dart';
import '../providers/cart.dart';
import '../providers/product.dart';
import '../screens/product_detail_screen.dart';
import 'package:provider/provider.dart';

class ProductItem extends StatelessWidget {
  //const ProductItem({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final product = Provider.of<Product>(context, listen: false);
    final String title = product.title;
    final String id = product.id;
    final String imageUrl = product.imageUrl;
    final cart = Provider.of<Cart>(context, listen: false);
    return ClipRRect(
      borderRadius: BorderRadius.only(
          topLeft: Radius.circular(10), topRight: Radius.circular(10)),
      child: GridTile(
        footer: GridTileBar(
          //su dung provider
          leading: Consumer<Product>(
            builder: (c, prod, child) => IconButton(
              icon: Icon(
                prod.isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.red,
              ),
              onPressed: () {
                final auth = Provider.of<Auth>(context,listen: false);
                product.toggleFavorite(auth.token,auth.userId);
              },
              color: Theme.of(context).accentColor,
            ),
          ),
          backgroundColor: Colors.black54,
          trailing: IconButton(
            icon: Icon(Icons.shopping_cart),
            color: Theme.of(context).accentColor,
            onPressed: () {
              cart.addItem(product.id, product.title, product.price);
              Scaffold.of(context).hideCurrentSnackBar();
              var snackBar = SnackBar(
                content: Text('You added one item'),
                duration: Duration(seconds: 4),
                action: SnackBarAction(label: 'UNDO',onPressed: (){
                  cart.removeSingleItem(product.id);
                  Scaffold.of(context).removeCurrentSnackBar();

                },),
              );
              Scaffold.of(context).showSnackBar(snackBar);
            },
          ),
          title: Text(
            title,
            textAlign: TextAlign.center,
          ),
        ),
        child: GestureDetector(
            onTap: () {
              Navigator.of(context)
                  .pushNamed(ProductDetailScreen.routeName, arguments: id);
            },
            child: Image.network(imageUrl, fit: BoxFit.cover)),
      ),
    );
  }
}
