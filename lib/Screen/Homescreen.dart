import 'package:flutter/material.dart';
import 'package:test_doomo/Bloc/UserBloc.dart';
import 'package:test_doomo/DB/Database.dart';
import 'package:test_doomo/Model/User.dart';
import 'package:test_doomo/Screen/ProfileScreen.dart';

import 'dart:math' as math;

import 'package:test_doomo/Screen/UserDetailScreen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final userBloc = UserBloc();

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('List Pengguna'),
          centerTitle: true,
          actions: <Widget>[
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => ProfileScreen()));
              },
              icon: Icon(
                Icons.account_circle,
                color: Colors.white,
              ),
            )
          ],
        ),
        body: SafeArea(
          child: SizedBox(
            width: MediaQuery.of(context).size.width,
            height: MediaQuery.of(context).size.height,
            child: StreamBuilder<List<User>>(
              stream: userBloc.users,
              builder:
                  (BuildContext context, AsyncSnapshot<List<User>> snapshot) {
                if (!snapshot.hasData || snapshot.data == null) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                } else {
                  return ListView.builder(
                    itemCount: snapshot.data.length,
                    itemBuilder: (BuildContext context, int index) {
                      User user = snapshot.data[index];
                      print(user);
                      return Card(
                          elevation: 10,
                          child: InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => UserDetailScreen(
                                        user: user,
                                      )));
                            },
                            child: ListTile(
                              title: Text(user.name),
                              subtitle: Text(user.username),
                              leading: Text(user.id.toString()),
                            ),
                          ));
                    },
                  );
                }
              },
            ),
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    userBloc.dispose();
    super.dispose();
  }
}
