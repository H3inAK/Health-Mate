part of 'app_theme_cubit.dart';

class AppThemeState extends Equatable {
  final ThemeColorSeed themeColorSeed;
  const AppThemeState({
    required this.themeColorSeed,
  });

  factory AppThemeState.initial() => const AppThemeState(
        themeColorSeed: ThemeColorSeed(
          name: 'Indigo',
          seedColor: Colors.indigo,
        ),
      );

  @override
  String toString() => 'AppThemeState(seedColor: $themeColorSeed)';

  AppThemeState copyWith({
    ThemeColorSeed? themeColorSeed,
  }) {
    return AppThemeState(
      themeColorSeed: themeColorSeed ?? this.themeColorSeed,
    );
  }

  @override
  List<Object> get props => [themeColorSeed];
}
