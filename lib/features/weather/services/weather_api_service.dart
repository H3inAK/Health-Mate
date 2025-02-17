import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../constants/constants.dart';
import '../exceptions/weather_exception.dart';
import '../models/direct_geocoding.dart';
import '../models/weather.dart';
import '../utils/http_error_handler.dart';

class WeatherApiService {
  final http.Client httpClient;
  WeatherApiService({
    required this.httpClient,
  });

  Future<DirectGeocoding> getDirectGeocoding(String city) async {
    try {
      Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: '/geo/1.0/direct',
        queryParameters: {
          'q': city,
          'limit': kLimit,
          'appid': dotenv.env['APPID'],
        },
      );

      final response = await httpClient.get(uri);

      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = json.decode(response.body);
      if (responseBody.isEmpty) {
        throw WeatherException("Couldn't get the location of $city");
      }

      final directGeoCoding = DirectGeocoding.fromJson(responseBody);

      return directGeoCoding;
    } catch (_) {
      rethrow;
    }
  }

  Future<Weather> getWeather(DirectGeocoding directGeocoding) async {
    try {
      Uri uri = Uri(
        scheme: 'https',
        host: kApiHost,
        path: '/data/2.5/weather',
        queryParameters: {
          'lat': '${directGeocoding.lat}',
          'lon': '${directGeocoding.lon}',
          'units': kUnit,
          'appid': dotenv.env['APPID'],
        },
      );

      final response = await httpClient.get(uri);
      if (response.statusCode != 200) {
        throw Exception(httpErrorHandler(response));
      }

      final responseBody = json.decode(response.body);
      final weather = Weather.fromJson(responseBody);

      return weather;
    } catch (_) {
      rethrow;
    }
  }
}
