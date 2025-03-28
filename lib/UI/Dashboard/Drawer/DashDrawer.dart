import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/UI/Dashboard/Drawer/ShopByCat.dart';
import 'package:flutter_app/UI/Dashboard/Profile/EditProfile/EditProfile.dart';
import 'package:flutter_app/UI/SignInUp/MobileLogin.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class DashDrawer extends StatefulWidget {
  @override
  _DashDrawerState createState() => _DashDrawerState();
}

class _DashDrawerState extends State<DashDrawer> {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 220,
      color: Colors.white,
      padding: const EdgeInsets.only(
        bottom: 15,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: ListView(
              physics: BouncingScrollPhysics(),
              shrinkWrap: true,
              children: [
                Consumer<AuthBloc>(builder: (context, snapshot, w) {
                  bool loggedIn = snapshot.userData.length > 0;
                  String photoLink;
                  if (loggedIn) photoLink = snapshot.userData['photo'];
                  return Container(
                      width: double.infinity,
                      height: 120,
                      child: Stack(
                        children: [
                          Center(child: Image.asset("assets/logo.png")),
                          InkWell(
                            onTap: !loggedIn
                                ? () async {
                              await Navigator.push(context,
                                  PageRouteBuilder(opaque: false,barrierColor: Colors.black54,transitionDuration: Duration(milliseconds: 500),transitionsBuilder: (c,a,b,w){
                                    return SlideTransition(position: Tween(begin: Offset(0,1),end: Offset.zero).animate(CurvedAnimation(curve: Curves.fastLinearToSlowEaseIn,parent: a)),child: w,);
                                  },pageBuilder:  (c,a,b) => MobileLogin()));
                                    if (mounted) setState(() {});
                                  }
                                : () => Navigator.of(context).push(
                                    SlideLeftPageRouteBuilder(
                                        transitionDuration:
                                            Duration(milliseconds: 300),
                                        pageBuilder: (c, a, b) => EditProfile(
                                              profileData: snapshot.userData,
                                            ))),
                            child: Container(
                              color: Colors.black38,
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(10.0),
                                      child: Container(
                                          width: 60,
                                          height: 60,
                                          decoration: BoxDecoration(
                                              color: Colors.white,
                                              borderRadius:
                                                  BorderRadius.circular(15)),
                                          child: photoLink != null
                                              ? ClipRRect(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                  child: CachedNetworkImage(
                                                    imageUrl:
                                                        "${Session.BASE_URL}/assets/images/users/$photoLink",
                                                    fit: BoxFit.cover,
                                                    width: 200,
                                                    height: 200,
                                                  ),
                                                )
                                              : Transform.scale(
                                                  scale: .5,
                                                  child: Image.asset(
                                                    "assets/user.png",
                                                    height: 30,
                                                    width: 30,
                                                  ),
                                                )),
                                    ),
                                    Text(
                                      loggedIn
                                          ? "Hello ${snapshot.userData['name']}"
                                          : "Please Login",
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 14,
                                        fontWeight: FontWeight.w400,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ],
                      ));
                }),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    "Shop By",
                    style: TextStyle(
                        color: Colors.black45, fontWeight: FontWeight.w800),
                  ),
                ),
                ShopByCategory(),
                Container(
                  width: 260,
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(600),
                    color: Color(0xff5b5b5b),
                  ),
                ),
                ListTile(
                  leading: Image.asset(
                    "assets/cart.png",
                    height: 20,
                    width: 20,
                  ),
                  title: Text(
                    "My Orders",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  onTap: () {
                    Navigator.pop(context);
                    Navigator.pushNamed(context, "Orders");
                  },
                ),
                ListTile(
                  leading: Icon(Icons.chat_outlined),
                  onTap: () async {
                    String url = "http://tickets.example.com/help-center";
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, "HelpCenter");
                  },
                  title: Text(
                    "Contact Us",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.book_outlined),
                  onTap: () async {
                    String url = "https://example.com/page/terms-and-conditions";
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, "HelpCenter");
                  },
                  title: Text(
                    "Terms of Use",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                ListTile(
                  leading: Icon(Icons.privacy_tip_outlined),
                  onTap: () async {
                    String url = "https://example.com/page/privacy-policy";
                    if (await canLaunch(url)) {
                      await launch(url);
                    }
                    Navigator.pop(context);
                    // Navigator.pushNamed(context, "HelpCenter");
                  },
                  title: Text(
                    "Privacy Policy",
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              "Version $versionName",
              style: TextStyle(
                color: Color(0xff9d9d9d),
                fontSize: 14,
                fontWeight: FontWeight.w400,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
