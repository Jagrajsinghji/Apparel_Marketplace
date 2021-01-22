import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ScreenBloc.dart';
import 'package:provider/provider.dart';

_bottomNav(BuildContext context, {VoidCallback voidCallback}) {
  ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
  return Container(
    height: 50,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 35.0),
            child: InkWell(
              onTap: () {
                screenBloc.setPage(0);
                voidCallback();
              },
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                        flex: 0,
                        child: Image.asset("assets/wowIcon.png",
                            height: 40, width: 40)),
                    // Expanded(flex: 0,child: Text("Home"))
                  ],
                ),
              ),
            ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(right: 20),
          //   child: InkWell(
          //     onTap: () {
          //       screenBloc.setPage(1);
          //       voidCallback();
          //     },
          //     child: Container(
          //       width: 60,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //             flex: 0,
          //             child: Padding(
          //               padding: const EdgeInsets.only(top: 10),
          //               child: Image.asset(
          //                 "assets/shirtIcon.png",
          //                 height: 25,
          //                 width: 25,
          //               ),
          //             ),
          //           ),
          //           Expanded(flex: 0,child: Text("Fashion"))
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 20.0),
          //   child: InkWell(
          //     onTap: () {
          //       screenBloc.setPage(3);
          //       voidCallback();
          //     },
          //     child: Container(
          //       width: 60,
          //       child: Column(
          //         mainAxisAlignment: MainAxisAlignment.spaceBetween,
          //         children: [
          //           Expanded(
          //             flex: 0,
          //             child: Padding(
          //               padding: const EdgeInsets.only(top: 8),
          //               child: Image.asset("assets/explore.png",
          //                   height: 27, width: 27),
          //             ),
          //           ),
          //           Expanded(flex: 0,child: Text("Explore"))
          //         ],
          //       ),
          //     ),
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.only(right: 35.0),
            child: InkWell(
              onTap: () {
                screenBloc.setPage(4);
                voidCallback();
              },
              child: Container(
                width: 60,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      flex: 0,
                      child: Padding(
                        padding: const EdgeInsets.only(top: 10),
                        child: Image.asset(
                          "assets/user.png",
                          height: 22,
                          width: 22,
                        ),
                      ),
                    ),
                    // Expanded(flex: 0,child: Text("Profile"))
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    ),
  );
}

bottomNavigation(BuildContext context, {VoidCallback voidCallback}) {
  return BottomAppBar(
    child: _bottomNav(context, voidCallback: voidCallback ?? () {}),
    shape: CircularNotchedRectangle(),
    elevation: 2,
    color: Colors.white,
  );
}

floatingActionButton(BuildContext context, {VoidCallback voidCallback}) {
  ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
  return Container(
    height: 70,
    width: 70,
    decoration: BoxDecoration(
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade400, width: 2)),
    child: Stack(
      children: [
        Center(
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: FloatingActionButton(
              heroTag: null,
              backgroundColor: Color(0xff005294),
              onPressed: () {
                screenBloc.setPage(2);
                voidCallback();
              },
              child: Text(
                "Deals",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
      ],
    ),
  );
}
