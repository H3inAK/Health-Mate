part of 'signin_cubit.dart';

enum SigninStatus {
  initial,
  submitting,
  success,
  error,
}

class SigninState extends Equatable {
  final SigninStatus signinStatus;
  final CustomError error;
  const SigninState({
    required this.signinStatus,
    required this.error,
  });

  factory SigninState.initial() => const SigninState(
        signinStatus: SigninStatus.initial,
        error: CustomError(),
      );

  SigninState copyWith({
    SigninStatus? signinStatus,
    CustomError? error,
  }) {
    return SigninState(
      signinStatus: signinStatus ?? this.signinStatus,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'SigninState(signinStatus: $signinStatus, error: $error)';

  @override
  List<Object> get props => [signinStatus, error];
}
