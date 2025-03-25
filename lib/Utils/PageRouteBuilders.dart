import 'package:flutter/cupertino.dart';

class SlideLeftPageRouteBuilder extends PageRouteBuilder {
  SlideLeftPageRouteBuilder({
    RouteSettings settings,
    RoutePageBuilder pageBuilder,

    Duration transitionDuration = const Duration(milliseconds: 500),
    Duration reverseTransitionDuration = const Duration(milliseconds: 500),
    bool opaque = true,
    bool barrierDismissible = false,
    Color barrierColor,
    String barrierLabel,
    bool maintainState = true,
    bool fullscreenDialog = false,
  }) : super(
            pageBuilder: pageBuilder,
            opaque: opaque,
            transitionsBuilder: (c,a,b,w){
              return SlideTransition(position: Tween(begin: Offset(1,0),end: Offset.zero).animate(a),child: w,);
            },
            barrierColor: barrierColor,
            barrierDismissible: barrierDismissible,
            fullscreenDialog: fullscreenDialog,
            reverseTransitionDuration: reverseTransitionDuration,
            transitionDuration: transitionDuration,
            barrierLabel: barrierLabel,
            maintainState: maintainState,
            settings: settings);
}
