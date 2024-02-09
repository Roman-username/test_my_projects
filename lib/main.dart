import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'firebase_options.dart';
import 'presentation/pages/home.dart';
import 'presentation/pages/sign_in/sign_in.dart';
import 'presentation/pages/splash_screen.dart';
import 'styles.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const ProviderScope(child: MyProjects()));
}

class MyProjects extends StatelessWidget {
  const MyProjects({super.key});

  @override
  Widget build(BuildContext context) {
    return ProviderScope(
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(
            seedColor: Colors.transparent,
            primary: kSelectedItemColor,
            surfaceTint: Colors.transparent,
          ),
          scaffoldBackgroundColor: kScaffoldBackground,
          fontFamily: 'SF Pro Text',
          useMaterial3: true,
          inputDecorationTheme: kInputTheme,
          appBarTheme: kAppBarTheme,
        ),
        initialRoute: SplashScreen.routName,
        routes: {
          SplashScreen.routName: (context) => const SplashScreen(),
          SignInPage.routName: (context) => const SignInPage(),
          HomePage.routName: (context) => const HomePage()
        },
      ),
    );
  }
}
