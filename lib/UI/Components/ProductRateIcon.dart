import 'package:flutter/material.dart';

class ProductRateIcon extends StatefulWidget {
  final Map productData;

  const ProductRateIcon({Key key, this.productData}) : super(key: key);

  @override
  _ProductRateIconState createState() => _ProductRateIconState();
}

class _ProductRateIconState extends State<ProductRateIcon> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // child: Row(mainAxisSize: MainAxisSize.min,
      //   children: [
      //     Text(
      //       "4.2",
      //       style: TextStyle(
      //         color: Color(0xff515151),
      //         fontSize: 12,
      //         letterSpacing: 0.24,
      //       ),
      //     ),
      //     Icon(
      //       Icons.star,
      //       color: Color(0xfffaae00),
      //       size: 16,
      //     ),
      //   ],
      // ),
    );
  }
}
