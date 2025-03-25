import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class GetRemarks extends StatefulWidget {
  final List remarks, slots;

  const GetRemarks({Key key, this.remarks, this.slots}) : super(key: key);

  @override
  _GetRemarksState createState() => _GetRemarksState();
}

class _GetRemarksState extends State<GetRemarks> {
  String timeSlot, remarks = "None",typeRemark;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.pop(context);
      },
      child: Scaffold(
        backgroundColor: Colors.black54,
        body: Align(
          alignment: Alignment.bottomCenter,
          child: GestureDetector(
            onTap: () {},
            child: Container(
              decoration: BoxDecoration(
                  color: Colors.white, borderRadius: BorderRadius.circular(20)),
              child: ListView(
                children: [
                  Center(
                      child: Text(
                    "Please Tell Us Why?",
                    style: TextStyle(fontSize: 22),
                  )),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: DropdownButton(
                        value: remarks == "None" ? null : remarks,
                        isExpanded: true,
                        hint: Text("Choose Remarks"),
                        items: [
                          DropdownMenuItem(
                            child: Text("None"),
                            value: "None",
                          ),
                          ...widget.remarks
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList()
                        ],
                        onChanged: (c) {
                          remarks = c;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  if (remarks == "None") ...[
                    Center(child: Text("OR")),
                    Padding(
                      padding: const EdgeInsets.only(
                        left: 10.0,
                        right: 10.0,
                      ),
                      child: TextFormField(
                        onChanged: (c) => typeRemark = c,
                        decoration: InputDecoration(
                          isDense: true,
                          contentPadding: EdgeInsets.all(16),
                          enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Color(0xffA8A8A8))),
                          focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(40),
                              borderSide: BorderSide(color: Color(0xffA8A8A8))),
                          errorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          focusedErrorBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: Colors.red),
                            borderRadius: BorderRadius.circular(40),
                          ),
                          hintText: "Enter Remarks*",
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
                  SizedBox(
                    height: 20,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    child: Center(
                      child: DropdownButton(
                        value: timeSlot,
                        isExpanded: true,
                        hint: Text("Choose Date"),
                        items: [
                          ...widget.slots
                              .map((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList()
                        ],
                        onChanged: (c) {
                          timeSlot = c;
                          setState(() {});
                        },
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 27, vertical: 10),
                    child: InkWell(
                      onTap: () {
                        if (timeSlot == null) {
                          Fluttertoast.showToast(msg: "Choose Date");

                        }else {
                          Navigator.of(context)
                              .pop({"remarks": typeRemark??remarks, "slot": timeSlot});
                        }
                      },
                      borderRadius: BorderRadius.circular(100),
                      child: Container(
                        height: 50,
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100),
                          color: Color(0xffdc0f21),
                        ),
                        child: Center(
                          child: Text(
                            "Return",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(
                    height: 30,
                  )
                ],
                shrinkWrap: true,
                physics: BouncingScrollPhysics(),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
