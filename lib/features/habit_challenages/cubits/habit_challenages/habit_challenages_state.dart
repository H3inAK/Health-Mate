part of 'habit_challenages_cubit.dart';

enum HabitChallenagesStatus { initial, loading, loaded, error }

class HabitChallenagesState extends Equatable {
  final HabitChallenagesStatus status;
  final List<Habit> habits;
  final CustomError error;
  const HabitChallenagesState({
    required this.status,
    required this.habits,
    required this.error,
  });

  factory HabitChallenagesState.initial() => const HabitChallenagesState(
        status: HabitChallenagesStatus.initial,
        habits: [],
        error: CustomError(),
      );

  HabitChallenagesState copyWith({
    HabitChallenagesStatus? status,
    List<Habit>? habits,
    CustomError? error,
  }) {
    return HabitChallenagesState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      error: error ?? this.error,
    );
  }

  @override
  String toString() =>
      'HabitChallenagesState(status: $status, habits: $habits, error: $error)';

  @override
  List<Object> get props => [status, habits, error];
}
