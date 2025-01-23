import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../../utils/custom_error.dart';
import '../../database/habit_db.dart';
import '../../models/habit_model.dart';

part 'individual_habit_event.dart';
part 'individual_habit_state.dart';

class IndividualHabitBloc
    extends Bloc<IndividualHabitEvent, IndividualHabitState> {
  IndividualHabitBloc() : super(IndividualHabitState.initial()) {
    on<ReadIndividualHabit>((event, emit) async {
      try {
        emit(state.copyWith(status: IndividualHabitStatus.loading));
        final habit = await HabitDatabase.instance.readHabit(event.habit.id);
        print(habit);
        emit(
          state.copyWith(
            habit: habit,
            status: IndividualHabitStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: IndividualHabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<UpdateIndividualHabit>((event, emit) async {
      try {
        emit(state.copyWith(status: IndividualHabitStatus.loading));
        await HabitDatabase.instance.update(event.habit);
        emit(
          state.copyWith(
            habit: event.habit,
            status: IndividualHabitStatus.success,
          ),
        );
      } catch (e) {
        emit(
          state.copyWith(
            status: IndividualHabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });

    on<UpdateHabitCompletedStatus>((event, emit) async {
      try {
        emit(state.copyWith(status: IndividualHabitStatus.loading));

        final updatedCompletedStatusHabit = event.habit;
        await HabitDatabase.instance.updateCompletedStatus(
          updatedCompletedStatusHabit.id,
          updatedCompletedStatusHabit.completed,
        );
        final habit = await HabitDatabase.instance
            .readHabit(updatedCompletedStatusHabit.id);
        emit(state.copyWith(
            habit: habit, status: IndividualHabitStatus.success));
      } catch (e) {
        emit(
          state.copyWith(
            status: IndividualHabitStatus.failure,
            error: CustomError(message: e.toString()),
          ),
        );
      }
    });
  }
}
