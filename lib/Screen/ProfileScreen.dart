import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_doomo/DB/Database.dart';
import 'package:test_doomo/Model/User.dart';
import 'package:test_doomo/Screen/ChangePassword.dart';
import 'package:test_doomo/Screen/EditScreen.dart';
import 'package:test_doomo/Screen/LoginScreen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({Key key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  var user;

  @override
  Widget build(BuildContext context) {
    final userDevice = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text('Profile'),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: userDevice.width,
          height: userDevice.height,
          child: Padding(
              padding: EdgeInsets.all(20),
              child: Column(
                children: <Widget>[
                  Card(
                    elevation: 10,
                    child: Padding(
                      padding: EdgeInsets.all(16),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Nama: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(user.name ?? '')
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Tempat Lahir: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(user.birthPlace ?? '')
                              ],
                            ),
                          ),
                          Padding(
                            padding:
                                EdgeInsets.only(left: 16, right: 16, top: 8),
                            child: Row(
                              children: <Widget>[
                                Text(
                                  'Tanggal Lahir: ',
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                                Text(user.birthDate ?? '')
                              ],
                            ),
                          )
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => EditUserScreen(
                                      user: user,
                                        )));
                        },
                        child: Text(
                          'Edit Profile',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => ChangePasswordScreen(
                                      user: user
                                        )));
                        },
                        child: Text(
                          'Change Password',
                          style: TextStyle(color: Colors.cyan),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      child: MaterialButton(
                        color: Colors.white,
                        onPressed: () {
                          logout();
                        },
                        child: Text(
                          'Log out',
                          style: TextStyle(color: Colors.red),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height:10),
                  SizedBox(
                    width: double.infinity,
                    child: Material(
                      child: MaterialButton(
                        color: Colors.red,
                        onPressed: () {
                          deleteAccount();
                        },
                        child: Text(
                          'Delete Account',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ),
                  )
                ],
              )),
        ),
      ),
    );
  }

  getuserData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userid');
    var res = DBProvider.db.getUser(userId);
    res.then((val) {
      setState(() {
        user = val;
      });
    });
  }

  deleteAccount() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userid');
    var res = DBProvider.db.deleteUser(userId);
    res.then((val) async {
      await logout();
    });

  }

  logout() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('userid');
    prefs.clear();
    Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => LoginScreen(
                                        )));
  }

  @override
  @override
  void initState() {
    super.initState();
    getuserData();
  }
}
