

///Created on Android Studio Canary Version
///User: Gagandeep
///Date: 04-05-2019
///Time: 21:47
///Project Name: flutter_database_app


class User{
  int _id;
  String _username;
  String _password;

  User(this._username, this._password);


  User.map(dynamic obj){
    this._username = obj['username'];
    this._password = obj['password'];
    this._id = obj['id'];
  }

  String get password => _password;
  String get username => _username;
  int get id => _id;

  Map<String, dynamic> toMap(){
    var map = Map<String, dynamic>();
    map['username'] = _username;
    map['password'] = _password;
    if(id != null ){
      map['id'] = _id;
    }
    return map;
  }

  User.fromMap(Map<String, dynamic> map){
    this._username = map['username'];
    this._password = map['password'];
    this._id = map['id'];
  }



}
