import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    theme: ThemeData(
        brightness: Brightness.light,
        primaryColor: Colors.amberAccent[700],
        accentColor: Colors.greenAccent),
    home: MyApp(),
  ));
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String todoTitle = "";
  String selfImportance;

  getTodoTitle(title) {
    this.todoTitle = title;
  }
  getImportance(importance) {
    this.selfImportance  = importance;
  }

  createTodos() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);

    //Map
    Map<String, dynamic> todos = {
      "todoTitle": todoTitle,
      "selfImportance":selfImportance};

    documentReference.set(todos).whenComplete(() {
      print("$todoTitle created");
    });
  }

  updateTodos() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);

    //Map
    Map<String, dynamic> todos = {
      "todoTitle": todoTitle,
      "selfImportance":selfImportance};

    documentReference.set(todos).whenComplete(() {
      print("$todoTitle updated");
    });
  }

  deleteTodos() {
    DocumentReference documentReference =
    FirebaseFirestore.instance.collection("MyTodos").doc(todoTitle);

    documentReference.delete().whenComplete(() {
      print("$todoTitle deleted");
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("List of things to do"),
      ),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Column(
          children: <Widget>[
            Padding(padding: EdgeInsets.only(bottom:  12.0),
              child: TextFormField(
                decoration:  InputDecoration(
                    labelText: "What task do we need to do?",
                    fillColor: Colors.white70
                ),
                onChanged: (String todoTitle) {
                  getTodoTitle(todoTitle);
                },
              ) ,
            ),
        Padding(padding: EdgeInsets.only(bottom:  12.0),
          child: TextFormField(
          decoration:  InputDecoration(
          labelText: "How important??",
          fillColor: Colors.white70
          ),
          onChanged: (String selfImportance) {
            getImportance(selfImportance);
          },
          ) ,
          ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                RaisedButton(
                    color: Colors.greenAccent,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    child : Icon (
                        Icons.add,
                        color: Colors.teal
                    ),
                    onPressed: createTodos),
                RaisedButton(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder (
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon (
                        Icons.update,
                        color: Colors.yellow
                    ),
                    onPressed: updateTodos),
                RaisedButton(
                    color: Colors.red,
                    shape: RoundedRectangleBorder (
                        borderRadius: BorderRadius.circular(8)),
                    child: Icon(
                        Icons.delete_forever,
                        color: Colors.white
                    ),
                    onPressed: deleteTodos)
              ],
            ),
            Padding(padding: EdgeInsets.all(4.0),
                child: Row (
                  children: <Widget>[
                    Expanded (
                      child: Text("Task to do"),
                    ),
                    Expanded(
                        child: Text("Importance"))
                  ],
                )),
            StreamBuilder(
              stream: FirebaseFirestore.instance.collection("MyTodos").snapshots(),
              builder: (context, snapshots) {
                if (snapshots.hasData) {
                  return ListView.builder(
                      shrinkWrap: true,
                      itemCount: snapshots.data.docs.length,
                      itemBuilder: (context, index) {
                        DocumentSnapshot documentSnapshot =
                        snapshots.data.docs[index];
                        return Row(
                          children: <Widget>[
                            Expanded(child: Text(documentSnapshot["todoTitle"]),
                            ),
                            Expanded(child: Text(documentSnapshot["selfImportance"])
                            )],
                        );
                      });
                } else {
                  return Align(
                    alignment: FractionalOffset.bottomCenter,
                    child: CircularProgressIndicator(),
                  );
                }
              },
            )
          ],
        ),
      ),
    );
  }
}