import 'dart:ui';

import 'package:flutter/material.dart';

class SortBy extends StatefulWidget {
  final Sort sort;

  const SortBy({Key key, this.sort}) : super(key: key);

  @override
  _SortByState createState() => _SortByState();
}

class _SortByState extends State<SortBy> {
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: GestureDetector(
        onTap: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.black26,
          body: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 30,
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 30.0),
                  child: ListView(
                    shrinkWrap: true,
                    children: [
                      Text(
                        "Sort By",
                        style: TextStyle(
                            color: Color(0xff2c393f),
                            fontSize: 16,
                            fontWeight: FontWeight.bold),
                      ),
                      SizedBox(height: 20),
                      Container(
                        height: 0.50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(32),
                          color: Color(0xff5b5b5b),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context, Sort.WhatsNew);
                        },
                        selectedTileColor: Color(0xffDC0F21),
                        selected: widget.sort == Sort.WhatsNew,
                        title: Text(
                          "What’s new",
                          style: TextStyle(
                            color: widget.sort == Sort.WhatsNew
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context, Sort.PriceHighToLow);
                        },
                        selectedTileColor: Color(0xffDC0F21),
                        selected: widget.sort == Sort.PriceHighToLow,
                        title: Text(
                          "Price - high to low",
                          style: TextStyle(
                            color: widget.sort == Sort.PriceHighToLow
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context, Sort.PriceLowToHigh);
                        },
                        selectedTileColor: Color(0xffDC0F21),
                        selected: widget.sort == Sort.PriceLowToHigh,
                        title: Text(
                          "Price - low to high",
                          style: TextStyle(
                            color: widget.sort == Sort.PriceLowToHigh
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      // ListTile(
                      //   onTap: () {
                      //     Navigator.pop(context, Sort.Popularity);
                      //   },
                      //   selectedTileColor: Color(0xffDC0F21),
                      //   selected: widget.sort == Sort.Popularity,
                      //   title: Text(
                      //     "Popularity",
                      //     style: TextStyle(
                      //       color: widget.sort == Sort.Popularity
                      //           ? Colors.white
                      //           : Colors.black,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                      ListTile(
                        onTap: () {
                          Navigator.pop(context, Sort.Discount);
                        },
                        selectedTileColor: Color(0xffDC0F21),
                        selected: widget.sort == Sort.Discount,
                        title: Text(
                          "Discount",
                          style: TextStyle(
                            color: widget.sort == Sort.Discount
                                ? Colors.white
                                : Colors.black,
                            fontSize: 14,
                          ),
                        ),
                      ),
                      SizedBox(height: 20,)
                      // ListTile(
                      //   onTap: () {
                      //     Navigator.pop(context, Sort.CustomerRating);
                      //   },
                      //   selectedTileColor: Color(0xffDC0F21),
                      //   selected: widget.sort == Sort.CustomerRating,
                      //   title: Text(
                      //     "Customer rating",
                      //     style: TextStyle(
                      //       color: widget.sort == Sort.CustomerRating
                      //           ? Colors.white
                      //           : Colors.black,
                      //       fontSize: 14,
                      //     ),
                      //   ),
                      // ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

enum Sort {
  NONE,
  WhatsNew,
  PriceHighToLow,
  PriceLowToHigh,
  Popularity,
  Discount,
  CustomerRating
}
