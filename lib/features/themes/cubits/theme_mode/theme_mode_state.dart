// ignore_for_file: public_member_api_docs, sort_constructors_first

part of 'theme_mode_cubit.dart';

class ThemeModeState extends Equatable {
  final ThemeMode themeMode;
  const ThemeModeState({
    required this.themeMode,
  });

  factory ThemeModeState.initial() => const ThemeModeState(
        themeMode: ThemeMode.light,
      );

  @override
  String toString() => 'ThemeModeState(appThemeMode: $themeMode)';

  @override
  List<Object> get props => [themeMode];

  ThemeModeState copyWith({
    ThemeMode? themeMode,
  }) {
    return ThemeModeState(
      themeMode: themeMode ?? this.themeMode,
    );
  }
}
