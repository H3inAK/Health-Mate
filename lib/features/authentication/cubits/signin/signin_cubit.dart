import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../repositories/auth_repository.dart';

part 'signin_state.dart';

class SigninCubit extends Cubit<SigninState> {
  final AuthRepository authRepository;
  SigninCubit({required this.authRepository}) : super(SigninState.initial());

  Future<void> signin({
    required String email,
    required String password,
  }) async {
    try {
      emit(state.copyWith(signinStatus: SigninStatus.submitting));
      await authRepository.signInWithEmailAndPassword(
          email: email, password: password);
      emit(state.copyWith(signinStatus: SigninStatus.success));
    } on CustomError catch (e) {
      emit(state.copyWith(
        signinStatus: SigninStatus.error,
        error: e,
      ));
    }
  }

  Future<void> signinWithGoogle() async {
    try {
      emit(state.copyWith(signinStatus: SigninStatus.submitting));
      await authRepository.signInWithGoogle();
      emit(state.copyWith(signinStatus: SigninStatus.success));
    } on CustomError catch (e) {
      emit(
        state.copyWith(
          signinStatus: SigninStatus.error,
          error: e,
        ),
      );
    }
  }
}
