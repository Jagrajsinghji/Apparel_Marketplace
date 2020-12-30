import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/UI/Dashboard/Cart/PaymentOptions.dart';
import 'package:provider/provider.dart';

class AddAddress extends StatefulWidget {
  final Map<String, dynamic> checkOutData;

  const AddAddress({Key key, this.checkOutData}) : super(key: key);

  @override
  _AddAddressState createState() => _AddAddressState();
}

class _AddAddressState extends State<AddAddress> {
  GlobalKey<FormFieldState> _nameKey = GlobalKey();
  GlobalKey<FormFieldState> _mobileKey = GlobalKey();
  GlobalKey<FormFieldState> _pinKey = GlobalKey();
  GlobalKey<FormFieldState> _addressKey = GlobalKey();
  GlobalKey<FormFieldState> _townKey = GlobalKey();
  GlobalKey<FormFieldState> _cityKey = GlobalKey();
  GlobalKey<FormFieldState> _stateKey = GlobalKey();

  String name, mobileNo, pinCode, address, town, city, state;

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
          "Add Shipping Address",
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
                      key: _nameKey,
                      validator: (c) {
                        if (c
                            .trim()
                            .length < 4)
                          return "Name must be greater than 4 words";
                        return null;
                      },
                      onChanged: (c) => name = c,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(keyboardType: TextInputType.number,
                      key: _mobileKey,
                      validator: (c) {
                        if (c
                            .trim()
                            .length < 10)
                          return "Invalid Mobile Number";
                        return null;
                      },
                      onChanged: (c) => mobileNo = c,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
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
                    child: TextFormField(keyboardType: TextInputType.number,
                      key: _pinKey,
                      validator: (val) {
                        if (val.trim().length!=6) {
                          return "Enter Valid Pin Code";
                        }
                        return null;
                      },
                      onChanged: (c) => pinCode = c,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      key: _addressKey,
                      onChanged: (c) => address = c,
                      validator: (c) =>
                      c
                          .trim()
                          .length < 5
                          ? "Please enter a valid Address"
                          : null,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: TextFormField(
                      validator: (c) =>
                      c
                          .trim()
                          .length == 0
                          ? "Please Enter Locality/Town"
                          : null,
                      onChanged: (c) => town = c,
                      key: _townKey,
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
                          fontWeight: FontWeight.w400,
                        ),
                      ),
                      style: TextStyle(
                        fontSize: 14,
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
                            onChanged: (c) => city = c,
                            validator: (c) =>
                            c
                                .trim()
                                .length == 0
                                ? "Please a valid City/District"
                                : null,
                            key: _cityKey,
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
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                      Expanded(
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: TextFormField(
                            key: _stateKey,
                            onChanged: (c) => state = c,
                            validator: (c) =>
                            c
                                .trim()
                                .length == 0
                                ? "Please a valid State"
                                : null,
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
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            style: TextStyle(
                              fontSize: 14,
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
          // Padding(
          //   padding: const EdgeInsets.only(top: 20, left: 10, bottom: 10.0),
          //   child: Text(
          //     "Save Address as",
          //     style: TextStyle(
          //       color: Color(0xff515151),
          //       fontSize: 15,
          //       letterSpacing: 0.45,
          //     ),
          //   ),
          // ),
          // Container(
          //   color: Colors.white,
          //   child: Padding(
          //     padding: const EdgeInsets.all(14.0),
          //     child: Row(
          //       mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          //       crossAxisAlignment: CrossAxisAlignment.center,
          //       children: [
          //         Container(
          //           width: 116,
          //           height: 38,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(113),
          //             border: Border.all(
          //               color: Color(0xffdc0f21),
          //               width: 0.50,
          //             ),
          //             color: Colors.white,
          //           ),
          //           child: Center(
          //             child: Text(
          //               "Home",
          //               style: TextStyle(
          //                 color: Color(0xff7f7f7f),
          //                 fontSize: 12,
          //                 letterSpacing: 0.36,
          //               ),
          //             ),
          //           ),
          //         ),
          //         Container(
          //           width: 116,
          //           height: 38,
          //           decoration: BoxDecoration(
          //             borderRadius: BorderRadius.circular(113),
          //             border: Border.all(
          //               color: Color(0xffdc0f21),
          //               width: 0.50,
          //             ),
          //             color: Colors.white,
          //           ),
          //           child: Center(
          //             child: Text(
          //               "Work",
          //               style: TextStyle(
          //                 color: Color(0xff7f7f7f),
          //                 fontSize: 12,
          //                 letterSpacing: 0.36,
          //               ),
          //             ),
          //           ),
          //         ),
          //       ],
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(left: 10.0),
          //   child: Row(
          //     mainAxisAlignment: MainAxisAlignment.start,
          //     children: [
          //       Checkbox(
          //         value: true,
          //         activeColor: Color(0xffdc0f21),
          //         onChanged: (t) {},
          //       ),
          //       Text(
          //         "Make this my default address",
          //         style: TextStyle(
          //           color: Color(0xff7f7f7f),
          //           fontSize: 12,
          //           letterSpacing: 0.36,
          //         ),
          //       ),
          //     ],
          //   ),
          // ),
          Padding(
            padding: const EdgeInsets.all(20.0),
            child: InkWell(
              onTap: _proceed,
              child: Container(
                height: 60,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(600),
                  color: Color(0xffdc0f21),
                ),
                child: Center(
                    child: Text(
                      // "Add Address",
                      " Proceed",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 14,
                      ),
                    )),
              ),
            ),
          )
        ],
      ),
    );
  }


  void _proceed() {
    if (_nameKey.currentState.validate() &&
        _mobileKey.currentState.validate() && _pinKey.currentState.validate() &&
        _addressKey.currentState.validate() &&
        _townKey.currentState.validate() && _cityKey.currentState.validate() &&
        _stateKey.currentState.validate()){
      AuthBloc aBloc= Provider.of<AuthBloc>(context,listen: false);

      Map<String,dynamic> data = {
        "name":name,
        "phone":mobileNo,
        "zip":pinCode,
        "address":address,
        "city":city,
        "state":state,
        "personalEmail":aBloc.userData['email'],
        "personalName":aBloc.userData['name'],
        "userId":aBloc.userData['user_id'],
      };
      data.addAll(widget.checkOutData);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => PaymentOptions(
            checkOutData: data,
          )));
    }
  }
}
