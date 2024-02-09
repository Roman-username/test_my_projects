import 'package:test_my_projects/domain/params.dart';

import 'entities.dart';
import 'repos.dart';

abstract class UseCase<Type, P extends Params> {
  get repo;

  Future<Type?> call(P params);
}

class GetUserUseCase implements UseCase<User, NoParams> {
  @override
  final UserRepo repo;

  GetUserUseCase(this.repo);

  @override
  Future<User?> call(NoParams params) async => await repo.getUser(params);
}

class EditUserUseCase implements UseCase<User, EditUserParams> {
  @override
  final UserRepo repo;

  EditUserUseCase(this.repo);

  @override
  Future<User> call(EditUserParams params) async => await repo.editUser(params);
}

class VerifyPhoneUseCase implements UseCase<String, VerifyPhoneParams> {
  @override
  final UserRepo repo;

  VerifyPhoneUseCase(this.repo);

  @override
  Future<String> call(VerifyPhoneParams params) async =>
      await repo.verifyPhone(params);
}

class VerifySmsUseCase implements UseCase<User, VerifySmsParams> {
  @override
  final UserRepo repo;

  VerifySmsUseCase(this.repo);

  @override
  Future<User> call(VerifySmsParams params) async =>
      await repo.verifySms(params);
}
