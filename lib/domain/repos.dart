import 'dart:async';

import 'entities.dart';
import 'params.dart';

abstract class UserRepo {
  Future<String> verifyPhone(VerifyPhoneParams params);
  Future<User> verifySms(VerifySmsParams params);
  Future<User> editUser(EditUserParams params);
  FutureOr<User?> getUser(NoParams params);
}
