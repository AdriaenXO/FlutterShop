import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:shop/models/http_exception.dart';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isFavorite;

  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.price,
    @required this.imageUrl,
    this.isFavorite = false,
  });

  void toggleFavorite(String token, String userId) async {
    var url =
        'https://flutter-one-6545c.firebaseio.com/userFavorites/$userId/$id.json?auth=$token';
    final oldStatus = isFavorite;
    isFavorite = !isFavorite;
    try {
      final response = await http.put(
        url,
        body: json.encode(
          isFavorite,
        ),
      );
      if (response.statusCode >= 400)
        throw new HttpException(response.statusCode.toString());
    } catch (error) {
      isFavorite = oldStatus;
      print(error);
      notifyListeners();
    }
    notifyListeners();
  }
}
