import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../models/custom_error.dart';
import '../../models/weather.dart';
import '../../repositories/weather_repository.dart';

part 'weather_event.dart';
part 'weather_state.dart';

class WeatherBloc extends Bloc<WeatherEvent, WeatherState> {
  final WeatherRepository weatherRepository;

  WeatherBloc(this.weatherRepository) : super(WeatherState.initial()) {
    on<FetchWeatherEvent>((event, emit) async {
      try {
        emit(state.copyWith(weatherStatus: WeatherStatus.loading));

        final weather = await weatherRepository.fetchWeather();
        emit(state.copyWith(
          weather: weather,
          weatherStatus: WeatherStatus.loaded,
        ));
      } catch (e) {
        emit(state.copyWith(
          error: CustomError(errMsg: e.toString()),
          weatherStatus: WeatherStatus.error,
        ));
      }
    });
  }
}
