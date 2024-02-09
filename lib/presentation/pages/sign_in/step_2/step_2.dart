import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../styles.dart';
import '../../../notifiers/notifiers.dart';
import '../widgets.dart';
import 'widgets.dart';

class Step2 extends ConsumerWidget {
  const Step2({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final smsParams = ref.watch(verifySmsParamsNotifierProvider);
    final phoneParams = ref.watch(verifyPhoneParamsNotifierProvider);
    final phone = phoneParams.phoneNumber;
    final user = ref.watch(userNotifierProvider);
    final isLoading = user.isLoading;
    if (user.value != null) {
      WidgetsBinding.instance.addPostFrameCallback(
          (d) => ref.read(signInStepIdxNotifierProvider.notifier).increment());
    }
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        StepHeader(
          title: 'Подтверждение',
          subtitle: 'Введите код, который мы отправили \nв SMS на $phone',
        ),
        const SizedBox(height: 24),
        if (isLoading)
          const Center(
            child: CupertinoActivityIndicator(
              color: kSignInPrimaryColor,
              radius: 25,
            ),
          )
        else ...[
          const PinCodeField(),
          const SizedBox(height: 24),
        ],
        const ResetSmsButton(),
      ],
    );
  }
}
