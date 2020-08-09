import 'package:ShopApp/screen/auth.dart';
import 'package:ShopApp/screen/cart_screen.dart';
import 'package:ShopApp/screen/form_screen.dart';
import 'package:ShopApp/screen/product_details.dart';
import 'package:ShopApp/screen/product_overview.dart';
import 'package:ShopApp/screen/user_product.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import './provider/product_provider.dart';
import './provider/cart.dart';
import './provider/order.dart';
import './screen/orderscreen.dart';
import './provider/auth.dart';
import './screen/splash.dart';
import './helper/rotes.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (ctx) => Auth(),
        ),
        ChangeNotifierProxyProvider<Auth, Products>(
          update: (ctx, auth, previousstate) => Products(auth.token,
              previousstate == null ? [] : previousstate.items, auth.userid),
          create: (_) => null,
        ),
        ChangeNotifierProvider(
          create: (ct) => CartP(),
        ),
        ChangeNotifierProxyProvider<Auth, Orders>(
          update: (_, auth, previousstate) => Orders(auth.token,
              previousstate == null ? [] : previousstate.orders, auth.userid),
          create: (ctx) => null,
        )
      ],
      child: MainMaterial(),
    );
  }
}

class MainMaterial extends StatelessWidget {
  const MainMaterial({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Consumer<Auth>(
      builder: (context, auth, child) => MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
            primarySwatch: Colors.purple,
            accentColor: Colors.deepOrange,
            fontFamily: 'Lato',
            pageTransitionsTheme: PageTransitionsTheme(builders: {
              TargetPlatform.iOS: CustomPageTransitionBuilder(),
              TargetPlatform.android: CustomPageTransitionBuilder()
            })),
        home: auth.isauth
            ? ProductOverviewScreen()
            : FutureBuilder(
                future: auth.trylogging(),
                builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return SplashScreen();
                  } else {
                    return AuthScreen();
                  }
                },
              ),
        routes: {
          ProductDetailsScreen.routeName: (ctx) => ProductDetailsScreen(),
          CartScreen.routeName: (ctx) => CartScreen(),
          OrderScreen.routeName: (ctx) => OrderScreen(),
          UserProductScreen.routeName: (_) => UserProductScreen(),
          FormScreen.routeName: (_) => FormScreen(),
        },
      ),
    );
  }
}
