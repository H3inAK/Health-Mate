part of 'habit_bloc.dart';

sealed class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object> get props => [];
}

class LoadHabits extends HabitEvent {
  final DateTime selectedDate;

  const LoadHabits({required this.selectedDate});

  @override
  List<Object> get props => [selectedDate];
}

class AddHabit extends HabitEvent {
  final Habit habit;

  const AddHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateHabit extends HabitEvent {
  final Habit habit;

  const UpdateHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class DeleteHabit extends HabitEvent {
  final Habit habit;

  const DeleteHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateCompletedStatus extends HabitEvent {
  final Habit habit;

  const UpdateCompletedStatus(this.habit);

  @override
  List<Object> get props => [habit];
}

enum FilterOptions { all, active, completed }

class FilterHabits extends HabitEvent {
  final FilterOptions filterOptions;

  const FilterHabits(this.filterOptions);

  @override
  List<Object> get props => [filterOptions];
}

enum SortOptions { alphabetical, date, completed, priority, reverse }

class SortHabits extends HabitEvent {
  final SortOptions sortOptions;

  const SortHabits(this.sortOptions);

  @override
  List<Object> get props => [sortOptions];
}
