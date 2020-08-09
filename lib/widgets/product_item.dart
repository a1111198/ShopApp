import 'package:ShopApp/provider/auth.dart';
import 'package:flutter/material.dart';
import '../screen/product_details.dart';
import 'package:provider/provider.dart';
import '../provider/product.dart';
import '../provider/cart.dart';

class ProductItem extends StatelessWidget {
  Product productinfo;
  CartP cart;
  @override
  Widget build(BuildContext context) {
    var scaff = Scaffold.of(context);
    productinfo = Provider.of<Product>(
      context,
      listen: false,
    );
    cart = Provider.of<CartP>(
      context,
      listen: false,
    );
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: GridTile(
        child: InkWell(
          onTap: () {
            Navigator.of(context).pushNamed(
              ProductDetailsScreen.routeName,
              arguments: productinfo.id,
            );
          },
          child: Hero(
            tag: productinfo.id,
            child: FadeInImage(
              placeholder: AssetImage('assets/mages/im.jfif'),
              image: NetworkImage(
                productinfo.imageUrl,
              ),
              fit: BoxFit.cover,
            ),
          ),
        ),
        footer: GridTileBar(
          leading: Consumer<Product>(
            builder: (ctx, productinfo, child) => IconButton(
              icon: Icon(
                productinfo.isfav ? Icons.favorite : Icons.favorite_border,
                color: Theme.of(context).accentColor,
              ),
              onPressed: () async {
                print(productinfo.id);
                try {
                  await productinfo.togglefav(
                      Provider.of<Auth>(context, listen: false).token,
                      Provider.of<Auth>(context, listen: false).userid);
                } catch (err) {
                  scaff.showSnackBar(SnackBar(
                    content: Text("not saved"),
                  ));
                }
              },
            ),
          ),
          trailing: IconButton(
            icon: Icon(
              Icons.add_shopping_cart,
              color: Theme.of(context).accentColor,
            ),
            onPressed: () {
              cart.additem(
                productinfo.id,
                productinfo.title,
                productinfo.price,
              );
              Scaffold.of(context).hideCurrentSnackBar();
              Scaffold.of(context).showSnackBar(SnackBar(
                content: Text('Added to card'),
                duration: Duration(seconds: 6),
                action: SnackBarAction(
                    label: 'Undo',
                    onPressed: () {
                      cart.removesingle(productinfo.id);
                    }),
              ));
            },
          ),
          backgroundColor: Colors.black87,
          title: Text(
            productinfo.title,
            textAlign: TextAlign.center,
          ),
        ),
      ),
    );
  }
}
