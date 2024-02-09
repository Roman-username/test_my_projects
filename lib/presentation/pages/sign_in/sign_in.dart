import 'package:easy_stepper/easy_stepper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../styles.dart';
import '../../notifiers/notifiers.dart';
import 'step_1/step_1.dart';
import 'step_2/step_2.dart';
import 'step_3/step_3.dart';

class SignInPage extends ConsumerWidget {
  static String routName = 'sing_in';

  const SignInPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    int index = ref.watch(signInStepIdxNotifierProvider);
    ref.listen(userNotifierProvider, (previous, next) {
      if (next is AsyncError) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error.toString(), textAlign: TextAlign.center),
            margin: const EdgeInsets.symmetric(
              vertical: 300,
              horizontal: 16,
            ),
            duration: const Duration(seconds: 2),
            behavior: SnackBarBehavior.floating,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        );
      }
    });
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: index == 1
            ? IconButton(
                icon: const Icon(CupertinoIcons.chevron_left),
                onPressed: () => ref
                    .read(signInStepIdxNotifierProvider.notifier)
                    .decrement(),
              )
            : const SizedBox(),
        backgroundColor: Colors.white,
      ),
      body: SafeArea(
        child: Column(
          children: [
            Stepper(index),
            const SizedBox(height: 24),
            Flexible(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: IndexedStack(
                  alignment: AlignmentDirectional.topCenter,
                  index: index,
                  children: const [
                    Step1(),
                    Step2(),
                    Step3(),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}

class Stepper extends StatelessWidget {
  final int _curIndex;
  const Stepper(this._curIndex, {super.key});

  @override
  Widget build(BuildContext context) {
    return EasyStepper(
      activeStep: _curIndex,
      disableScroll: true,
      alignment: Alignment.topCenter,
      internalPadding: 0,
      stepRadius: 25,
      borderThickness: 1,
      defaultStepBorderType: BorderType.normal,
      enableStepTapping: false,
      showLoadingAnimation: false,
      showTitle: false,
      activeStepBackgroundColor: kSignInPrimaryColor,
      activeStepBorderColor: kSignInPrimaryColor,
      unreachedStepBackgroundColor: const Color(0xFFECECEC),
      unreachedStepBorderColor: const Color(0xFFECECEC),
      finishedStepBackgroundColor: Colors.white,
      finishedStepBorderColor: const Color(0xFF39A314),
      lineStyle: const LineStyle(
        lineType: LineType.normal,
        defaultLineColor: Color(0xFFECECEC),
      ),
      steps: List.generate(
        3,
        (index) => EasyStep(
          customStep: _curIndex <= index
              ? Text(
                  (index + 1).toString(),
                  style: const TextStyle(
                      fontSize: 15, fontWeight: FontWeight.w400),
                )
              : const Icon(Icons.done, size: 20, color: Color(0xFF39A314)),
        ),
      ),
    );
  }
}
