import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CountryStateBloc.dart';
import 'package:flutter_app/Utils/Extensions.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:provider/provider.dart';

import 'PaymentOptions.dart';

class ChooseAddress extends StatefulWidget {
  final Map<String, dynamic> checkOutData;
  final Map profileData, countryStates;

  const ChooseAddress(
      {Key key, this.checkOutData, this.profileData, this.countryStates})
      : super(key: key);

  @override
  _ChooseAddressState createState() => _ChooseAddressState();
}

class _ChooseAddressState extends State<ChooseAddress> {
  GlobalKey<FormFieldState> _nameKey = GlobalKey();
  GlobalKey<FormFieldState> _emailKey = GlobalKey();
  GlobalKey<FormFieldState> _mobileKey = GlobalKey();
  GlobalKey<FormFieldState> _pinKey = GlobalKey();
  GlobalKey<FormFieldState> _addressKey = GlobalKey();
  GlobalKey<FormFieldState> _cityKey = GlobalKey();

  TextEditingController _name = TextEditingController();
  TextEditingController _email = TextEditingController();
  TextEditingController _mobile = TextEditingController();
  TextEditingController _pin = TextEditingController();
  TextEditingController _address = TextEditingController();
  TextEditingController _city = TextEditingController();

  bool selectPrevAddress = false;
  bool showLastSavedAddress = false;
  bool makeThisDefAddress = false;
  List countries = [], states = [];
  String selectedCountry, selectedState;

  int selectedCId;

  @override
  void initState() {
    super.initState();

    CountryStateBloc _countrySBloc =
        Provider.of<CountryStateBloc>(context, listen: false);
    countries = _countrySBloc.countries;
    states = _countrySBloc.states;
  }

  @override
  Widget build(BuildContext context) {
    AuthBloc _authBloc = Provider.of<AuthBloc>(context);
    return Scaffold(
      backgroundColor: Colors.white,
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
          "Choose Shipping Address",
          style: TextStyle(
            color: Color(0xff2c393f),
            fontSize: 18,fontFamily: goggleFont
          ),
        ),
        iconTheme: IconThemeData(color: Colors.black),
      ),
      body: CustomScrollView(
        shrinkWrap: true,
        physics: BouncingScrollPhysics(),
        slivers: [
          SliverList(delegate: SliverChildListDelegate([...prevAddress()])),
          SliverList(delegate: SliverChildListDelegate([newAddress()])),
          SliverList(
            delegate: SliverChildListDelegate([
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: InkWell(
                  onTap: _proceed,
                  child: Container(
                    height: 50,
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
            ]),
          )
        ],
      ),
    );
  }

  List<Widget> prevAddress() {
    String name, mobileNo, pinCode, address, city, email, state, country;
    if (widget.profileData != null) {
      name = widget.profileData['name'];
      mobileNo = widget.profileData['mobile_number'];
      city = widget.profileData['city'];
      pinCode = widget.profileData['zip'];
      email = widget.profileData['email'];
      address = widget.profileData['address'];
      country = widget.profileData['country'];
      state = widget.profileData['state'];
    }
    showLastSavedAddress = (name != null &&
        mobileNo != null &&
        city != null &&
        pinCode != null &&
        email != null &&
        address != null &&
        state != null &&
        country != null);
    if (!showLastSavedAddress)
      return [Container()];
    else
      return [
        Padding(
          padding: const EdgeInsets.all(10.0),
          child: InkWell(
            onTap: () {
              setState(() {
                selectPrevAddress = !selectPrevAddress;
              });
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              child: Stack(
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        left: 20, right: 20.0, top: 10, bottom: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Name:  $name"),
                        Text("Email: $email"),
                        Text("Phone Number: $mobileNo"),
                        Text("Address: $address"),
                        Text(
                            "$pinCode, $city, $state, $country"),
                      ],
                    ),
                  ),
                  Positioned(
                    right: 8,
                    top: 8,
                    child: Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: selectPrevAddress ? Colors.green : null,
                        border: Border.all(color: Colors.grey),
                      ),
                      width: 15,
                      height: 15,
                      child: selectPrevAddress
                          ? Icon(
                              Icons.check,
                              size: 10,
                            )
                          : null,
                    ),
                  )
                ],
              ),
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Color(0xffDC0F21))),
            ),
          ),
        ),
        Center(
            child: Text(
          "OR",
          style: TextStyle(fontSize: 20),
        )),
      ];
  }

  Widget newAddress() {
    return Container(
      color: selectPrevAddress ? Colors.grey.shade300 : Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 10.0),
        child: ListView(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 10, bottom: 5.0),
              child: Text(
                "Contact Details",
                style: TextStyle(
                  color: Color(0xff515151),
                  fontSize: 15,
                  letterSpacing: 0.45,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
              child: TextFormField(
                key: _nameKey,
                validator: (c) {
                  if (c.trim().length < 4)
                    return "Name must be greater than 4 words";
                  return null;
                },
                controller: _name,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffA8A8A8))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffA8A8A8))),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
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
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
              child: TextFormField(
                key: _emailKey,
                validator: (val) {
                  Pattern pattern =
                      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
                  RegExp regex = new RegExp(pattern);
                  if (val.isEmpty ||
                      val == " " ||
                      val.length < 5 ||
                      !regex.hasMatch(val)) {
                    return "Enter Valid Email Address";
                  }
                  return null;
                },
                controller: _email,
                decoration: InputDecoration(
                    isDense: true,
                    contentPadding: EdgeInsets.all(16),
                    enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffA8A8A8))),
                    focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: BorderSide(color: Color(0xffA8A8A8))),
                    errorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    focusedErrorBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.red),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    hintText: "Email ID*",
                    hintStyle: TextStyle(
                      color: Color(0xff9d9d9d),
                      fontSize: 14,
                      fontWeight: FontWeight.w400,
                    )),
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
              child: TextFormField(
                controller: _mobile,
                key: _mobileKey,
                keyboardType: TextInputType.number,
                validator: (c) {
                  if (c.trim().length < 10) return "Invalid Mobile Number";
                  return null;
                },
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffA8A8A8))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffA8A8A8))),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
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
            Padding(
              padding: const EdgeInsets.only(top: 20, left: 10, bottom: 5.0),
              child: Text(
                "Address",
                style: TextStyle(
                  color: Color(0xff515151),
                  fontSize: 15,
                  letterSpacing: 0.45,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
              child: TextFormField(
                key: _addressKey,
                controller: _address,
                validator: (c) =>
                    c.trim().length < 5 ? "Please enter a valid Address" : null,
                decoration: InputDecoration(
                  isDense: true,
                  contentPadding: EdgeInsets.all(16),
                  enabledBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffA8A8A8))),
                  focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: BorderSide(color: Color(0xffA8A8A8))),
                  errorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  focusedErrorBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.red),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Address (house no, building, street, area)*",
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 2.5, top: 5),
                    child: TextFormField(
                      keyboardType: TextInputType.number,
                      key: _pinKey,
                      validator: (val) {
                        if (val.trim().length != 6) {
                          return "Enter Valid Pin Code";
                        }
                        return null;
                      },
                      controller: _pin,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        focusedErrorBorder: OutlineInputBorder(
                          borderSide: BorderSide(color: Colors.red),
                          borderRadius: BorderRadius.circular(10),
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
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 2.5, right: 8, top: 5),
                    child: TextFormField(
                      controller: _city,
                      validator: (c) => c.trim().length == 0
                          ? "Please a valid City/District"
                          : null,
                      key: _cityKey,
                      decoration: InputDecoration(
                        isDense: true,
                        contentPadding: EdgeInsets.all(16),
                        enabledBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10),
                            borderSide: BorderSide(color: Color(0xffA8A8A8))),
                        errorBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
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
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(flex: 1, child: countryDropdown()),
                Expanded(flex: 1, child: stateDropdown()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Checkbox(
                  value: makeThisDefAddress,
                  activeColor: Color(0xffdc0f21),
                  onChanged: (t) {
                    setState(() {
                      makeThisDefAddress = t;
                    });
                  },
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
          ],
        ),
      ),
    );
  }

  void _proceed() {
    Map<String, dynamic> data = {};
    if (selectPrevAddress) {
      String name,
          mobileNo,
          pinCode,
          address,
          city,
          email,
          state,
          country,
          userId;
      name = widget.profileData['name'];
      mobileNo = widget.profileData['mobile_number'];
      city = widget.profileData['city'];
      pinCode = widget.profileData['zip'];
      email = widget.profileData['email'];
      address = widget.profileData['address'];
      country = widget.profileData['country'];
      state = widget.profileData['state'];
      userId = widget.profileData['user_id'].toString();
      data.addAll({
        "name": name,
        "phone": mobileNo,
        "zip": pinCode,
        "address": address,
        "city": city,
        "email":email,
        "state": state,
        "country": country,
        "personalEmail": email,
        "personalName": name,
        "userId": userId,
      });
      data.addAll(widget.checkOutData);
      Navigator.of(context).push(MaterialPageRoute(
          builder: (c) => PaymentOptions(
            checkOutData: data,
          )));
    }
    else {
      if (_nameKey.currentState.validate() &&
          _emailKey.currentState.validate() &&
          _mobileKey.currentState.validate() &&
          _addressKey.currentState.validate() &&
          _pinKey.currentState.validate() &&
          _cityKey.currentState.validate()) {
        if (selectedCountry == null) {
          Fluttertoast.showToast(msg: "Choose Country");
          return;
        }
        if (selectedState == null) {
          Fluttertoast.showToast(msg: "Choose State");
          return;
        }
        AuthBloc aBloc = Provider.of<AuthBloc>(context, listen: false);
        Map<String, dynamic> data = {
          "name": _name.text,
          "phone": _mobile.text,
          "zip": _pin.text,
          "address": _address.text,
          "city": _city.text,
          "email":_email.text,
          "state": selectedState,
          "country": selectedCountry,
          "personalEmail": aBloc.userData['email'] ??_email.text,
          "personalName": aBloc.userData['name'],
          "userId": aBloc.userData['user_id'].toString(),
        };
        data.addAll(widget.checkOutData);
        if(makeThisDefAddress)
          aBloc.editProfile(zip: _pin.text,address: _address.text,
            state: selectedState,city: _city.text,
            country: selectedCountry,email: aBloc.userData['email'] ??_email.text,
          );
        Navigator.of(context).push(MaterialPageRoute(
            builder: (c) => PaymentOptions(
              checkOutData: data,
            )));
      }
    }

  }

  Widget countryDropdown() {
    return Padding(
      padding: const EdgeInsets.only(right: 2.5, left: 8, top: 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffA8A8A8))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              hint: Text("${selectedCountry ?? "Country"}"),
              isExpanded: true,
              value: selectedCountry,
              items: [
                ...countries.map((e) {
                  return DropdownMenuItem(
                    onTap: () => setState(() {
                      selectedCountry = e['name'];
                      selectedCId = e['id'];
                      selectedState = null;
                    }),
                    child: Text("${e['name']}"),
                    value: e['name'],
                  );
                }),
              ],
              onChanged: (c) {},
            ),
          ),
        ),
      ),
    );
  }

  Widget stateDropdown() {
    return Padding(
      padding: const EdgeInsets.only(left: 2.5, right: 8, top: 5),
      child: Container(
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            border: Border.all(color: Color(0xffA8A8A8))),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5),
          child: DropdownButtonHideUnderline(
            child: DropdownButton(
              icon: selectedCountry == null ? Container() : null,
              isExpanded: true,
              hint: Text("${selectedState ?? "State"}"),
              value: selectedState,
              items: [
                if (selectedCountry != null)
                  ...states
                      .where((element) => element['country_id'] == selectedCId)
                      .toList()
                      .map((e) {
                    return DropdownMenuItem(
                      onTap: () => setState(() {
                        selectedState = e['name'];
                      }),
                      child: Text("${e['name']}"),
                      value: e['name'],
                    );
                  }),
              ],
              onChanged: (c) {},
            ),
          ),
        ),
      ),
    );
  }
}
