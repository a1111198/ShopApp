import 'package:ShopApp/provider/product_provider.dart';
import 'package:flutter/material.dart';
import './product_item.dart';
import 'package:provider/provider.dart';

class ProductsGridview extends StatelessWidget {
  final bool showfav;
  ProductsGridview(this.showfav);
  @override
  Widget build(BuildContext context) {
    final productsdataclass = Provider.of<Products>(
      context,
      listen: true,
    );
    final products =
        showfav ? productsdataclass.favitems : productsdataclass.items;

    return GridView.builder(
      padding: EdgeInsets.all(10),
      itemCount: products.length,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 3 / 2,
        crossAxisSpacing: 20,
        mainAxisSpacing: 20,
      ),
      itemBuilder: (ctx, index) {
        return ChangeNotifierProvider.value(
          value: products[index],
          child: ProductItem(),
        );
      },
    );
  }
}
