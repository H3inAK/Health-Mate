import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../../../screens/home_screen.dart';
import '../blocs.dart';
import '../utils/error_dialog.dart';
import '../widgets/custom_button.dart';
import '../widgets/google_sign_in_button.dart';
import 'forgot_password_screen.dart';
import 'signup_screen.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  static const routeName = '/signin-screen';

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  String? email, password;

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  bool _rememberMe = false;

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  void _saveForm() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = _formKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    _formKey.currentState!.save();
    await context
        .read<SigninCubit>()
        .signin(email: email!, password: password!);
  }

  @override
  void initState() {
    controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );

    fadeAnimation = CurvedAnimation(
      parent: controller,
      curve: Curves.easeIn,
    );

    slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.1),
      end: Offset.zero,
    ).animate(CurvedAnimation(
      parent: controller,
      curve: Curves.easeInOut,
    ));

    controller.forward();

    super.initState();
  }

  @override
  void dispose() {
    controller.dispose();
    emailController.dispose();
    passwordController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Theme.of(context).brightness == Brightness.dark
          ? Brightness.light
          : Brightness.dark,
      statusBarBrightness:
          !kIsWeb && Platform.isAndroid ? Brightness.light : Brightness.dark,
      systemNavigationBarColor: Theme.of(context).brightness == Brightness.dark
          ? AdaptiveTheme.of(context).darkTheme.scaffoldBackgroundColor
          : AdaptiveTheme.of(context).lightTheme.scaffoldBackgroundColor,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.dark,
    ));
    final size = MediaQuery.of(context).size;

    return PopScope(
      canPop: true,
      child: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: BlocConsumer<SigninCubit, SigninState>(
          listener: (context, state) {
            if (state.signinStatus == SigninStatus.error) {
              errorDialog(context, state.error);
            }
          },
          builder: (context, state) {
            return BlocConsumer<AuthBloc, AuthState>(
              listener: (context, authState) {
                if (authState.authStatus == AuthStatus.authenticated) {
                  Navigator.of(context)
                      .pushReplacementNamed(HomeScreen.routeName);
                }
              },
              builder: (context, authState) {
                return Scaffold(
                  backgroundColor: Theme.of(context)
                      .scaffoldBackgroundColor
                      .withOpacity(0.96),
                  body: Center(
                    child: SingleChildScrollView(
                      physics: const BouncingScrollPhysics(),
                      child: Padding(
                        padding: EdgeInsets.only(
                          top: MediaQuery.of(context).padding.top + 20,
                          left: MediaQuery.of(context).size.width * 0.09,
                          right: MediaQuery.of(context).size.width * 0.09,
                          bottom: 20,
                        ),
                        child: AnimatedBuilder(
                          animation: controller,
                          builder: (context, child) => FadeTransition(
                            opacity: fadeAnimation,
                            child: SlideTransition(
                              position: slideAnimation,
                              child: child,
                            ),
                          ),
                          child: Form(
                            key: _formKey,
                            autovalidateMode: autovalidateMode,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Login to Your Account",
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xFF0D120E)
                                        : null,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 24,
                                    letterSpacing: 0.5,
                                  ),
                                ),
                                Text(
                                  "To continue with Health Mate",
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xFF0D120E)
                                        : null,
                                    fontSize: 16,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/login.png',
                                  width: 200,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 20),
                                Container(
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
                                  decoration: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 18,
                                            offset: const Offset(1, 2),
                                          ),
                                        ])
                                      : null,
                                  child: TextFormField(
                                    controller: emailController,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.mail_rounded,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black45
                                            : null,
                                      ),
                                      labelText: 'Email',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: 'Enter account email',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : null,
                                      ),
                                      fillColor: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : null,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    keyboardType: TextInputType.emailAddress,
                                    validator: _validateEmail,
                                    onSaved: (newValue) {
                                      setState(() {
                                        email = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                Container(
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
                                  decoration: Theme.of(context).brightness ==
                                          Brightness.light
                                      ? BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.2),
                                            spreadRadius: 1,
                                            blurRadius: 18,
                                            offset: const Offset(1, 2),
                                          ),
                                        ])
                                      : null,
                                  child: TextFormField(
                                    controller: passwordController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        size: 26,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black45
                                            : null,
                                      ),
                                      labelText: 'Password',
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
                                      hintText: 'Enter account password',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : null,
                                      ),
                                      fillColor: Theme.of(context).brightness ==
                                              Brightness.light
                                          ? Colors.white
                                          : null,
                                      filled: true,
                                      border: const OutlineInputBorder(
                                        borderSide: BorderSide.none,
                                        borderRadius: BorderRadius.all(
                                          Radius.circular(8.0),
                                        ),
                                      ),
                                    ),
                                    obscureText: true,
                                    onSaved: (newValue) {
                                      setState(() {
                                        password = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 24),
                                SizedBox(
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
                                  child: Row(
                                    children: <Widget>[
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (value) {
                                          setState(() {
                                            _rememberMe = value!;
                                          });
                                        },
                                      ),
                                      const Text('Remember me'),
                                      const Spacer(),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pushNamed(
                                            ForgotPasswordScreen.routeName,
                                          );
                                        },
                                        child: Text(
                                          'Forgot Password?',
                                          style: TextStyle(
                                            color: Theme.of(context)
                                                .colorScheme
                                                .primary,
                                            fontWeight: FontWeight.bold,
                                          ),
                                          overflow: TextOverflow.visible,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                const SizedBox(height: 24),
                                CustomButton(
                                  onPressed: state.signinStatus ==
                                          SigninStatus.submitting
                                      ? null
                                      : _saveForm,
                                  width: 240,
                                  height: 55,
                                  elevation: 16,
                                  borderRadius: BorderRadius.circular(32),
                                  child: Text(
                                    state.signinStatus ==
                                            SigninStatus.submitting
                                        ? 'Loading...'
                                        : 'Login',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: Colors.white,
                                      fontSize: 17,
                                      fontWeight: FontWeight.w500,
                                      letterSpacing: 0.8,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Text('Don\'t have an account?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          SignUpScreen.routeName,
                                        );
                                      },
                                      child: const Text('Signup'),
                                    ),
                                  ],
                                ),
                                if (Platform.isAndroid ||
                                    Platform.isIOS ||
                                    kIsWeb)
                                  const Text(
                                    'OR',
                                    textAlign: TextAlign.center,
                                  ),
                                if (Platform.isAndroid ||
                                    Platform.isIOS ||
                                    kIsWeb)
                                  const SizedBox(height: 10),
                                if (Platform.isAndroid ||
                                    Platform.isIOS ||
                                    kIsWeb)
                                  GoogleSignInButton(
                                    onClick: state.signinStatus ==
                                            SigninStatus.submitting
                                        ? null
                                        : () async {
                                            await context
                                                .read<SigninCubit>()
                                                .signinWithGoogle();
                                          },
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
