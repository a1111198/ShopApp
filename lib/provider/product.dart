import 'package:ShopApp/ErrorHandlers/httperroe.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class Product with ChangeNotifier {
  final String id;
  final String title;
  final String description;
  final double price;
  final String imageUrl;
  bool isfav;
  Product({
    @required this.id,
    @required this.title,
    @required this.description,
    @required this.imageUrl,
    this.isfav = false,
    @required this.price,
  });
  Future<void> togglefav(String authToken, String userid) async {
    isfav = !isfav;
    notifyListeners();
    var url =
        'https://shopapp-35487.firebaseio.com/favstatus/$userid/$id.json?auth=$authToken';
    var res = await http.put(url, body: json.encode(isfav));
    print(res.statusCode);
    if (res.statusCode >= 400) {
      isfav = !isfav;
      notifyListeners();
      throw HttpException("some error in send fav status");
    }
  }
}
