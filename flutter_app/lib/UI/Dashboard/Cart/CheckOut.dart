import 'package:flutter/material.dart';

class CheckOut extends StatefulWidget {
  @override
  _CheckOutState createState() => _CheckOutState();
}

class _CheckOutState extends State<CheckOut> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        iconTheme: IconThemeData(color: Colors.black),
      ),
      backgroundColor: Color(0xffE5E5E5),
      body: ListView(physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 170,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    height: double.maxFinite,
                    child: Image.asset(
                      "assets/intro2.png",
                      fit: BoxFit.fitHeight,
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2.4,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shirts by AFCFAB",
                            maxLines: 1,
                            style: TextStyle(
                              color: Color(0xff515151),
                              fontSize: 15,
                              letterSpacing: 0.45,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Men Blue Print Solid Collar Shirt",
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 10,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:10.0),
                                    child: RaisedButton(
                                      color: Color(0xffF2F2F2),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      elevation: 2,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Size : ",
                                            style: TextStyle(
                                              color: Color(0xff515151),
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 0.30,
                                            ),
                                          ),
                                          DropdownButton(
                                              dropdownColor: Color(0xffF2F2F2),
                                              style: TextStyle(
                                                color: Color(0xff515151),
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.30,
                                              ),
                                              value: 0,
                                              elevation: 0,
                                              underline: Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text("S"),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("M"),
                                                  value: 0,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("L"),
                                                  value: 3,
                                                ),
                                              ],
                                              onChanged: (x) {
                                                print(x);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: RaisedButton(
                                      color: Color(0xffF2F2F2),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      elevation: 2,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Qty : ",
                                            style: TextStyle(
                                              color: Color(0xff515151),
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 0.30,
                                            ),
                                          ),
                                          DropdownButton(
                                              dropdownColor: Color(0xffF2F2F2),
                                              style: TextStyle(
                                                color: Color(0xff515151),
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.30,
                                              ),
                                              value: 0,
                                              elevation: 0,
                                              underline: Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text("-1"),
                                                  value: -1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("2"),
                                                  value: 0,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("+1"),
                                                  value: 1,
                                                ),
                                              ],
                                              onChanged: (x) {
                                                print(x);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "\u20B9 877",
                                    //${data['price'].toString().substring(0, 4)}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // if ((data['previous_price']??0 )!=
                                //     0)
                                Expanded(
                                  child: Text(
                                    "\u20B9 3990",
                                    //${data['previous_price'].toString().substring(0, 4)}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xffA9A9A9),
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                                // if ((data['is_discount']??0) > 0)
                                Expanded(
                                  child: Text(
                                    "78% Off",
                                    //      "${data['whole_sell_discount']}% Off",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "30 days easy return",
                            style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 10,
                              letterSpacing: 0.30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Container(
              height: 170,
              color: Colors.white,
              child: Row(
                children: [
                  Container(
                    height: double.maxFinite,
                    child: Image.asset(
                      "assets/intro2.png",
                      fit: BoxFit.fitHeight,
                    ),
                    width: MediaQuery
                        .of(context)
                        .size
                        .width / 2.4,
                  ),
                  Expanded(
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Shirts by AFCFAB",
                            maxLines: 1,
                            style: TextStyle(
                              color: Color(0xff515151),
                              fontSize: 15,
                              letterSpacing: 0.45,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(top: 8.0),
                            child: Text(
                              "Men Blue Print Solid Collar Shirt",
                              maxLines: 1,
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 10,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.30,
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 5.0, right: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(right:10.0),
                                    child: RaisedButton(
                                      color: Color(0xffF2F2F2),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      elevation: 2,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Size : ",
                                            style: TextStyle(
                                              color: Color(0xff515151),
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 0.30,
                                            ),
                                          ),
                                          DropdownButton(
                                              dropdownColor: Color(0xffF2F2F2),
                                              style: TextStyle(
                                                color: Color(0xff515151),
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.30,
                                              ),
                                              value: 0,
                                              elevation: 0,
                                              underline: Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text("S"),
                                                  value: 1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("M"),
                                                  value: 0,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("L"),
                                                  value: 3,
                                                ),
                                              ],
                                              onChanged: (x) {
                                                print(x);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                  child: Padding(
                                    padding: const EdgeInsets.only(left:10.0),
                                    child: RaisedButton(
                                      color: Color(0xffF2F2F2),
                                      onPressed: () {},
                                      padding: EdgeInsets.zero,
                                      elevation: 2,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            "Qty : ",
                                            style: TextStyle(
                                              color: Color(0xff515151),
                                              fontSize: 14,
                                              fontFamily: "Poppins",
                                              fontWeight: FontWeight.w300,
                                              letterSpacing: 0.30,
                                            ),
                                          ),
                                          DropdownButton(
                                              dropdownColor: Color(0xffF2F2F2),
                                              style: TextStyle(
                                                color: Color(0xff515151),
                                                fontSize: 14,
                                                fontFamily: "Poppins",
                                                fontWeight: FontWeight.w300,
                                                letterSpacing: 0.30,
                                              ),
                                              value: 0,
                                              elevation: 0,
                                              underline: Container(
                                                width: 0,
                                                height: 0,
                                              ),
                                              items: [
                                                DropdownMenuItem(
                                                  child: Text("-1"),
                                                  value: -1,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("2"),
                                                  value: 0,
                                                ),
                                                DropdownMenuItem(
                                                  child: Text("+1"),
                                                  value: 1,
                                                ),
                                              ],
                                              onChanged: (x) {
                                                print(x);
                                              }),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Expanded(
                                  child: Text(
                                    "\u20B9 877",
                                    //${data['price'].toString().substring(0, 4)}",
                                    maxLines: 1,
                                    style: TextStyle(
                                      fontSize: 15,
                                    ),
                                  ),
                                ),
                                // if ((data['previous_price']??0 )!=
                                //     0)
                                Expanded(
                                  child: Text(
                                    "\u20B9 3990",
                                    //${data['previous_price'].toString().substring(0, 4)}",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15,
                                        color: Color(0xffA9A9A9),
                                        decoration: TextDecoration.lineThrough),
                                  ),
                                ),
                                // if ((data['is_discount']??0) > 0)
                                Expanded(
                                  child: Text(
                                    "78% Off",
                                    //      "${data['whole_sell_discount']}% Off",
                                    maxLines: 1,
                                    style: TextStyle(
                                        fontSize: 15, color: Colors.red),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            "30 days easy return",
                            style: TextStyle(
                              color: Color(0xff999999),
                              fontSize: 10,
                              letterSpacing: 0.30,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(bottom: 10.0),
            child: Container(
              color: Colors.white,
              child: ListTile(
                leading: Container(
                    width: 25,
                    height: 25,
                    child: Image.asset("assets/freshTag.png")),
                title: Text(
                  "Apply Coupons",
                  style: TextStyle(
                    color: Color(0xff515151),
                    fontSize: 15,
                    letterSpacing: 0.45,
                  ),
                ),
                trailing: Icon(Icons.arrow_forward_ios),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Container(
              color: Colors.white,
              child: Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Price Details (2 Items)",
                      style: TextStyle(
                        color: Color(0xff515151),
                        fontSize: 15,
                        letterSpacing: 0.45,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Total MRP",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "\u20B9 1,754",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Discount on MRP",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "\u20B9 1,754",
                            style: TextStyle(
                              color: Color(0xff05B90D),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Coupon Discount",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "Apply Coupon",
                            style: TextStyle(
                              color: Color(0xffFF1D1D),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text(
                            "Handling Fee",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                          Text(
                            "\u20B9 1,754",
                            style: TextStyle(
                              color: Color(0xff7f7f7f),
                              fontSize: 14,
                              letterSpacing: 0.42,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Text("Total Amount", style: TextStyle(
                            color: Color(0xff515151),
                            fontSize: 15,
                            letterSpacing: 0.45,),),
                          Text("\u20B9 1,215", style: TextStyle(
                            color: Color(0xff515151),
                            fontSize: 14,
                            letterSpacing: 0.42,),),
                        ],
                      ),
                    ),

                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(600),
                  color: Color(0xffdc0f21),),
                child: Center(
                  child: Text("Place Order", style: TextStyle(
                    color: Colors.white, fontSize: 14,),),
                ), ),
          )
        ],
      ),
    );
  }
}
