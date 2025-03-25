import 'package:flutter/material.dart';

class SliderDots extends StatefulWidget {
  final length;
  final PageController pageController;

  const SliderDots({Key key, this.pageController, this.length})
      : super(key: key);

  @override
  _SliderDotsState createState() => _SliderDotsState();
}

class _SliderDotsState extends State<SliderDots> {
  int page = 0;
  VoidCallback callback;

  @override
  void initState() {
    super.initState();
    callback = () {
      setState(() {
        page = widget.pageController.page.round();
      });
    };
    widget.pageController.addListener(callback);
  }

  @override
  void dispose() {
    widget.pageController.removeListener(callback);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Container(
        height: 20,
        child: ListView.builder(
          scrollDirection: Axis.horizontal,
          itemBuilder: (c, i) {
            if (page == i)
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                      color: Colors.black, shape: BoxShape.circle),
                ),
              );
            else
              return Padding(
                padding: const EdgeInsets.all(2.0),
                child: Container(
                  height: 6,
                  width: 6,
                  decoration: BoxDecoration(
                      border: Border.all(
                        color: Colors.black,
                      ),
                      shape: BoxShape.circle),
                ),
              );
          },
          itemCount: (widget.length) + 1,
          shrinkWrap: true,
        ),
      ),
    );
  }
}
