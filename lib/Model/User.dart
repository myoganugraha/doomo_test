import 'dart:convert';

User userFromJson(String str) {
  final jsonData = json.decode(str);
  return User.fromMap(jsonData);
}

String userToJson(User data) {
  final dyn = data.toMap();
  return json.encode(dyn); 
}

class User {
  int id;
  String name;
  String birthPlace;
  String birthDate;
  String username;
  String password;

  User({
    this.id,
    this.name,
    this.birthPlace,
    this.birthDate,
    this.username,
    this.password
  });

  factory User.fromMap(Map<String, dynamic> json) {
    return User(
      id: json["id"],
      name: json["name"],
      birthPlace: json["birthPlace"],
      birthDate: json["birthDate"],
      username: json["username"],
      password: json["password"]
    );    
  }

  Map<String, dynamic> toMap() => {
      "id": id,
      "name": name,
      "birthPlace": birthPlace,
      "birthDate": birthDate,
      "username": username,
      "password": password
    };
}