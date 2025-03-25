import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class ReturnItemView extends StatefulWidget {
  final String orderNo, prodId, returnID;

  const ReturnItemView({Key key, this.returnID, this.orderNo, this.prodId})
      : super(key: key);

  @override
  _ReturnItemViewState createState() => _ReturnItemViewState();
}

class _ReturnItemViewState extends State<ReturnItemView> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    OrdersBloc _orderBloc = Provider.of<OrdersBloc>(context);

    return Material(
      color: Colors.white,
      child: isLoading
          ? Center(
              child: SpinKitFadingCircle(
              color: Color(0xffDC0F21),
            ))
          : FutureBuilder<Response>(
              future: _orderBloc.getReturnItemView(
                  widget.orderNo, widget.prodId, widget.returnID),
              builder: (c, snap) {
                if (snap?.data?.data == null)
                  return Material(
                    color: Colors.white,
                    child: Center(
                        child: SpinKitFadingCircle(
                      color: Color(0xffDC0F21),
                    )),
                  );
                else {

                  Map data = snap?.data?.data ?? {};
                  Map prods = data['return_products'] ?? {};
                  bool eligibleForCancel =
                      data['return_status'].toString() == "Requested";
                  Map pickupDetails = data['pickup_details'] ?? {};
                  Map billingAddress = data['billing_address'] ?? {};
                  return Scaffold(
                    body: ListView(
                      physics: BouncingScrollPhysics(),
                      shrinkWrap: true,
                      children: [
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("Return Id: ${data['return_id']}",style: TextStyle(
                            color: Colors.black,fontSize: 20,
                            fontFamily: goggleFont,
                            letterSpacing: 0.45,
                          ),),
                        ),
                        Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: RichText(
                              text: TextSpan(
                                  text: "Return Status",
                                  style: TextStyle(
                                    color: Colors.black,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: goggleFont,
                                    letterSpacing: 0.45,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: " ${data['return_status']}",
                                      style: TextStyle(
                                        color: data['return_status']
                                                .toString()
                                                .toLowerCase()
                                                .contains("returned")
                                            ? Colors.green
                                            : data['return_status']
                                                    .toString()
                                                    .toLowerCase()
                                                    .contains("cancel")
                                                ? Color(0xffdc0f21)
                                                : Color(0xfffaae00),
                                        fontWeight: FontWeight.normal,
                                        letterSpacing: 0.45,
                                      ),
                                    ),
                                  ]),
                              textAlign: TextAlign.center,
                            ),
                          ),
                        ),

                        ...prods.entries
                            .map((e) => productTile(
                                  e.key,
                                  e.value,
                                ))
                            .toList(),
                        if (eligibleForCancel)
                          Padding(
                            padding: const EdgeInsets.all(20.0),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(600),
                              onTap: () async {
                                showDialog(
                                    context: context,
                                    builder: (c) => AlertDialog(
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20),
                                          ),
                                          backgroundColor: Colors.white,
                                          title: Text("Are you sure?"),
                                          content: Text(
                                              "Are you sure you want to cancel this return request?"),
                                          actions: [
                                            FlatButton(
                                                onPressed: () async {
                                                  Navigator.pop(c);
                                                  setState(() {
                                                    isLoading = true;
                                                  });
                                                  await _orderBloc.cancelReturnOrder(returnStatus: "Return Canceled By User",returnId: data['return_id']);
                                                  setState(() {
                                                    isLoading = false;
                                                  });
                                                },
                                                child: Text(
                                                  "Yes",
                                                  style: TextStyle(
                                                      color: Color(0xffDC0F21)),
                                                )),
                                            FlatButton(
                                                onPressed: () {
                                                  Navigator.pop(c);
                                                },
                                                child: Text(
                                                  "No",
                                                  style: TextStyle(
                                                      color: Colors.black),
                                                )),
                                          ],
                                        ));
                              },
                              child: Container(
                                height: 50,
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(600),
                                  color: Color(0xffdc0f21),
                                ),
                                child: Center(
                                  child: Text(
                                    "Cancel Return",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 14,
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),



                        Theme(
                          data: ThemeData(
                            accentColor: Color(0xffDC0F21),
                            fontFamily: goggleFont,
                          ),
                          child: ExpansionTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: "Pickup",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: goggleFont,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Address",
                                        style: TextStyle(
                                          color: Color(0xffdc0f21),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            childrenPadding: EdgeInsets.only(left: 20),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name : ${pickupDetails['pickup_name']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email Id : ${pickupDetails['pickup_email']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Phone Number : ${pickupDetails['pickup_phone']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pickup Address : ${pickupDetails['pickup_address']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pickup City : ${pickupDetails['pickup_city']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pin Code : ${pickupDetails['pin_code']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Theme(
                          data: ThemeData(
                            accentColor: Color(0xffDC0F21),
                            fontFamily: goggleFont,
                          ),
                          child: ExpansionTile(
                            title: Align(
                              alignment: Alignment.centerLeft,
                              child: RichText(
                                text: TextSpan(
                                    text: "Billing",
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 15,
                                      fontFamily: goggleFont,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 0.45,
                                    ),
                                    children: [
                                      TextSpan(
                                        text: " Address",
                                        style: TextStyle(
                                          color: Color(0xffdc0f21),
                                          fontWeight: FontWeight.normal,
                                          fontSize: 15,
                                          letterSpacing: 0.45,
                                        ),
                                      ),
                                    ]),
                                textAlign: TextAlign.center,
                              ),
                            ),
                            childrenPadding: EdgeInsets.only(left: 20),
                            children: [
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Name: ${billingAddress['customer_name']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Email Id: ${billingAddress['customer_email']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Billing Number: ${billingAddress['customer_phone']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Billing Address: ${billingAddress['customer_address']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Billing City: ${billingAddress['customer_city']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerLeft,
                                child: Text(
                                  "Pin Code: ${billingAddress['customer_pincode']}",
                                  style: TextStyle(
                                    fontSize: 14,
                                    letterSpacing: 0.42,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                      ],
                    ),
                    backgroundColor: Colors.white,
                    appBar: AppBar(
                      elevation: 0,
                      leading: FlatButton(
                        child: Image.asset("assets/backArrow.png"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      titleSpacing: -10,
                      title: Text(
                        "Return Item View",
                        style: TextStyle(
                            color: Colors.black, fontFamily: goggleFont),
                      ),
                      backgroundColor: Colors.white,
                      iconTheme: IconThemeData(color: Colors.black),
                    ),
                  );
                }
              },
            ),
    );
  }

  Widget productTile(String key, Map details) {
    double newPrice = double.parse(details['price']?.toString());
    //TODO: ask ravjot to send currency value
    double currency = 68.95;

    return Padding(
      padding: const EdgeInsets.only(bottom: 5.0),
      child:  Container(
        height: 130,
        decoration: BoxDecoration(boxShadow: [
          BoxShadow(
              color: Colors.black12,
              blurRadius: .5,
              spreadRadius: .5,
              offset: Offset(0, 1))
        ], color: Colors.white),
        child: Row(
          children: [
            InkWell(
              onTap: () {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (c) => ItemPage(
                          itemSlug: details['item']['slug'],
                        )));
              },
              child: Container(
                height: double.maxFinite,
                width: MediaQuery.of(context).size.width / 2.4,
                child: Padding(
                  padding: const EdgeInsets.all(2.0),
                  child: Center(
                    child: Container(decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),border: Border.all(color: Colors.grey.shade300)
                    ),
                      child: Padding(
                        padding: const EdgeInsets.all(4.0),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(20),
                          child: CachedNetworkImage(
                            imageUrl:
                            "${Session.IMAGE_BASE_URL}/assets/images/products/${details['item']['photo']}",
                            fit: BoxFit.fitHeight,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 5),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Text(
                        "${details['item']['name']}",
                        maxLines: 2,
                        style: TextStyle(
                          color: Color(0xff515151),
                          fontSize: 14,
                          letterSpacing: 0.45,
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        if (details['size'].toString().length > 0)
                          Expanded(
                            flex: 0,
                            child: Text(
                              "Size : ${details['size']}",
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.30,
                              ),
                            ),
                          ),
                        Expanded(
                          flex: 0,
                          child: Padding(
                            padding: EdgeInsets.only(
                                left: (details['size'].toString().length > 0)
                                    ? 20.0
                                    : 0),
                            child: Text(
                              "Qty : ${details['qty']}",
                              style: TextStyle(
                                color: Color(0xff515151),
                                fontSize: 12,
                                fontWeight: FontWeight.w300,
                                letterSpacing: 0.30,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 5.0),
                        child: Text(
                          "\u20B9 ${(newPrice * currency).round()}",
                          maxLines: 1,
                          style: TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
