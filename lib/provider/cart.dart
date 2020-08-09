import 'package:flutter/cupertino.dart';

class Cart {
  final String id;
  final String title;
  final double price;
  final int quantity;
  Cart({
    @required this.id,
    @required this.price,
    @required this.title,
    @required this.quantity,
  });
}

class CartP with ChangeNotifier {
  Map<String, Cart> _items = {};
  Map<String, Cart> get items {
    return {..._items};
  }

  void removesingle(String key) {
    if (!_items.containsKey(key)) {
      return;
    }
    if (_items[key].quantity > 1) {
      _items.update(
          key,
          (value) => Cart(
              id: value.id,
              price: value.price,
              title: value.title,
              quantity: value.quantity - 1));
    } else {
      _items.remove(key);
    }
    notifyListeners();
  }

  void dismisitem(String proid) {
    _items.remove(proid);
    notifyListeners();
  }

  double get totalamount {
    double total = 0.0;
    _items.forEach((key, value) {
      total = total + (value.price * value.quantity);
    });
    return total.roundToDouble();
  }

  int get numberofitems {
    return _items.length;
  }

  void additem(String id, String title, double price) {
    if (_items.containsKey(id)) {
      _items.update(
        id,
        (value) => Cart(
            id: value.id,
            price: value.price,
            title: value.title,
            quantity: value.quantity + 1),
      );
    } else {
      _items.putIfAbsent(
        id,
        () => Cart(
          id: DateTime.now().toString(),
          title: title,
          price: price,
          quantity: 1,
        ),
      );
    }
    notifyListeners();
  }

  void clearcart() {
    _items = {};
    notifyListeners();
  }
}
