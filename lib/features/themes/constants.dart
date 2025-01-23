// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class ThemeColorSeed extends Equatable {
  final String name;
  final Color seedColor;
  const ThemeColorSeed({
    required this.name,
    required this.seedColor,
  });

  @override
  String toString() => 'ThemeColorSeed(name: $name, seedColor: $seedColor)';

  @override
  List<Object> get props => [name, seedColor];

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'name': name,
      'seedColor': seedColor.value,
    };
  }

  factory ThemeColorSeed.fromMap(Map<String, dynamic> map) {
    return ThemeColorSeed(
      name: map['name'] as String,
      seedColor: Color(map['seedColor'] as int),
    );
  }

  String toJson() => json.encode(toMap());

  factory ThemeColorSeed.fromJson(String source) =>
      ThemeColorSeed.fromMap(json.decode(source) as Map<String, dynamic>);
}

const themeColorSeeds = [
  ThemeColorSeed(name: 'Red', seedColor: Color(0xFFF66B4A)),
  ThemeColorSeed(name: 'Bright Red', seedColor: Color(0xFFF10E4B)),
  // ThemeColorSeed(name: 'Blue', seedColor: Color(0xFF4091CB)),
  // ThemeColorSeed(name: 'Blue Grey', seedColor: Colors.blueGrey),
  ThemeColorSeed(name: 'Brown', seedColor: Color(0xFF936332)),
  // ThemeColorSeed(name: 'Cyan', seedColor: Colors.cyan),
  // ThemeColorSeed(name: 'Deep Orange', seedColor: Colors.deepOrange),
  ThemeColorSeed(name: 'Deep Purple', seedColor: Colors.deepPurple),
  // ThemeColorSeed(name: 'Green', seedColor: Color(0xFF7FBE1D)),
  ThemeColorSeed(name: 'Indigo', seedColor: Colors.indigo),
  ThemeColorSeed(name: 'Light Blue', seedColor: Color(0xFF4091CB)),
  ThemeColorSeed(name: 'Light Green', seedColor: Color(0xFF7FBE1D)),
  ThemeColorSeed(name: 'Lime', seedColor: Color(0xFF98BF5E)),
  // ThemeColorSeed(name: 'Meganta', seedColor: Color(0xFFCD4D4B)),
  ThemeColorSeed(name: 'Pink', seedColor: Color(0xFFD378B8)),
  ThemeColorSeed(name: 'Purple', seedColor: Color(0xFF9737CB)),
  ThemeColorSeed(name: 'Teal', seedColor: Color(0xFF2DADA5)),
  ThemeColorSeed(name: 'Yellow', seedColor: Color(0xFFF8AA02)),
];
