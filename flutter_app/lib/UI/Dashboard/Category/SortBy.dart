import 'package:flutter/material.dart';

class SortBy extends StatefulWidget {
  @override
  _SortByState createState() => _SortByState();
}

class _SortByState extends State<SortBy> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: 414,
        color: Colors.white,
        padding: const EdgeInsets.only(
          left: 20,
          right: 19,
          top: 39,
          bottom: 57,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Sort By",
              style: TextStyle(
                color: Color(0xff2c393f),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.79),
            Container(
              width: 375,
              height: 0.50,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(32),
                color: Color(0xff5b5b5b),
              ),
            ),
            SizedBox(height: 28.79),
            Text(
              "What’s new",
              style: TextStyle(
                color: Color(0xff969696),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.79),
            Text(
              "Price - high to low",
              style: TextStyle(
                color: Color(0xff969696),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.79),
            Text(
              "Price - low to high",
              style: TextStyle(
                color: Color(0xff969696),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.79),
            Text(
              "Popularity",
              style: TextStyle(
                color: Color(0xff969696),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.79),
            Text(
              "Discount",
              style: TextStyle(
                color: Color(0xff969696),
                fontSize: 14,
              ),
            ),
            SizedBox(height: 28.79),
            Text(
              "Customer rating",
              style: TextStyle(
                color: Color(0xff969696),
                fontSize: 14,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
