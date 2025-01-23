import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';

import 'repositories/auth_repository.dart';

class AuthExampleWidget extends StatelessWidget {
  const AuthExampleWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final authRepository = AuthRepository(
      firebaseAuth: FirebaseAuth.instance,
      googleSignIn: GoogleSignIn(),
    );

    return SafeArea(
      child: Scaffold(
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              ElevatedButton(
                onPressed: () async {
                  try {
                    User? user =
                        await authRepository.signUpWithEmailAndPassword(
                      name: 'user',
                      email: 'newuser@example.com',
                      password: 'password123',
                    );
                    if (user != null) {
                      print(
                          'User signed up \n ${user.email} \n ${user.uid} \n ${user.displayName} \n ${user.photoURL}');
                    }
                  } catch (e) {
                    print('Error signing up: $e');
                  }
                },
                child: const Text('Sign up with Email'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    User? user =
                        await authRepository.signInWithEmailAndPassword(
                      email: 'tzo@gmail.com',
                      password: 'tzo123456',
                    );
                    print(user);
                    if (user != null) {
                      print('User signed in: ${user.email}');
                    }
                  } catch (e) {
                    print('Error signing in: $e');
                  }
                },
                child: const Text('Sign in with Email'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authRepository.signOut();
                    print('User signed out');
                  } catch (e) {
                    print('Error signing out: $e');
                  }
                },
                child: const Text('Sign Out'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    User? user = await authRepository.signInWithGoogle();
                    if (user != null) {
                      print('User signed in with Google: ${user.email}');
                    }
                  } catch (e) {
                    print('Error signing in with Google: $e');
                  }
                },
                child: const Text('Sign in with Google'),
              ),
              ElevatedButton(
                onPressed: () async {
                  try {
                    await authRepository.signOut();
                    print('User signed out from Google');
                  } catch (e) {
                    print('Error signing out from Google: $e');
                  }
                },
                child: const Text('Google Sign Out'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
