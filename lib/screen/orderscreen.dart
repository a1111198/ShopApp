import 'package:flutter/material.dart';
import '../provider/order.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'dart:math';

class OrderScreen extends StatelessWidget {
  static const routeName = '/oredrs';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Your Orders'),
      ),
      body: RefreshIndicator(
        onRefresh: () {
          Orders orderdata = Provider.of<Orders>(context, listen: false);
          orderdata.changeisfetched();
          return orderdata.fetchorders();
        },
        child: FutureBuilder(
          future: Provider.of<Orders>(context, listen: false).fetchorders(),
          builder: (BuildContext context, AsyncSnapshot snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return Center(child: CircularProgressIndicator());
            }
            if (snapshot.hasData) {
              return Consumer<Orders>(
                builder: (context, orderdata, child) => ListView.builder(
                  itemCount: orderdata.orders.length,
                  itemBuilder: (BuildContext context, int index) {
                    return OrderItem(
                      orderdata.orders[index],
                    );
                  },
                ),
              );
            }
            if (snapshot.hasError) {
              return Center(child: Text("Oops Error"));
            } else {
              return Text("something went wrong");
            }
          },
        ),
      ),
    );
  }
}

class OrderItem extends StatefulWidget {
  final Order order;
  OrderItem(this.order);

  @override
  _OrderItemState createState() => _OrderItemState();
}

class _OrderItemState extends State<OrderItem> {
  bool expanded = false;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 500),
      curve: Curves.linear,
      height: expanded
          ? min(
              widget.order.products.length * 20.0 + 150,
              300,
            )
          : 100,
      child: Card(
        margin: EdgeInsets.all(10),
        child: Column(
          children: [
            ListTile(
              title: Text(
                '\$${widget.order.amount}',
              ),
              subtitle: Text(
                DateFormat(
                  'dd/ MM/ yyyy hh:mm',
                ).format(
                  widget.order.time,
                ),
              ),
              trailing: IconButton(
                icon: Icon(
                  expanded ? Icons.expand_less : Icons.expand_more,
                ),
                onPressed: () {
                  setState(() {
                    expanded = !expanded;
                  });
                },
              ),
            ),
            AnimatedContainer(
              curve: Curves.linear,
              duration: Duration(milliseconds: 500),
              height: expanded
                  ? min(
                      widget.order.products.length * 20.0 + 50,
                      200,
                    )
                  : 0,
              child: ListView.builder(
                itemCount: widget.order.products.length,
                itemBuilder: (BuildContext context, int index) {
                  return Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${widget.order.products[index].title}',
                          style: TextStyle(
                              fontWeight: FontWeight.bold, fontSize: 20),
                        ),
                        Text(
                          '${widget.order.products[index].quantity}',
                          style: TextStyle(fontSize: 20),
                        ),
                        Text(
                          '${widget.order.products[index].price}',
                          style: TextStyle(fontSize: 20),
                        ),
                      ],
                    ),
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
