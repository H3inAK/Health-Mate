import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';

import '../../constants.dart';

part 'app_theme_state.dart';

class AppThemeCubit extends HydratedCubit<AppThemeState> {
  AppThemeCubit() : super(AppThemeState.initial());

  void changeThemeColorScheme(ThemeColorSeed themeColorSeed) {
    emit(state.copyWith(themeColorSeed: themeColorSeed));
  }

  @override
  AppThemeState? fromJson(Map<String, dynamic> json) {
    final themeColorSeed = ThemeColorSeed.fromJson(json['themeColorSeed']);
    return AppThemeState(themeColorSeed: themeColorSeed);
  }

  @override
  Map<String, dynamic>? toJson(AppThemeState state) {
    return {
      'themeColorSeed': state.themeColorSeed.toJson(),
    };
    // return jsonEncode(state.themeColorSeed.toJson()) as Map<String, dynamic>;
  }
}
