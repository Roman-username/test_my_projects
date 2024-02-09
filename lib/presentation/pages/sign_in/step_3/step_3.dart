import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../styles.dart';
import '../../../../validators.dart';
import '../../../notifiers/notifiers.dart';
import '../../home.dart';
import '../widgets.dart';

class Step3 extends ConsumerStatefulWidget {
  const Step3({super.key});

  @override
  ConsumerState<Step3> createState() => _Step3State();
}

class _Step3State extends ConsumerState<Step3> {
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(userNotifierProvider).value;
    final name = user?.name;
    final lastName = user?.lastName;
    if (name != null &&
        name.isNotEmpty &&
        lastName != null &&
        lastName.isNotEmpty) {
      Navigator.pushReplacementNamed(context, 'home');
    }
    return Form(
      key: _formKey,
      child: Column(
        children: [
          const StepHeader(title: 'Регистрация'),
          LabeledTextField(
            label: 'Имя',
            onChanged: (v) => ref
                .watch(editUserParamsNotifierProvider.notifier)
                .setField(name: v),
            validator: nameValidator,
          ),
          const SizedBox(height: 8),
          LabeledTextField(
            label: 'Фамилия',
            onChanged: (v) => ref
                .watch(editUserParamsNotifierProvider.notifier)
                .setField(lastName: v),
            validator: nameValidator,
          ),
          const SizedBox(height: 24),
          FilledButton(
            onPressed: () {
              if (_formKey.currentState!.validate()) {
                ref.read(userNotifierProvider.notifier).editUser();
                Navigator.pushReplacementNamed(context, HomePage.routName);
              }
            },
            style: FilledButton.styleFrom(
              padding: const EdgeInsets.symmetric(horizontal: 68, vertical: 16),
              backgroundColor: kSignInPrimaryColor,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
            child: const Text(
              'Сохранить',
              style: TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }
}
