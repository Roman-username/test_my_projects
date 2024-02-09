import 'package:firebase_auth/firebase_auth.dart' as fb show User;

import '../domain/entities.dart';

class UserModel extends User {
  UserModel(
      {required super.uid,
      required super.name,
      required super.lastName,
      super.email,
      super.photoURL});

  static List<String> splitFirebaseName(String? displayName) {
    if (displayName == null) return ['', ''];
    List splitName = displayName.split(' ');
    final name = splitName[0];
    final lastName = splitName.length == 2 ? splitName[1] : '';
    return [name, lastName];
  }

  factory UserModel.fromFirebase(fb.User user) {
    final splitName = splitFirebaseName(user.displayName);
    return UserModel(
      uid: user.uid,
      name: splitName[0],
      lastName: splitName[1],
      email: user.email,
      photoURL: user.photoURL,
    );
  }

  User get entity => User(
        uid: uid,
        name: name,
        lastName: lastName,
        photoURL: photoURL,
      );
}
