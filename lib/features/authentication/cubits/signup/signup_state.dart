part of 'signup_cubit.dart';

enum SignupStatus {
  initial,
  submitting,
  success,
  error,
}

class SignupState extends Equatable {
  final SignupStatus signupStatus;
  final CustomError error;
  const SignupState({
    required this.signupStatus,
    required this.error,
  });

  factory SignupState.initial() => const SignupState(
        signupStatus: SignupStatus.initial,
        error: CustomError(),
      );

  SignupState copyWith({
    SignupStatus? signupStatus,
    CustomError? error,
  }) {
    return SignupState(
      signupStatus: signupStatus ?? this.signupStatus,
      error: error ?? this.error,
    );
  }

  @override
  List<Object> get props => [signupStatus, error];

  @override
  String toString() =>
      'SignupState(signupStatus: $signupStatus, error: $error)';
}
