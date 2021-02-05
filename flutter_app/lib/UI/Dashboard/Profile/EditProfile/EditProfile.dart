import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_app/Bloc/AuthBloc.dart';
import 'package:flutter_app/Bloc/CountryStateBloc.dart';
import 'package:flutter_app/Utils/PickerDialog.dart';
import 'package:flutter_app/Utils/Session.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

import 'ViewProfileImage.dart';

class EditProfile extends StatefulWidget {
  final Map profileData;

  const EditProfile({Key key, this.profileData}) : super(key: key);

  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  bool editFlag = false;
  FocusNode _nameFocus = FocusNode();
  GlobalKey<FormFieldState> _nameKey = GlobalKey();
  GlobalKey<FormFieldState> _emailKey = GlobalKey();
  GlobalKey<FormFieldState> _pinKey = GlobalKey();
  GlobalKey<FormFieldState> _addressKey = GlobalKey();
  GlobalKey<FormFieldState> _cityKey = GlobalKey();

  String name, mobileNo, pinCode, address, city, email, photoLink;
  bool isLoading = false;

  File photoFile;
  List countries = [], states = [];
  String selectedCountry , selectedState ;
  int selectedCId;

  @override
  void initState() {
    super.initState();
    if (widget.profileData != null) {

      name = widget.profileData['name'];
      mobileNo = widget.profileData['mobile_number'];
      city = widget.profileData['city'];
      pinCode = widget.profileData['zip'];
      email = widget.profileData['email'];
      address = widget.profileData['address'];
      selectedCountry = widget.profileData['country'];
      selectedState = widget.profileData['state'];
      photoLink = widget.profileData['photo'];
    }
    CountryStateBloc _countrySBloc =
        Provider.of<CountryStateBloc>(context, listen: false);
    countries = _countrySBloc.countries;
    states = _countrySBloc.states;
  }

  @override
  Widget build(BuildContext context) {

    return WillPopScope(
      onWillPop: () async {
        if (editFlag) {
          showDialog(
              context: context,
              builder: (c) => AlertDialog(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    backgroundColor: Colors.white,
                    title: Text("Are you sure?"),
                    content: Text(
                        "You have unsaved changes.\nAre you sure you want to exit?"),
                    actions: [
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(c);
                            Navigator.pop(context);
                          },
                          child: Text(
                            "Yes",
                            style: TextStyle(color: Color(0xffDC0F21)),
                          )),
                      FlatButton(
                          onPressed: () {
                            Navigator.pop(c);
                          },
                          child: Text(
                            "No",
                            style: TextStyle(color: Colors.black),
                          )),
                    ],
                  ));
          return false;
        }
        return true;
      },
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
          elevation: 0,
          leading: FlatButton(
            child: Image.asset("assets/backArrow.png"),
            onPressed: () {
              Navigator.of(context).maybePop();
            },
          ),
          backgroundColor: Colors.white,
          title: Text(
            "Edit Profile",
            style: TextStyle(
              color: Color(0xff2c393f),
              fontSize: 18,
            ),
          ),
          iconTheme: IconThemeData(color: Colors.black),
        ),
        body: isLoading
            ? SpinKitFadingCircle(
                color: Color(0xffDC0F21),
              )
            : ListView(
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
                children: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          color: Colors.grey.shade300,
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.black)),
                      child: InkWell(
                        onTap: () {
                          if (photoFile == null && photoLink == null) {
                            Navigator.of(context).push(PageRouteBuilder(
                                opaque: false,
                                pageBuilder: (c, a, b) => PickerDialog(
                                    openCamera: () =>
                                        pickImage(ImageSource.camera),
                                    openGallery: () =>
                                        pickImage(ImageSource.gallery))));
                            return;
                          }
                          Navigator.push(
                              context,
                              PageRouteBuilder(
                                  transitionDuration:
                                      Duration(milliseconds: 800),
                                  reverseTransitionDuration:
                                      Duration(milliseconds: 500),
                                  pageBuilder: (c, a, b) => ViewProfileImage(
                                        imageUrl: photoLink,
                                        file: photoFile,
                                      )));
                        },
                        child: Hero(
                          tag: "ProfilePic",
                          child: Material(
                            color: Colors.transparent,
                            child: Stack(
                              children: [
                                photoFile != null
                                    ? Center(
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(500),
                                          child: Image.file(
                                            photoFile,
                                            fit: BoxFit.cover,
                                            width: 200,
                                            height: 200,
                                          ),
                                        ),
                                      )
                                    : photoLink == null
                                        ? Center(
                                            child: Image.asset(
                                              "assets/user.png",
                                              height: 50,
                                              width: 50,
                                            ),
                                          )
                                        : Center(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(500),
                                              child: CachedNetworkImage(
                                                imageUrl:
                                                    "${Session.BASE_URL}/assets/images/users/$photoLink",
                                                fit: BoxFit.cover,
                                                width: 200,
                                                height: 200,
                                              ),
                                            ),
                                          ),
                                Positioned(
                                  bottom: 0,
                                  height: 50,
                                  width: 50,
                                  right: MediaQuery.of(context).size.width / 2 +
                                      30,
                                  child: InkWell(
                                    onTap: () {
                                      Navigator.of(context).push(
                                          PageRouteBuilder(
                                              opaque: false,
                                              pageBuilder: (c, a, b) =>
                                                  PickerDialog(
                                                      openCamera: () =>
                                                          pickImage(ImageSource
                                                              .camera),
                                                      openGallery: () =>
                                                          pickImage(ImageSource
                                                              .gallery))));
                                    },
                                    child: Container(
                                        width: 50,
                                        height: 50,
                                        decoration: BoxDecoration(
                                          color: Colors.grey.shade300,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Center(
                                          child: Icon(Icons.edit_outlined),
                                        )),
                                  ),
                                )
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding:
                        const EdgeInsets.only(top: 10, left: 10, bottom: 5.0),
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                    child: TextFormField(
                      focusNode: _nameFocus,
                      key: _nameKey,
                      initialValue: name,
                      readOnly: !editFlag,
                      validator: (c) {
                        if (c.trim().length < 4)
                          return "Name must be greater than 4 words";
                        return null;
                      },
                      onChanged: (c) => name = c,
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                    child: TextFormField(
                      key: _emailKey, validator: (val) {
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
                    },onChanged: (c)=>email=c,
                      initialValue: email,
                      readOnly: !editFlag,
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                    child: TextFormField(
                      initialValue: mobileNo,
                      readOnly: true,
                      keyboardType: TextInputType.number,
                      validator: (c) {
                        if (c.trim().length < 10)
                          return "Invalid Mobile Number";
                        return null;
                      },
                      onChanged: (c) => mobileNo = c,
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
                    padding:
                        const EdgeInsets.only(top: 20, left: 10, bottom: 5.0),
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
                    padding:
                        const EdgeInsets.only(left: 8.0, right: 8.0, top: 5),
                    child: TextFormField(
                      initialValue: address,
                      readOnly: !editFlag,
                      key: _addressKey,
                      onChanged: (c) => address = c,
                      validator: (c) => c.trim().length < 5
                          ? "Please enter a valid Address"
                          : null,
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
                          padding: const EdgeInsets.only(
                              left: 8.0, right: 2.5, top: 5),
                          child: TextFormField(
                            initialValue: pinCode,
                            readOnly: !editFlag,
                            keyboardType: TextInputType.number,
                            key: _pinKey,
                            validator: (val) {
                              if (val.trim().length != 6) {
                                return "Enter Valid Pin Code";
                              }
                              return null;
                            },
                            onChanged: (c) => pinCode = c,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(16),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
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
                          padding: const EdgeInsets.only(
                              left: 2.5, right: 8, top: 5),
                          child: TextFormField(
                            initialValue: city,
                            readOnly: !editFlag,
                            onChanged: (c) => city = c,
                            validator: (c) => c.trim().length == 0
                                ? "Please a valid City/District"
                                : null,
                            key: _cityKey,
                            decoration: InputDecoration(
                              isDense: true,
                              contentPadding: EdgeInsets.all(16),
                              enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
                              focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide:
                                      BorderSide(color: Color(0xffA8A8A8))),
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
                          editFlag ? "Save" : "Edit",
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
      ),
    );
  }

  void _proceed() async {
    if (!editFlag) {
      FocusScope.of(context).requestFocus(_nameFocus);
      if (mounted)
        setState(() {
          editFlag = true;
        });
      return;
    }
    if (_nameKey.currentState.validate() &&
        _emailKey.currentState.validate() &&
        _addressKey.currentState.validate() &&
        _pinKey.currentState.validate() &&
        _cityKey.currentState.validate()) {
      if(selectedCountry==null) {
        Fluttertoast.showToast(msg: "Choose Country");
        return;
      }
      if(selectedState==null) {
        Fluttertoast.showToast(msg: "Choose State");
        return;
      }
      if (mounted)
        setState(() {
          isLoading = true;
        });
      AuthBloc aBloc = Provider.of<AuthBloc>(context, listen: false);

      Response response = await aBloc.editProfile(
          name: name,
          address: address,
          city: city,
          state: selectedState,
          country: selectedCountry,
          email: email,
          mobileNumber: mobileNo,
          zip: pinCode,
          photo: photoFile);
      if (response?.data is Map) {
        if (response?.data['message']
            .toString()
            .toLowerCase()
            .contains("successfully updated")) {
          Fluttertoast.showToast(msg: "Profile Saved");
          if (mounted)
            setState(() {
              editFlag = false;
            });
          FocusScope.of(context).requestFocus(FocusNode());
        }
      } else
        Fluttertoast.showToast(msg: "An Error Occurred!");
      if (mounted)
        setState(() {
          isLoading = false;
        });
    }
  }

  void pickImage(ImageSource source) async {
    PickedFile pFile = await ImagePicker().getImage(
      source: source,
      imageQuality: 50,
    );
    if (pFile != null) {
      if (mounted)
        setState(() {
          editFlag = true;
          photoFile = File(pFile.path);
        });
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
            child: DropdownButton(icon: !editFlag?Container():null,
              hint: Text("${selectedCountry??"Country"}"),
              isExpanded: true,
              value: selectedCountry,
              items: [
                if(editFlag)
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
              onChanged: (c) {

              },
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
            child: DropdownButton(icon: !editFlag?Container():null,
              isExpanded: true,
              hint: Text("${selectedState??"State"}"),
              value: selectedState,
              items: [
                if (selectedCountry != null&&editFlag)
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
              onChanged: (c) {
              },
            ),
          ),
        ),
      ),
    );
  }
}
