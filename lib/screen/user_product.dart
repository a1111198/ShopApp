import 'package:ShopApp/screen/form_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../provider/product_provider.dart';

class UserProductScreen extends StatelessWidget {
  static const routeName = '/user';
  Future<bool> getdata(BuildContext context) async {
    await Provider.of<Products>(context, listen: false)
        .fetchproducts(isfilter: true);
    return true;
  }

  Future<void> delete(BuildContext context, id) async {
    try {
      await Provider.of<Products>(context, listen: false).delete(id);
    } catch (err) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('Deleting Faild !'),
        action: SnackBarAction(
            label: 'Try Again',
            onPressed: () async {
              await delete(context, id);
            }),
      ));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('My Products'),
        actions: [
          IconButton(
              icon: Icon(Icons.add),
              onPressed: () {
                Navigator.of(context).pushNamed(FormScreen.routeName);
              })
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(
          15,
        ),
        child: FutureBuilder(
          future: getdata(context),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(
                child: CircularProgressIndicator(),
              );
            } else if (snapshot.hasError) {
              Center(
                child: Text("Oops Error"),
              );
            } else if (snapshot.hasData) {
              return Consumer<Products>(
                builder: (context, prod, child) => ListView.builder(
                  itemCount: prod.userproducts.length,
                  itemBuilder: (BuildContext context, int index) {
                    return ListTile(
                      title: Text(
                        prod.items[index].title,
                      ),
                      leading: CircleAvatar(
                        backgroundImage:
                            NetworkImage(prod.items[index].imageUrl),
                      ),
                      trailing: Container(
                        width: 100,
                        child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                icon: Icon(Icons.edit),
                                onPressed: () {
                                  Navigator.of(context).pushNamed(
                                      FormScreen.routeName,
                                      arguments: prod.items[index].id);
                                },
                              ),
                              IconButton(
                                  icon: Icon(Icons.delete),
                                  onPressed: () async {
                                    await delete(context, prod.items[index].id);
                                  })
                            ]),
                      ),
                    );
                  },
                ),
              );
            }
            return Center();
          },
        ),
      ),
    );
  }
}
