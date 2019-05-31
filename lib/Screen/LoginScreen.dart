import 'package:flutter/material.dart';
import 'package:test_doomo/DB/Database.dart';
import 'package:test_doomo/Screen/Homescreen.dart';
import 'package:test_doomo/Screen/RegisterScreen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  bool _obscureText = true;

  TextEditingController usernameController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  final GlobalKey<ScaffoldState> _loginScaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      key: _loginScaffoldKey,
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                'Login',
                style: TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.bold,
                    fontSize: 24),
              ),
              SizedBox(
                height: 80,
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
                height: 25,
              ),
              MaterialButton(
                color: Colors.blueAccent,
                onPressed: () {
                  submit();
                },
                child: Text(
                  'Login',
                  style: TextStyle(color: Colors.white),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              FlatButton(
                onPressed: () {
                  Navigator.of(context).push(MaterialPageRoute(
                                    builder: (context) => RegisterScreen()));
                },
                child: Text("Didn't Have Account ? Register Here"),
              )
            ],
          ),
        ),
      ),
    );
  }

  submit() async {
    final res = await DBProvider.db
        .loginUser(usernameController.text, passwordController.text);
        print(res);
    if (res == null) {
      _loginScaffoldKey.currentState
          .showSnackBar(SnackBar(content: Text("User not found")));
    } else {
      SharedPreferences prefs = await SharedPreferences.getInstance();    
      await prefs.setInt('userid', res.id); 

      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        )));
    }
  }

  checkIsUserLoggedIn() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if(prefs.getInt('userid') != null){
      Navigator.of(context).pushReplacement(MaterialPageRoute(
                                    builder: (context) => HomeScreen(
                                        )));
    }
  }

  @override
  void initState() {
    checkIsUserLoggedIn();
    super.initState();
  }
}
