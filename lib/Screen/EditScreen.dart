import 'dart:convert';
import 'package:crypto/crypto.dart' as crypto;

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:test_doomo/DB/Database.dart';
import 'package:test_doomo/Model/User.dart';
import 'package:test_doomo/Screen/Homescreen.dart';

class EditUserScreen extends StatefulWidget {
  final User user;

  EditUserScreen({Key key, @required this.user}) : super(key: key);

  @override
  _EditUserScreenState createState() => _EditUserScreenState();
}

class _EditUserScreenState extends State<EditUserScreen> {
  TextEditingController nameController = TextEditingController();

  TextEditingController birthplaceController = TextEditingController();

  TextEditingController birthdateController = TextEditingController();

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  final GlobalKey<ScaffoldState> _editUserScaffoldKey =
      new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    final userDevice = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      key: _editUserScaffoldKey,
      appBar: AppBar(
        centerTitle: true,
        automaticallyImplyLeading: true,
        title: Text('Edit ${widget.user.username}'),
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
                  elevation: 8,
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: <Widget>[
                        TextFormField(
                            controller: nameController,
                            decoration: InputDecoration(
                              labelText: 'Name',
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        TextFormField(
                            controller: birthplaceController,
                            decoration: InputDecoration(
                              labelText: 'Birthplace',
                              hasFloatingPlaceholder: true,
                              border: OutlineInputBorder(),
                            )),
                        SizedBox(
                          height: 15,
                        ),
                        DateTimePickerFormField(
                          controller: birthdateController,
                          inputType: InputType.date,
                          initialTime: TimeOfDay(hour: 10, minute: 0),
                          editable: false,
                          style: TextStyle(
                            color: Color(0xff35477d),
                          ),
                          decoration: InputDecoration(
                            labelText: 'Date of Birth',
                            hasFloatingPlaceholder: true,
                            border: OutlineInputBorder(),
                          ),
                          format: formats[InputType.date],
                        ),
                        SizedBox(
                          height: 40,
                        ),
                        MaterialButton(
                          color: Colors.blueAccent,
                          onPressed: () {
                            saveUser();
                          },
                          child: Text(
                            'Save',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  saveUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    int userId = prefs.getInt('userid');

    var res = DBProvider.db.updateUser(
      User(
        id: userId, 
        name: nameController.text ?? widget.user.name,
        password: widget.user.password,
        username: widget.user.username,
        birthDate: birthdateController.text ?? widget.user.birthDate,
        birthPlace: birthplaceController.text ?? widget.user.birthPlace
      )
    );

    res.then((val) {
      
      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        )));
      _editUserScaffoldKey.currentState.showSnackBar(SnackBar(content: Text('Successfully Change Data'),));                          
    });
  }

  initTextFieldValue() {
    nameController.text = widget.user.name;
    birthdateController.text = widget.user.birthDate;
    birthplaceController.text = widget.user.birthPlace;
  }

  String generateMd5(String input) {
    return crypto.md5.convert(utf8.encode(input)).toString();
  }

  @override
  @override
  void initState() { 
    super.initState();
    initTextFieldValue();
  }
}
