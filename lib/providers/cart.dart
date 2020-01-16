import 'package:flutter/foundation.dart';

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

  void removeItem(String id) {
    _items.remove(id);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if(!_items.containsKey(productId)){
        return;
    }
    if (_items[productId].quantity == 1) {
      _items.removeWhere((key, _) {
        return key == productId;
      });
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
