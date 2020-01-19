import 'package:flutter/material.dart';
import 'package:flutter_complete_guide/models/http_exception.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];

  List<Product> get items {
    return [..._items];
  }

  final String authToken;
  final String userId;

  Products(this.authToken, this.userId, this._items);

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => id == item.id);
  }

  Future<void> updateProduct(String id, Product product) async {
    final url =
        'https://shopapps-31411.firebaseio.com/products/$id.json?auth=$authToken';
    int prodIndex = _items.indexWhere((prod) {
      return id == product.id;
    });
    if (prodIndex >= 0) {
      try {
        final data = json.encode({
          'title': product.title,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'isFavorite': product.isFavorite,
          'description': product.description,
          'creatorId': product.userId
        });
        await http.patch(url, body: data);
        _items[prodIndex] = product;
      } catch (e) {
        throw e;
      }
    }

    notifyListeners();
  }

  Future<void> removeProduct(String id) async {
    final String url =
        'https://shopapps-31411.firebaseio.com/products/$id.json?auth=$authToken';

    final existingProductIndex = _items.indexWhere((item) => id == item.id);
    Product existingProduct = _items[existingProductIndex];
    _items.removeAt(existingProductIndex);
    notifyListeners();
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(existingProductIndex, existingProduct);
      notifyListeners();
      throw HttpException('Could not delete this product');
    }
    existingProduct = null;
  }

  Future<void> fetchAndSetProducts() async {
    final url =
        'https://shopapps-31411.firebaseio.com/products.json?auth=$authToken';
    final favoriteUrl =
        'https://shopapps-31411.firebaseio.com/userFavorite/$userId.json?auth=$authToken';

    final List<Product> loadedProducts = [];
    try {
      final response = await http.get(url);

      final map = json.decode(response.body);

      if (map == null) {
        _items = [];
        notifyListeners();
        return;
      }
      final favoriteResponse = json.decode((await http.get(favoriteUrl)).body);
      print(favoriteResponse);

      (map as Map<String, dynamic>).forEach((id, prod) {
        print('Creator: ${prod['creatorId']}');
        final product = Product(
            id: id,
            description: prod['description'] as String,
            imageUrl: prod['imageUrl'],
            price: prod['price'],
            title: prod['title'],
            isFavorite: favoriteResponse == null
                ? false
                : favoriteResponse[id] ?? false,
            userId: prod['creatorId']);

        //if(_items.firstWhere((p)=>p.id == product.id)==null)
        loadedProducts.add(product);
      });
      _items = loadedProducts;
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    final url =
        'https://shopapps-31411.firebaseio.com/products.json?auth=$authToken';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'description': product.description,
            'creatorId': product.userId
          },
        ),
      );
      final productMap = json.decode(response.body);
      final newProduct = Product(
          id: productMap['name'],
          description: product.description,
          imageUrl: product.imageUrl,
          price: product.price,
          title: product.title,
          userId: product.userId);
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
