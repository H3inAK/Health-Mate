import 'dart:io';

import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:healthmate/screens/home_screen.dart';

import '../widgets/custom_button.dart';
import '../blocs.dart';
import '../utils/error_dialog.dart';
import '../widgets/google_sign_in_button.dart';
import 'signin_screen.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  static const routeName = '/signup-screen';

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen>
    with SingleTickerProviderStateMixin {
  final GlobalKey<FormState> _singUpFormKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();

  AutovalidateMode autovalidateMode = AutovalidateMode.disabled;
  String? name, email, password;
  bool visiblePassword = false;
  bool visiblePassword1 = false;
  bool confirmPasswordError = false;

  late AnimationController controller;
  late Animation<double> fadeAnimation;
  late Animation<Offset> slideAnimation;

  String? _validateName(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your name';
    }
    return null;
  }

  String? _validateEmail(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your email';
    }
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return 'Please enter a valid email address';
    }
    return null;
  }

  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter your password';
    }
    if (value.length < 8) {
      return 'Password must be at least 8 characters long';
    }
    if (!RegExp(r'(?=.*?[A-Z])').hasMatch(value)) {
      return 'Password must contain at least one uppercase letter';
    }
    if (!RegExp(r'(?=.*?[!@#\$&*~])').hasMatch(value)) {
      return 'Password must contain at least one special character';
    }
    return null;
  }

  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please confirm your password';
    }
    if (value != passwordController.text) {
      return 'Passwords do not match';
    }
    return null;
  }

  String? _checkPasswordsMatch(String? value) {
    if (value! != passwordController.text) {
      setState(() {
        confirmPasswordError = true;
      });

      return 'Passwords do not match';
    } else {
      setState(() {
        confirmPasswordError = false;
      });

      return null;
    }
  }

  void _saveForm() async {
    setState(() {
      autovalidateMode = AutovalidateMode.always;
    });

    final form = _singUpFormKey.currentState;
    if (form == null || !form.validate()) {
      return;
    }

    _singUpFormKey.currentState!.save();
    await context
        .read<SignupCubit>()
        .signup(name: name!, email: email!, password: password!);
  }

  @override
  void initState() {
    controller = AnimationController(
      duration: const Duration(milliseconds: 640),
      vsync: this,
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
    nameController.dispose();
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
        child: BlocConsumer<SignupCubit, SignupState>(
          listener: (context, state) {
            if (state.signupStatus == SignupStatus.error) {
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
                        padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                            key: _singUpFormKey,
                            autovalidateMode: autovalidateMode,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  "Register Your Account",
                                  style: GoogleFonts.getFont(
                                    'Poppins',
                                    color: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? const Color(0xFF0D120E)
                                        : const Color(0xFFFFFFFF),
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
                                        : const Color(0xFFFFFFFF),
                                    fontSize: 16,
                                    letterSpacing: 0.2,
                                  ),
                                ),
                                Image.asset(
                                  'assets/images/login.png',
                                  width: size.width * 0.35,
                                  fit: BoxFit.cover,
                                ),
                                const SizedBox(height: 22.0),
                                SizedBox(
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
                                  child: Container(
                                    decoration: Theme.of(context).brightness ==
                                            Brightness.light
                                        ? BoxDecoration(boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.2),
                                              spreadRadius: 1,
                                              blurRadius: 18,
                                              offset: const Offset(1, 2),
                                            ),
                                          ])
                                        : BoxDecoration(boxShadow: [
                                            BoxShadow(
                                              color:
                                                  Colors.grey.withOpacity(0.1),
                                              spreadRadius: 1,
                                              blurRadius: 14,
                                              offset: const Offset(1, 2),
                                            ),
                                          ]),
                                    child: TextFormField(
                                      controller: nameController,
                                      keyboardType: TextInputType.name,
                                      textInputAction: TextInputAction.next,
                                      decoration: InputDecoration(
                                        prefixIcon: Icon(
                                          Icons.person,
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black54
                                              : null,
                                        ),
                                        labelText: 'Full Name',
                                        hintText: 'Enter full name',
                                        fillColor:
                                            Theme.of(context).brightness ==
                                                    Brightness.light
                                                ? Colors.white
                                                : null,
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        filled: true,
                                        border: const OutlineInputBorder(
                                          borderSide: BorderSide.none,
                                          borderRadius: BorderRadius.all(
                                            Radius.circular(8.0),
                                          ),
                                        ),
                                      ),
                                      validator: _validateName,
                                      onSaved: (newValue) {
                                        setState(() {
                                          name = newValue;
                                        });
                                      },
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Container(
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
                                      : BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 14,
                                            offset: const Offset(1, 2),
                                          ),
                                        ]),
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
                                  child: TextFormField(
                                    controller: emailController,
                                    keyboardType: TextInputType.emailAddress,
                                    textInputAction: TextInputAction.next,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.email,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : null,
                                      ),
                                      labelText: 'Email',
                                      hintText: 'Enter account email',
                                      hintStyle: TextStyle(
                                          color: Theme.of(context).brightness ==
                                                  Brightness.light
                                              ? Colors.black54
                                              : null),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                    validator: _validateEmail,
                                    onSaved: (newValue) {
                                      setState(() {
                                        email = newValue;
                                      });
                                    },
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Container(
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
                                      : BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 14,
                                            offset: const Offset(1, 2),
                                          ),
                                        ]),
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
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
                                      hintText: 'Enter account password',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : null,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () => setState(() {
                                              visiblePassword =
                                                  !visiblePassword;
                                            }),
                                            icon: visiblePassword
                                                ? const Icon(
                                                    Icons.visibility_off)
                                                : const Icon(Icons.visibility),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      ),
                                    ),
                                    obscureText: !visiblePassword,
                                    onSaved: (newValue) => setState(() {
                                      password = newValue;
                                    }),
                                    validator: _validatePassword,
                                  ),
                                ),
                                const SizedBox(height: 20.0),
                                Container(
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
                                      : BoxDecoration(boxShadow: [
                                          BoxShadow(
                                            color: Colors.grey.withOpacity(0.1),
                                            spreadRadius: 1,
                                            blurRadius: 14,
                                            offset: const Offset(1, 2),
                                          ),
                                        ]),
                                  width: Platform.isWindows || kIsWeb
                                      ? size.width * 0.75
                                      : size.width * 0.8,
                                  child: TextFormField(
                                    controller: confirmPasswordController,
                                    decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.lock,
                                        size: 26,
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black45
                                            : null,
                                      ),
                                      labelText: 'Confirm Password',
                                      hintText: 'Confirm account password',
                                      hintStyle: TextStyle(
                                        color: Theme.of(context).brightness ==
                                                Brightness.light
                                            ? Colors.black54
                                            : null,
                                      ),
                                      floatingLabelBehavior:
                                          FloatingLabelBehavior.always,
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
                                      suffixIcon: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          IconButton(
                                            onPressed: () => setState(() {
                                              visiblePassword1 =
                                                  !visiblePassword1;
                                            }),
                                            icon: visiblePassword1
                                                ? const Icon(
                                                    Icons.visibility_off)
                                                : const Icon(Icons.visibility),
                                          ),
                                          const SizedBox(width: 12),
                                        ],
                                      ),
                                      errorText: confirmPasswordError
                                          ? "Password doesn't match"
                                          : null,
                                    ),
                                    obscureText: !visiblePassword1,
                                    onChanged: _checkPasswordsMatch,
                                    validator: _validateConfirmPassword,
                                  ),
                                ),
                                const SizedBox(height: 24.0),
                                CustomButton(
                                  onPressed: state.signupStatus ==
                                          SignupStatus.submitting
                                      ? null
                                      : _saveForm,
                                  width: 240,
                                  height: 50,
                                  elevation: 8,
                                  borderRadius: BorderRadius.circular(32),
                                  child: Text(
                                    state.signupStatus ==
                                            SignupStatus.submitting
                                        ? 'Loading...'
                                        : 'Create Account',
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      color: Colors.white,
                                      fontSize: 15,
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
                                    const Text('Already have an account?'),
                                    TextButton(
                                      onPressed: () {
                                        Navigator.of(context)
                                            .pushReplacementNamed(
                                          SignInScreen.routeName,
                                        );
                                      },
                                      child: const Text('Log In'),
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
                                    onClick: state.signupStatus ==
                                            SignupStatus.submitting
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
