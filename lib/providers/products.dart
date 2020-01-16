import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import './product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [];
 

  // List<Product> _items = [
  //   Product(
  //     id: 'p1',
  //     title: 'Red Shirt',
  //     description: 'A red shirt - it is pretty red!',
  //     price: 29.99,
  //     imageUrl:
  //         'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
  //   ),
  //   Product(
  //     id: 'p2',
  //     title: 'Trousers',
  //     description: 'A nice pair of trousers.',
  //     price: 59.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
  //   ),
  //   Product(
  //     id: 'p3',
  //     title: 'Yellow Scarf',
  //     description: 'Warm and cozy - exactly what you need for the winter.',
  //     price: 19.99,
  //     imageUrl:
  //         'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
  //   ),
  //   Product(
  //     id: 'p4',
  //     title: 'A Pan',
  //     description: 'Prepare any meal you want.',
  //     price: 49.99,
  //     imageUrl:
  //         'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
  //   ),
  // ];
  // var _showFavoritesOnly = false;
  // void showFavoritesOnly(){
  //   _showFavoritesOnly = true;
  //   notifyListeners();
  // }
  // void showAll(){
  //   _showFavoritesOnly = false;
  //   notifyListeners();
  // }

  List<Product> get items {
    // if(_showFavoritesOnly)
    //   return _items.where((item)=> item.isFavorite).toList();
    // else{
    return [..._items];
  }

  List<Product> get favoriteItems {
    return _items.where((item) => item.isFavorite).toList();
  }

  Product findById(String id) {
    return _items.firstWhere((item) => id == item.id);
  }

  void updateProduct(Product product) {
    int prodIndex = _items.indexWhere((prod) {
      print('Calee');
      return prod.id == product.id;
    });
    _items[prodIndex] = product;

    // _items.removeWhere((prod)=>prod.id == product.id);
    // print(_items.length);
    // _items.add(product);

    notifyListeners();
  }

  void removeProduct(String id) {
    _items.removeWhere((pr) => pr.id == id);
    notifyListeners();
  }

  Future<void> fetchAndSetProducts() async {
    const url = 'https://shopapps-31411.firebaseio.com/products.json';
    final List<Product> loadedProducts = [];
    try {
      final response = await http.get(url);
      print(response.body);
      final map = json.decode(response.body);

      (map as Map<String, dynamic>).forEach((id, prod) {
        final product = Product(
          id: id,
          description: prod['description'] as String,
          imageUrl: prod['imageUrl'],
          price: prod['price'],
          title: prod['title'],
          isFavorite: prod['isFavorite'],
        );
        print(prod['description']);
       //if(_items.firstWhere((p)=>p.id == product.id)==null)
           loadedProducts.add(product);

      });
      _items = loadedProducts;
      notifyListeners();

      //final products = response.body as Map<String, Object>;

      // products.map(
      //   (key, value) {
      //     final currentProduct = value as Map<String, String>;
      //     print(currentProduct);
      //     final product = Product(
      //       id: key,
      //       description: currentProduct['desciption'],
      //       imageUrl: currentProduct['imageUrl'],
      //       price: currentProduct['price'] as double,
      //       title: currentProduct['title'],
      //       isFavorite: currentProduct['isFavorite'] as bool,
      //     );

      //     _items.add(product);
      //   },
      // );
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> addProduct(Product product) async {
    const url = 'https://shopapps-31411.firebaseio.com/products.json';
    try {
      final response = await http.post(
        url,
        body: json.encode(
          {
            'title': product.title,
            'imageUrl': product.imageUrl,
            'price': product.price,
            'isFavorite': product.isFavorite,
            'description':product.description
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
        isFavorite: product.isFavorite,
      );
      _items.add(newProduct);
      notifyListeners();
    } catch (error) {
      throw error;
    }
  }
}
