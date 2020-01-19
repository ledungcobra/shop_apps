import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter_complete_guide/providers/cart.dart';
import 'package:flutter_complete_guide/providers/product.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem(
      {@required this.id,
      @required this.amount,
      @required this.products,
      @required this.dateTime});
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];
  List<OrderItem> get orders {
    return [..._orders];
  }
  final String authToken;
  Orders(this.authToken,this._orders);



  Future<void> fetchAndSetOrders() async {
    final String url = 'https://shopapps-31411.firebaseio.com/orders.json?auth=$authToken';
    final List<OrderItem> loadedOrders = [];
    try {
      final response = await http.get(url);
      final map = json.decode(response.body) as Map<String, dynamic>;
      if (map == null) {
        _orders = [];        
        notifyListeners();
        return;
      }
    
      map.forEach((key, item) {
        loadedOrders.add(
          OrderItem(
            id: key,
            amount: item['amount'],
            dateTime: DateTime.parse(
              item['dateTime'],
            ),
            products: (item['products'] as List <dynamic>).map((itemTemp){
              return CartItem(id: itemTemp['id'],price: itemTemp['price'],title: itemTemp['title'],quantity: itemTemp['quantity']);


            }).toList()
          ),
        );
      });
      _orders = loadedOrders.reversed.toList();
      notifyListeners();
    } catch (e) {
      throw e;
    }
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    final String url = 'https://shopapps-31411.firebaseio.com/orders.json';
    final timeStamp = DateTime.now();
    final response = await http.post(
      url,
      body: json.encode({
        'amount': total,
        'dateTime': timeStamp.toIso8601String(),
        'products': cartProducts
            .map((cp) => {
                  'id': cp.id,
                  'title': cp.title,
                  'quantity': cp.quantity,
                  'price': cp.price
                })
            .toList()
      }),
    );

    _orders.add(
      OrderItem(
        amount: total,
        id: json.decode(response.body)['name'],
        products: cartProducts,
        dateTime: timeStamp,
      ),
    );
    notifyListeners();
  }
}
