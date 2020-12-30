import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/UI/SignInUp/SignIn.dart';

class Profile extends StatefulWidget {
  @override
  _ProfileState createState() => _ProfileState();
}

class _ProfileState extends State<Profile> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      body: StreamBuilder<User>(
          stream: FirebaseAuth.instance.authStateChanges(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting)
              return Center(
                  child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation(Color(0xffdc0f21)),
              ));
            if (snapshot.data == null)
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
                            MaterialPageRoute(builder: (c) => SignIn()));
                        if (mounted) setState(() {});
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
              return ListView(
                  physics: BouncingScrollPhysics(),
                  shrinkWrap: true,
                  children: [
                    Container(
                        width: double.infinity,
                        height: 120,
                        color: Color(0xff303847),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.start,
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
                                    child: Transform.scale(
                                      scale: .5,
                                      child: Image.asset(
                                        "assets/user.png",
                                        height: 30,
                                        width: 30,
                                      ),
                                    )),
                              ),
                              Text(
                                "Hello, ${snapshot.data?.displayName ?? snapshot.data.email.split("@").first}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ),
                        )),
                    SizedBox(height: 40.23),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "Orders");
                      },
                      title: Text(
                        "Orders",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        "Check your order status",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        Navigator.pushNamed(context, "HelpCenter");
                      },
                      title: Text(
                        "Help Center",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        "Help regarding your recent purchases",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Wishlist",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        "Your most loved style",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Saved Cards",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        "Save your card for faster checkout",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      title: Text(
                        "Coupons",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        "Manage Coupons for additional discounts",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 10,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                    ),
                    ListTile(
                      onTap: () {
                        FirebaseAuth.instance.signOut();
                        if (mounted) setState(() {});
                      },
                      title: Text(
                        "LogOut",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      subtitle: Text(
                        "LogOut your account from this device.",
                        style: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 10,
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
