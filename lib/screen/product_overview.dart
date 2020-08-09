import 'package:ShopApp/provider/cart.dart';
import 'package:ShopApp/screen/cart_screen.dart';
import 'package:ShopApp/widgets/Badge.dart';
import 'package:ShopApp/widgets/drawer.dart';
import 'package:flutter/material.dart';
import '../widgets/products_grid.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

enum Options {
  Fav,
  All,
}

class ProductOverviewScreen extends StatefulWidget {
  @override
  _ProductOverviewScreenState createState() => _ProductOverviewScreenState();
}

class _ProductOverviewScreenState extends State<ProductOverviewScreen> {
  bool showfav = false;
  bool isfirst = true;
  bool isloading = false;

  @override
  void didChangeDependencies() {
    if (isfirst) {
      setState(() {
        isloading = true;
      });
      Provider.of<Products>(context, listen: false)
          .fetchproducts()
          .then((value) {
        setState(() {
          isloading = false;
        });
        isfirst = false;
      });
    }

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Shop App'),
        actions: [
          PopupMenuButton(
            color: Theme.of(context).accentColor,
            onSelected: (Options selectedvalue) {
              setState(
                () {
                  if (selectedvalue == Options.Fav) {
                    showfav = true;
                  } else {
                    showfav = false;
                  }
                },
              );
            },
            icon: Icon(Icons.more_vert),
            itemBuilder: (_) => [
              PopupMenuItem(
                child: Text("Only Favourites"),
                value: Options.Fav,
              ),
              PopupMenuItem(
                child: Text('All Products'),
                value: Options.All,
              ),
            ],
          ),
          Consumer<CartP>(
            builder: (ctx, cart, child) => Badge(
              child: child,
              color: Theme.of(context).accentColor,
              value: cart.numberofitems,
            ),
            child: IconButton(
              icon: Icon(Icons.shopping_cart),
              onPressed: () {
                Navigator.of(context).pushNamed(CartScreen.routeName);
              },
            ),
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Provider.of<Products>(context, listen: false).setisfetched();
          return Provider.of<Products>(context, listen: false)
              .fetchproducts()
              .then((value) {
            setState(() {
              isloading = false;
            });
            isfirst = false;
          });
        },
        child: isloading
            ? Center(
                child: CircularProgressIndicator(
                backgroundColor: Colors.purple,
              ))
            : ProductsGridview(showfav),
      ),
      drawer: CustomDrawer(),
    );
  }
}
