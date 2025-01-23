import 'package:equatable/equatable.dart';

class Weather extends Equatable {
  final String name;
  final String country;
  final String description;
  final double temp;
  final double tempMax;
  final double tempMin;
  final String icon;
  final DateTime lastUpdated;
  const Weather({
    required this.name,
    required this.country,
    required this.description,
    required this.temp,
    required this.tempMax,
    required this.tempMin,
    required this.icon,
    required this.lastUpdated,
  });

  factory Weather.initial() => Weather(
        name: '',
        country: '',
        description: '',
        temp: 100.0,
        tempMax: 100.0,
        tempMin: 100.0,
        icon: '',
        lastUpdated: DateTime(1997),
      );

  factory Weather.fromJson(Map<String, dynamic> json) {
    final name = json['name'];
    final country = json['sys']['country'];
    final weather = json['weather'][0];
    final main = json['main'];

    return Weather(
      name: name,
      country: country,
      description: weather['description'],
      temp: main['temp'],
      tempMax: main['temp_max'],
      tempMin: main['temp_min'],
      icon: weather['icon'],
      lastUpdated: DateTime.now(),
    );
  }

  Weather copyWith({
    String? name,
    String? country,
    String? description,
    double? temp,
    double? tempMax,
    double? tempMin,
    String? icon,
    DateTime? lastUpdated,
  }) {
    return Weather(
      name: name ?? this.name,
      country: country ?? this.country,
      description: description ?? this.description,
      temp: temp ?? this.temp,
      tempMax: tempMax ?? this.tempMax,
      tempMin: tempMin ?? this.tempMin,
      icon: icon ?? this.icon,
      lastUpdated: lastUpdated ?? this.lastUpdated,
    );
  }

  @override
  String toString() {
    return 'Weather(name: $name, country: $country, description: $description, temp: $temp, tempMax: $tempMax, tempMin: $tempMin, icon: $icon, lastUpdated: $lastUpdated)';
  }

  @override
  List<Object> get props {
    return [
      name,
      country,
      description,
      temp,
      tempMax,
      tempMin,
      icon,
    ];
  }
}
