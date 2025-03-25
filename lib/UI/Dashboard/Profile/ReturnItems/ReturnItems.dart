import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/OrdersBloc.dart';
import 'package:flutter_app/UI/Dashboard/Item/ItemPage.dart';
import 'package:flutter_app/UI/Dashboard/Profile/Orders/OrderDetails.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';
import 'ReturnItemView.dart';

class ReturnItems extends StatefulWidget {
  @override
  _ReturnItemsState createState() => _ReturnItemsState();
}

class _ReturnItemsState extends State<ReturnItems> {
  @override
  Widget build(BuildContext context) {
    OrdersBloc _orderBloc = Provider.of<OrdersBloc>(context);
    return Scaffold( appBar: AppBar(
      elevation: 0,
      leading: FlatButton(
        child: Image.asset("assets/backArrow.png"),
        onPressed: () {
          Navigator.of(context).pop();
        },
      ),
      title: Text(
        "My Returns",
        style: TextStyle(color: Colors.black, fontFamily: goggleFont),
      ),
      backgroundColor: Colors.white,
      iconTheme: IconThemeData(color: Colors.black),
    ),
      backgroundColor: Colors.white,
      body: _orderBloc.returnItems.length==0?Center(child: Text("No Return Items"),):Scrollbar(
        radius: Radius.circular(20),
        child: ListView.builder(
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            itemCount: _orderBloc.returnItems.length,
            itemBuilder: (c, i) {
              Map _data = _orderBloc.returnItems.elementAt(i);

              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 5),
                  child: InkWell(
                    onTap: () {
                      Navigator.of(context).push(
                          SlideLeftPageRouteBuilder(
                              pageBuilder: (c, a, b) =>
                                  ReturnItemView(
                                    orderNo:  _data['order_number'].toString(),
                                    prodId: _data['product_id'].toString(),
                                    returnID: _data['return_id'].toString() ,
                                  )));
                    },
                    child: Container(
                      height: 140,
                      decoration: BoxDecoration(
                          color: Colors.white38,
                          border: Border.all(color: Colors.grey.shade300),
                          borderRadius: BorderRadius.circular(10)),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          Expanded(
                            flex: 0,
                            child: Container(
                              width: MediaQuery.of(context).size.width / 3,
                              child:      Padding(
                                padding: const EdgeInsets.all(2.0),
                                child: Container(
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),border: Border.all(color: Colors.grey.shade300)
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(4.0),
                                    child: ClipRRect(
                                      borderRadius:
                                      BorderRadius.circular(10),
                                      child: CachedNetworkImage(
                                        imageUrl:
                                        "${Session.IMAGE_BASE_URL}/assets/images/products/${_data['product_image']}",
                                        fit: BoxFit.fill,
                                        height: 140,
                                        width:
                                        MediaQuery.of(context)
                                            .size
                                            .width /
                                            3,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                          Expanded(
                              flex: 1,
                              child: Padding(
                                padding: const EdgeInsets.only(
                                    left: 10.0, top: 5, bottom: 5),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Text(
                                      "${_data['name']}",
                                      maxLines: 2,
                                      style: TextStyle(fontSize: 16),
                                    ),
                                    RichText(
                                      text: TextSpan(
                                          text: "Return Status",
                                          style: TextStyle(
                                            color: Colors.black,
                                            fontFamily: goggleFont,
                                            fontSize: 12,
                                            letterSpacing: 0.45,
                                          ),
                                          children: [
                                            TextSpan(
                                              text: " ${_data['return_status']}",
                                              style: TextStyle(
                                                color: _data['return_status']
                                                        .toString()
                                                        .toLowerCase()
                                                        .contains("returned")
                                                    ? Colors.green
                                                    : _data['return_status']
                                                            .toString()
                                                            .toLowerCase()
                                                            .contains("cancel")
                                                        ? Color(0xffdc0f21)
                                                        : Color(0xfffaae00),
                                                letterSpacing: 0.45,
                                              ),
                                            ),
                                          ]),
                                      textAlign: TextAlign.center,
                                    ),
                                    Text(
                                      "Return Date : ${_data['return_date']}",
                                      style: TextStyle(fontSize: 12),
                                    ),
                                    InkWell(onTap: (){
                                      Navigator.of(context).push(
                                          SlideLeftPageRouteBuilder(
                                              pageBuilder: (c, a, b) =>
                                                  OrderDetails(
                                                    orderId: _data['order_id'],
                                                  )));
                                    },
                                      child: Container(
                                        child: Align(alignment: Alignment.centerLeft,
                                          child: Text(
                                            "View Order",
                                            style: TextStyle(fontSize: 14),
                                          ),
                                        ),
                                      ),
                                    ),

                                  ],
                                ),
                              )),
                          Expanded(
                            flex: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: Align(
                                  alignment: Alignment.centerRight,
                                  child: Icon(Icons.arrow_forward_ios_rounded)),
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                ),
              );
            }),
      ),
    );
  }
}
