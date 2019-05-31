import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:test_doomo/DB/Database.dart';
import 'package:test_doomo/Model/User.dart';
import 'package:test_doomo/Screen/LoginScreen.dart';

import 'package:datetime_picker_formfield/datetime_picker_formfield.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  bool _obscureText = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController birthPlaceController = TextEditingController();
  TextEditingController nameController = TextEditingController();
  TextEditingController datePickerController = TextEditingController();

  final GlobalKey<ScaffoldState> _registerScaffoldKey =
      new GlobalKey<ScaffoldState>();

  final formats = {
    InputType.both: DateFormat("EEEE, MMMM d, yyyy 'at' h:mma"),
    InputType.date: DateFormat('yyyy-MM-dd'),
    InputType.time: DateFormat("HH:mm"),
  };

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _registerScaffoldKey,
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'Register',
                  style: TextStyle(
                      color: Colors.black87,
                      fontWeight: FontWeight.bold,
                      fontSize: 24),
                ),
                SizedBox(
                  height: 50,
                ),
                TextFormField(
                    controller: usernameController,
                    decoration: InputDecoration(
                      labelText: 'Username',
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 15,
                ),
                TextFormField(
                    controller: passwordController,
                    obscureText: _obscureText,
                    decoration: InputDecoration(
                        labelText: 'Password',
                        hasFloatingPlaceholder: true,
                        border: OutlineInputBorder(),
                        suffixIcon: IconButton(
                          icon: Icon(_obscureText
                              ? Icons.visibility
                              : Icons.visibility_off),
                          onPressed: () {
                            setState(() {
                              _obscureText = !_obscureText;
                            });
                          },
                        ))),
                SizedBox(
                  height: 15,
                ),
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
                    controller: birthPlaceController,
                    decoration: InputDecoration(
                      labelText: 'Birthplace',
                      hasFloatingPlaceholder: true,
                      border: OutlineInputBorder(),
                    )),
                SizedBox(
                  height: 15,
                ),
                DateTimePickerFormField(
                  controller: datePickerController,
                  inputType: InputType.date,
                  initialTime: TimeOfDay(hour: 10, minute: 0),
                  editable: false,
                  style: TextStyle(
                      color: Color(0xff35477d),),
                  decoration: InputDecoration(
                    labelText: 'Date of Birth',
                    hasFloatingPlaceholder: true,
                    border: OutlineInputBorder(),
                  ), 
                  format: formats[InputType.date],
                ),
                SizedBox(
                  height: 25,
                ),
                MaterialButton(
                  color: Colors.blueAccent,
                  onPressed: () {
                    submit();
                  },
                  child: Text(
                    'Register Me',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
                SizedBox(
                  height: 10,
                ),
                FlatButton(
                  onPressed: () {
                    Navigator.of(context).push(
                        MaterialPageRoute(builder: (context) => LoginScreen()));
                  },
                  child: Text("Have Account ? Login Here"),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  submit() async {
    final res = await DBProvider.db
        .newUser(User(
          name: nameController.text, 
          birthDate: datePickerController.text,
          birthPlace: birthPlaceController.text,
          username: usernameController.text,
          password: passwordController.text));
    print(res);
    if(res == 200){
      _registerScaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Register Success")));
          Navigator.of(context).pushReplacement(MaterialPageRoute(
                                        builder: (context) => LoginScreen(
                                            )));
    }
    else {
      _registerScaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("Username has registered")));
    }
  }
}
