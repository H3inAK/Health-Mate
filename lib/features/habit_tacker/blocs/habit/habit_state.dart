part of 'habit_bloc.dart';

enum HabitStatus { initial, loading, success, failure }

class HabitState extends Equatable {
  final HabitStatus status;
  final List<Habit> habits;
  final CustomError error;
  const HabitState({
    required this.status,
    required this.habits,
    required this.error,
  });

  factory HabitState.initial() {
    return const HabitState(
      status: HabitStatus.initial,
      habits: [],
      error: CustomError(),
    );
  }

  HabitState copyWith({
    HabitStatus? status,
    List<Habit>? habits,
    CustomError? error,
  }) {
    return HabitState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'HabitState(status: $status, habits: $habits, error: $error)';

  @override
  List<Object> get props => [status, habits, error];
}
