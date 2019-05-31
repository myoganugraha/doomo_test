import 'package:flutter/material.dart';
import 'package:test_doomo/Model/User.dart';


class UserDetailScreen extends StatelessWidget{
  final User user;

  const UserDetailScreen({Key key, @required this.user}) : super(key: key);

  @override
  Widget build(BuildContext context) {
  final userDevice = MediaQuery.of(context).size;
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Tentang ${user.username}'
        ),
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
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Row(
                            children: <Widget>[
                              Text('Nama: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                              Text(user.name)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Row(
                            children: <Widget>[
                              Text('Tempat Lahir: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                              Text(user.birthPlace)
                            ],
                          ),
                        ),
                        Padding(
                          padding: EdgeInsets.only(left: 16, right: 16, top: 8),
                          child: Row(
                            children: <Widget>[
                              Text('Tanggal Lahir: ',
                              style: TextStyle(
                                fontWeight: FontWeight.bold
                              ),),
                              Text(user.birthDate)
                            ],
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ],
            )
          ),
        ),
      ),
    );
  }

}