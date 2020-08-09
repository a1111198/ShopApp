import 'package:ShopApp/widgets/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/cart.dart' show CartP;
import '../provider/order.dart';

class CartScreen extends StatelessWidget {
  static const routeName = '/cart';
  const CartScreen({Key key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    final cart = Provider.of<CartP>(context);
    final cartitems = cart.items.values.toList();
    return Scaffold(
      appBar: AppBar(
        title: Text('Cart'),
      ),
      body: Column(
        children: [
          CustomCard(cart: cart),
          Expanded(
            child: ListView.builder(
              itemCount: cart.numberofitems,
              itemBuilder: (
                BuildContext context,
                int index,
              ) {
                return CartItem(
                  cartitems[index].price,
                  cartitems[index].id,
                  cartitems[index].quantity,
                  cartitems[index].title,
                  cart.items.keys.toList()[index],
                );
              },
            ),
          )
        ],
      ),
    );
  }
}

class CustomCard extends StatelessWidget {
  const CustomCard({
    Key key,
    @required this.cart,
  }) : super(key: key);

  final CartP cart;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: EdgeInsets.all(10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          SizedBox(
            width: 20,
          ),
          Text(
            'Total',
            style: TextStyle(fontSize: 20),
          ),
          Spacer(),
          Chip(
            backgroundColor: Theme.of(context).primaryColor,
            label: Text(
              '\$${cart.totalamount}',
            ),
          ),
          Consumer<Orders>(
            builder: (ctx, orders, child) => MaterialButton(
              onPressed: cart.totalamount == 0
                  ? null
                  : () async {
                      try {
                        await orders.addorder(
                            cart.items.values.toList(), cart.totalamount);
                        cart.clearcart();
                      } catch (err) {
                        Scaffold.of(context).showSnackBar(SnackBar(
                          content: Text('Unable to Place Order'),
                        ));
                      }
                    },
              child: orders.isloading
                  ? Center(child: CircularProgressIndicator())
                  : Text(
                      'Order Now',
                      style: Theme.of(context).textTheme.headline6,
                    ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(
                  20,
                ),
              ),
              color: Theme.of(context).primaryColor,
            ),
          )
        ],
      ),
    );
  }
}
