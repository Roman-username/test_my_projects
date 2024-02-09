import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

import '../../../../styles.dart';
import '../../../notifiers/notifiers.dart';

class ResetSmsButton extends ConsumerStatefulWidget {
  const ResetSmsButton({super.key});

  @override
  ConsumerState createState() => _ResetSmsTimerState();
}

class _ResetSmsTimerState extends ConsumerState<ResetSmsButton> {
  Timer? _timer;
  int _start = 60;

  void startTimer() {
    setState(() => _start = 60);
    _timer = Timer.periodic(
      const Duration(seconds: 1),
      (Timer timer) {
        if (_start == 0) {
          setState(() => timer.cancel());
        } else {
          setState(() => _start--);
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    ref.listen(signInStepIdxNotifierProvider, (previous, next) {
      if (previous == 0 && next == 1) startTimer();
    });
    return _start != 0
        ? Text(
            '$_start сек до повтора отправки кода',
            style: kSignInStepSubTitleStyle,
          )
        : TextButton(
            onPressed: () async {
              ref.read(verifySmsParamsNotifierProvider.notifier).sms = '';
              ref.read(userNotifierProvider.notifier).verifyPhone();
              startTimer();
            },
            child: const Text(
              'Отправить код еще раз',
              style: TextStyle(fontSize: 15, color: kSignInPrimaryColor),
            ),
          );
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

class PinCodeField extends ConsumerStatefulWidget {
  const PinCodeField({super.key});

  @override
  ConsumerState<PinCodeField> createState() => _PinCodeFieldState();
}

class _PinCodeFieldState extends ConsumerState<PinCodeField> {
  final _focusNode = FocusNode();

  @override
  Widget build(BuildContext context) {
    ref.listen(signInStepIdxNotifierProvider, (previous, next) {
      if (previous == 0 && next == 1) {
        _focusNode.requestFocus();
      }
    });
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35),
      child: PinCodeTextField(
        keyboardType: TextInputType.number,
        appContext: context,
        length: 6,
        focusNode: _focusNode,
        pinTheme: PinTheme(
            activeColor: const Color(0xFFA7A7A7),
            selectedColor: const Color(0xFFA7A7A7),
            inactiveColor: const Color(0xFFA7A7A7),
            fieldWidth: 35),
        textStyle: const TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          fontFamily: 'SF Pro Display',
        ),
        dialogConfig: DialogConfig(
            dialogTitle: 'Вставка кода',
            dialogContent: 'Вы хотите вставить код:  ',
            affirmativeText: 'Вставить',
            negativeText: 'Отмена'),
        onCompleted: (v) {
          if (ref.read(verifySmsParamsNotifierProvider).smsCode.isNotEmpty) {
            ref
                .read(userNotifierProvider.notifier)
                .setError('Дождитесь повторной отправки смс');
          } else {
            ref.read(verifySmsParamsNotifierProvider.notifier).sms = v;
            ref.read(userNotifierProvider.notifier).verifySms();
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    super.dispose();
    _focusNode.dispose();
  }
}
