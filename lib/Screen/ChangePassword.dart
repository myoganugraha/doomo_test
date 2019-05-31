import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_doomo/DB/Database.dart';
import 'package:test_doomo/Model/User.dart';
import 'package:test_doomo/Screen/LoginScreen.dart';

class ChangePasswordScreen extends StatefulWidget {

  final User user;

  const ChangePasswordScreen({Key key, @required this.user}) : super(key: key);

  @override
  _ChangePasswordScreenState createState() => _ChangePasswordScreenState();
}

class _ChangePasswordScreenState extends State<ChangePasswordScreen> {
  bool _obscureNewPasswordText = true;

  bool _obscureConfirmationText = true;

  TextEditingController newpasswordController = TextEditingController();

  TextEditingController newpasswordConfirmationController = TextEditingController();

  final GlobalKey<ScaffoldState> _changePasswordScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userDevice = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      key: _changePasswordScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        title: Text('Change Password'),
        automaticallyImplyLeading: true,
      ),
      body: SafeArea(
        child: SizedBox(
          width: userDevice.width,
          height: userDevice.height,
          child: Padding(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8)),
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                          obscureText: _obscureNewPasswordText,
                              controller: newpasswordController,
                              decoration: InputDecoration(
                                labelText: 'New Password',
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                            icon: Icon(_obscureNewPasswordText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureNewPasswordText = !_obscureNewPasswordText;
                              });
                            },
                          ))),
                          SizedBox(
                            height: 15,
                          ),
                          TextFormField(
                            obscureText: _obscureConfirmationText,
                              controller: newpasswordConfirmationController,
                              decoration: InputDecoration(
                                labelText: 'Confirm New Password',
                                hasFloatingPlaceholder: true,
                                border: OutlineInputBorder(),
                                suffixIcon: IconButton(
                            icon: Icon(_obscureConfirmationText
                                ? Icons.visibility
                                : Icons.visibility_off),
                            onPressed: () {
                              setState(() {
                                _obscureConfirmationText = !_obscureConfirmationText;
                              });
                            },
                          ))),
                          SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            savePassword();
                          },
                          child: Text(
                            'Save Password',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }

  savePassword() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userid');
    
    if(newpasswordController.text != newpasswordConfirmationController.text){
      _changePasswordScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Please type same password'),));
    } else if(newpasswordController.text.length < 5 || newpasswordConfirmationController.text.length < 5){
      _changePasswordScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Password too short'),));
    } else {
      var res = DBProvider.db.updateUser(
        User(
          id: userId, 
          name: widget.user.name,
          password: generateMd5(newpasswordController.text),
          username: widget.user.username,
          birthDate: widget.user.birthDate,
          birthPlace: widget.user.birthPlace
        )
      );

      res.then((val) {
        prefs.remove('userid');
        prefs.clear();
        Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                            )));
      });
    }
  }
}
