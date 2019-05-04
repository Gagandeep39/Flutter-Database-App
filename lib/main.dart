import 'package:flutter/material.dart';
import 'package:flutter_database_app/utils/database_helper.dart';
import 'package:flutter_database_app/utils/models/user.dart';

void main() async {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
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

  String insertStatus = "waiting";
  String deleteStatus = "waiting";
  String updateStatus = "waiting";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("SQLite Demo"),
      ),
      body: new Container(
        child: ListView(
          children: <Widget>[
            new Container(
              //Insert Container
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: <Widget>[
                  Text(
                    "Insert",
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  TextField(
                    controller: _nameController,
                    decoration: InputDecoration(labelText: "Name"),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(labelText: "Password"),
                  ),
                  Text(
                    "Update Status: $insertStatus",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                  RaisedButton(
                    child: Text(
                      "Insert Data",
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      _insertData();
                    },
                    color: Colors.pink,
                  ),
                ],
              ),
            ),
            new Container(
              //Delete Container
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: <Widget>[
                  Text(
                    "Delete",
                    style:
                    TextStyle(fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  TextField(
                    controller: _idController,
                    decoration: InputDecoration(labelText: "Name"),
                    keyboardType: TextInputType.number,
                  ),
                  RaisedButton(
                    child: Text(
                      "Delete Data",
                    ),
                    textColor: Colors.white,
                    onPressed: () {
                      _deleteData();
                    },
                    color: Colors.pink,
                  ),
                  Text(
                    "Delete Status: $deleteStatus",
                    style:
                    TextStyle(fontSize: 16, fontWeight: FontWeight.w300),
                  ),
                ],
              ),
            ),
            new Container(
              //Display Container
              margin: EdgeInsets.all(8.0),
              padding: EdgeInsets.all(8.0),
              decoration: BoxDecoration(border: Border.all(width: 1)),
              child: Column(
                children: <Widget>[
                  Text(
                    "Display",
                    style: TextStyle(
                      fontSize: 24, fontWeight: FontWeight.w400),
                  ),
                  RaisedButton(
                    onPressed: () {
                      Navigator.push(context, MaterialPageRoute(
                        builder: (BuildContext context) {
                          return DisplayScreen();
                        }));
                    },
                    textColor: Colors.white,
                    child: Text("Display Data"),
                    color: Colors.pink,
                  )
                ],
              )),
          ],
        ),
      ));
  }

  void _insertData() async {
    var dbClient = DatabaseHelper();
    int result;
    if (_nameController.text.isNotEmpty && _passwordController.text.isNotEmpty)
      result = await dbClient.saveUser(
        new User("${_nameController.text}", "${_passwordController.text}"));
    else
      print("Eror");
    setState(() {
      if (result != null && result > 0) {
        insertStatus = "Inserted";
        _passwordController.text = "";
        _nameController.text = "";
//        dbClient.close();
      }
    });
  }

  void _deleteData() async {
    var dbClient = DatabaseHelper();
    var result;
    if (_idController.text.isNotEmpty)
      result = await dbClient.deleteUser(int.parse(_idController.text));
    else
      print("Eror");

    setState(() {
      if (result != null && result > 0) {
        _idController.text = "";
        deleteStatus = "Deleted";
      } else
        deleteStatus = "User not found";
    });

//    dbClient.close();
  }
}

class DisplayScreen extends StatefulWidget {
  @override
  _DisplayScreenState createState() => _DisplayScreenState();
}

class _DisplayScreenState extends State<DisplayScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Display Data"),
      ),
      body: FutureBuilder(
        future: _displayUser(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List _user = snapshot.data;
            return ListViewWidget(
              _user); //List view builder could have been made here but for readability it was created as a separated class
          } else
            return Text("");
        },
      ),
    );
  }

  Future<List> _displayUser() async {
    var dbClient = DatabaseHelper();
    List _users = await dbClient.getAllUsers();
    return _users;
  }
}

class ListViewWidget extends StatelessWidget {
  final List _user;

  ListViewWidget(this._user);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: _user.length,
      itemBuilder: (BuildContext context, int index) {
        return new Card(
          margin: EdgeInsets.all(2.0),
          elevation: 2.0,
          child: ListTile(
            onTap: () {},
            title: Text("User : ${User
              .fromMap(_user[index])
              .username}"),
            subtitle: Text("ID  : ${User
              .fromMap(_user[index])
              .id}"),
          ),
        );
      },
    );
  }
}

/***
 *
 * To implement update user in future
 *
 * User updateUser = User.fromMap({
 *  "username" : "Gagan"
 *  "password" : "123456"
 *  "id" : "2"
 * });
 * await db.updateUser(updateUser)
 */
