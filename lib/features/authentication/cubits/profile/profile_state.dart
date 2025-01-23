part of 'profile_cubit.dart';

enum ProfileStatus {
  initial,
  loading,
  loaded,
  error,
}

class ProfileState extends Equatable {
  final ProfileStatus profileStatus;
  final User user;
  final CustomError error;
  const ProfileState({
    required this.profileStatus,
    required this.user,
    required this.error,
  });

  factory ProfileState.initial() => ProfileState(
        profileStatus: ProfileStatus.initial,
        user: User.initialUser(),
        error: const CustomError(),
      );

  ProfileState copyWith({
    ProfileStatus? profileStatus,
    User? user,
    CustomError? error,
  }) {
    return ProfileState(
      profileStatus: profileStatus ?? this.profileStatus,
      user: user ?? this.user,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'ProfileState(profileStatus: $profileStatus, user: $user, error: $error)';

  @override
  List<Object> get props => [profileStatus, user, error];
}
