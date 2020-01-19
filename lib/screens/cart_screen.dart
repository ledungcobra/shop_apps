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
   
  }

  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<Cart>(context);
    final cartItems = cart.items;

    final orders = Provider.of<Orders>(context, listen: false);

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
                  Container( 
                    width: 140,
                                      child: FittedBox(
                      fit:BoxFit.fitWidth,
                      child: Chip(
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
                    ),
                  ),
                  OrderButton(cart: cart, orders: orders)
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

class OrderButton extends StatefulWidget {
  const OrderButton({
    Key key,
    @required this.cart,
    @required this.orders,
  }) : super(key: key);

  final Cart cart;
  final Orders orders;

  @override
  _OrderButtonState createState() => _OrderButtonState();
}

class _OrderButtonState extends State<OrderButton> {
  var isLoading = false;

  @override
  Widget build(BuildContext context) {
    return FlatButton(
      child: isLoading?CircularProgressIndicator():Text('ORDER NOW'),
      onPressed:(widget.cart.totalSum<=0||isLoading) ?null:() async {
        setState(() {
          isLoading = true;
        });

        await widget.orders.addOrder(
            widget.cart.items.values.toList(), widget.cart.totalSum);
        widget.cart.clear();

        setState(() {
          isLoading = false;
          
        });
        Navigator.of(context).pushNamed(OrdersScreen.nameRoute);
      },
      textColor: Theme.of(context).primaryColor,
    );
  }
}
