// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'weather_bloc.dart';

enum WeatherStatus {
  initial,
  loading,
  loaded,
  error,
}

class WeatherState extends Equatable {
  final WeatherStatus weatherStatus;
  final Weather weather;
  final CustomError error;
  const WeatherState({
    required this.weatherStatus,
    required this.weather,
    required this.error,
  });

  factory WeatherState.initial() => WeatherState(
        weatherStatus: WeatherStatus.initial,
        weather: Weather.initial(),
        error: const CustomError(),
      );

  @override
  String toString() =>
      'WeatherState(weatherStatus: $weatherStatus, weather: $weather, error: $error)';

  @override
  List<Object> get props => [weather];

  WeatherState copyWith({
    WeatherStatus? weatherStatus,
    Weather? weather,
    CustomError? error,
  }) {
    return WeatherState(
      weatherStatus: weatherStatus ?? this.weatherStatus,
      weather: weather ?? this.weather,
      error: error ?? this.error,
    );
  }
}
