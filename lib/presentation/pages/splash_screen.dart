import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import '../notifiers/notifiers.dart';
import 'home.dart';
import 'sign_in/sign_in.dart';

class SplashScreen extends ConsumerWidget {
  static String routName = 'splash';

  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      if (ref.read(userNotifierProvider).value == null) {
        Navigator.pushReplacementNamed(context, SignInPage.routName);
      } else {
        Navigator.pushReplacementNamed(context, HomePage.routName);
      }
    });
    return const Scaffold(
      body: Center(
        child: CupertinoActivityIndicator(
          color: kSignInPrimaryColor,
          radius: 25,
        ),
      ),
    );
  }
}
