import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../styles.dart';
import '../../notifiers/notifiers.dart';
import 'widgets.dart';

class MyAccount extends ConsumerWidget {
  const MyAccount({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isLoading = ref.watch(userNotifierProvider).isLoading;
    return Scaffold(
      appBar: AppBar(
        title: const Text('Аккаунт'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(
            color: Colors.black.withOpacity(0.3),
            height: 1.0,
          ),
        ),
      ),
      body: Stack(children: [
        const Column(
          children: [
            SizedBox(height: 24),
            AvatarButton(),
            SizedBox(height: 12),
            EmailField(),
            SizedBox(height: 24),
            UserFieldListTiles(),
          ],
        ),
        if (isLoading)
          Container(
            color: Colors.black.withOpacity(0.1),
            width: double.infinity,
            height: double.infinity,
            child: const Center(
              child: CupertinoActivityIndicator(
                color: kSignInPrimaryColor,
                radius: 25,
              ),
            ),
          )
      ]),
    );
  }
}
