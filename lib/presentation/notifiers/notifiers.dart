import 'dart:async';
import 'dart:io';

import 'package:riverpod_annotation/riverpod_annotation.dart';

import '../../domain/entities.dart';
import '../../domain/params.dart';
import '../../domain/use_cases.dart';
import '../../injection_container.dart';

part 'notifiers.g.dart';

@Riverpod(keepAlive: true)
class UserNotifier extends _$UserNotifier {
  late final GetUserUseCase _getUserUseCase;
  late final EditUserUseCase _editUserUseCase;
  late final VerifyPhoneUseCase _verifyPhoneUseCase;
  late final VerifySmsUseCase _verifySmsUseCase;

  @override
  Future<User?> build() {
    _getUserUseCase = ref.watch(getUserUseCaseProvider);
    _verifyPhoneUseCase = ref.watch(verifyPhoneUseCaseProvider);
    _verifySmsUseCase = ref.watch(verifySmsUseCaseProvider);
    _editUserUseCase = ref.watch(editUserUseCaseProvider);
    return getUser();
  }

  Future<User?> getUser() async => await _getUserUseCase(NoParams());

  Future<void> editUser() async {
    final params = ref.read(editUserParamsNotifierProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _editUserUseCase(params));
  }

  Future<void> verifyPhone() async {
    state = const AsyncValue.loading();
    final params = ref.read(verifyPhoneParamsNotifierProvider);
    try {
      final verificationId = await _verifyPhoneUseCase(params);
      ref.read(verifySmsParamsNotifierProvider.notifier).id = verificationId;
      state = await AsyncValue.guard(() async => await getUser());
    } catch (e, st) {
      state = AsyncError(e, st);
    }
  }

  Future<void> verifySms() async {
    final params = ref.read(verifySmsParamsNotifierProvider);
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async => await _verifySmsUseCase(params));
  }

  void setError(String message) =>
      state = AsyncError(Exception(message), StackTrace.empty);
}

@riverpod
class EditUserParamsNotifier extends _$EditUserParamsNotifier {
  @override
  EditUserParams build() => const EditUserParams();

  void setField({
    String? name,
    String? lastName,
    String? email,
    File? photo,
  }) =>
      state = EditUserParams(
          name: name ?? state.name,
          lastName: lastName ?? state.lastName,
          email: email ?? state.email,
          photo: photo ?? state.photo);
}

@riverpod
class VerifyPhoneParamsNotifier extends _$VerifyPhoneParamsNotifier {
  @override
  VerifyPhoneParams build() => const VerifyPhoneParams(phoneNumber: '');

  set phone(String phone) => state = VerifyPhoneParams(phoneNumber: phone);
}

@riverpod
class VerifySmsParamsNotifier extends _$VerifySmsParamsNotifier {
  @override
  VerifySmsParams build() =>
      const VerifySmsParams(smsCode: '', verificationId: '');

  set sms(String sms) => state = VerifySmsParams(
        smsCode: sms,
        verificationId: state.verificationId,
      );

  set id(String id) => state = VerifySmsParams(
        smsCode: state.smsCode,
        verificationId: id,
      );
}

@riverpod
class SignInStepIdxNotifier extends _$SignInStepIdxNotifier {
  @override
  int build() => 0;

  void increment() => state++;

  void decrement() => state--;
}
