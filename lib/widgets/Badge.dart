import 'package:flutter/material.dart';

class Badge extends StatelessWidget {
  final Widget child;
  final int value;
  final Color color;
  Badge({
    @required this.child,
    @required this.color,
    @required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        child,
        Positioned(
            right: 3,
            top: 0,
            child: Container(
              padding: EdgeInsets.all(2.0),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0), color: color),
              constraints: BoxConstraints(
                minWidth: 16,
                minHeight: 16,
              ),
              child: Text(
                value.toString(),
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 20,
                ),
              ),
            )),
      ],
    );
  }
}
