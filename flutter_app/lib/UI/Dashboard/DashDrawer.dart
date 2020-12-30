import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:provider/provider.dart';

import 'Category/CategoriesPage.dart';

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
                Consumer<AuthBloc>(
                    builder: (context, snapshot,w) {
                      return Container(
                          width: double.infinity,
                          height: 120,
                          color: Color(0xff303847),
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
                                "Hello ${snapshot?.userData??""}",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                            ],
                          ));
                    }),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pushNamedAndRemoveUntil(
                          context, Session.BASE_URL, (p) => false);
                    },
                    child: Text(
                      "Home",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CategoriesPage(
                                categoryName: null,
                              )));
                    },
                    child: Text(
                      "Fashion",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CategoriesPage(
                                categoryName: null,
                              )));
                    },
                    child: Text(
                      "Apparel",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Top Brands",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CategoriesPage(
                                categoryName: "Men",
                              )));
                    },
                    child: Text(
                      "Men",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CategoriesPage(
                                categoryName: "Women",
                              )));
                    },
                    child: Text(
                      "Women",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CategoriesPage(
                                categoryName: "kids",
                              )));
                    },
                    child: Text(
                      "Kids",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (c) => CategoriesPage(
                                categoryName: null,
                              )));
                    },
                    child: Text(
                      "Toddlers",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Container(
                  width: 260,
                  height: 1,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(600),
                    color: Color(0xff5b5b5b),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "Orders");
                    },
                    child: Text(
                      "Your Orders",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Settings",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "FAQs",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                      Navigator.pushNamed(context, "HelpCenter");
                    },
                    child: Text(
                      "Contact Us",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "About Us",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Terms of Use",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 22.33),
                Padding(
                  padding: const EdgeInsets.only(left: 80.0),
                  child: InkWell(
                    onTap: () {
                      Navigator.pop(context);
                    },
                    child: Text(
                      "Privacy Policy",
                      style: TextStyle(
                        color: Color(0xff9d9d9d),
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 0,
            child: Text(
              "Version 0.0.1",
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
