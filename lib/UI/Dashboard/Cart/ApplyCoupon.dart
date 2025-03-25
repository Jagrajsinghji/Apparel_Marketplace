import 'dart:ui';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/CartBloc.dart';
import 'package:provider/provider.dart';

class ApplyCoupon extends StatefulWidget {
  final String totalPrice;

  const ApplyCoupon({Key key, this.totalPrice}) : super(key: key);

  @override
  _ApplyCouponState createState() => _ApplyCouponState();
}

class _ApplyCouponState extends State<ApplyCoupon> {
  String coupon = "";
  bool invalidCoupon = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black26,
      body: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Container(
          color: Colors.transparent,
          child: Center(
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 2, sigmaY: 2),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20.0),
                child: Container(
                  decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20)),
                  child: ListView(
                    shrinkWrap: true,
                    physics: BouncingScrollPhysics(),
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 20.0),
                        child: Center(
                            child: Text(
                          "Please Enter Your Coupon Code",
                          style: TextStyle(fontSize: 16),
                        )),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20.0),
                        child: TextField(
                          onChanged: (c) => setState(() {
                            coupon = c;
                          }),
                          decoration: InputDecoration(
                            hintText: "Coupon Code",
                            focusedBorder: UnderlineInputBorder(
                                borderSide: BorderSide(
                              color: Color(0xffDC0F21),
                            )),
                          ),
                        ),
                      ),
                      if (invalidCoupon)
                        Padding(
                          padding: const EdgeInsets.only(top: 20.0),
                          child: Center(
                              child: Text(
                            "Invalid Code",
                            style: TextStyle(
                              fontSize: 16,
                              color: Color(0xffDC0F21),
                            ),
                          )),
                        ),
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Center(
                          child: RaisedButton(
                            color: Color(0xffDC0F21),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8)),
                            disabledColor: Color(0xffDC0F21).withOpacity(.5),
                            onPressed: coupon.trim().length == 0
                                ? null
                                : () async {
                                    Response resp = await Provider.of<CartBloc>(
                                            context,
                                            listen: false)
                                        .getCouponDetails(
                                            coupon, widget.totalPrice);
                                    print(resp.data);
                                    //I/flutter ( 9681): {final_amt: ₹2.71, coupon_code: COUPON15, coupon_amt: 0.48, coupon_id: 1, coupon_percent: 15%, value: 1}
                                    if (resp?.data is Map)
                                      Navigator.of(context).pop();
                                    else if (mounted)
                                      setState(() {
                                        invalidCoupon = true;
                                      });
                                  },
                            child: Text("Apply"),
                          ),
                        ),
                      )
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
