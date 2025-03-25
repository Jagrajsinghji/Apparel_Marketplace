import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';

class UploadBillImage extends StatefulWidget {
  final File image;

  const UploadBillImage({Key key, this.image}) : super(key: key);

  @override
  _UploadBillImageState createState() => _UploadBillImageState();
}

class _UploadBillImageState extends State<UploadBillImage> {
  GlobalKey<FormFieldState> _amtKey = GlobalKey();
  String totalAmount;
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        resizeToAvoidBottomPadding: false,
        backgroundColor: Colors.white,
        body: isLoading
            ? Center(
                child: SpinKitFadingCircle(
                color: Color(0xffDC0F21),
              ))
            : Stack(
                children: [
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.only(top: 100.0),
                      child: Image.file(
                        widget.image,
                      ),
                    ),
                  ),
                  Container(
                    height: 100,
                    color: Colors.white,
                    child: Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 27),
                        child: TextFormField(
                          key: _amtKey,
                          validator: (c) {
                            if (c.trim().length == 0)
                              return "Please Enter Bill Amount";
                            return null;
                          },
                          onChanged: (c) =>
                              setState(() => totalAmount = c.trim()),
                          decoration: InputDecoration(
                            filled: true,
                            suffixIcon: FlatButton(
                              child: Text("Submit"),
                              onPressed: totalAmount == null
                                  ? null
                                  : () {
                                      AuthBloc bloc =
                                          Provider.of(context, listen: false);
                                      String id =
                                          bloc.userData['user_id'].toString();
                                      String fileName =
                                          widget.image?.path?.split('/')?.last;
                                      if (mounted)
                                        setState(() {
                                          isLoading = true;
                                        });
                                      UploadTask task = FirebaseStorage.instance
                                          .ref()
                                          .child("Bills/$id/$fileName")
                                          .putFile(widget.image);
                                      task.whenComplete(() async{
                                        await showDialog(
                                            context: context,
                                            child: AlertDialog(
                                              title: Text(
                                                  "Your request is being processed by us."),
                                              content: Text(
                                                  "Allow us 4 hours for the validation of your data."),
                                            ));
                                        Navigator.popUntil(context, (route) => route.isFirst);
                                      });

                                    },
                            ),
                            fillColor: Colors.white,
                            isDense: true,
                            contentPadding: EdgeInsets.all(16),
                            enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide(color: Colors.black)),
                            focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(100),
                                borderSide: BorderSide(color: Colors.black)),
                            errorBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: Color(0xffDC0F21).withOpacity(.5)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            focusedErrorBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: Color(0xffDC0F21)),
                              borderRadius: BorderRadius.circular(100),
                            ),
                            hintText: "Enter Bill Amount",
                            hintStyle: TextStyle(
                              color: Color(0xff9d9d9d),
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          style: TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
