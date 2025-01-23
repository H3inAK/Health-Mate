// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String name;
  final String email;
  final String profileImage;
  final String gender;
  const User({
    required this.id,
    required this.name,
    required this.email,
    required this.profileImage,
    required this.gender,
  });

  factory User.fromDoc(DocumentSnapshot userDoc) {
    final userData = userDoc.data() as Map<String, dynamic>?;

    return User(
      id: userDoc.id,
      name: userData!['name'],
      email: userData['email'],
      profileImage: userData['profileImage'],
      gender: userData['gender'],
    );
  }

  factory User.initialUser() {
    return const User(
      id: '',
      name: '',
      email: '',
      profileImage: '',
      gender: '',
    );
  }

  @override
  String toString() {
    return 'User(id: $id, name: $name, email: $email, profileImage: $profileImage, gender: $gender)';
  }

  @override
  List<Object> get props {
    return [
      id,
      name,
      email,
      profileImage,
      gender,
    ];
  }

  User copyWith({
    String? id,
    String? name,
    String? email,
    String? profileImage,
    String? gender,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      profileImage: profileImage ?? this.profileImage,
      gender: gender ?? this.gender,
    );
  }
}
