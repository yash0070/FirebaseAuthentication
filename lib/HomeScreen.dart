import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_app/LoginScreen.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:fluttertoast/fluttertoast.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final db = FirebaseFirestore.instance;
  final auth = FirebaseAuth.instance;

  final _key = GlobalKey<FormState>();

  String? task;

  void showdialog(bool isUpdate, DocumentSnapshot? ds) {
    showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: isUpdate ? Text("Update Todo") : Text("Add todo"),
            content: Form(
              key: _key,
              child: TextFormField(
                autofocus: true,
                decoration: InputDecoration(
                    border: OutlineInputBorder(), labelText: 'Task'),
                validator: (value) {
                  if (value!.isEmpty) {
                    return 'Task is required';
                  }
                  return null;
                },
                onChanged: (value) {
                  task = value;
                },
              ),
            ),
            actions: [
              RaisedButton(
                onPressed: () {
                  setState(() {
                    if (isUpdate) {
                      db
                          .collection('tasks')
                          .doc(ds!.id)
                          .update({'task': task, 'time': DateTime.now()});
                    } else {
                      // crating database
                      db
                          .collection("tasks")
                          .add({'task': task, 'time': DateTime.now()});
                    }

                    Navigator.pop(context);
                  });
                },
                child: Text("ADD"),
              )
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepPurple[200],
      floatingActionButton: FloatingActionButton(
        backgroundColor: Colors.deepPurple[300],
        onPressed: () {
          showdialog(false, null);
        },
        child: Icon(
          Icons.add_a_photo,
          color: Colors.deepPurple,
        ),
      ),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        leading: SizedBox(
            width: 15,
            child: IconButton(
                onPressed: () {
                  setState(() {
                    Navigator.of(context).pop();
                  });
                },
                icon: Icon(
                  Icons.arrow_back_ios,
                  color: Colors.deepPurple,
                ))),
        elevation: 0.0,
        actions: [
          Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: IconButton(
                  color: Colors.deepPurple,
                  onPressed: () {
                    signOut();
                  },
                  icon: Icon(Icons.logout))),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        // for fetching data from firebse (read data)
        stream: db.collection("tasks").orderBy("time").snapshots(),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return ListView.builder(
                itemCount: snapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  DocumentSnapshot ds = snapshot.data!.docs[index];
                  return Container(
                    margin:
                        EdgeInsets.only(left: 20.0, right: 24.0, bottom: 10.0),
                    height: 50,
                    color: Colors.deepPurple[300],
                    child: SizedBox(
                      height: 30,
                      child: ListTile(
                          title: Text(
                            ds['task'],
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontSize: 25.0, fontWeight: FontWeight.w300),
                          ),
                          onLongPress: () {
                            // delete tasks
                            db.collection('tasks').doc(ds.id).delete();
                          },
                          onTap: () {
                            // update Tasks
                            showdialog(true, ds);
                          }),
                    ),
                  );
                });
          } else if (snapshot.hasError) {
            return CircularProgressIndicator();
          } else {
            return CircularProgressIndicator();
          }
        },
      ),
    );
  }

  void signOut() async {
    await FirebaseAuth.instance.signOut().then((uid) => {
          Fluttertoast.showToast(msg: 'SignOut'),
          Navigator.pushReplacement(
              context, MaterialPageRoute(builder: (context) => LoginScreen())),
        });
  }
}
