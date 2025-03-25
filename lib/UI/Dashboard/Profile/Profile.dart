import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/UI/Dashboard/Profile/EditProfile/EditProfile.dart';
import 'package:flutter_app/UI/SignInUp/MobileLogin.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:flutter_app/Utils/PageRouteBuilders.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class Profile extends StatefulWidget {
  const Profile({Key key}):super(key: key);
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: isLoading
          ? SpinKitFadingCircle(
              color: Color(0xffDC0F21),
            )
          : Consumer<AuthBloc>(builder: (_, snapshot, w) {
              // if (snapshot.connectionState == ConnectionState.waiting)
              //   return Center(
              //       child: CircularProgressIndicator(
              //     valueColor: AlwaysStoppedAnimation(Color(0xffdc0f21)),
              //   ));
              if (snapshot.userData.length == 0)
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Hey, it feels so empty",
                      style: TextStyle(
                        color: Color(0xff5b5b5b),
                        fontSize: 20,
                      ),
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Center(
                      child: InkWell(
                        borderRadius: BorderRadius.circular(600),
                        onTap: () async {

                          await Navigator.push(context,
                              PageRouteBuilder(opaque: false,barrierColor: Colors.black54,reverseTransitionDuration: Duration(milliseconds: 100),transitionDuration: Duration(milliseconds: 500),transitionsBuilder: (c,a,b,w){
                                return SlideTransition(position: Tween(begin: Offset(0,1),end: Offset.zero).animate(CurvedAnimation(curve: Curves.fastLinearToSlowEaseIn,parent: a)),child: w,);
                              },pageBuilder:  (c,a,b) => MobileLogin()));
                        },
                        child: Container(
                          width: 186,
                          height: 58,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(600),
                            border: Border.all(
                              color: Color(0xffdc0f21),
                              width: 2,
                            ),
                            color: Colors.white,
                          ),
                          child: Center(
                            child: Text(
                              "Log In Now",
                              style: TextStyle(
                                color: Color(0xffdc0f21),
                                fontSize: 14,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              else {
                String photoLink = snapshot.userData['photo'];
                return ListView(
                    physics: BouncingScrollPhysics(),
                    shrinkWrap: true,
                    children: [
                      InkWell(
                        onTap: () {
                          Navigator.of(context).push(SlideLeftPageRouteBuilder(
                              pageBuilder: (c, a, b) => EditProfile(
                                    profileData: snapshot.userData,
                                  )));
                        },
                        child: Stack(
                          children: [
                            Center(child: Image.asset("assets/logo.png")),
                            Container(
                                width: double.infinity,
                                height: 120,
                                color: Colors.black38,
                                child: Padding(
                                  padding: const EdgeInsets.only(left: 20.0),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
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
                                                        BorderRadius.circular(
                                                            15),
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
                                        "Hello, ${snapshot.userData['name'] ?? ""}",
                                        style: TextStyle(
                                          color: Colors.white,
                                          fontSize: 14,
                                          fontWeight: FontWeight.w400,
                                        ),
                                      ),
                                    ],
                                  ),
                                )),
                          ],
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "Orders");
                        },
                        title: Text(
                          "Orders",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "Check your order status",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () {
                          Navigator.pushNamed(context, "Returns");
                        },
                        title: Text(
                          "Return Items",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "Check your returns status",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          String url = "http://tickets.example.com/help-center";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        title: Text(
                          "Help Center",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "Help regarding your recent purchases",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          String url = "https://example.com/page/privacy-policy";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        title: Text(
                          "Privacy Policy",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "Have a look at our privacy policies",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      ListTile(
                        onTap: () async {
                          String url =
                              "https://example.com/page/terms-and-conditions";
                          if (await canLaunch(url)) {
                            await launch(url);
                          }
                        },
                        title: Text(
                          "Terms & Conditions",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "Have you seen Our T&Cs ?",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                      // ListTile(
                      //   title: Text(
                      //     "Coupons",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 16,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      //   subtitle: Text(
                      //     "Manage Coupons for additional discounts",
                      //     style: TextStyle(
                      //       color: Colors.black,
                      //       fontSize: 12,
                      //       fontWeight: FontWeight.w400,
                      //     ),
                      //   ),
                      // ),
                      ListTile(
                        onTap: () async {
                          if (mounted)
                            setState(() {
                              isLoading = true;
                            });
                          await snapshot
                              .logOut();
                          refreshBlocs(context,logInOutRefresh: true);
                          if (mounted)
                            setState(() {
                              isLoading = false;
                            });
                        },
                        title: Text(
                          "LogOut",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                        subtitle: Text(
                          "LogOut your account from this device.",
                          style: TextStyle(
                            color: Colors.black,
                            fontSize: 12,
                            fontWeight: FontWeight.w400,
                          ),
                        ),
                      ),
                    ]);
              }
            }),
    );
  }
}
