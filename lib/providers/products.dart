import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';
import 'package:shop/providers/product.dart';

class Products with ChangeNotifier {
  List<Product> _items = [
    // Product(
    //   id: 'p1',
    //   title: 'Red Shirt',
    //   description: 'A red shirt - it is pretty red!',
    //   price: 29.99,
    //   imageUrl:
    //       'https://cdn.pixabay.com/photo/2016/10/02/22/17/red-t-shirt-1710578_1280.jpg',
    // ),
    // Product(
    //   id: 'p2',
    //   title: 'Trousers',
    //   description: 'A nice pair of trousers.',
    //   price: 59.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/e/e8/Trousers%2C_dress_%28AM_1960.022-8%29.jpg/512px-Trousers%2C_dress_%28AM_1960.022-8%29.jpg',
    // ),
    // Product(
    //   id: 'p3',
    //   title: 'Yellow Scarf',
    //   description: 'Warm and cozy - exactly what you need for the winter.',
    //   price: 19.99,
    //   imageUrl:
    //       'https://live.staticflickr.com/4043/4438260868_cc79b3369d_z.jpg',
    // ),
    // Product(
    //   id: 'p4',
    //   title: 'A Pan',
    //   description: 'Prepare any meal you want.',
    //   price: 49.99,
    //   imageUrl:
    //       'https://upload.wikimedia.org/wikipedia/commons/thumb/1/14/Cast-Iron-Pan.jpg/1024px-Cast-Iron-Pan.jpg',
    // ),
  ];

  final String authToken;
  final String userId;
  Products(this.authToken, this.userId, this._items);

  List<Product> get items {
    return [..._items];
  }

  Future<void> fetchProducts([bool filterByUser = false]) async {
    var url =
        'https://flutter-one-6545c.firebaseio.com/products.json?auth=$authToken' +
            (filterByUser ? '&orderBy="creatorId"&equalTo="$userId"' : '');
    try {
      var response = await http.get(url);
      var data = json.decode(response.body) as Map<String, dynamic>;
      url =
          'https://flutter-one-6545c.firebaseio.com/userFavorites/$userId.json?auth=$authToken';
      final favorites = await http.get(url);
      final favoriteData = json.decode(favorites.body) as Map<String, dynamic>;
      List<Product> _tempItems = [];
      data.forEach(
        (prodId, prodData) {
          _tempItems.add(
            Product(
              id: prodId,
              title: prodData['title'],
              description: prodData['description'],
              price: prodData['price'],
              imageUrl: prodData['imageUrl'],
              isFavorite:
                  favoriteData == null ? false : favoriteData[prodId] ?? false,
            ),
          );
        },
      );
      _items = _tempItems;
      notifyListeners();
    } catch (error) {
      print(error.toString());
    }
  }

  Future<void> addProduct(Product product) async {
    var url =
        'https://flutter-one-6545c.firebaseio.com/products.json?auth=$authToken';
    final response = await http.post(
      url,
      body: json.encode(
        {
          'title': product.title,
          'description': product.description,
          'imageUrl': product.imageUrl,
          'price': product.price,
          'creatorId': userId,
        },
      ),
    );
    _items.add(
      Product(
        id: json.decode(response.body)['name'],
        title: product.title,
        description: product.description,
        price: product.price,
        imageUrl: product.imageUrl,
        isFavorite: false,
      ),
    );

    notifyListeners();
  }

  Product findById(String id) {
    return items.firstWhere((element) => element.id == id);
  }

  List<Product> get favoriteItems {
    return _items.where((element) => element.isFavorite).toList();
  }

  Future<void> updateProduct(Product newProduct) async {
    var index = _items.indexWhere((element) => element.id == newProduct.id);
    if (index >= 0) {
      final url =
          'https://flutter-one-6545c.firebaseio.com/products/${newProduct.id}.json?auth=$authToken';
      await http.patch(
        url,
        body: json.encode(
          {
            'title': newProduct.title,
            'description': newProduct.description,
            'imageUrl': newProduct.imageUrl,
            'price': newProduct.price,
          },
        ),
      );
      _items[index] = newProduct;
    }
    notifyListeners();
  }

  Future<void> deleteProduct(String id) async {
    final url =
        'https://flutter-one-6545c.firebaseio.com/products/${id}.json?auth=$authToken';
    final index = _items.indexWhere((element) => element.id == id);
    var existingProduct = _items[index];
    _items.removeAt(index);
    notifyListeners();
    var response = await http.delete(url);
    if (response.statusCode >= 400) {
      print(response.statusCode);
      _items.insert(index, existingProduct);
      notifyListeners();
      throw HttpException(response.statusCode.toString());
    }
    existingProduct = null;
  }
}
