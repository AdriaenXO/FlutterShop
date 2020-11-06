import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:shop/providers/cart.dart';
import 'package:http/http.dart' as http;

class OrderItem {
  final String id;
  final double amount;
  final List<CartItem> products;
  final DateTime dateTime;
  OrderItem({
    this.id,
    @required this.amount,
    @required this.products,
    @required this.dateTime,
  });

  Map toJson() => {
        'id': id,
        'amount': amount,
        'dateTime': dateTime.toIso8601String(),
        'products': products,
      };

  OrderItem.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        amount = json['amount'],
        dateTime = DateTime.parse(json['dateTime']),
        products = (json['products'] as List<dynamic>)
            .map(
              (cartItem) => CartItem.fromJson(cartItem),
            )
            .toList();
}

class Orders with ChangeNotifier {
  List<OrderItem> _orders = [];

  final String _authToken;
  final String _userId;
  Orders(this._authToken, this._userId, this._orders);

  List<OrderItem> get orders {
    return [..._orders];
  }

  Future<void> fetchOrders() async {
    var url =
        'https://flutter-one-6545c.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final response = await http.get(url);
    final decodedData = json.decode(response.body) as Map<String, dynamic>;
    List<OrderItem> loadedOrders = [];
    decodedData?.forEach(
      (key, value) {
        //print('order: ' + value.toString());
        loadedOrders.add(OrderItem.fromJson(value));
      },
    );
    _orders = loadedOrders.reversed.toList();
    notifyListeners();
  }

  Future<void> addOrder(List<CartItem> cartProducts, double total) async {
    var url =
        'https://flutter-one-6545c.firebaseio.com/orders/$_userId.json?auth=$_authToken';
    final timestamp = DateTime.now();
    final response = await http.post(
      url,
      // body: json.encode(
      //   {
      //     'amount': total,
      //     'dateTime': timestamp.toIso8601String(),
      //     'products': cartProducts
      //         .map(
      //           (e) => {
      //             'id': e.product.id,
      //             'title': e.product.title,
      //             'quantity': e.quantity,
      //             'price': e.product.price,
      //           },
      //         )
      //         .toList(),
      //   },
      // ),
      body: json.encode(OrderItem(
          amount: total, products: cartProducts, dateTime: timestamp)),
    );
    print(json.decode(response.body)['name']);
    _orders.insert(
      0,
      OrderItem(
        id: json.decode(response.body)['name'],
        amount: total,
        products: cartProducts,
        dateTime: DateTime.now(),
      ),
    );
    notifyListeners();
  }
}
