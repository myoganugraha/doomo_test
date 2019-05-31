import 'dart:async';

import 'package:test_doomo/Model/User.dart';
import 'package:test_doomo/DB/Database.dart';

class UserBloc{
  final _userController = StreamController<List<User>>.broadcast();

  get users =>_userController.stream;
  

  dispose() {
    _userController.close();
  }

  getAllUser() async {
    _userController.sink.add(await DBProvider.db.getAllUser());
  }

  UserBloc() {
    getAllUser();
  }

  deleteUser(int id) {
    DBProvider.db.deleteUser(id);
    getAllUser();
  }

  createUser(User user){
    DBProvider.db.newUser(user);
    getAllUser();
  }

  getUser(int id){
    DBProvider.db.getUser(id);
  }
}