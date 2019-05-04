import 'package:flutter/material.dart';
import 'package:flutter_database_app/utils/database_helper.dart';
import 'package:flutter_database_app/utils/models/user.dart';

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 05-05-2019
///Time: 00:50
///Project Name: flutter_database_app

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
            title: Text("User : ${User.fromMap(_user[index]).username}"),
            subtitle: Text("ID  : ${User.fromMap(_user[index]).id}"),
          ),
        );
      },
    );
  }
}
