import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/ScreenBloc.dart';
import 'package:provider/provider.dart';

_bottomNav(BuildContext context, {VoidCallback voidCallback}) {
  ScreenBloc screenBloc = Provider.of<ScreenBloc>(context);
  int page = screenBloc.page;
  Alignment align =page==0? Alignment.bottomLeft:page==2?Alignment.bottomCenter:Alignment.bottomRight;
  return Container(
    height: 50,color: Colors.transparent,
    child: Padding(
      padding: const EdgeInsets.only(bottom: 5),
      child: Stack(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 35.0),
                child: InkWell(
                  onTap: () {
                    screenBloc.setPage(0);
                    voidCallback();
                  },borderRadius: BorderRadius.circular(200),
                  child: Container(width: 50,height: 50,
                      child: Center(
                        child: Image.asset("assets/wowIcon.png",
                            height: page==0?40:30, width:page==0? 40:30),
                      ),),
                ),
              ),

              Padding(
                padding: const EdgeInsets.only(right: 35.0),
                child: InkWell(
                  onTap: () {
                    screenBloc.setPage(4);
                    voidCallback();
                  },borderRadius: BorderRadius.circular(200),
                  child: Container(
                    height: 50,
                    width: 50,
                    child: Center(
                      child: Image.asset(
                        "assets/user.png",
                        height: page == 4 ? 25 : 20,
                        width: page == 4 ? 25 : 20,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),

          AnimatedAlign(alignment: align,duration: Duration(seconds: 1,milliseconds: 500),
            curve: Curves.fastLinearToSlowEaseIn,
            child: Padding(
              padding: const EdgeInsets.only(left: 45.0,right: 45.0),
              child: Container(
                decoration: BoxDecoration(
                    color: Colors.grey.shade400,
                    borderRadius: BorderRadius.circular(20)),
                height: 1.5,
                width: 30,
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
    color: Color(0xff005294),
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
    child: Center(
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
  );
}
