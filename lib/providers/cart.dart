import 'package:flutter/cupertino.dart';
import 'package:shop/providers/product.dart';

class CartItem {
  Product product;
  int quantity;
  CartItem(this.product, this.quantity);
}

class Cart with ChangeNotifier {
  Map<String, CartItem> _items = {};

  Map<String, CartItem> get items {
    return {..._items};
  }

  int get itemCount {
    return _items.length;
  }

  double get totalAmount {
    var total = 0.0;
    _items.forEach((key, value) {
      total += value.product.price * value.quantity;
    });
    return total;
  }

  void addItem(Product product) {
    if (_items.containsKey(product.id)) {
      _items.update(
        product.id,
        (value) => CartItem(value.product, value.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        product.id,
        () => CartItem(product, 1),
      );
    }
    notifyListeners();
  }

  void removeItem(String productId) {
    _items.remove(productId);
    notifyListeners();
  }

  void removeSingleItem(String productId) {
    if (_items.containsKey(productId)) {
      switch (_items[productId].quantity) {
        case 1:
          _items.remove(productId);
          break;
        default:
          _items.update(
            productId,
            (value) => CartItem(value.product, value.quantity - 1),
          );
      }
      notifyListeners();
    }
  }

  void clear() {
    _items = {};
    notifyListeners();
  }
}
