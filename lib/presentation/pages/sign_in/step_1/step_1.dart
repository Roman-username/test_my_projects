import 'package:flutter/material.dart';

import '../widgets.dart';
import 'widgets.dart';

class Step1 extends StatelessWidget {
  const Step1({super.key});

  @override
  Widget build(BuildContext context) {
    return const Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StepHeader(
          title: 'Регистрация',
          subtitle: 'Введите номер телефона \nдля регистрации',
        ),
        SizedBox(height: 36),
        PhoneFlied(),
        SizedBox(height: 120),
        SendSmsButton(),
      ],
    );
  }
}
