import 'dart:ui';

import 'package:flutter/material.dart';

class FilterBy extends StatefulWidget {
  final Map<String, Set> allFilters, appliedFilters;

  const FilterBy({Key key, this.allFilters, this.appliedFilters})
      : super(key: key);

  @override
  _FilterByState createState() => _FilterByState();
}

class _FilterByState extends State<FilterBy> {
  Set selectedBrands = Set(),
      selectedPrice = Set(),
      selectedSizes = Set(),
      selectedColors = Set(),
      selectedStars = Set(),
      selectedDiscount = Set();

  bool showAllBrands = false, brandsMoreThan6 = false;

  double minPrice = 0, maxPrice = 20000;

  RangeValues _priceValues;

  @override
  void initState() {
    super.initState();
    selectedBrands = Set()..addAll(widget.appliedFilters['brands'] ?? []);
    selectedPrice = Set()..addAll(widget.appliedFilters['price'] ?? []);

    selectedSizes = Set()..addAll(widget.appliedFilters['size'] ?? []);
    selectedColors = Set()..addAll(widget.appliedFilters['colors'] ?? []);
    selectedStars = Set()..addAll(widget.appliedFilters['stars'] ?? []);
    selectedDiscount = Set()..addAll(widget.appliedFilters['discount'] ?? []);
    if ((widget.allFilters['brands']?.length ?? 0) > 6) brandsMoreThan6 = true;
    maxPrice = (widget.allFilters['price'])
        .reduce((curr, next) => curr > next ? curr : next);
    minPrice = (widget.allFilters['price'])
        .reduce((curr, next) => curr < next ? curr : next);

    if (selectedPrice.length == 2) {
      _priceValues = RangeValues(selectedPrice.first, selectedPrice.last);
    } else {
      _priceValues = RangeValues(minPrice, maxPrice);
    }
  }

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
              child: ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 20.0),
                        child: Text(
                          "Filters",
                          style: TextStyle(
                              color: Color(0xff2c393f),
                              fontSize: 16,
                              fontWeight: FontWeight.bold),
                        ),
                      ),
                      FlatButton(
                        onPressed: () {
                          selectedBrands.clear();
                          selectedPrice.clear();
                          selectedSizes.clear();
                          selectedColors.clear();
                          selectedStars.clear();
                          selectedDiscount.clear();
                          maxPrice = (widget.allFilters['price']).reduce(
                              (curr, next) => curr > next ? curr : next);
                          minPrice = (widget.allFilters['price']).reduce(
                              (curr, next) => curr < next ? curr : next);
                          _priceValues = RangeValues(minPrice, maxPrice);
                          Map<String, Set> appFilters = {}..addAll({
                              "brands": selectedBrands,
                              "price": selectedPrice,
                              "colors": selectedColors,
                              "size": selectedSizes,
                              "stars": selectedStars,
                              "discount": selectedDiscount
                            });

                          Navigator.pop(context, appFilters);
                          // if(mounted)
                          //   setState(() {
                          //
                          //   });
                        },
                        child: Text(
                          "Clear all",
                          style: TextStyle(
                            color: Color(0xffdc0f21),
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ],
                  ),
                  if(widget.allFilters['brands'].length!=0)
                  ...[Padding(
                    padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                    child: Text(
                      "Brand",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        ...widget.allFilters['brands']
                            .toList()
                            .sublist(
                                0,
                                brandsMoreThan6 && !showAllBrands
                                    ? 6
                                    : widget.allFilters['brands'].length)
                            .map((brand) {
                          bool selected =
                              selectedBrands.contains(brand) ?? false;
                          return InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {
                              if (selected)
                                selectedBrands.remove(brand);
                              else
                                selectedBrands.add(brand);
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color(0xff969696),
                                  width: 1,
                                ),
                                color:
                                    selected ? Color(0xff686868) : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "$brand",
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Color(0xff969696),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        }).toList(),
                      ],
                    ),
                  ),
                  if (brandsMoreThan6)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: FlatButton(
                        onPressed: () {
                          if (mounted)
                            setState(() {
                              showAllBrands = !showAllBrands;
                            });
                        },
                        child: Align(
                            alignment: Alignment.centerLeft,
                            child: Text(
                              showAllBrands ? "- less" : "+ more",
                              style: TextStyle(
                                color: Color(0xff196f96),
                                fontSize: 12,
                              ),
                            )),
                      ),
                    ),],
                  Padding(
                    padding: const EdgeInsets.only(
                      left: 10.0,
                      top: 10,
                    ),
                    child: Text(
                      "Price Range",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 10),
                    child: Theme(
                      data: ThemeData(
                          sliderTheme: SliderThemeData(
                              rangeTrackShape:
                                  RoundedRectRangeSliderTrackShape(),
                              rangeValueIndicatorShape:
                                  PaddleRangeSliderValueIndicatorShape(),
                              showValueIndicator: ShowValueIndicator.always)),
                      child: RangeSlider(
                        values: _priceValues,
                        activeColor: Color(0xffDC0F21),
                        inactiveColor: Color(0xff5B5B5B),
                        onChanged: (x) {
                          if (mounted)
                            setState(() {
                              _priceValues = x;
                              selectedPrice.clear();
                              selectedPrice.add(x.start);
                              selectedPrice.add(x.end);
                            });
                        },
                        min: minPrice,
                        max: maxPrice,
                        labels: RangeLabels(
                            _priceValues.start.round().toString(),
                            _priceValues.end.round().toString()),
                      ),
                    ),
                  ),
                  Transform.translate(
                    offset: Offset(0, -15),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 30.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "\u20B9${minPrice.round()}",
                            style: TextStyle(
                              color: Color(0xff969696),
                              fontSize: 14,
                            ),
                          ),
                          Text(
                            "\u20B9${maxPrice.round()}",
                            style: TextStyle(
                              color: Color(0xff969696),
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  if ((widget.allFilters['size']).length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(left: 10.0, bottom: 10),
                      child: Text(
                        "Size",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 8,
                        spacing: 8,
                        children: [
                          ...(widget.allFilters['size']).map((s) {
                            bool selected = selectedSizes.contains(s) ?? false;
                            return InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () {
                                if (selected)
                                  selectedSizes.remove(s);
                                else
                                  selectedSizes.add(s);
                                if (mounted) setState(() {});
                              },
                              child: Container(
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(4),
                                  border: Border.all(
                                    color: Color(0xff969696),
                                    width: 1,
                                  ),
                                  color: selected
                                      ? Color(0xff686868)
                                      : Colors.white,
                                ),
                                child: Padding(
                                  padding: const EdgeInsets.all(6.0),
                                  child: Text(
                                    " $s ",
                                    style: TextStyle(
                                      color: selected
                                          ? Colors.white
                                          : Color(0xff969696),
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                  if ((widget.allFilters['colors']).length > 0) ...[
                    Padding(
                      padding: const EdgeInsets.only(
                          left: 10.0, top: 10, bottom: 10),
                      child: Text(
                        "Colour",
                        style: TextStyle(
                            color: Colors.black,
                            fontSize: 14,
                            fontWeight: FontWeight.bold),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 8.0),
                      child: Wrap(
                        alignment: WrapAlignment.start,
                        crossAxisAlignment: WrapCrossAlignment.start,
                        runSpacing: 8,
                        spacing: 8,
                        children: [
                          ...(widget.allFilters['colors']).map((c) {
                            bool selected = selectedColors.contains(c) ?? false;
                            return InkWell(
                              borderRadius: BorderRadius.circular(4),
                              onTap: () {
                                if (selected)
                                  selectedColors.remove(c);
                                else
                                  selectedColors.add(c);
                                if (mounted) setState(() {});
                              },
                              child: Stack(
                                children: [
                                  Container(
                                    width: 50,
                                    height: 35,
                                    child: Center(
                                        child: Text(
                                      "$c",
                                      style: TextStyle(fontSize: 14),
                                    )),
                                    decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(color: Colors.black)
                                        // color: Color(int.parse("0xff" + c)),
                                        ),
                                  ),
                                  if (selected)
                                    Container(
                                      width: 50,
                                      height: 35,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(4),
                                        color: Colors.black26,
                                      ),
                                      child: Icon(Icons.check,
                                          color: Colors.white),
                                    ),
                                ],
                              ),
                            );
                          }).toList(),
                        ],
                      ),
                    ),
                  ],
                  // Padding(
                  //   padding:
                  //       const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                  //   child: Text(
                  //     "Star Rating",
                  //     style: TextStyle(
                  //         color: Colors.black,
                  //         fontSize: 14,
                  //         fontWeight: FontWeight.bold),
                  //   ),
                  // ),
                  // Padding(
                  //   padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  //   child: Wrap(
                  //     alignment: WrapAlignment.start,
                  //     crossAxisAlignment: WrapCrossAlignment.start,
                  //     runSpacing: 8,
                  //     spacing: 8,
                  //     children: [
                  //       ...List.generate(5, (index) {
                  //         bool selected = selectedStars.contains(index) ?? false;
                  //         return InkWell(
                  //           borderRadius: BorderRadius.circular(4),
                  //           onTap: () {
                  //             if (selected)
                  //               selectedStars.clear();
                  //             else
                  //               selectedStars = [index].toSet();
                  //             if (mounted) setState(() {});
                  //           },
                  //           child: Container(
                  //             decoration: BoxDecoration(
                  //               borderRadius: BorderRadius.circular(4),
                  //               border: Border.all(
                  //                 color: Color(0xff969696),
                  //                 width: 1,
                  //               ),
                  //               color:
                  //                   selected ? Color(0xff686868) : Colors.white,
                  //             ),
                  //             child: Padding(
                  //               padding: const EdgeInsets.all(10.0),
                  //               child: Text(
                  //                 "${index + 1}${index == 4 ? "" : "+"}",
                  //                 style: TextStyle(
                  //                   color: selected
                  //                       ? Colors.white
                  //                       : Color(0xff969696),
                  //                   fontSize: 14,
                  //                 ),
                  //               ),
                  //             ),
                  //           ),
                  //         );
                  //       })
                  //     ],
                  //   ),
                  // ),
                  Padding(
                    padding:
                        const EdgeInsets.only(left: 10.0, top: 10, bottom: 10),
                    child: Text(
                      "Discount",
                      style: TextStyle(
                          color: Colors.black,
                          fontSize: 14,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Wrap(
                      alignment: WrapAlignment.start,
                      crossAxisAlignment: WrapCrossAlignment.start,
                      runSpacing: 8,
                      spacing: 8,
                      children: [
                        ...List.generate(5, (index) {
                          bool selected =
                              selectedDiscount.contains(index) ?? false;
                          String text = "10% Or Above";
                          switch (index) {
                            case 1: text = "20% Or Above";
                            break;
                            case 2:
                              text = "30% Or Above";
                              break;
                            case 3:
                              text = "50% Or Above";
                              break;
                            case 4:
                              text = "70% Or Above";
                              break;
                          }
                          return InkWell(
                            borderRadius: BorderRadius.circular(4),
                            onTap: () {
                              if (selected)
                                selectedDiscount.clear();
                              else
                                selectedDiscount = [index].toSet();
                              if (mounted) setState(() {});
                            },
                            child: Container(
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(4),
                                border: Border.all(
                                  color: Color(0xff969696),
                                  width: 1,
                                ),
                                color:
                                    selected ? Color(0xff686868) : Colors.white,
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(10.0),
                                child: Text(
                                  "$text",
                                  style: TextStyle(
                                    color: selected
                                        ? Colors.white
                                        : Color(0xff969696),
                                    fontSize: 14,
                                  ),
                                ),
                              ),
                            ),
                          );
                        })
                      ],
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 25, vertical: 20),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(right: 12.5),
                            child: FlatButton(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              color: Color(0xff7B8387),
                              height: 40,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "Close",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(left: 12.5),
                            child: FlatButton(
                              onPressed: () {
                                Map<String, Set> appFilters = {}..addAll({
                                    "brands": selectedBrands,
                                    "price": selectedPrice,
                                    "colors": selectedColors,
                                    "size": selectedSizes,
                                    "stars": selectedStars,
                                    "discount": selectedDiscount
                                  });

                                Navigator.pop(context, appFilters);
                              },
                              color: Color(0xffDC0F21),
                              height: 40,
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8)),
                              child: Text(
                                "Apply",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
