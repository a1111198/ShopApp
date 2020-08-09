import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart';

class CartItem extends StatelessWidget {
  final String id;
  final String title;
  final double price;
  final int quantity;
  final String productid;
  CartItem(this.price, this.id, this.quantity, this.title, this.productid);
  @override
  Widget build(BuildContext context) {
    return Dismissible(
      key: UniqueKey(),
      direction: DismissDirection.endToStart,
      confirmDismiss: (direction) {
        return showDialog(
            context: context,
            builder: (c) => AlertDialog(
                  title: Text(
                    'Are you Sure',
                  ),
                  content: Text('Do you want to remove this item'),
                  actions: [
                    FlatButton(
                      onPressed: () {
                        Navigator.of(c).pop(
                          true,
                        );
                      },
                      child: Text(
                        'Yes',
                      ),
                    ),
                    FlatButton(
                      onPressed: () {
                        Navigator.of(c).pop(
                          false,
                        );
                      },
                      child: Text(
                        'No',
                      ),
                    ),
                  ],
                ));
      },
      background: Container(
        padding: EdgeInsets.all(20),
        alignment: Alignment.centerRight,
        color: Theme.of(context).errorColor,
        child: Icon(
          Icons.delete,
          size: 40,
          color: Colors.white,
        ),
      ),
      onDismissed: (DismissDirection direction) {
        Provider.of<CartP>(context, listen: false).dismisitem(productid);
      },
      child: Card(
        margin: EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 5,
        ),
        child: Padding(
          padding: EdgeInsets.all(10),
          child: ListTile(
            leading: CircleAvatar(
              maxRadius: 50.0,
              child: Text(
                '\$$price',
              ),
            ),
            title: Text(
              title,
              style: Theme.of(context).textTheme.headline6,
            ),
            trailing: Text(
              '$quantity',
              style: Theme.of(context).textTheme.headline6,
            ),
          ),
        ),
      ),
    );
  }
}
