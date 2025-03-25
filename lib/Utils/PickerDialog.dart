import 'package:flutter/material.dart';

class PickerDialog extends StatelessWidget {
  final Function openCamera, openGallery;

  const PickerDialog({Key key, this.openCamera, this.openGallery})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: () {
          Navigator.pop(context);
        },
        child: Scaffold(
          backgroundColor: Colors.black45,
          body: Center(
            child: InkWell(
              onTap: () {},
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                width: 300,
                child: GridView(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2),
                  children: <Widget>[
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openCamera();
                      },
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.camera,
                            color: Colors.grey,
                            size: 35.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Take a\nPicture',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0)),
                          ),
                        ],
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        openGallery();
                      },
                      child: Column(crossAxisAlignment: CrossAxisAlignment.center,mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Icon(
                            Icons.photo_library,
                            color: Colors.grey,
                            size: 35.0,
                          ),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Select Picture from Gallery',
                                textAlign: TextAlign.center,
                                style: TextStyle(fontSize: 16.0)),
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
      ),
    );
  }
}
