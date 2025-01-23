import 'dart:typed_data';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

import '../../models/custom_error.dart';
import '../../models/user_model.dart';
import '../../repositories/profile_repository.dart';

part 'profile_state.dart';

class ProfileCubit extends Cubit<ProfileState> {
  final ProfileRepository profileRepository;
  ProfileCubit({required this.profileRepository})
      : super(ProfileState.initial());

  Future<void> getProfile({required String uid}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      final user = await profileRepository.getProfileInfo(uid);
      emit(state.copyWith(
        profileStatus: ProfileStatus.loaded,
        user: user,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        error: e,
      ));
    }
  }

  Future<void> updateProfileName(
      {required String uid, required String newName}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      final user = fbAuth.FirebaseAuth.instance.currentUser;
      if (user != null) {
        await user.updateDisplayName(newName);
      }

      await profileRepository.updateProfileName(uid, newName);
      emit(state.copyWith(
        profileStatus: ProfileStatus.loaded,
        user: state.user.copyWith(name: newName),
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        error: e,
      ));
    }
  }

  Future<void> updateProfilePicture(
      {required String uid, required Uint8List file}) async {
    emit(state.copyWith(profileStatus: ProfileStatus.loading));
    try {
      await profileRepository.uploadProfilePicture(uid, file);
      final updatedUser = await profileRepository.getProfileInfo(uid);
      emit(state.copyWith(
        profileStatus: ProfileStatus.loaded,
        user: updatedUser,
      ));
    } on CustomError catch (e) {
      emit(state.copyWith(
        profileStatus: ProfileStatus.error,
        error: e,
      ));
    }
  }
}
