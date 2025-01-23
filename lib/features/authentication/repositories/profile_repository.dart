import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;
import 'package:firebase_storage/firebase_storage.dart';

import '../models/user_model.dart';

class ProfileRepository {
  final fbAuth.FirebaseAuth _firebaseAuth;
  final FirebaseFirestore _firestore;
  final FirebaseStorage _storage;

  ProfileRepository({
    fbAuth.FirebaseAuth? firebaseAuth,
    FirebaseFirestore? firestore,
    FirebaseStorage? storage,
  })  : _firebaseAuth = firebaseAuth ?? fbAuth.FirebaseAuth.instance,
        _firestore = firestore ?? FirebaseFirestore.instance,
        _storage = storage ?? FirebaseStorage.instance;

  Future<void> uploadProfilePicture(String userId, Uint8List file) async {
    try {
      final storageRef = _storage.ref().child('profile_pictures').child(userId);

      final uploadTask = storageRef.putData(file);
      await uploadTask.whenComplete(() => null);
      final downloadUrl = await storageRef.getDownloadURL();

      final signedInUser = _firebaseAuth.currentUser!;
      await signedInUser.updatePhotoURL(downloadUrl);
      await signedInUser.reload();
      print("SignedInUser => $signedInUser");

      await _firestore.collection('users').doc(userId).update({
        'profileImage': downloadUrl,
      });
      final userDoc = await _firestore.collection('users').doc(userId).get();
      print("UserDoc => $userDoc.data()");
    } catch (e) {
      throw Exception('Failed to upload profile picture: $e');
    }
  }

  Future<void> updateProfileName(String userId, String newName) async {
    try {
      final signedInUser = _firebaseAuth.currentUser!;
      await signedInUser.updateDisplayName(newName);
      await signedInUser.reload();

      await _firestore.collection('users').doc(userId).update({
        'name': newName,
      });
    } catch (e) {
      throw Exception('Failed to update profile name: $e');
    }
  }

  Future<User?> getProfileInfo(String userId) async {
    try {
      final userDoc = await _firestore.collection('users').doc(userId).get();

      if (!userDoc.exists) {
        throw Exception('User not found');
      } else {
        final currentUser = User.fromDoc(userDoc);
        return currentUser;
      }
    } catch (e) {
      throw Exception('Failed to get profile info: $e');
    }
  }
}
