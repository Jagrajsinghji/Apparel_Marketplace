import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';

class DealsPage extends StatefulWidget {
  @override
  _DealsPageState createState() => _DealsPageState();
}

class _DealsPageState extends State<DealsPage> {
  List<String> banners = [
    "1.jpg",
    "2.jpg",
    "3.jpg",
    "4.jpg",
    "5.jpg",
    "6.jpg",
    "800X250.jpg"
  ];

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Color(0xffE5E5E5),
        body: ListView(
          physics: BouncingScrollPhysics(),
          shrinkWrap: true,
          children: [
            InkWell(
              onTap: () async {
                PickedFile file = await ImagePicker().getImage(
                  source: ImageSource.camera,
                );
                if (file != null) {
                  showDialog(
                      context: context,
                      child: AlertDialog(
                        title: Text("Your request is being processed by us."),
                        content: Text(
                            "Please wait! After processing your request your account will be credited with WOWFAS Points. "),
                      ));
                }
              },
              child: Padding(
                padding: const EdgeInsets.symmetric(vertical: 20),
                child: Container(
                  color: Colors.white,
                  height: 80,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Expanded(
                          flex: 0,
                          child: Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Icon(Icons.camera),
                          )),
                      Expanded(
                          flex: 1,
                          child: Text(
                            "Scan your bills\n&\nGet 10% upto \u20B9 100 ",
                            style: TextStyle(fontSize: 16),
                          ))
                    ],
                  ),
                ),
              ),
            ),
            ListView.builder(
              shrinkWrap: true,
              physics: NeverScrollableScrollPhysics(),
              itemCount: banners.length,
              itemBuilder: (BuildContext context, int index) {
                return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Image.asset(
                      "assets/DealsBanners/${banners.elementAt(index)}"),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}
