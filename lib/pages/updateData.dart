import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class UpdateData extends StatefulWidget {
  final String id;
  const UpdateData({Key? key, required this.id}) : super(key: key);

  @override
  _UpdateDataState createState() => _UpdateDataState();
}

class _UpdateDataState extends State<UpdateData> {
  DateTime currentDate = DateTime.now();
  final _formkey = GlobalKey<FormState>();

  var des = "";
  var payment = "";
  var loc = "";
  var received = "";
  var date = "";

  var myFormat = DateFormat('d-MM-yyyy');

  get id => null;

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

  CollectionReference user = FirebaseFirestore.instance.collection('user');

  Future<void> updateUser(
    id,
    loc,
    des,
    payment,
    rec,
  ) {
    return user
        .doc(id)
        .update({
          'location': loc,
          'desprication': des,
          'received': rec,
          'payment': payment
        })
        .then((value) => CircularProgressIndicator(
              semanticsLabel: 'upadted',
            ))
        .catchError((onError) => Text("error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Update User"),
      ),
      body: Form(
          key: _formkey,
          child: FutureBuilder<DocumentSnapshot<Map<String, dynamic>>>(
              future: FirebaseFirestore.instance
                  .collection("user")
                  .doc(widget.id)
                  .get(),
              builder: (_, snapshot) {
                if (snapshot.hasError) {
                  print("somthing wrong");
                }
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }
                var data = snapshot.data!.data();
                var loc = data!['location'];
                var des = data['desprication'];
                var rec = data['received'];
                var payment = data['payment'];
                var date = data['date'];

                return Padding(
                  padding: EdgeInsets.symmetric(
                    vertical: 30,
                  ),
                  child: ListView(
                    children: [
                      // Container(
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
                          initialValue: loc,
                          onChanged: (v) {
                            loc = v;
                          },
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
                          onChanged: (v) {
                            des = v;
                          },
                          initialValue: des,
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
                          initialValue: payment,
                          autofocus: false,
                          keyboardType: TextInputType.number,
                          onChanged: (v) {
                            payment = v;
                          },
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
                          initialValue: rec,
                          onChanged: (v) {
                            rec = v;
                          },
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
                            Text("${currentDate.toLocal()}".split(' ')[0]),
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
                            margin: EdgeInsets.symmetric(
                                vertical: 18, horizontal: 18),
                            child: MaterialButton(
                              onPressed: () {
                                if (_formkey.currentState!.validate()) {
                                  setState(() {
                                    updateUser(
                                        widget.id, loc, des, payment, rec);
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              color: Colors.blue,
                              child: Text(
                                "Submit",
                                style: TextStyle(
                                    color: Colors.white, fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
              })),
    );
  }
}
