import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

import '../repositories/auth_repository.dart';
import '../widgets/custom_button.dart';

class ForgotPasswordScreen extends StatelessWidget {
  static const routeName = '/forgor-password-screen';

  final TextEditingController _emailController = TextEditingController();

  ForgotPasswordScreen({super.key});

  void _resetPassword(BuildContext context) async {
    String email = _emailController.text.trim();

    if (email == '') {
      return;
    }

    try {
      await context.read<AuthRepository>().resetPassword(email: email);
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Password reset email sent to \n$email'),
        ),
      );
    } catch (e) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to send password reset email: \n$e'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Forgot Password'),
        elevation: 0,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24.0, horizontal: 32.0),
        child: Column(
          children: [
            Container(
              decoration: Theme.of(context).brightness == Brightness.light
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
              child: TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  hintText: 'Enter your account email',
                  fillColor: Theme.of(context).brightness == Brightness.light
                      ? Colors.white
                      : null,
                  filled: true,
                  border: const OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(Radius.circular(8.0)),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 30),
            CustomButton(
              onPressed: () => _resetPassword(context),
              width: 270,
              height: 52,
              elevation: 12,
              child: Text(
                "Send Password Reset Link",
                style: GoogleFonts.getFont(
                  'Lato',
                  color: Colors.white,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  letterSpacing: 0.8,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
