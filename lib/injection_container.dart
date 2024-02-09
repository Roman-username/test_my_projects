import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'data/data_sources.dart';
import 'data/repos.dart';
import 'domain/repos.dart';
import 'domain/use_cases.dart';

part 'injection_container.g.dart';

@Riverpod(keepAlive: true)
UserRepo userRepo(UserRepoRef ref) =>
    UserRepoImpl(userFirebaseDataSource: UserFirebaseDataSource());

@Riverpod(keepAlive: true)
GetUserUseCase getUserUseCase(GetUserUseCaseRef ref) {
  final repository = ref.watch(userRepoProvider);
  return GetUserUseCase(repository);
}

@Riverpod(keepAlive: true)
EditUserUseCase editUserUseCase(EditUserUseCaseRef ref) {
  final repository = ref.watch(userRepoProvider);
  return EditUserUseCase(repository);
}

@Riverpod(keepAlive: true)
VerifyPhoneUseCase verifyPhoneUseCase(VerifyPhoneUseCaseRef ref) {
  final repository = ref.watch(userRepoProvider);
  return VerifyPhoneUseCase(repository);
}

@Riverpod(keepAlive: true)
VerifySmsUseCase verifySmsUseCase(VerifySmsUseCaseRef ref) {
  final repository = ref.watch(userRepoProvider);
  return VerifySmsUseCase(repository);
}
