import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:my_contact_app/style/app_style.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'form.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  runApp(MaterialApp(
      debugShowCheckedModeBanner: false,
      title: "Flutter Contact Firebase",
      home: MyApp()));
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    FirebaseFirestore firebase = FirebaseFirestore.instance;

    CollectionReference users = firebase.collection('users');

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        title: Text("My Contact"),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.person),
        ),
        backgroundColor: AppStyle.mainColor,
      ),
      body: FutureBuilder<QuerySnapshot>(
        future: users.get(),
        builder: (_, snapshot) {
          if (snapshot.hasData) {
            var alldata = snapshot.data!.docs;

            return alldata.length != 0
                ? ListView.builder(
                    itemCount: alldata.length,
                    itemBuilder: (_, index) {
                      return ListTile(
                        leading: CircleAvatar(
                          child: Text(
                            alldata[index]['name'][0],
                            style: TextStyle(color: Colors.white),
                          ),
                          backgroundColor: AppStyle.mainColor,
                        ),
                        title: Text(alldata[index]['name'],
                            style: TextStyle(fontSize: 20)),
                        subtitle: Text(alldata[index]['phoneNumber'],
                            style: TextStyle(fontSize: 16)),
                        trailing: IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => FormPage(
                                          id: snapshot.data!.docs[index].id,
                                        )),
                              );
                            },
                            icon: Icon(Icons.arrow_forward_rounded)),
                      );
                    })
                : Center(
                    child: Text(
                      'No Data',
                      style: TextStyle(fontSize: 20),
                    ),
                  );
          } else {
            return Center(child: Text("Loading...."));
          }
        },
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: Colors.white,
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => FormPage()),
          );
        },
        label: Text(
          "Add New",
          style: TextStyle(color: AppStyle.mainColor),
        ),
        icon: Icon(
          Icons.add,
          color: AppStyle.mainColor,
        ),
      ),
    );
  }
}
