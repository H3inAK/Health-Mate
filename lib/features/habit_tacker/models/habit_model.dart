import 'dart:convert';

import 'package:equatable/equatable.dart';

class Habit extends Equatable {
  final int id;
  final String title;
  final String description;
  final bool completed;
  final String priority;
  final String icon;
  final String repeat;
  final DateTime createdAt;
  final DateTime updatedAt;

  const Habit({
    this.id = 0,
    required this.title,
    required this.description,
    this.completed = false,
    required this.priority,
    required this.icon,
    required this.repeat,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Habit.initial() {
    return Habit(
      title: '',
      description: '',
      priority: '',
      icon: '',
      repeat: '',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'title': title,
      'description': description,
      'completed': completed ? 1 : 0, // Store as 1 or 0 in the database
      'priority': priority,
      'icon': icon,
      'repeat': repeat,
      'created_at': createdAt.millisecondsSinceEpoch,
      'updated_at': updatedAt.millisecondsSinceEpoch,
    };
  }

  Habit copyWith({
    int? id,
    String? title,
    String? description,
    bool? completed,
    String? priority,
    String? icon,
    String? repeat,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return Habit(
      id: id ?? this.id,
      title: title ?? this.title,
      description: description ?? this.description,
      completed: completed ?? this.completed,
      priority: priority ?? this.priority,
      icon: icon ?? this.icon,
      repeat: repeat ?? this.repeat,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  factory Habit.fromMap(Map<String, dynamic> map) {
    return Habit(
      id: map['id'] as int,
      title: map['title'] as String,
      description: map['description'] as String,
      completed: map['completed'] == 1, // Convert 1 or 0 to bool
      priority: map['priority'] as String,
      icon: map['icon'] as String,
      repeat: map['repeat'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
      updatedAt: DateTime.fromMillisecondsSinceEpoch(map['updated_at']),
    );
  }

  String toJson() => json.encode(toMap());

  factory Habit.fromJson(String source) =>
      Habit.fromMap(json.decode(source) as Map<String, dynamic>);

  @override
  String toString() {
    return 'Habit(id: $id, title: $title, description: $description, completed: $completed, priority: $priority, icon: $icon, repeat: $repeat, createdAt: $createdAt, updatedAt: $updatedAt)';
  }

  @override
  List<Object> get props {
    return [
      id,
      title,
      description,
      completed,
      priority,
      icon,
      repeat,
      createdAt,
      updatedAt,
    ];
  }
}
