import 'dart:io';

abstract class Params {}

class NoParams implements Params {}

class VerifyPhoneParams implements Params {
  final String phoneNumber;

  const VerifyPhoneParams({required this.phoneNumber});
}

class VerifySmsParams implements Params {
  final String smsCode;
  final String verificationId;

  const VerifySmsParams({
    required this.smsCode,
    required this.verificationId,
  });
}

class EditUserParams implements Params {
  final String? name;
  final String? lastName;
  final String? email;
  final File? photo;

  const EditUserParams({
    this.name,
    this.lastName,
    this.photo,
    this.email,
  });
}
