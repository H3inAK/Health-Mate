import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../screens/home_screen.dart';
import '../../onboarding/data_persistence.dart';
import '../../onboarding/onborading_screen.dart';
import '../blocs/auth/auth_bloc.dart';
import 'signin_screen.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  static const String routeName = '/';

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));

    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) async {
        if (SharedPrefsKeys.isAppFirstTimeLaunched) {
          await SharedPrefsKeys.setAppFirstTimeLaunched(false);

          // ignore: use_build_context_synchronously
          Navigator.of(context)
              .pushReplacementNamed(OnBoardingScreen.routeName);
        } else if (state.authStatus == AuthStatus.unauthenticated) {
          Navigator.of(context).pushReplacementNamed(SignInScreen.routeName);
        } else if (state.authStatus == AuthStatus.authenticated) {
          Navigator.of(context).pushReplacementNamed(HomeScreen.routeName);
        }
      },
      builder: (context, state) {
        return SafeArea(
          child: Scaffold(
            appBar: AppBar(
              elevation: 0,
            ),
            body: const Center(
              child: CircularProgressIndicator(),
            ),
          ),
        );
      },
    );
  }
}
