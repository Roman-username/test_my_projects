import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../styles.dart';
import '../notifiers/notifiers.dart';
import 'home.dart';
import 'sign_in/sign_in_page.dart';

class SplashScreen extends ConsumerWidget {
  static String routName = 'splash';

  const SplashScreen({super.key});

  void showErrorSnackBar(BuildContext context, String text) =>
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(text)));

  void goTo(BuildContext context, String routName) =>
      WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
        Navigator.pushReplacementNamed(context, routName);
      });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    ref.listen(userNotifierProvider, (previous, next) {
      switch (next) {
        case AsyncLoading():
          return;
        case AsyncError(:final error):
          showErrorSnackBar(context, error.toString());
        case AsyncData() when next.value == null:
          goTo(context, SignInPage.routName);
        case AsyncData() when next.value != null:
          goTo(context, HomePage.routName);
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
