// import 'package:flutter/material.dart';
// import 'package:fluttertoast/fluttertoast.dart';
// import 'package:razorpay_flutter/razorpay_flutter.dart';
//
// class RazorPayBloc with ChangeNotifier {
//   Razorpay razorPay;
//   final TEST_KEY = 'rzp_test_xDH74d48cwl8DF';
//   final LIVE_KEY = 'cr0H1BiQ20hVzhpHfHuNbGri';
//
//   RazorPayBloc() {
//     initRazorPay();
//   }
//
//   initRazorPay() {
//     razorPay = Razorpay();
//     razorPay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
//     razorPay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
//     razorPay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
//   }
//
//
//
//   @override
//   void dispose() {
//     razorPay?.clear();
//     super.dispose();
//   }
// }
//
