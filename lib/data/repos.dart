import 'dart:async';

import '../domain/entities.dart';
import '../domain/params.dart';
import '../domain/repos.dart';
import 'data_sources.dart';

class UserRepoImpl implements UserRepo {
  final UserFirebaseDataSource userFirebaseDataSource;

  UserRepoImpl({required this.userFirebaseDataSource});

  @override
  Future<String> verifyPhone(VerifyPhoneParams params) async =>
      await userFirebaseDataSource.verifyPhone(params);

  @override
  Future<User> verifySms(VerifySmsParams params) async =>
      await userFirebaseDataSource.verifySms(params);

  @override
  FutureOr<User?> getUser(NoParams params) async =>
      userFirebaseDataSource.getUser(params);

  @override
  Future<User> editUser(EditUserParams params) =>
      userFirebaseDataSource.editUser(params);
}
