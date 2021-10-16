// ignore_for_file: avoid_unnecessary_containers

import 'package:app/pages/home.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:intl/intl.dart';

class AddData extends StatefulWidget {
  const AddData({Key? key}) : super(key: key);

  @override
  _AddDataState createState() => _AddDataState();
}

String dropdownValue = 'Karachi';
final List<String> loation = ['Karachi.', 'Islamabad', 'Lahore'];

late final String title;
bool isloading = false;
String holder = '';

class _AddDataState extends State<AddData> {
  CollectionReference user = FirebaseFirestore.instance.collection('user');

  Future<void> addUser() {
    return user.add(
      {
        'location': loc,
        'desprication': des,
        'payment': payment,
        'received': received,
        'date': date
      },
    );

    // ignore: dead_code
    setState(() {
      isloading = false;
    });
  }

  final _formkey = GlobalKey<FormState>();
  DateTime currentDate = DateTime.now();

  var des = "";
  var payment = "";
  var loc = "";
  var received = "";
  var date = "";

  TextEditingController _datecontroller = new TextEditingController();
  TextEditingController descontroller = new TextEditingController();
  TextEditingController paymentcontroller = new TextEditingController();
  TextEditingController recivedcontroller = new TextEditingController();
  TextEditingController locationcontoller = new TextEditingController();

  var myFormat = DateFormat('d-MM-yyyy').format(DateTime.now());

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
        context: context,
        initialDate: currentDate,
        firstDate: DateTime(2015),
        lastDate: DateTime(2050));
    if (pickedDate != null && pickedDate != currentDate) {
      setState(() {
        currentDate = pickedDate;
      });
    }
  }

  late String newdate = "${currentDate.toLocal()}".split(' ')[0];

  clearText() {
    locationcontoller.clear();
    descontroller.clear();
    paymentcontroller.clear();
    _datecontroller.clear();
    recivedcontroller.clear();
  }

  @override
  void dispose() {
    locationcontoller.dispose();
    descontroller.dispose();
    paymentcontroller.dispose();
    _datecontroller.dispose();
    recivedcontroller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add New Record"),
      ),
      body: isloading
          ? Container(
              child: Center(child: CircularProgressIndicator()),
            )
          : Form(
              key: _formkey,
              child: Padding(
                padding: EdgeInsets.symmetric(
                  vertical: 30,
                ),
                child: ListView(
                  children: [
                    //   margin: EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                    //   child: DropdownButtonFormField<String>(
                    //     hint: Text("data"),
                    //     value: dropdownValue,
                    //     onChanged: (String? newValue) {
                    //       setState(() {
                    //         dropdownValue = newValue!;
                    //       });
                    //     },
                    //     items: <String>['Karachi', 'Islamabad', 'Lahore']
                    //         .map<DropdownMenuItem<String>>((String value) {
                    //       return DropdownMenuItem<String>(
                    //         value: value,
                    //         child: Text(value),
                    //       );
                    //     }).toList(),
                    //   ),
                    // ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      child: TextFormField(
                        autofocus: false,
                        controller: locationcontoller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Some Text ";
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Location",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      child: TextFormField(
                        controller: descontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Some Text ";
                          }
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                            labelText: "Descrption",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      child: TextFormField(
                        autofocus: false,
                        keyboardType: TextInputType.number,
                        controller: paymentcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Srome Text ";
                          }
                        },
                        decoration: InputDecoration(
                            labelText: "Payment",
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(color: Colors.red, width: 5.0),
                            )),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      child: TextFormField(
                        controller: recivedcontroller,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return "Please Enter Some Text ";
                          }
                        },
                        autofocus: false,
                        decoration: InputDecoration(
                          labelText: "Received",
                          border: OutlineInputBorder(
                            borderSide:
                                BorderSide(color: Colors.red, width: 5.0),
                          ),
                        ),
                      ),
                    ),
                    Container(
                      margin:
                          EdgeInsets.symmetric(vertical: 18, horizontal: 18),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(myFormat.toString()),
                          SizedBox(
                            height: 20.0,
                          ),
                          MaterialButton(
                            onPressed: () => _selectDate(context),
                            child: Text('Select date'),
                          ),
                        ],
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Container(
                          height: 60,
                          margin: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: MaterialButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                des = descontroller.text;
                                payment = paymentcontroller.text;
                                loc = locationcontoller.text;
                                date = currentDate.toString();
                                received = recivedcontroller.text;
                                addUser();
                                Navigator.pop(context);
                                setState(() {
                                  isloading = false;
                                });
                                clearText();
                              }
                            },
                            color: Colors.blue,
                            child: Text(
                              "Reset",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                        Container(
                          height: 60,
                          margin: EdgeInsets.symmetric(
                              vertical: 18, horizontal: 18),
                          child: MaterialButton(
                            onPressed: () {
                              if (_formkey.currentState!.validate()) {
                                setState(() {
                                  isloading = true;
                                });
                                des = descontroller.text;
                                payment = paymentcontroller.text;
                                loc = locationcontoller.text;
                                date = currentDate.toString();
                                received = recivedcontroller.text;
                                addUser();
                                Navigator.pop(context);
                                setState(() {
                                  isloading = false;
                                });
                                clearText();
                              }
                            },
                            color: Colors.blue,
                            child: Text(
                              "Submit",
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
    );
  }
}
