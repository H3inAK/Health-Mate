import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

part 'theme_mode_state.dart';

class ThemeModeCubit extends HydratedCubit<ThemeModeState> {
  ThemeModeCubit() : super(ThemeModeState.initial());

  void changeThemeMode() {
    if (state.themeMode == ThemeMode.system) {
      emit(state.copyWith(themeMode: ThemeMode.system));
    }
    if (state.themeMode == ThemeMode.light) {
      emit(state.copyWith(themeMode: ThemeMode.dark));
    } else {
      emit(state.copyWith(themeMode: ThemeMode.light));
    }
  }

  @override
  ThemeModeState? fromJson(Map<String, dynamic> json) {
    if (json['themeMode'] == 'system') {
      emit(state.copyWith(themeMode: ThemeMode.system));
      return const ThemeModeState(
        themeMode: ThemeMode.system,
      );
    } else if (json['themeMode'] == 'light') {
      emit(state.copyWith(themeMode: ThemeMode.light));
      return const ThemeModeState(
        themeMode: ThemeMode.light,
      );
    } else {
      emit(state.copyWith(themeMode: ThemeMode.dark));
      return ThemeModeState(
        themeMode: json['themeMode'] as ThemeMode,
      );
    }
  }

  @override
  Map<String, dynamic>? toJson(ThemeModeState state) {
    String themeMode;

    if (state.themeMode == ThemeMode.system) {
      themeMode = 'system';
    } else if (state.themeMode == ThemeMode.light) {
      themeMode = 'light';
    } else {
      themeMode = 'dark';
    }

    return {
      'themeMode': themeMode,
    };
  }
}
