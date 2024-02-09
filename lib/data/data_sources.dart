import 'dart:async';

import 'package:firebase_auth/firebase_auth.dart' as fb;
import 'package:firebase_storage/firebase_storage.dart';

import '../domain/entities.dart';
import '../domain/params.dart';
import 'models.dart';

class UserFirebaseDataSource {
  final fb.FirebaseAuth _auth = fb.FirebaseAuth.instance;
  final storage = FirebaseStorage.instance;

  User? getUser(NoParams params) => _auth.currentUser != null
      ? UserModel.fromFirebase(_auth.currentUser!).entity
      : null;

  Future<String> verifyPhone(VerifyPhoneParams params) async {
    final idCompleter = Completer<String>();
    Future<String> verificationId = idCompleter.future;
    await _auth.verifyPhoneNumber(
      phoneNumber: params.phoneNumber,
      verificationCompleted: (credential) async =>
          await _auth.signInWithCredential(credential),
      verificationFailed: (e) {
        if (e.code == 'invalid-phone-number') {
          throw Exception('Неверно указан телефон');
        }
      },
      codeSent: (String id, int? resendToken) => idCompleter.complete(id),
      codeAutoRetrievalTimeout: (String id) {},
    );
    return await verificationId;
  }

  Future<User> verifySms(VerifySmsParams params) async {
    final credential = fb.PhoneAuthProvider.credential(
      verificationId: params.verificationId,
      smsCode: params.smsCode,
    );
    fb.User? firebaseUser;
    try {
      firebaseUser = (await _auth.signInWithCredential(credential)).user;
    } on fb.FirebaseAuthException catch (e) {
      print(e.code);
      if (e.code == 'invalid-verification-code') {
        throw Exception('Неверный смс-код');
      }
    }
    if (firebaseUser == null) throw Exception('Ошибка авторизации');
    return UserModel.fromFirebase(firebaseUser);
  }

  Future<User> editUser(EditUserParams params) async {
    fb.User? user = _auth.currentUser;
    if (user == null) throw Exception('Нет данных пользователя');
    if (params.name != null) {
      String? curDisplayName = user.displayName;
      if (curDisplayName == null || curDisplayName.isEmpty) {
        await user.updateDisplayName(params.name);
      } else {
        List splitName = UserModel.splitFirebaseName(curDisplayName);
        await user.updateDisplayName('${params.name} ${splitName[1]}');
      }
      user = _auth.currentUser!;
    }
    if (params.lastName != null) {
      String? curDisplayName = user.displayName;
      if (curDisplayName == null || curDisplayName.isEmpty) {
        await user.updateDisplayName(' ${params.lastName}');
      } else {
        List splitName = UserModel.splitFirebaseName(curDisplayName);
        await user.updateDisplayName('${splitName[0]} ${params.lastName}');
      }
      user = _auth.currentUser!;
    }
    if (params.email != null) {
      await user.verifyBeforeUpdateEmail(params.email!);
    }
    if (params.photo != null) {
      final storageRef = FirebaseStorage.instance.ref();
      final avatarImagesRef = storageRef.child("avatars/${user.uid}");
      await avatarImagesRef.putFile(params.photo!);
      final photoUrl = await avatarImagesRef.getDownloadURL();
      print(photoUrl);
      await user.updatePhotoURL(photoUrl);
    }
    return getUser(NoParams())!;
  }
}
