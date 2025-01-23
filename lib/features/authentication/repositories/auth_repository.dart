import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:flutter/foundation.dart';
import 'package:google_sign_in/google_sign_in.dart';

import '../models/custom_error.dart';

final userRef = FirebaseFirestore.instance.collection('users');

class AuthRepository {
  final fbAuth.FirebaseAuth _firebaseAuth;
  final GoogleSignIn _googleSignIn;

  AuthRepository({
    fbAuth.FirebaseAuth? firebaseAuth,
    GoogleSignIn? googleSignIn,
  })  : _firebaseAuth = firebaseAuth ?? fbAuth.FirebaseAuth.instance,
        _googleSignIn = googleSignIn ?? GoogleSignIn();

  Stream<fbAuth.User?> get user => _firebaseAuth.userChanges();

  fbAuth.User? get userCredential => _firebaseAuth.currentUser;

  Future<fbAuth.User?> signUpWithEmailAndPassword({
    required String name,
    required String email,
    required String password,
    String? gender,
  }) async {
    try {
      fbAuth.UserCredential userCredential =
          await _firebaseAuth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      gender = gender ?? 'unknown';

      final signedInUser = userCredential.user!;
      final currentUser = _firebaseAuth.currentUser!;
      await currentUser.updateDisplayName(name);
      await currentUser.reload();
      await currentUser.updatePhotoURL(signedInUser.photoURL ??
          'https://st.depositphotos.com/1779253/5140/v/600/depositphotos_51405259-stock-illustration-male-avatar-profile-picture-use.jpg');
      await currentUser.reload();

      print("Display Name : ${currentUser.displayName}");
      print("Display Name : ${signedInUser.displayName}");

      final userInfo = {
        'name': signedInUser.displayName ?? name,
        'email': signedInUser.email,
        'profileImage': signedInUser.photoURL,
        'gender': gender,
        'isEmailVerified': signedInUser.emailVerified,
        'creationTime': signedInUser.metadata.creationTime.toString(),
        'lastSignInTime': signedInUser.metadata.lastSignInTime.toString(),
      };

      await userRef
          .doc(signedInUser.uid)
          .set(userInfo, SetOptions(merge: true));
      await _firebaseAuth.currentUser?.reload();
      return signedInUser;
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<fbAuth.User?> signInWithEmailAndPassword(
      {required String email, required String password}) async {
    try {
      fbAuth.UserCredential userCredential =
          await _firebaseAuth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      final signedInUser = userCredential.user!;
      final userInfo = {
        'isEmailVerified': signedInUser.emailVerified,
        'lastSignInTime': signedInUser.metadata.lastSignInTime.toString(),
      };

      await userRef
          .doc(signedInUser.uid)
          .set(userInfo, SetOptions(merge: true));
      return signedInUser;
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> signOut() async {
    try {
      if (Platform.isAndroid || Platform.isIOS || kIsWeb) {
        await _googleSignIn.signOut();
      }
      await _firebaseAuth.signOut(); // Sign out from Firebase
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<fbAuth.User?> signInWithGoogle() async {
    try {
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();
      if (googleUser == null) {
        return null;
      }
      final GoogleSignInAuthentication googleAuth =
          await googleUser.authentication;
      final fbAuth.AuthCredential credential =
          fbAuth.GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      fbAuth.UserCredential userCredential =
          await _firebaseAuth.signInWithCredential(credential);
      final signedInUser = userCredential.user!;

      final userDoc = await userRef.doc(signedInUser.uid).get();
      final photoUrl = userDoc.data()?['profileImage'];
      print(photoUrl);

      final userInfo = {
        'name': signedInUser.displayName,
        'email': signedInUser.email,
        'profileImage': photoUrl ?? signedInUser.photoURL,
        'gender': 'unknown',
        'isEmailVerified': signedInUser.emailVerified,
        'creationTime': signedInUser.metadata.creationTime.toString(),
        'lastSignInTime': signedInUser.metadata.lastSignInTime.toString(),
      };

      await userRef
          .doc(signedInUser.uid)
          .set(userInfo, SetOptions(merge: true));

      return userCredential.user;
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }

  Future<void> resetPassword({required String email}) async {
    try {
      await _firebaseAuth.sendPasswordResetEmail(email: email);
    } on fbAuth.FirebaseAuthException catch (e) {
      throw CustomError(
        code: e.code,
        message: e.message!,
        plugin: e.plugin,
      );
    } catch (e) {
      throw CustomError(
        code: 'Exception',
        message: e.toString(),
        plugin: 'flutter_error/server_error',
      );
    }
  }
}
