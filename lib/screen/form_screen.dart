import 'package:ShopApp/provider/product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ShopApp/provider/product_provider.dart';

class FormScreen extends StatefulWidget {
  static const routeName = '/edit';
  @override
  _FormScreenState createState() => _FormScreenState();
}

class _FormScreenState extends State<FormScreen> {
  final _pricefocus = FocusNode();
  final _desfocus = FocusNode();
  final _formkey = GlobalKey<FormState>();
  bool _isinit = true;
  bool isloading = false;
  Product editableproduct;
  String title = ' ';
  String price = '';
  String description = '';
  String imageUrl = '';
  String productid = '';
  bool isfav = false;
  @override
  void dispose() {
    _pricefocus.dispose();
    _desfocus.dispose();
    super.dispose();
  }

  void saveform() {
    bool isvalid = _formkey.currentState.validate();
    setState(() {
      isloading = true;
    });
    if (!isvalid) {
      return;
    }
    _formkey.currentState.save();
    Products p = Provider.of<Products>(context, listen: false);
    editableproduct = Product(
        description: description,
        title: title,
        id: DateTime.now().toString(),
        imageUrl: imageUrl,
        price: double.parse(price),
        isfav: isfav);
    if (productid != null) {
      p.updateproduct(productid, editableproduct);
      Navigator.of(context).pop();
    } else {
      p.addproduct(editableproduct).catchError((err) {
        return showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
                  title: Text("Oops Error"),
                  actions: [
                    FlatButton(
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                        child: Text('Ok'))
                  ],
                ));
      }).then((value) => Navigator.of(context).pop());
    }
  }

  @override
  void didChangeDependencies() {
    if (_isinit) {
      productid = ModalRoute.of(context).settings.arguments as String;
      if (productid != null) {
        editableproduct =
            Provider.of<Products>(context).findproductbyid(productid);
        price = editableproduct.price.toString();
        title = editableproduct.title;
        description = editableproduct.description;
        imageUrl = editableproduct.imageUrl;
        isfav = editableproduct.isfav;
      }
    }

    _isinit = false;
    super.didChangeDependencies();
  }

  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Edit Products'),
          actions: [IconButton(icon: Icon(Icons.save), onPressed: saveform)],
        ),
        body: isloading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.purple,
              ))
            : Padding(
                padding: const EdgeInsets.all(15.0),
                child: Form(
                  autovalidate: true,
                  key: _formkey,
                  child: SingleChildScrollView(
                      child: Column(
                    children: [
                      TextFormField(
                        initialValue: title,
                        onSaved: (value) => title = value,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'please provide some text';
                          }
                          return null;
                        },
                        decoration: InputDecoration(labelText: 'title'),
                        textInputAction: TextInputAction.next,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_pricefocus);
                        },
                      ),
                      TextFormField(
                        initialValue: price,
                        validator: (value) {
                          if (value.isEmpty) {
                            return 'Please enter some price';
                          }
                          if (double.tryParse(value) == null) {
                            return 'please enter a valid number';
                          }
                          if (double.tryParse(value) <= 1) {
                            return 'price must be grater then 1\$';
                          }
                          return null;
                        },
                        onSaved: (value) => price = value,
                        decoration: InputDecoration(labelText: 'price'),
                        textInputAction: TextInputAction.next,
                        keyboardType: TextInputType.number,
                        focusNode: _pricefocus,
                        onFieldSubmitted: (_) {
                          FocusScope.of(context).requestFocus(_desfocus);
                        },
                      ),
                      TextFormField(
                        initialValue: description,
                        validator: (value) {
                          if (value.length < 10) {
                            return 'please enter at least 10 character long description';
                          }
                          return null;
                        },
                        onSaved: (value) => description = value,
                        focusNode: _desfocus,
                        decoration: InputDecoration(
                          labelText: 'Description',
                        ),
                        maxLines: 3,
                        keyboardType: TextInputType.multiline,
                        textInputAction: TextInputAction.next,
                      ),
                    ],
                  )),
                ),
              ));
  }
}
