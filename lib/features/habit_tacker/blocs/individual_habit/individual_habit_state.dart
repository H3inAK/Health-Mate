part of 'individual_habit_bloc.dart';

enum IndividualHabitStatus { initial, loading, success, failure }

class IndividualHabitState extends Equatable {
  final IndividualHabitStatus status;
  final Habit habit;
  final CustomError error;
  const IndividualHabitState({
    required this.status,
    required this.habit,
    required this.error,
  });

  factory IndividualHabitState.initial() {
    return IndividualHabitState(
      status: IndividualHabitStatus.initial,
      habit: Habit.initial(),
      error: const CustomError(),
    );
  }

  IndividualHabitState copyWith({
    IndividualHabitStatus? status,
    Habit? habit,
    CustomError? error,
  }) {
    return IndividualHabitState(
      status: status ?? this.status,
      habit: habit ?? this.habit,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'IndividualHabitState(status: $status, habit: $habit, error: $error)';

  @override
  List<Object> get props => [status, habit, error];
}
