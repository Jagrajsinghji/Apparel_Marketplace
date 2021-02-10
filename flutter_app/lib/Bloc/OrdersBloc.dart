import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/DioInterceptors.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OrdersBloc with ChangeNotifier {
  List myOrders = [];
  DioInterceptor _dioInterceptor = DioInterceptor.getInstance();
  List returnItems = [];

  OrdersBloc() {
    getMyOrders();
    getReturnItems();
  }

  Future<Response> getMyOrders() async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("/api/user/orders",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);

      if (response?.data is List)
        myOrders = response?.data ?? [];
      else
        myOrders = [];
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      myOrders = [];
      notifyListeners();
      return null;
    }
  }

  Future<Response> getOrderDetails(int id) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get("/api/user/order/$id",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);

    return response;
  }

  Future<Response> cancelOrder(String id) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get("/api/user/cancel-this-order/$id/1",
        options: Options(headers: {"Authorization": "Bearer $token"}));
    await Session.instance.updateCookie(response);
    notifyListeners();
    return response;
  }

  Future<Response> returnOrder(
      {String returnId,
      String returnStatus,
      Map<String, dynamic> formData}) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.post(
      "/api/user/return-item-status-update/$returnId/$returnStatus",
      data: FormData.fromMap(formData),
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    await Session.instance.updateCookie(response);
    await getReturnItems();
    notifyListeners();
    return response;
  }

  Future<Response> getReturnItems() async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get("/api/user/return-orders",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);

      if (response.data is List)
        returnItems = []..addAll(response.data);
      else
        returnItems = [];
      notifyListeners();
      return response;
    } catch (err) {
      print(err);
      returnItems = [];
      notifyListeners();
      return null;
    }
  }

  Future<Response> getReturnItemView(
      String orderNumber, String productId, String returnId) async {
    try {
      Dio dio = Dio(Session.instance.baseOptions);
      dio.interceptors.add(_dioInterceptor);
      String token = await Session.instance.getToken();
      Response response = await dio.get(
          "/api/user/return-item-view/$orderNumber/$productId/$returnId",
          options: Options(headers: {"Authorization": "Bearer $token"}));
      await Session.instance.updateCookie(response);
      return response;
    } catch (err) {
      print(err);
      return null;
    }
  }

  Future<Response> cancelReturnOrder({
    String returnId,
    String returnStatus,
  }) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.post(
      "/api/user/return-item-status-update/$returnId/$returnStatus",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    await Session.instance.updateCookie(response);

    await getReturnItems();
    notifyListeners();
    return response;
  }

  Future<void> printOrder({
    String id,
  }) async {
    Dio dio = Dio(Session.instance.baseOptions);
    dio.interceptors.add(_dioInterceptor);
    String token = await Session.instance.getToken();
    Response response = await dio.get(
      "/api/user/print/order/print/$id",
      options: Options(
        headers: {"Authorization": "Bearer $token"},
      ),
    );
    print(response.data);
    await Session.instance.updateCookie(response);

    if (response?.data != null && response.data is Map) {
      final doc = pw.Document();
      Map data = response?.data ?? {};
      Map billingAddress = data['billing_address'] ?? {};
      Map shippingAddress = data['shipping_address'] ?? {};
      Map cart = data['cart'] ?? {};
      doc.addPage(pw.Page(
          pageFormat: PdfPageFormat.a4,
          build: (pw.Context context) {
            return pw.ListView(children: [
              pw.Align(
                alignment: pw.Alignment.topLeft,
                child: pw.Text(
                    "ORDER#${data["order_details"]['order_number']}[${data["order_details"]['order_status']}]"),
              ),
              pw.SizedBox(height: 20),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Column(children: [
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text("Billing Address:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Name: ${billingAddress['customer_name']}",
                        ),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Email Id: ${billingAddress['customer_email']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Billing Number: ${billingAddress['customer_phone']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Billing Address: ${billingAddress['customer_address']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Billing City: ${billingAddress['customer_city']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Pin Code: ${billingAddress['customer_pincode']}",
                      ),
                    ),
                  ]),
                  pw.Column(children: [
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text("Shipping Address:",
                          style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Align(
                        alignment: pw.Alignment.centerLeft,
                        child: pw.Text(
                          "Name : ${shippingAddress['shipping_name']}",
                        ),
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Email Id : ${shippingAddress['shipping_email']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Phone Number : ${shippingAddress['shipping_phone']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Shipping Address : ${shippingAddress['shipping_address']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Shipping City : ${shippingAddress['shipping_city']}",
                      ),
                    ),
                    pw.Align(
                      alignment: pw.Alignment.centerLeft,
                      child: pw.Text(
                        "Pin Code : ${shippingAddress['pin_code']}",
                      ),
                    ),
                  ])
                ])
              ]),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text("Payment Information:",
                    style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "Payment Method : ${data['order_details']['payment_method']}",
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "Shipping Fee : Rs.${data['order_details']['shipping_cost']}",
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "Packaging Fee : Rs.${data['order_details']['packaging_cost']}",
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "Total : Rs.${data['order_details']['total']}",
                ),
              ),
              pw.Align(
                alignment: pw.Alignment.centerLeft,
                child: pw.Text(
                  "Payment Status : ${data['order_details']['payment_status']}",
                ),
              ),
              pw.Text("Ordered Products",
                  style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
              pw.Table(children: [
                pw.TableRow(children: [
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text("ID"),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text("Name"),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text("Details"),
                  ),
                  pw.Padding(
                    padding: pw.EdgeInsets.all(5),
                    child: pw.Text("Price"),
                  )
                ]),
                ...cart.entries.map((e) {
                  return pw.TableRow(children: [
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text("${e.key}"),
                    ),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text("${e.value['item']['name']}"),
                    ),
                    pw.Padding(
                        padding: pw.EdgeInsets.all(5),
                        child: pw.Text(
                            "Size: ${e.value['size']}\nQty: ${e.value['size_qty']}")),
                    pw.Padding(
                      padding: pw.EdgeInsets.all(5),
                      child: pw.Text("Rs.${(e.value['price'] * 68.5).round()}"),
                    ),
                  ]);
                }).toList()
              ]),
            ]); // order_status
          })); // Page
      Directory dir = await getApplicationDocumentsDirectory();
      String fileName =
          "Order_Details${response.data['order_details']['order_number']}.pdf";

      String path = "${dir.path}/OrderDetials/$fileName";
      File pdf = await File(path).create(recursive: true);
      pdf.open(mode: FileMode.write);
      await pdf.writeAsBytes(await doc.save());
      OpenFile.open(
        path,
      );
    }
  }
}
