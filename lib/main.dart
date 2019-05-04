import 'package:flutter/material.dart';
import 'package:flutter_database_app/utils/database_helper.dart';
import 'package:flutter_database_app/utils/models/user.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.


  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        primarySwatch: Colors.pink,
      ),
      home: MyHome(),
    );
  }
}

class MyHome extends StatefulWidget {
  @override
  _MyHomeState createState() => _MyHomeState();
}

class _MyHomeState extends State<MyHome> {

  final _nameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _idController = TextEditingController();

  var db = DatabaseHelper();
  String updateStatus = "waiting";
  String deleteStatus = "waiting";

  @override
  void initState() {
    super.initState();
    _displayUser();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite Demo"),
      ),
      body: ListView(
        children: <Widget>[
          Text("Insert",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),
          Column(
            children: <Widget>[
              TextField(controller: _nameController,
                decoration: InputDecoration(labelText: "Name"),),
              TextField(controller: _passwordController,
                decoration: InputDecoration(labelText: "Password"),),
              Text("Update Status: $updateStatus"),
              RaisedButton(
                child: Text("Insert Data",),
                textColor: Colors.white,
                onPressed: () {
                  _insertData();
                },
                color: Colors.pink,),

            ],
          ),
          Text("Delete",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),
          Column(
            children: <Widget>[
              TextField(controller: _idController,
                decoration: InputDecoration(labelText: "Name"),
                keyboardType: TextInputType.number,),
              RaisedButton(child: Text("Delete Data",),
                textColor: Colors.white,
                onPressed: () {
                  _deleteData();
                },
                color: Colors.pink,),

            ],
          ),
          Text("Delete Status: $deleteStatus",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),

          Text("Display",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.w400),),
        ],
      ),
    );
  }

  void _displayUser() async {
//    int a =  await db.saveUser(new User("Gagan", "gaga"));
    List _users = await db.getAllUsers();
//    print("User saved $a");
    for (int i = 0; i < _users.length; i++) {
      print(_users[i].toString());
    }
  }

  void _insertData() async {
    int result;
    if (_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty)
      result = await db.saveUser(
        new User("${_nameController.text}", "${_passwordController.text}"));
    else
      print("Eror");
    setState(() {
      if (result != null && result > 0) {
        updateStatus = "Inserted";
        _passwordController.text = "";
        _nameController.text = "";
      }
    });
  }

  void _deleteData() async {
    var result;
    if (_idController.text.isNotEmpty)
      result = await db.deleteUser(int.parse(_idController.text));
    else
      print("Eror");

    setState(() {
      if (result != null && result > 0) {
        _idController.text = "";
        deleteStatus = "Deleted";
      }

      else
        deleteStatus = "User not found";
    });
  }
}

