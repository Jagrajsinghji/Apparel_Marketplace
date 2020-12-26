import 'package:flutter/material.dart';

class AddAddress extends StatefulWidget {
  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffE5E5E5),
      appBar: AppBar(
        elevation: 0,
        leading: FlatButton(
          child: Image.asset("assets/backArrow.png"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        backgroundColor: Colors.white,
        title: Text(
          "Add New Address",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 18,
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: ListView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10.0),
            child: Text(
              "Contact Details",
              style: TextStyle(
                color: Color(0xff515151),
                fontSize: 15,
                letterSpacing: 0.45,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Name*",
                        hintStyle: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Mobile No.*",
                        hintStyle: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10.0),
            child: Text(
              "Address",
              style: TextStyle(
                color: Color(0xff515151),
                fontSize: 15,
                letterSpacing: 0.45,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Pin Code*",
                        hintStyle: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Address (house no, building, street, ares)*",
                        hintStyle: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      decoration: InputDecoration(
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(5),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                        hintText: "Locality / Town*",
                        hintStyle: TextStyle(
                          color: Color(0xff9d9d9d),
                          fontSize: 14,
                          fontFamily: "Poppins",
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontFamily: "Poppins",
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              hintText: "City / District*",
                              hintStyle: TextStyle(
                                color: Color(0xff9d9d9d),
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            decoration: InputDecoration(
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(5),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
                              errorBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(5),
                              ),
                              hintText: "State*",
                              hintStyle: TextStyle(
                                color: Color(0xff9d9d9d),
                                fontSize: 14,
                                fontFamily: "Poppins",
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontFamily: "Poppins",
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10.0),
            child: Text(
              "Save Address as",
              style: TextStyle(
                color: Color(0xff515151),
                fontSize: 15,
                letterSpacing: 0.45,
              ),
            ),
          ),
          Container(
            color: Colors.white,
            child: Padding(
              padding: const EdgeInsets.all(14.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    width: 116,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(113),
                      border: Border.all(
                        color: Color(0xffdc0f21),
                        width: 0.50,
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Home",
                        style: TextStyle(
                          color: Color(0xff7f7f7f),
                          fontSize: 12,
                          letterSpacing: 0.36,
                        ),
                      ),
                    ),
                  ),
                  Container(
                    width: 116,
                    height: 38,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(113),
                      border: Border.all(
                        color: Color(0xffdc0f21),
                        width: 0.50,
                      ),
                      color: Colors.white,
                    ),
                    child: Center(
                      child: Text(
                        "Work",
                        style: TextStyle(
                          color: Color(0xff7f7f7f),
                          fontSize: 12,
                          letterSpacing: 0.36,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: true,
                  activeColor: Color(0xffdc0f21),
                  onChanged: (t) {},
                ),
                Text(
                  "Make this my default address",
                  style: TextStyle(
                    color: Color(0xff7f7f7f),
                    fontSize: 12,
                    letterSpacing: 0.36,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: Container(
              height: 60,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(600),
                color: Color(0xffdc0f21),
              ),
              child: Center(
                  child: Text(
                "Add Address",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                ),
              )),
            ),
          )
        ],
      ),
    );
  }
}
