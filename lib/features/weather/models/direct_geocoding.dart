import 'package:equatable/equatable.dart';

class DirectGeocoding extends Equatable {
  final String name;
  final String country;
  final double lat;
  final double lon;
  const DirectGeocoding({
    required this.name,
    required this.country,
    required this.lat,
    required this.lon,
  });

  factory DirectGeocoding.fromJson(List<dynamic> json) {
    final geoCodingData = json[0];

    final directGeocoding = DirectGeocoding(
      name: geoCodingData['name'],
      country: geoCodingData['country'],
      lat: geoCodingData['lat'],
      lon: geoCodingData['lon'],
    );

    return directGeocoding;
  }

  @override
  String toString() {
    return 'DirectGeocoding(name: $name, country: $country, lat: $lat, lon: $lon)';
  }

  @override
  List<Object> get props => [name, country, lat, lon];
}
