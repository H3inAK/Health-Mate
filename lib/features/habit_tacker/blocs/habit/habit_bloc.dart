import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../authentication/models/custom_error.dart';
import '../../database/habit_db.dart';
import '../../models/habit_model.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  List<Habit> _originalHabits = [];

  List<Habit> get habits => _originalHabits;

  HabitBloc() : super(HabitState.initial()) {
    on<LoadHabits>((event, emit) async {
      try {
        emit(state.copyWith(status: HabitStatus.loading));
        final habits = await HabitDatabase.instance
            .readAllHabits(selectedDate: event.selectedDate);

        _originalHabits = habits;
        emit(state.copyWith(habits: habits, status: HabitStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: HabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<AddHabit>((event, emit) async {
      try {
        emit(state.copyWith(status: HabitStatus.loading));

        final newHabit = event.habit;
        await HabitDatabase.instance.create(newHabit);
        final habits = await HabitDatabase.instance
            .readAllHabits(selectedDate: DateTime.now());

        _originalHabits = habits;
        emit(state.copyWith(habits: habits, status: HabitStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: HabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<UpdateHabit>((event, emit) async {
      try {
        emit(state.copyWith(status: HabitStatus.loading));

        final updatedHabit = event.habit;
        await HabitDatabase.instance.update(updatedHabit);
        final habits = await HabitDatabase.instance
            .readAllHabits(selectedDate: DateTime.now());

        _originalHabits = habits;
        emit(state.copyWith(habits: habits, status: HabitStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: HabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<DeleteHabit>((event, emit) async {
      try {
        emit(state.copyWith(status: HabitStatus.loading));

        final deletedHabit = event.habit;
        await HabitDatabase.instance.delete(deletedHabit.id);
        final habits = await HabitDatabase.instance
            .readAllHabits(selectedDate: DateTime.now());

        _originalHabits = habits;
        emit(state.copyWith(habits: habits, status: HabitStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: HabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<UpdateCompletedStatus>((event, emit) async {
      try {
        emit(state.copyWith(status: HabitStatus.loading));

        final updatedHabit = event.habit;
        await HabitDatabase.instance.updateCompletedStatus(
          updatedHabit.id,
          updatedHabit.completed,
        );
        final habits = await HabitDatabase.instance
            .readAllHabits(selectedDate: DateTime.now());

        _originalHabits = habits;
        emit(state.copyWith(habits: habits, status: HabitStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: HabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<FilterHabits>((event, emit) {
      print("Filter Bloc ${event.filterOptions}");
      final allHabits = _originalHabits;

      List<Habit> filteredHabits;

      if (event.filterOptions == FilterOptions.all) {
        filteredHabits = allHabits;
      } else if (event.filterOptions == FilterOptions.active) {
        filteredHabits = allHabits.where((habit) => !habit.completed).toList();
      } else if (event.filterOptions == FilterOptions.completed) {
        filteredHabits = allHabits.where((habit) => habit.completed).toList();
      } else {
        filteredHabits = allHabits;
      }

      emit(state.copyWith(habits: filteredHabits));
    });

    SortOptions? currentSortOption;
    bool isAscending = true;

    on<SortHabits>((event, emit) {
      List<Habit> sortedHabits = List.from(state.habits);

      if (currentSortOption == event.sortOptions) {
        isAscending = !isAscending;
      } else {
        isAscending = true;
      }

      switch (event.sortOptions) {
        case SortOptions.alphabetical:
          sortedHabits.sort((a, b) => a.title.compareTo(b.title));
          break;
        case SortOptions.date:
          sortedHabits.sort((a, b) => a.createdAt.compareTo(b.createdAt));
          break;
        case SortOptions.completed:
          final completedHabits =
              sortedHabits.where((habit) => habit.completed).toList();
          final uncompletedHabits =
              sortedHabits.where((habit) => !habit.completed).toList();
          sortedHabits = [...completedHabits, ...uncompletedHabits];
          break;
        case SortOptions.priority:
          final highPriorityHabits =
              sortedHabits.where((habit) => habit.priority == 'High').toList();
          final mediumPriorityHabits = sortedHabits
              .where((habit) => habit.priority == 'Medium')
              .toList();
          final lowPriorityHabits =
              sortedHabits.where((habit) => habit.priority == 'Low').toList();
          sortedHabits = [
            ...highPriorityHabits,
            ...mediumPriorityHabits,
            ...lowPriorityHabits
          ];
          break;
        case SortOptions.reverse:
          isAscending = !isAscending;
          break;
      }

      if (!isAscending) {
        sortedHabits = sortedHabits.reversed.toList();
      }

      currentSortOption = event.sortOptions;

      emit(state.copyWith(habits: sortedHabits));
    });
  }
}
