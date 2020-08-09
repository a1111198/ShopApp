import 'package:ShopApp/provider/auth.dart';
import 'package:ShopApp/screen/orderscreen.dart';
import 'package:ShopApp/screen/user_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class CustomDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          AppBar(
            title: Text('hello Guys'),
            automaticallyImplyLeading: false,
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.shop),
            title: Text(
              'Shop',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.of(context).pushNamed('/');
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.payment),
            title: Text(
              'Orders',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(OrderScreen.routeName);
              // Navigator.of(context).pushReplacement(
              //     CustomRoute(builder: (ctx) => OrderScreen()));
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.edit),
            title: Text(
              'Manage Products',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Navigator.of(context).pushNamed(UserProductScreen.routeName);
            },
          ),
          Divider(),
          ListTile(
            leading: Icon(Icons.exit_to_app),
            title: Text(
              'Logout',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600),
            ),
            onTap: () {
              Provider.of<Auth>(context, listen: false).logout();
              Navigator.of(context).pop();
              Navigator.of(context).pushReplacementNamed('/');
            },
          )
        ],
      ),
    );
  }
}
