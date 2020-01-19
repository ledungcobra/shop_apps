import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CartItem {
  final String id;
  final String title;
  int quantity;
  //Price per product

  final double price;
  CartItem(
      {@required this.id,
      @required this.title,
      @required this.quantity,
      @required this.price});
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};
  final  String authToken;
  Cart(this.authToken,this._items);

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalSum {
    double sum = 0.0;
    _items.forEach((key, item) {
      sum += item.price * item.quantity;
    });
    return sum;
  }

  Future<void> removeItem(String id)  async{

    final String url = 'https://shopapps-31411.firebaseio.com/cart/$id.json?auth=$authToken';
    var backupItem = _items[id];



    try{
      await http.delete(url);
      _items.remove(id);
      backupItem = null;
      notifyListeners();
    }catch(e){
      _items.putIfAbsent(id, ()=>backupItem);
      throw e;

    }
  
  }

  Future<void> removeSingleItem(String productId) async{
    final String url = 'https://shopapps-31411.firebaseio.com/cart/$productId.json?auth=$authToken';
    if(!_items.containsKey(productId)){
        return;
    }
    if (_items[productId].quantity == 1) {
      final response =  await http.delete(url);
      final backupItem = _items[productId];    

      _items.removeWhere((key, _) {
        return key == productId;
      });
      notifyListeners();
      if(response.statusCode>=400){
        _items.putIfAbsent(productId, ()=>backupItem);
      }
    } else {
      
      _items.update(
          productId,
          (prev) => CartItem(
              id: prev.id,
              title: prev.id,
              quantity: prev.quantity - 1,
              price: prev.price));
    }
    notifyListeners();
  }

  void addItem(String productId, String title, double price) {
    if (_items.containsKey(productId)) {
      _items.update(
        productId,
        (existingItem) => CartItem(
            id: existingItem.id,
            price: existingItem.price,
            title: existingItem.title,
            quantity: existingItem.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        productId,
        () => CartItem(
          title: title,
          price: price,
          quantity: 1,
          id: DateTime.now().toString(),
        ),
      );
    }
    notifyListeners();
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
