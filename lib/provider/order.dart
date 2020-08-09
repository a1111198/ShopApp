import 'dart:convert';
import 'package:flutter/cupertino.dart';
import './cart.dart';
import 'package:http/http.dart' as http;

class Order {
  final String id;
  final double amount;
  final List<Cart> products;
  final DateTime time;
  Order({
    @required this.id,
    @required this.amount,
    @required this.products,
    @required this.time,
  });
}

class Orders with ChangeNotifier {
  final String authToken;
  final String userid;
  List<Order> _orders = [];
  List<Order> get orders {
    return [..._orders];
  }

  Orders(this.authToken, this._orders, this.userid);
  void changeisfetched() {
    _isfetched = false;
  }

  bool _isfetched = false;
  bool _isloading = false;
  bool get isloading {
    return _isloading;
  }

  Future<bool> fetchorders() async {
    if (_isfetched == true) {
      return true;
    }
    _orders = [];
    final url =
        'https://shopapp-35487.firebaseio.com/orders/$userid.json?auth=$authToken';
    try {
      print("i ran");
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      if (data == null) {
        return true;
      }
      print(data);
      data.forEach((key, value) {
        List<Cart> list = [];
        value['products'].forEach((p) {
          list.add(Cart(
              id: p['id'],
              title: p['title'],
              quantity: p['quantity'],
              price: p['price']));
        });
        _orders.add(Order(
            id: key,
            amount: value['amount'],
            time: DateTime.parse(value['time']),
            products: list));
      });
      _orders = _orders.reversed.toList();
      _isfetched = true;
      return true;
    } catch (err) {
      throw err;
    } finally {
      notifyListeners();
    }
  }

  Future<void> addorder(List<Cart> cartproducts, double total) async {
    _isloading = true;
    notifyListeners();
    DateTime timestamp = DateTime.now();

    List l = [];
    cartproducts.forEach((element) {
      l.add({
        'id': element.id,
        'title': element.title,
        'price': element.price,
        'quantity': element.quantity
      });
    });
    final url =
        'https://shopapp-35487.firebaseio.com/orders/$userid.json?auth=$authToken';
    try {
      final res = await http.post(url,
          body: json.encode({
            'amount': total,
            'time': timestamp.toIso8601String(),
            'products': l
          }));
      Order localorder = Order(
        id: json.decode(res.body)['name'],
        amount: total,
        time: timestamp,
        products: cartproducts,
      );
      _orders.insert(0, localorder);
    } catch (err) {
      throw err;
    } finally {
      _isloading = false;
      notifyListeners();
    }
  }
}
