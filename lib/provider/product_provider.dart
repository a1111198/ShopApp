import 'package:ShopApp/ErrorHandlers/httperroe.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import './product.dart';
import 'package:http/http.dart' as http;

class Products with ChangeNotifier {
  final String authtoken;
  final String userid;
  Products(this.authtoken, this._items, this.userid);
  List<Product> _items = [];
  List<Product> get items {
    return [..._items];
  }

  bool _isfetched = false;
  void setisfetched() {
    _isfetched = false;
  }

  List _userproducts = [];
  List get userproducts {
    return [..._userproducts];
  }

  Future<void> fetchproducts({bool isfilter = false}) async {
    var filterstring = '';
    isfilter
        ? filterstring = '&orderBy="creatorId"&equalTo="$userid"'
        : filterstring = '';
    final url =
        'https://shopapp-35487.firebaseio.com/products/.json?auth=$authtoken$filterstring';
    try {
      final res = await http.get(url);
      final data = json.decode(res.body) as Map<String, dynamic>;
      if (data == null) {
        return;
      }
      var url1 =
          'https://shopapp-35487.firebaseio.com/favstatus/$userid.json?auth=$authtoken';
      final d = await http.get(url1);
      final favdata = json.decode(d.body);

      final List<Product> loadedproducts = [];
      data.forEach((key, value) {
        loadedproducts.add(Product(
            id: key,
            isfav: favdata == null ? false : favdata[key] ?? false,
            title: value['title'],
            description: value['description'],
            imageUrl: value['imageUrl'],
            price: value['price']));
        isfilter ? _userproducts = loadedproducts : _items = loadedproducts;
        notifyListeners();
        print(_userproducts);
      });
      _isfetched = true;
    } catch (err) {
      throw err;
    }
  }

  Future<void> addproduct(Product p) async {
    final url =
        'https://shopapp-35487.firebaseio.com/products.json?auth=$authtoken';
    try {
      var value = await http.post(url,
          body: json.encode({
            'creatorId': userid,
            'title': p.title,
            'price': p.price,
            'description': p.description,
            'imageUrl': p.imageUrl,
          }));
      _items.add(Product(
          id: json.decode(value.body)['name'],
          title: p.title,
          description: p.description,
          imageUrl: p.imageUrl,
          price: p.price));
      notifyListeners();
    } catch (err) {
      throw err;
    }
  }

  Future<void> updateproduct(String id, Product p) async {
    final url =
        'https://shopapp-35487.firebaseio.com/products/$id.json?auth=$authtoken';
    await http.patch(url,
        body: json.encode({
          'title': p.title,
          'price': p.price,
          'imageUrl': p.imageUrl,
          'description': p.description
        }));
    int index = _items.indexWhere((element) => element.id == id);
    _items[index] = p;
    notifyListeners();
  }

  Future<void> delete(String id) async {
    final url =
        'https://shopapp-35487.firebaseio.com/products/$id.json?auth=$authtoken';
    final epi = _items.indexWhere((element) => element.id == id);
    var exp = _items[epi];
    notifyListeners();
    _items.removeAt(epi);
    final response = await http.delete(url);
    if (response.statusCode >= 400) {
      _items.insert(epi, exp);
      notifyListeners();
      throw HttpException("Could not delete right now");
    }
    exp = null;
  }
  // void showfavs() {
  //   showfav = true;
  //   notifyListeners();
  // }

  // void showall() {
  //   showfav = false;
  //   notifyListeners();
  // }
  List<Product> get favitems {
    return _items.where((element) => element.isfav == true).toList();
  }

  Product findproductbyid(String id) {
    return _items.firstWhere((element) => element.id == id);
  }

  void fun() {
    notifyListeners();
  }
}
