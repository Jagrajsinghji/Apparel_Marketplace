import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/Session.dart';

class ViewProfileImage extends StatelessWidget {
  final String imageUrl;
  final File file;

  const ViewProfileImage({Key key, this.imageUrl, this.file}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Profile Picture",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 18,fontFamily: goggleFont
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Hero(
            tag: "ProfilePic",
            child: Material(
              color: Colors.transparent,
              child: Center(
                child: file != null
                    ? Image.file(file)
                    : CachedNetworkImage(
                        imageUrl:
                            "${Session.BASE_URL}/assets/images/users/$imageUrl",
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
