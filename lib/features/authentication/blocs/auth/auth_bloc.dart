import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
// ignore: library_prefixes
import 'package:firebase_auth/firebase_auth.dart' as fbAuth;

import '../../repositories/auth_repository.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository authRepository;
  late StreamSubscription authSubscription;

  AuthBloc({required this.authRepository}) : super(AuthState.unknown()) {
    authSubscription = authRepository.user.listen((fbAuth.User? user) {
      add(AuthStateChangeEvent(user: user));
    });

    on<AuthStateChangeEvent>((event, emit) {
      if (event.user != null) {
        emit(state.copyWith(
          authStatus: AuthStatus.authenticated,
          user: event.user,
        ));
      } else {
        emit(state.copyWith(
          authStatus: AuthStatus.unauthenticated,
          user: null,
        ));
      }
    });

    on<SignoutRequestEvent>((event, emit) async {
      await authRepository.signOut();
    });
  }

  @override
  Future<void> close() {
    authSubscription.cancel();
    return super.close();
  }
}
