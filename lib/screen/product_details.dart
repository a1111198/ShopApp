import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class ProductDetailsScreen extends StatelessWidget {
  static const routeName = '/productdet';
  String productid;
  @override
  Widget build(BuildContext context) {
    productid = ModalRoute.of(context).settings.arguments as String;
    final productsdata = Provider.of<Products>(
      context,
      listen: false,
    );
    final product = productsdata.findproductbyid(
      productid,
    );

    return Scaffold(
      // appBar: AppBar(
      //   title: Text(product.title),
      // ),
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 300,
            pinned: true,
            flexibleSpace: FlexibleSpaceBar(
              title: Text(product.title),
              background: Hero(
                tag: product.id,
                child: Image.network(
                  product.imageUrl,
                  fit: BoxFit.cover,
                ),
              ),
            ),
          ),
          SliverList(
            delegate: SliverChildListDelegate(
              [
                SizedBox(height: 10),
                Text(
                  '${product.title}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                SizedBox(height: 10),
                Text(
                  '${product.price}',
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headline6,
                ),
                Container(
                  padding: EdgeInsets.all(20),
                  child: Text(
                    '${product.description}',
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: 560)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
