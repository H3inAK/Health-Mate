import 'package:healthmate/features/weather/services/location_service.dart';

import '../exceptions/weather_exception.dart';
import '../models/custom_error.dart';
import '../models/direct_geocoding.dart';
import '../models/weather.dart';
import '../services/weather_api_service.dart';

class WeatherRepository {
  final WeatherApiService weatherApiService;
  final LocationService locationService;
  WeatherRepository(
    this.locationService, {
    required this.weatherApiService,
  });

  Future<Weather> fetchWeather() async {
    try {
      final position = await locationService.getCurrentLocation();

      final directGeocoding = DirectGeocoding(
        name: "",
        country: "",
        lat: position!.latitude,
        lon: position.longitude,
      );

      final Weather tempWeather =
          await weatherApiService.getWeather(directGeocoding);

      return tempWeather;
    } on WeatherException catch (e) {
      throw CustomError(errMsg: e.message);
    } catch (e) {
      throw CustomError(errMsg: e.toString());
    }
  }
}
