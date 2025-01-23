part of 'individual_habit_bloc.dart';

sealed class IndividualHabitEvent extends Equatable {
  const IndividualHabitEvent();

  @override
  List<Object> get props => [];
}

class ReadIndividualHabit extends IndividualHabitEvent {
  final Habit habit;

  const ReadIndividualHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateIndividualHabit extends IndividualHabitEvent {
  final Habit habit;

  const UpdateIndividualHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateHabitCompletedStatus extends IndividualHabitEvent {
  final Habit habit;

  const UpdateHabitCompletedStatus(this.habit);

  @override
  List<Object> get props => [habit];
}
