import 'package:app/pages/updateData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class ListUserPage extends StatefulWidget {
  const ListUserPage({Key? key}) : super(key: key);

  @override
  _ListUserPageState createState() => _ListUserPageState();
}

class _ListUserPageState extends State<ListUserPage> {
  var myFormat = DateFormat('yyyy-MM-dd');
  final Stream<QuerySnapshot> userStream =
      FirebaseFirestore.instance.collection('user').snapshots();

  CollectionReference user = FirebaseFirestore.instance.collection('user');

  Future<void> deleteUser(id) {
    return user
        .doc(id)
        .delete()
        .then((value) => CircularProgressIndicator(
              semanticsLabel: "User Deleted",
            ))
        .catchError((onError) => Text(onError.toString()));
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: userStream,
        builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
          if (snapshot.hasError) {
            print("Somthing Worng");
          }
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          final List storedoc = [];
          snapshot.data!.docs.map((DocumentSnapshot documentSnapshot) {
            Map a = documentSnapshot.data() as Map<String, dynamic>;
            storedoc.add(a);
            print(storedoc);
            a['id'] = documentSnapshot.id;
          }).toList();

          return Container(
            color: Colors.white10,
            margin: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
            child: SingleChildScrollView(
                scrollDirection: Axis.vertical,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    for (var i = 0; i < storedoc.length; i++) ...[
                      Card(
                        
                        
                        clipBehavior: Clip.antiAlias,
                          color: Colors.white,
                          child: Column(

                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                               ExpansionTile(

                  leading: Icon(Icons.person_pin_circle),
                  title: const Text('User Detail'),
                  children: [
                     Padding(
                  padding: const EdgeInsets.all(1.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(" Description : " +
                                  storedoc[i]['desprication']),
                                   Text(" Received : " + storedoc[i]['received']),
                              Text(" Payment : " + storedoc[i]['payment']),
                              Text(" Date :  " +myFormat.format(DateTime.parse(storedoc[i]['date'])).toString() ),
                                Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  IconButton(
                                      onPressed: () {
                                        Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                                builder: (context) =>
                                                    UpdateData(
                                                        id: storedoc[i]
                                                            ['id'])));
                                      },
                                      icon: Icon(
                                        Icons.edit,
                                        color: Colors.blue,
                                      )),
                                  IconButton(
                                      onPressed: () {
                                        deleteUser(storedoc[i]['id']).then(
                                            (value) =>
                                                CircularProgressIndicator());
                                      },
                                      icon: Icon(
                                        Icons.delete,
                                        color: Colors.red,
                                      )),
                                ],
                              ),
                    ],
                  ),
                ),
                    
                  ],
                 
                  
                ),
                 
                //  ButtonBar(
                //   alignment: MainAxisAlignment.start,
                //   children: [
                //       IconButton(
                //                       onPressed: () {
                //                         Navigator.push(
                //                             context,
                //                             MaterialPageRoute(
                //                                 builder: (context) =>
                //                                     UpdateData(
                //                                         id: storedoc[i]
                //                                             ['id'])));
                //                       },
                //                       icon: Icon(
                //                         Icons.edit,
                //                         color: Colors.blue,
                //                       )),
                //                   IconButton(
                //                       onPressed: () {
                //                         deleteUser(storedoc[i]['id']).then(
                //                             (value) =>
                //                                 CircularProgressIndicator());
                //                       },
                //                       icon: Icon(
                //                         Icons.delete,
                //                         color: Colors.red,
                //                       )),
                //   ],
                // ),
                              // Text(" Location : " + storedoc[i]['location']),
                              // Text(" Description : " +
                              //     storedoc[i]['desprication']),
                              // Text(" Received : " + storedoc[i]['received']),
                              // Text(" Payment : " + storedoc[i]['payment']),
                              // Text(" Date :  " + storedoc[i]['date']),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  // IconButton(
                                  //     onPressed: () {
                                  //       Navigator.push(
                                  //           context,
                                  //           MaterialPageRoute(
                                  //               builder: (context) =>
                                  //                   UpdateData(
                                  //                       id: storedoc[i]
                                  //                           ['id'])));
                                  //     },
                                  //     icon: Icon(
                                  //       Icons.edit,
                                  //       color: Colors.blue,
                                  //     )),
                                  // IconButton(
                                  //     onPressed: () {
                                  //       deleteUser(storedoc[i]['id']).then(
                                  //           (value) =>
                                  //               CircularProgressIndicator());
                                  //     },
                                  //     icon: Icon(
                                  //       Icons.delete,
                                  //       color: Colors.red,
                                  //     )),
                                ],
                              ),
                            ],
                          )),
                    ]
                  ],
                )),
          );
        });
  }
}
